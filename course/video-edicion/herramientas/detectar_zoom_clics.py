"""Detecta clics, menús y acciones localizadas en pantalla y propone zooms suaves (1.25x, rampa 0.6 s).
Uso: .venv/bin/python -I detectar_zoom_clics.py   -> 03-analisis/frames/zoom-clics.json
Criterio por paso de 0.2 s (384x216 en gris):
  - píxeles que cambian > 20 niveles, excluyendo webcam + overlay de teclas (x<780, y>=690 en píxeles de origen)
    y la barra de título (y<30);
  - evento = al menos 30 px cambiados (~1200 px de origen) con caja envolvente <= 40 % del cuadro
    (descarta scroll y cambios de pantalla completa);
  - eventos a menos de 1.5 s se agrupan si caben en la ventana de zoom; si no, se abre otro grupo;
  - zoom = grupo de >= 2.5 s (se alarga 1.2 s tras el último evento), centrado en la caja del grupo."""
import json, os, subprocess
import numpy as np
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
W, H, FPS_S = 384, 216, 5
SX = 1920 / W
S = 1.25; ZW, ZH = 1920 / S, 1080 / S; MARGIN = 40
mask = np.ones((H, W), bool)
mask[: int(30 / SX), :] = False
mask[int(690 / SX):, : int(780 / SX)] = False
def frames(src):
    p = subprocess.Popen(["ffmpeg", "-v", "error", "-i", src, "-vf", f"fps={FPS_S},scale={W}:{H},format=gray", "-f", "rawvideo", "-"], stdout=subprocess.PIPE)
    while True:
        b = p.stdout.read(W * H)
        if len(b) < W * H: break
        yield np.frombuffer(b, np.uint8).reshape(H, W).astype(np.int16)
def window(cx, cy):
    cx = min(max(cx, ZW / 2), 1920 - ZW / 2); cy = min(max(cy, ZH / 2), 1080 - ZH / 2)
    return cx, cy, (cx - ZW / 2 + MARGIN, cy - ZH / 2 + MARGIN, cx + ZW / 2 - MARGIN, cy + ZH / 2 - MARGIN)
out = {}
for p in range(1, 6):
    events, prev = [], None
    for i, f in enumerate(frames(f"{BASE}/01-crudo/.por-numero/parte {p}.mp4")):
        if prev is not None:
            d = (np.abs(f - prev) > 20) & mask
            n = int(d.sum())
            if n >= 30:
                ys, xs = np.nonzero(d)
                x0, x1, y0, y1 = xs.min() * SX, (xs.max() + 1) * SX, ys.min() * SX, (ys.max() + 1) * SX
                if (x1 - x0) * (y1 - y0) <= 0.40 * 1920 * 1080:
                    events.append((i / FPS_S, x0, y0, x1, y1, n))
        prev = f
    groups = []
    for t, x0, y0, x1, y1, n in events:
        g = groups[-1] if groups else None
        if g and t - g["t1"] <= 1.5:
            ux0, uy0, ux1, uy1 = min(g["box"][0], x0), min(g["box"][1], y0), max(g["box"][2], x1), max(g["box"][3], y1)
            if ux1 - ux0 <= ZW - 2 * MARGIN and uy1 - uy0 <= ZH - 2 * MARGIN:
                g.update(t1=t, box=[ux0, uy0, ux1, uy1], n=g["n"] + 1); continue
        groups.append({"t0": t, "t1": t, "box": [x0, y0, x1, y1], "n": 1})
    zooms = []
    for g in groups:
        t0, t1 = round(g["t0"] - 0.4, 2), round(g["t1"] + 1.2, 2)
        if t1 - t0 < 2.5 or g["n"] < 2: continue
        bx0, by0, bx1, by1 = g["box"]
        cx, cy, _ = window((bx0 + bx1) / 2, (by0 + by1) / 2)
        zooms.append({"id": f"P{p}-C{len(zooms)+1:03d}", "t_start": max(0.0, t0), "t_end": t1, "scale": S,
                      "crop_rect_px": [round(cx - ZW / 2), round(cy - ZH / 2), round(ZW), round(ZH)], "ease_in_s": 0.6, "ease_out_s": 0.6,
                      "eventos": g["n"], "caja_accion_px": [round(v) for v in g["box"]],
                      "reason": "acción localizada en pantalla (clic, menú, diálogo o edición): zoom suave para que se lea"})
    out[p] = zooms
    tot = sum(z["t_end"] - z["t_start"] for z in zooms)
    print(p, "eventos", len(events), "grupos", len(groups), "zooms", len(zooms), "seg en zoom", round(tot, 1), flush=True)
json.dump(out, open(f"{BASE}/03-analisis/frames/zoom-clics.json", "w"), indent=1)
