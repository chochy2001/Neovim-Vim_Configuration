"""Localiza la caja negra de teclas en cada momento (2 fps), en la mitad inferior de la pantalla.
Píxel de caja = negro (<14) o blanco puro (>215). Busca el rectángulo de filas con racha larga de píxeles de caja.
Salida: 03-analisis/teclas/parte-N/caja.json  [[t, x0, y0, x1, y1] | [t, null]]  en píxeles 1920x1080."""
import json, os, subprocess, sys
import numpy as np
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
p = int(sys.argv[1]); out = f"{BASE}/03-analisis/teclas/parte-{p}"; os.makedirs(out, exist_ok=True)
W, H = 960, 270   # mitad inferior a la mitad de resolución
cmd = ["ffmpeg", "-nostdin", "-v", "error", "-i", f"{BASE}/01-crudo/.por-numero/parte {p}.mp4", "-vf", f"fps=2,crop=1920:540:0:540,scale={W}:{H}:flags=area,format=gray",
       "-f", "rawvideo", "-"]
pr = subprocess.Popen(cmd, stdout=subprocess.PIPE); res = []; i = 0
def runs(row):
    best = (0, 0, 0); s = None
    for x, v in enumerate(np.append(row, False)):
        if v and s is None: s = x
        if not v and s is not None:
            if x - s > best[0]: best = (x - s, s, x)
            s = None
    return best
while True:
    b = pr.stdout.read(W * H)
    if len(b) < W * H: break
    g = np.frombuffer(b, np.uint8).reshape(H, W)
    m = (g < 14) | (g > 215)
    good = []
    for y in range(H):
        if m[y].sum() < 150: continue
        n, a, c = runs(m[y])
        if n >= 150: good.append((y, a, c))
    box = None
    if len(good) >= 20:
        # bloque de filas consecutivas más largo
        blocks, cur = [], [good[0]]
        for r in good[1:]:
            if r[0] - cur[-1][0] <= 3: cur.append(r)
            else: blocks.append(cur); cur = [r]
        blocks.append(cur); bl = max(blocks, key=len)
        if len(bl) >= 20:
            x0 = int(np.median([r[1] for r in bl])); x1 = int(np.median([r[2] for r in bl]))
            box = [x0 * 2, 540 + bl[0][0] * 2, x1 * 2, 540 + (bl[-1][0] + 1) * 2]
    res.append([round(i / 2, 2)] + (box or [None]))
    i += 1
json.dump(res, open(f"{out}/caja.json", "w"))
from collections import Counter
c = Counter(tuple(round(v / 20) * 20 for v in r[1:]) for r in res if r[1] is not None)
print(p, "muestras", len(res), "con caja", sum(1 for r in res if r[1] is not None), "posiciones", c.most_common(5))
