"""Máscara de voz: qué tramos del crudo se conservan porque se HABLA (pedido del operador, ronda 2: todo silencio
sin voz se corta aunque se mueva en la interfaz).
Voz = energía > -50 dBFS (ventanas de 20 ms, huecos < 0.35 s rellenados) Y solapada con alguna palabra de Whisper
(así los clics de teclado no cuentan y las alucinaciones de Whisper en silencio tampoco).
Se conserva cada tramo con 0.18 s antes y 0.28 s después; tramos separados < 0.45 s se unen.
Salida: 03-analisis/edicion/habla-parte-N.json. Uso: .venv/bin/python -I mascara_voz.py"""
import json, os, subprocess
import numpy as np
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
TH, HOP, FILL, PRE, POST, MERGE = -50.0, 0.02, 0.35, 0.18, 0.28, 0.45
for p in range(1, 6):
    b = subprocess.run(["ffmpeg", "-v", "error", "-i", f"{BASE}/03-analisis/audio/parte-{p}.wav", "-f", "s16le", "-ac", "1", "-ar", "16000", "-"], capture_output=True).stdout
    a = np.frombuffer(b, np.int16).astype(float) / 32768; n = int(HOP * 16000)
    w = a[:len(a) // n * n].reshape(-1, n); db = 20 * np.log10(np.sqrt((w ** 2).mean(1)) + 1e-9); dur = len(a) / 16000
    v = db > TH
    # regiones de energía
    regs, s = [], None
    for i, x in enumerate(np.append(v, False)):
        if x and s is None: s = i
        if not x and s is not None: regs.append([s * HOP, i * HOP]); s = None
    merged = []
    for r in regs:
        if merged and r[0] - merged[-1][1] < FILL: merged[-1][1] = r[1]
        else: merged.append(r)
    words = [(w_["start"], w_["end"]) for sg in json.load(open(f"{BASE}/03-analisis/transcripts/parte-{p}.json"))["segments"] for w_ in sg.get("words") or []]
    wi = np.array(words)
    speech = [r for r in merged if ((wi[:, 0] < r[1]) & (wi[:, 1] > r[0])).any()]
    keep = []
    for a0, a1 in speech:
        a0, a1 = max(0, a0 - PRE), min(dur, a1 + POST)
        if keep and a0 - keep[-1][1] < MERGE: keep[-1][1] = max(keep[-1][1], a1)
        else: keep.append([a0, a1])
    # comprobación: palabras con energía que quedarían fuera (no debería haber)
    fuera = [w_ for w_ in words if not any(k0 <= (w_[0] + w_[1]) / 2 <= k1 for k0, k1 in keep) and db[min(len(db) - 1, int((w_[0] + w_[1]) / 2 / HOP))] > TH]
    kept = sum(b_ - a_ for a_, b_ in keep)
    json.dump({"umbral_db": TH, "tramos": [[round(x, 3), round(y, 3)] for x, y in keep], "segundos_voz": round(kept, 1), "duracion": round(dur, 1),
               "palabras_con_energia_fuera": len(fuera), "regiones_energia_sin_palabras": len(merged) - len(speech)},
              open(f"{BASE}/03-analisis/edicion/habla-parte-{p}.json", "w"), indent=0)
    print(p, "dur", round(dur), "voz", round(kept), f"({kept/dur:.0%})", "tramos", len(keep), "palabras fuera", len(fuera), "regiones sin palabras", len(merged) - len(speech))
