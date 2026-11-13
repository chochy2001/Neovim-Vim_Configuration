"""Comprueba cada diferencia de 3+ palabras entre transcripciones (posible contenido perdido).
Whisper en archivos largos a veces se salta trozos: aquí se vuelve a transcribir SOLO una ventana del export (8 s antes, largo según el tramo)
y se mira si las palabras del original están (≥ 60 % de las palabras de 3+ letras, sin acentos).
Uso: .venv/bin/python -I verificar_candidatos.py -> 03-analisis/verificacion/candidatos.json"""
import os
# Modelo de Whisper: si existe la copia local (.modelos/whisper-large-v3-turbo), se usa sin red. Si no, se descarga
# de Hugging Face en CADA ejecución (~2 min): no queda en ~/.cache. Ver COMO-EDITAR-CURSOS.md E58.
_ML = os.path.expanduser("~/Movies/Capdesis-Curso-Vim/.modelos/whisper-large-v3-turbo")
MODELO_WHISPER = _ML if os.path.isfile(f"{_ML}/config.json") else "mlx-community/whisper-large-v3-turbo"
import json, os, re, subprocess, unicodedata
import mlx_whisper
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
_EST = json.load(open(os.path.expanduser("~/Movies/Capdesis-Curso-Vim/04-davinci/estructura.json"))); PRE_S = _EST["pre"] / 60
NAMES = {1: "01-modos-y-movimientos", 2: "02-insertar-pegar-y-buscar", 3: "03-buscar-caracteres-y-borrar", 4: "04-objetos-de-texto", 5: "05-ventanas-y-lineas"}
EQ = {"skip": "esc", "bim": "vim"}
def toks(s):
    s = unicodedata.normalize("NFD", s.lower()); s = "".join(c for c in s if unicodedata.category(c) != "Mn")
    return [EQ.get(t, t) for t in re.findall(r"\w+", s)]
ITEMS = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))
def audio_identico(p, n, t0, dur):
    """Prueba de audio (no de texto): cada tramo de 0.5 s del original en [t0, t0+dur] debe estar en el timeline y su envolvente
    debe coincidir con la del final en el tiempo mapeado (corr >= 0.95). Whisper puede transcribir distinto el mismo audio (E41)."""
    import numpy as np
    def au(src, t, d):
        b = subprocess.run(["ffmpeg", "-nostdin", "-v", "error", "-ss", f"{max(0, t):.3f}", "-t", f"{d:.3f}", "-i", src, "-ac", "1", "-ar", "16000", "-f", "f32le", "-"], capture_output=True).stdout
        x = np.frombuffer(b, np.float32); return np.convolve(np.abs(x), np.ones(400) / 400, "same")
    rows = ITEMS[str(p)]["audio"]; peor = 1.0; k = 0.0
    while k < dur:
        f = round((t0 + k) * 60); r = next((r_ + f - s_ for s_, e_, r_ in rows if s_ <= f and f + 30 <= e_), None)
        if r is None: return False, f"{t0 + k:.2f}s del original no está en el timeline"
        eo = au(f"{BASE}/01-crudo/.por-numero/parte {p}.mp4", t0 + k, 0.5); ex = au(f"{BASE}/editado/{n}.mp4", r / 60 + PRE_S, 0.5); m = min(len(eo), len(ex))
        if m <= 1000: return False, f"{t0 + k:.2f}s: muestra de audio demasiado corta para comparar"
        # original en silencio: solo cuenta como igual si el final TAMBIÉN está en silencio (revisión 2026-11-13)
        c = float(np.corrcoef(eo[:m], ex[:m])[0, 1]) if eo[:m].std() > 1e-4 else (1.0 if ex[:m].std() <= 1e-4 else 0.0)
        peor = min(peor, c); k += 0.5
    return peor >= 0.95, f"audio idéntico al original (corr. mínima {peor:.3f}); Whisper lo transcribe distinto"
import sys
OUTF = f"{BASE}/03-analisis/verificacion/candidatos.json"
if os.path.exists(OUTF): os.remove(OUTF)   # nunca dejar el resultado de una ejecución anterior (revisión 2026-11-13)
res = {}
for p, n in NAMES.items():
    comp = json.load(open(f"{BASE}/03-analisis/verificacion/export-parte-{p}-comparacion.json"))
    out = []
    for c in comp["candidatos_error_contenido(>=3 palabras)"]:
        c = dict(c, t_origen=c.get("t_origen"))
        t = c["t_export"]
        if t is None or t < 0:
            # sin tiempo en el final: puede ser una alucinación de Whisper en un silencio (p. ej. "Gracias.") dentro de un tramo acelerado.
            # Se mide el original: si es silencio digital (pico < -50 dB) no hay contenido; el resto de palabras se busca en el final.
            est, nota = "SIN_TIEMPO", ""
            if c.get("t_origen") is not None:
                e_ = subprocess.run(["ffmpeg", "-nostdin", "-hide_banner", "-ss", str(c["t_origen"]), "-t", "1.5", "-i", f"{BASE}/01-crudo/.por-numero/parte {p}.mp4", "-vn", "-af", "volumedetect", "-f", "null", "-"], capture_output=True, text=True).stderr
                mx = float(re.search(r"max_volume: (-?[\d.]+) dB", e_).group(1))
                exp = json.load(open(f"{BASE}/03-analisis/verificacion/export-parte-{p}.json")); et = set(toks(" ".join(sg["text"] for sg in exp["segments"])))
                rest = [w for w in toks(c["palabras"]) if len(w) >= 3]
                if mx < -50:
                    falt = [w for w in rest[1:] if w not in et]
                    if not falt: est = "PRESENTE"; nota = f"'{rest[0] if rest else ''}' es alucinación de Whisper: el original es silencio digital (pico {mx} dB); el resto está en el final"
            if est == "SIN_TIEMPO" and c.get("t_origen") is not None:
                # el pasaje empieza en un corte: se ubican sus palabras conservadas y se re-transcribe esa ventana del final
                au = ITEMS[str(p)]["audio"]; Wd = [w for sg in json.load(open(f"{BASE}/03-analisis/transcripts/parte-{p}.json"))["segments"] for w in sg["words"]
                                               if c["t_origen"] - 0.5 <= w["start"] <= c["t_origen"] + 1.2 * len(c["palabras"].split()) * 0.5 + 3]
                recs = [r + round((w["start"] + w["end"]) / 2 * 60) - s for w in Wd for s, e, r in au if s <= round((w["start"] + w["end"]) / 2 * 60) < e]
                if recs:
                    a0 = min(recs) / 60 + PRE_S - 1; dd = (max(recs) - min(recs)) / 60 + 2
                    subprocess.run(["ffmpeg", "-nostdin", "-v", "error", "-y", "-ss", str(a0), "-t", str(dd), "-i", f"{BASE}/editado/{n}.mp4", "-vn", "-ac", "1", "-ar", "16000", "/tmp/cand.wav"])
                    got = toks(mlx_whisper.transcribe("/tmp/cand.wav", path_or_hf_repo=MODELO_WHISPER, language="es")["text"])
                    want = toks(" ".join(w["w"] for w in Wd if any(s <= round((w["start"] + w["end"]) / 2 * 60) < e for s, e, r in au)))
                    import difflib
                    cov = sum(b.size for b in difflib.SequenceMatcher(a=want, b=got, autojunk=False).get_matching_blocks()) / max(1, len(want))
                    if cov >= 0.8: est = "PRESENTE"; nota = f"empieza en un corte; sus palabras conservadas están en el final ({cov:.0%}, ventana re-transcrita)"
            if est == "SIN_TIEMPO":
                af = f"{BASE}/03-analisis/edicion/analisis-v2-parte-{p}.json"
                import difflib
                for tm in (json.load(open(af)).get("tomas_malas_aplicables", []) if os.path.exists(af) else []):
                    dentro = c.get("t_origen") is not None and tm["t_ini"] - 1 <= c["t_origen"] <= tm["t_fin"] + 1
                    if dentro and difflib.SequenceMatcher(a=" ".join(toks(tm["texto"])), b=" ".join(toks(c["palabras"] or ""))).ratio() >= 0.6:
                        est = "PRESENTE"; nota = f"corte intencional: toma mala quitada ({tm['texto'][:50]})"; break
            out.append({**c, "estado": est, "nota": nota}); print(p, c.get("t_origen"), est, nota, flush=True); continue
        subprocess.run(["ffmpeg", "-nostdin", "-v", "error", "-y", "-ss", str(max(0, t - 8)), "-t", str(max(20, 16 + 0.5 * len(c["palabras"].split()))), "-i", f"{BASE}/editado/{n}.mp4", "-vn", "-ac", "1", "-ar", "16000", "/tmp/cand.wav"])
        txt = mlx_whisper.transcribe("/tmp/cand.wav", path_or_hf_repo=MODELO_WHISPER, language="es")["text"]
        want = [w for w in toks(c["palabras"]) if len(w) >= 3] or toks(c["palabras"])
        have = set(toks(txt)); got = toks(txt)
        # tokens completos (antes "w in joined" daba PRESENTE con subcadenas: "d i w" 3/3 sin estar, revisión 2026-11-13)
        hit = sum(1 for w in want if w in have or (len(w) >= 4 and any(h[:4] == w[:4] for h in have if len(h) >= 4)))
        if all(len(w) < 3 for w in want):   # solo letras sueltas: deben aparecer seguidas y en orden
            hit = len(want) if any(got[i:i + len(want)] == want for i in range(len(got))) else 0
        ok = hit >= 0.6 * len(want)
        nota = ""
        if not ok and c.get("t_origen") is not None:
            # prueba definitiva: el mismo fragmento (8 s) en el original y en el final, con el mismo modelo
            tx = {}
            for lab, src, tt in [("o", f"{BASE}/01-crudo/.por-numero/parte {p}.mp4", c["t_origen"]), ("e", f"{BASE}/editado/{n}.mp4", t)]:
                subprocess.run(["ffmpeg", "-nostdin", "-v", "error", "-y", "-ss", str(max(0, tt - 4)), "-t", "8", "-i", src, "-vn", "-ac", "1", "-ar", "16000", "/tmp/cand.wav"])
                tx[lab] = toks(mlx_whisper.transcribe("/tmp/cand.wav", path_or_hf_repo=MODELO_WHISPER, language="es")["text"])
            import difflib
            sm = difflib.SequenceMatcher(a=tx["o"], b=tx["e"], autojunk=False)
            cov = sum(b.size for b in sm.get_matching_blocks()) / max(1, len(tx["o"]))   # palabras del original presentes en orden
            if cov >= 0.8: ok = True; nota = f"mismo fragmento en original y final ({cov:.0%} de las palabras del original, en orden)"
        if not ok and c.get("t_origen") is not None:
            ok, nota_a = audio_identico(p, n, c["t_origen"], 0.4 * len(c["palabras"].split()) + 0.6)
            if ok: nota = nota_a
        if not ok:
            af = f"{BASE}/03-analisis/edicion/analisis-v2-parte-{p}.json"
            for tm in (json.load(open(af)).get("tomas_malas_aplicables", []) if os.path.exists(af) else []):
                import difflib
                dentro = c.get("t_origen") is not None and tm["t_ini"] - 1 <= c["t_origen"] <= tm["t_fin"] + 1
                if dentro and difflib.SequenceMatcher(a=" ".join(toks(tm["texto"])), b=" ".join(toks(c["palabras"]))).ratio() >= 0.6:
                    ok = True; nota = f"corte intencional: toma mala quitada ({tm['texto'][:50]})"; break
        out.append({"t_export": t, "original": c["palabras"], "ventana": txt.strip()[:300], "coinciden": f"{hit}/{len(want)}", "estado": "PRESENTE" if ok else "REVISAR", "nota": nota})
        print(p, t, out[-1]["estado"], out[-1]["coinciden"], c["palabras"][:50], flush=True)
    res[p] = out
json.dump(res, open(OUTF, "w"), ensure_ascii=False, indent=1)
mal = sum(1 for v in res.values() for c in v if c["estado"] != "PRESENTE")
print("candidatos", sum(len(v) for v in res.values()), "por revisar", mal)
sys.exit(1 if mal else 0)
