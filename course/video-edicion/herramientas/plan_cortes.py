"""Construye el plan de cortes por parte (pasos 2, 3 y 4) y lo valida contra la transcripción."""
import json, os, sys
sys.path.insert(0, os.path.dirname(__file__))
from revisar_medium_lib import frames, diff  # noqa
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
FPS = 60
NO_UTIL = {"P1-001": "instalación del plugin en VS Code; solo se mueve el ratón y salen notificaciones",
           "P1-002": "VS Code sin cambios, solo aparece la barra de tareas",
           "P1-003": "acomoda la ventana del overlay de teclas; no se enseña nada",
           "P1-004": "acomoda la ventana del overlay de teclas; no se enseña nada",
           "P1-021": "mueve la ventana del overlay de teclas ('déjenme quito este de acá')"}
# Tomas erróneas: límites ajustados a la energía real del audio (Whisper pega las palabras)
WRONG = {"P1-007": (305.40, 317.16, "fin de 'modos' 305.16 s; la toma buena 'para movernos hacia abajo' arranca 317.36 s"),
         "P4-009": (532.46, 543.96, "fin de 'paréntesis' 532.44 s; la toma buena 'puedo seleccionarlo' arranca 544.14 s")}
STUTTER = {1: [("P1-T01", 1044.60, 1045.62, "se sale se sale del documento", "se sale del documento")],
           5: [("P5-T01", 239.70, 241.10, "sería el símbolo de el símbolo de la llavecita", "sería el símbolo de la llavecita"),
               ("P5-T02", 418.80, 420.30, "combinando los diferentes los diferentes comandos", "combinando los diferentes comandos")]}

def still_runs(src, t0, t1, margin):
    fr = frames(src, t0, t1)
    act = [t0 + (i+1)*0.25 for i in range(len(fr)-1) if diff(fr[i], fr[i+1]) > 15]
    prot = [(a-margin-0.25, a+margin) for a in act]
    runs, cur = [], t0
    for a, b in sorted(prot):
        if a > cur: runs.append((cur, min(a, t1)))
        cur = max(cur, b)
    if cur < t1: runs.append((cur, t1))
    return [(a, b) for a, b in runs if b - a >= 0.5], act


import wave, struct, math, glob
def rms_series(p, t0, t1):
    w = wave.open(f"{BASE}/03-analisis/audio/parte-{p}.wav"); sr = w.getframerate(); ch = w.getnchannels(); sw = w.getsampwidth()
    t0 = max(0.0, t0); w.setpos(int(t0 * sr)); raw = w.readframes(int((t1 - t0) * sr))
    data = struct.unpack("<%d%s" % (len(raw) // sw, {2: "h", 4: "i"}[sw]), raw); full = float(2 ** (8 * sw - 1)); win = int(0.02 * sr) * ch
    return [(t0 + i / ch / sr, 20 * math.log10(math.sqrt(sum(x * x for x in data[i:i + win]) / win) / full + 1e-9)) for i in range(0, len(data) - win, win)]
def quiet_runs(p, a, b, thr=-45.0, minlen=0.06):
    runs, cur = [], None
    for t, db in rms_series(p, a, b):
        if db < thr:
            cur = [t, t + 0.02] if cur is None else [cur[0], t + 0.02]
        else:
            if cur and cur[1] - cur[0] >= minlen: runs.append(cur)
            cur = None
    if cur and cur[1] - cur[0] >= minlen: runs.append(cur)
    return runs
def snap_cut(p, t_ini, t_fin):
    """Devuelve (ini, fin) en silencios reales alrededor de [t_ini, t_fin] o None si no hay bordes limpios."""
    pre = [r for r in quiet_runs(p, t_ini - 0.5, t_ini + 0.2) if r[0] <= t_ini + 0.2]
    post = [r for r in quiet_runs(p, t_fin - 0.2, t_fin + 0.5) if r[1] >= t_fin - 0.2]
    if not pre or not post: return None
    a = min(pre, key=lambda r: abs((r[0] + r[1]) / 2 - t_ini)); b = min(post, key=lambda r: abs((r[0] + r[1]) / 2 - t_fin))
    ini, fin = (a[0] + a[1]) / 2, (b[0] + b[1]) / 2
    return (round(ini, 3), round(fin, 3)) if fin - ini > 0.15 else None
def screen_action(src, a, b):
    fr = frames(src, a, b)
    return [round(a + (i + 1) * 0.25, 2) for i in range(len(fr) - 1) if diff(fr[i], fr[i + 1]) > 15]
REPS = []
for fjs in sorted(glob.glob(f"{BASE}/03-analisis/edicion/repeticiones-*.json")):
    REPS += json.load(open(fjs))

plan = {}
for p in range(1, 6):
    d = json.load(open(f"{BASE}/03-analisis/edicion/parte-{p}.json"))
    src = f"{BASE}/01-crudo/.por-numero/parte {p}.mp4"
    t = json.load(open(f"{BASE}/03-analisis/transcripts/parte-{p}.json"))
    words = [(w["start"], w["end"], w["w"].strip()) for s in t["segments"] for w in s["words"]]
    nframes = round(d["raw_duration_s"] * FPS)
    cuts, log = [], []
    for it in d["items"]:
        gs, ge = it.get("gap_full", [it["in"] - 0.25, it["out"] + 0.25])
        rec = {"id": it["id"], "type": it["type"], "confidence": it["confidence"],
               "in_tc": it["in_tc"], "out_tc": it["out_tc"], "dur_propuesta": it["dur"]}
        if it["id"] in WRONG:
            a, b, why = WRONG[it["id"]]
            cuts.append((a, b, it["id"], True)); rec.update(aplicado=[[a, b]], dur_cortada=round(b-a, 2),
                resultado="aplicado (toma errónea)", motivo=it["reason"] + " Límites por energía de audio: " + why)
        elif it["id"] == "P1-008":
            rec.update(aplicado=[], dur_cortada=0, resultado="incluido en P1-007", motivo="el rango queda dentro de la toma errónea P1-007")
        elif it["confidence"] == "high":
            cuts.append((it["in"], it["out"], it["id"], False))
            rec.update(aplicado=[[it["in"], it["out"]]], dur_cortada=round(it["out"]-it["in"], 2), resultado="aplicado", motivo=it["reason"])
        elif it["confidence"] == "medium":
            if it["id"] in NO_UTIL:
                a, b = gs + 0.2, ge - 0.2
                cuts.append((a, b, it["id"], False))
                rec.update(aplicado=[[round(a, 2), round(b, 2)]], dur_cortada=round(b-a, 2), resultado="aplicado (pausa 0.4 s)",
                           motivo="revisado con fotogramas: " + NO_UTIL[it["id"]])
            else:
                runs, act = still_runs(src, gs + 0.2, ge - 0.2, 0.3)
                if act:
                    runs, act = still_runs(src, gs + 0.75, ge - 0.75, 0.75)
                    kind = "con actividad útil en pantalla (escritura/cursor): se conserva la acción y solo se acortan los tramos quietos a 1.5 s"
                else:
                    kind = "pantalla quieta, sin palabras: se deja 0.4 s de pausa"
                for a, b in runs: cuts.append((a, b, it["id"], False))
                rec.update(aplicado=[[round(a, 2), round(b, 2)] for a, b in runs], dur_cortada=round(sum(b-a for a, b in runs), 2),
                           resultado="aplicado" if runs else "no aplicado", actividad_s=act[:60], motivo=kind)
        else:
            rec.update(aplicado=[], dur_cortada=0, resultado="no aplicado (baja: solo se reporta)", motivo=it["reason"])
        log.append(rec)
    for sid, a, b, before, after in STUTTER.get(p, []):
        cuts.append((a, b, sid, True))
        log.append({"id": sid, "type": "repeticion_traba", "confidence": "revisado", "aplicado": [[a, b]], "dur_cortada": round(b-a, 2),
                    "resultado": "aplicado", "antes": before, "despues": after,
                    "motivo": "repetición por traba; límites en silencios medidos con energía de audio (Whisper desplaza estas palabras)"})
    for r in [r for r in REPS if int(r["parte"]) == p]:
        rec = {"id": r["id"], "type": "repeticion", "confidence": r["decision"], "antes": r.get("antes", ""), "despues": r.get("despues", ""),
               "quitar_texto": r["quitar_texto"], "queda": r.get("queda", ""), "motivo_agente": r.get("motivo", "")}
        if r["decision"] != "cortar":
            rec.update(aplicado=[], dur_cortada=0, resultado="no aplicado (duda: se reporta)"); log.append(rec); continue
        if r.get("inicio_de_parte"):   # falso inicio: desde el fotograma 0 hasta el silencio previo a la toma buena
            post = [q for q in quiet_runs(p, float(r["t_fin"]) - 0.6, float(r["t_fin"]) + 0.3)]
            sc = (0.0, round(max(q[1] for q in post) - 0.05, 3)) if post else None
        else:
            sc = snap_cut(p, float(r["t_ini"]), float(r["t_fin"]))
        if not sc:
            rec.update(aplicado=[], dur_cortada=0, resultado="no aplicado: sin silencio limpio en los bordes"); log.append(rec); continue
        import re as _re, unicodedata as _ud
        def _n(t):
            t = _ud.normalize("NFD", t.lower()); return _re.sub(r"[^\w ]", "", "".join(c for c in t if _ud.category(c) != "Mn")).split()
        dentro = [w for ws, we, w in words if sc[0] < (ws + we) / 2 < sc[1]]
        if _n(" ".join(dentro)) != _n(r["quitar_texto"]):
            rec.update(aplicado=[], dur_cortada=0, dentro=" ".join(dentro), resultado="no aplicado: el silencio limpio más cercano quitaría otras palabras"); log.append(rec); continue
        act = [] if r.get("forzar_pantalla") else screen_action(src, sc[0], sc[1])
        if act:
            rec.update(aplicado=[], dur_cortada=0, actividad_s=act[:20], resultado="no aplicado: la pantalla muestra una acción dentro del tramo"); log.append(rec); continue
        cuts.append((sc[0], sc[1], r["id"], True))
        rec.update(aplicado=[list(sc)], dur_cortada=round(sc[1] - sc[0], 2), resultado="aplicado (bordes en silencio medido, " + ("revisión QA: acción repetida después)" if r.get("forzar_pantalla") else "pantalla quieta)")); log.append(rec)
    # validación contra palabras
    viol = []
    for a, b, cid, intentional in cuts:
        if intentional: continue
        for ws, we, w in words:
            if (ws - 0.1 < b and we + 0.1 > a):
                viol.append((cid, a, b, w, ws, we))
    # segmentos a conservar, en fotogramas
    cf = sorted((round(a * FPS), round(b * FPS)) for a, b, *_ in cuts)
    keep, cur = [], 0
    for a, b in cf:
        if a > cur: keep.append([cur, a])
        cur = max(cur, b)
    if cur < nframes: keep.append([cur, nframes])
    plan[p] = {"keep_frames": keep, "final_frames": sum(b-a for a, b in keep), "raw_frames": nframes, "violaciones": viol}
    json.dump({"parte": p, "items": log, "segmentos_conservados_frames": keep}, open(f"{BASE}/03-analisis/edicion/aplicados-parte-{p}.json", "w"), ensure_ascii=False, indent=1)
    print(p, "reps", [(x["id"], x["resultado"][:12]) for x in log if x["type"] == "repeticion"], "segmentos", len(keep), "bruto", round(nframes/FPS, 1), "final", round(plan[p]["final_frames"]/FPS, 1), "violaciones", viol)
json.dump(plan, open(f"{BASE}/03-analisis/edicion/plan-resolve.json", "w"), indent=1)
