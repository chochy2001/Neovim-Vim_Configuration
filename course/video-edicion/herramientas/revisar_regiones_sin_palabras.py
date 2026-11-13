"""Re-transcribe (Whisper en ventana) cada región con energía de voz que la máscara iba a cortar por no tener palabras.
Si hay palabras reales, la región se añade a la máscara (no se corta voz que Whisper se saltó en el archivo largo).
Uso: .venv/bin/python -I revisar_regiones_sin_palabras.py  -> actualiza habla-parte-N.json (clave "rescatadas")"""
import os
# Modelo de Whisper: si existe la copia local (.modelos/whisper-large-v3-turbo), se usa sin red. Si no, se descarga
# de Hugging Face en CADA ejecución (~2 min): no queda en ~/.cache. Ver COMO-EDITAR-CURSOS.md E58.
_ML = os.path.expanduser("~/Movies/Capdesis-Curso-Vim/.modelos/whisper-large-v3-turbo")
MODELO_WHISPER = _ML if os.path.isfile(f"{_ML}/config.json") else "mlx-community/whisper-large-v3-turbo"
import json, os, subprocess
import numpy as np, mlx_whisper
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); TH, HOP = -50.0, 0.02
for p in range(1, 6):
    hf = f"{BASE}/03-analisis/edicion/habla-parte-{p}.json"; h = json.load(open(hf))
    b = subprocess.run(["ffmpeg", "-v", "error", "-i", f"{BASE}/03-analisis/audio/parte-{p}.wav", "-f", "s16le", "-ac", "1", "-ar", "16000", "-"], capture_output=True).stdout
    a = np.frombuffer(b, np.int16).astype(float) / 32768; n = int(HOP * 16000)
    db = 20 * np.log10(np.sqrt((a[:len(a) // n * n].reshape(-1, n) ** 2).mean(1)) + 1e-9); v = db > TH
    regs, s = [], None
    for i, x in enumerate(np.append(v, False)):
        if x and s is None: s = i
        if not x and s is not None: regs.append([s * HOP, i * HOP]); s = None
    fuera = [r for r in regs if not any(k0 <= (r[0] + r[1]) / 2 <= k1 for k0, k1 in h["tramos"]) and r[1] - r[0] >= 0.25]
    resc = []
    for r0, r1 in fuera:
        subprocess.run(["ffmpeg", "-nostdin", "-v", "error", "-y", "-ss", str(max(0, r0 - 0.3)), "-t", str(r1 - r0 + 0.6), "-i", f"{BASE}/03-analisis/audio/parte-{p}.wav", "/tmp/reg.wav"])
        t = mlx_whisper.transcribe("/tmp/reg.wav", path_or_hf_repo=MODELO_WHISPER, language="es", condition_on_previous_text=False,
                                   no_speech_threshold=0.5)
        txt = t["text"].strip(); nsp = min([s_.get("no_speech_prob", 1) for s_ in t["segments"]] or [1])
        real = bool(txt) and nsp < 0.5 and txt.lower().strip(".¡!¿? ") not in ("gracias", "subtítulos realizados por la comunidad de amara.org")
        if real: resc.append({"ini": round(r0, 2), "fin": round(r1, 2), "texto": txt, "no_speech": round(nsp, 2)})
        print(p, round(r0, 2), round(r1 - r0, 2), "REAL" if real else "-", repr(txt[:60]), round(nsp, 2), flush=True)
    for r in resc:
        h["tramos"].append([max(0, r["ini"] - 0.18), r["fin"] + 0.28])
    h["tramos"].sort(); m = []
    for x in h["tramos"]:
        if m and x[0] - m[-1][1] < 0.45: m[-1][1] = max(m[-1][1], x[1])
        else: m.append(list(x))
    h["tramos"] = m; h["rescatadas"] = resc; h["segundos_voz"] = round(sum(y - x for x, y in m), 1)
    json.dump(h, open(hf, "w"), indent=0, ensure_ascii=False)
    print("PARTE", p, "revisadas", len(fuera), "rescatadas", len(resc), "voz", h["segundos_voz"], flush=True)
