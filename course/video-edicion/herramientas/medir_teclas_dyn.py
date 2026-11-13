"""Como medir_teclas.py pero siguiendo la caja donde esté (cajas-parte-N.json de buscar_cajas_negras.py, 2 fps):
la caja de la parte 1 cambia de tamaño y de sitio. Guarda por estado el rectángulo y el color del panel alrededor.
Salida: 03-analisis/teclas/parte-N/D/estados.json + k-<hash>.png. Uso: .venv/bin/python -I medir_teclas_dyn.py N"""
import json, os, subprocess, sys, hashlib
import numpy as np
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); STEP = 2
p = int(sys.argv[1]); out = f"{BASE}/03-analisis/teclas/parte-{p}/D"; os.makedirs(out, exist_ok=True)
cajas = json.load(open(f"{BASE}/03-analisis/teclas/cajas-parte-{p}.json"))
by_t = {}
for t, x0, y0, x1, y1, fill in cajas:
    k = round(t * 2)
    if k not in by_t or (x1 - x0) * (y1 - y0) > (by_t[k][2] - by_t[k][0]) * (by_t[k][3] - by_t[k][1]): by_t[k] = (x0, y0, x1, y1)
def rect_at(f):
    k = round(f / 60 * 2)
    for d in (0, -1, 1):
        if k + d in by_t: return by_t[k + d]
pr = subprocess.Popen(["ffmpeg", "-nostdin", "-v", "error", "-i", f"{BASE}/01-crudo/.por-numero/parte {p}.mp4", "-vf", f"select='not(mod(n\\,{STEP}))',format=rgb24",
                       "-fps_mode", "passthrough", "-f", "rawvideo", "-"], stdout=subprocess.PIPE)
FS = 1920 * 1080 * 3; estados, cur, i = [], None, 0
while True:
    b = pr.stdout.read(FS)
    if len(b) < FS: break
    f = i * STEP; r = rect_at(f); key = None; vacio = None; col = None
    if r:
        x0, y0, x1, y1 = r
        a = np.frombuffer(b, np.uint8).reshape(1080, 1920, 3)
        c = a[y0 + 2:y1 - 2, x0 + 2:x1 - 2]; g = c.mean(2); inner = g[4:-6, 4:-14]
        if inner.size and (inner < 24).mean() > 0.6:
            wht = (inner > 170).mean(); vacio = bool(wht < 0.002)
            key = hashlib.md5(np.packbits(inner[::4, ::4] > 110).tobytes() + bytes(str(c.shape), "ascii")).hexdigest()[:10]
            ring = np.concatenate([a[max(0, y0 - 5):max(0, y0 - 2), x0:x1].reshape(-1, 3), a[y0:y1, min(1919, x1 + 2):min(1920, x1 + 5)].reshape(-1, 3)])
            col = [int(v) for v in np.median(ring, 0)] if len(ring) else [49, 52, 51]
            png = f"{out}/k-{key}.png"
            if not vacio and not os.path.exists(png + ".ppm") and not os.path.exists(png):
                open(png + ".ppm", "wb").write(b"P6 %d %d 255\n" % (c.shape[1], c.shape[0]) + c.tobytes())
        else: r = None
    st = {"key": key, "rect": list(r) if r else None, "vacio": vacio}
    if cur and cur["key"] == st["key"] and cur["rect"] == st["rect"]: cur["fin"] = f + STEP
    else:
        if cur: estados.append(cur)
        cur = {"ini": f, "fin": f + STEP, "presente": r is not None, "color": col, **st}
    i += 1
if cur: estados.append(cur)
for fn in os.listdir(out):
    if fn.endswith(".ppm"):
        subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", f"{out}/{fn}", f"{out}/{fn[:-4]}"], check=True); os.remove(f"{out}/{fn}")
json.dump({"step": STEP, "dinamico": True, "estados": estados}, open(f"{out}/estados.json", "w"))
print(p, "estados", len(estados), "presente", sum(e["fin"] - e["ini"] for e in estados if e["presente"]), "de", i * STEP,
      "textos", len([x for x in os.listdir(out) if x.endswith(".png")]))
