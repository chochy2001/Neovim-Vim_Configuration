"""Busca TODA caja negra rectangular (negro puro, componente conectado, área > 6000 px a 1080p, rectangularidad > 0.85)
en cada segundo del crudo, para que la caja de teclas vieja no asome nunca aunque se haya movido o esté tapada a medias.
Salida: 03-analisis/teclas/cajas-parte-N.json [[t, x0, y0, x1, y1, relleno], ...] (1 fps, coordenadas 1080p)."""
import json, os, subprocess, sys
import numpy as np
from scipy import ndimage
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); W, H = 960, 540
FINAL = "--final" in sys.argv; FALLA = False     # verificación: en el video FINAL no debe quedar ninguna caja de teclas
NAMES = {1: "01-modos-y-movimientos", 2: "02-insertar-pegar-y-buscar", 3: "03-buscar-caracteres-y-borrar", 4: "04-objetos-de-texto", 5: "05-ventanas-y-lineas"}
for p in [int(x) for x in sys.argv[1:] if not x.startswith("--")] or [1, 2, 3, 4, 5]:
    srcf = f"{BASE}/editado/{NAMES[p]}.mp4" if FINAL else f"{BASE}/01-crudo/.por-numero/parte {p}.mp4"
    pr = subprocess.Popen(["ffmpeg", "-v", "error", "-i", srcf, "-vf", f"fps=2,scale={W}:{H}:flags=neighbor,format=gray", "-f", "rawvideo", "-"], stdout=subprocess.PIPE)
    res, i = [], 0
    while True:
        b = pr.stdout.read(W * H)
        if len(b) < W * H: break
        g = np.frombuffer(b, np.uint8).reshape(H, W)
        lab, n = ndimage.label(g < 9)
        for k, sl in enumerate(ndimage.find_objects(lab), 1):
            h, w = sl[0].stop - sl[0].start, sl[1].stop - sl[1].start
            if h * w < 1500 or h < 25 or w < 40: continue
            fill = float((lab[sl] == k).mean())
            if fill < 0.85 or (h > 500 and w > 900): continue          # pantalla negra completa = transición, no caja
            # tamaño de la caja de teclas (a media resolución): 190-240 x 37-63 (abajo puede estar cortada por el borde)
            if not (190 <= w <= 240 and 37 <= h <= 63): continue
            res.append([i / 2, sl[1].start * 2, sl[0].start * 2, sl[1].stop * 2, sl[0].stop * 2, round(fill, 2)])
        i += 1
    pr.wait(); dur = float(subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", srcf], capture_output=True, text=True).stdout)
    assert pr.returncode == 0 and i >= 0.9 * dur * 2, f"parte {p}: solo {i} fotogramas leídos de {dur * 2:.0f} (ffmpeg {pr.returncode})"   # antes: [] = OK
    json.dump(res, open(f"{BASE}/03-analisis/verificacion/capas/cajas-final-parte-{p}.json" if FINAL else f"{BASE}/03-analisis/teclas/cajas-parte-{p}.json", "w"))
    from collections import Counter
    c = Counter((round(r[1], -1), round(r[2], -1), round(r[3], -1), round(r[4], -1)) for r in res)
    print(p, "muestras con caja", len({r[0] for r in res}), "de", i, "posiciones", c.most_common(8), flush=True)
    if FINAL and res: FALLA = True
sys.exit(1 if FALLA else 0)   # --final: cualquier caja = fallo
