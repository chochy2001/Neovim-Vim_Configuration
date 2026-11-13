"""Borde izquierdo del editor (donde empiezan los números de línea) cada 5 s del crudo.
Divisor = columna casi constante en vertical con salto de brillo respecto a la de al lado (x 200-1000).
Los zooms no pueden recortar a la derecha de este borde (pedido del operador: siempre ver los números de línea).
Salida: 03-analisis/edicion/gutter-parte-N.json {"paso": 5, "x": [...]} (None si no se detecta)."""
import json, os, subprocess
import numpy as np
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); W, H = 1000, 780
for p in range(1, 6):
    pr = subprocess.Popen(["ffmpeg", "-v", "error", "-i", f"{BASE}/01-crudo/.por-numero/parte {p}.mp4", "-vf", "fps=0.2,crop=1000:780:0:120,format=gray", "-f", "rawvideo", "-"], stdout=subprocess.PIPE)
    xs = []
    while True:
        b = pr.stdout.read(W * H)
        if len(b) < W * H: break
        g = np.frombuffer(b, np.uint8).reshape(H, W).astype(float)
        sd, mn = g.std(0), g.mean(0)
        c = [x for x in range(200, 1000) if sd[x] < 4 and abs(mn[x] - mn[x - 2]) > 3]
        xs.append(int(c[0]) if c else None)
    json.dump({"paso": 5, "x": xs}, open(f"{BASE}/03-analisis/edicion/gutter-parte-{p}.json", "w"))
    v = [x for x in xs if x]; print(p, "muestras", len(xs), "detectadas", len(v), "valores", sorted(set(v))[:12])
