"""Elige dónde va el logo en cada tramo para que nunca tape contenido.
Para cada 0.5 s del video final calcula, con el zoom de ese instante, qué zona del original cae bajo cada
posición candidata y mide la "tinta" (fracción de puntos que se apartan > 30 niveles de la mediana de la zona).
Las zonas tapadas por privacidad cuentan como vacías. Viterbi con penalización por cambio = el logo no salta.
Uso: .venv/bin/python -I colocar_logo.py  -> 04-davinci/logo-plan.json"""
import json, os, subprocess
import numpy as np
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
items = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))
W, H, SC = 960, 540, 0.5          # fotogramas del original a media resolución
LOGO = 120                         # caja del logo en el video final (px)
DEF = (1784, 8)                    # posición por defecto: arriba a la derecha
CANDS = [(x, y) for x in (1784, 1650) for y in (8, 112, 480, 820, 940)]
PATCH = {"as": [(548, 2, 900, 27), (168, 78, 145, 23)], "vs": [(326, 888, 290, 28)], "br": [(0, 66, 1920, 27), (1700, 36, 180, 26)]}
APPS = {1: [(0, 51.3, "as"), (51.3, 212.8, "vs"), (212.8, 1e9, "as")], 2: [(0, 47.9, "vs"), (47.9, 1e9, "as")], 3: [(0, 1e9, "as")], 4: [(0, 1e9, "as")],
        5: [(0, 828.3, "as"), (828.3, 855.2, "br"), (855.2, 861.6, "as"), (861.6, 915.6, "br"), (915.6, 1e9, "as")]}
def app_at(p, t): return next(k for a, b, k in APPS[p] if a <= t < b)
gy, gx = np.mgrid[0:24, 0:24]; gy = (gy + 0.5) / 24 * LOGO; gx = (gx + 0.5) / 24 * LOGO
plan = {}
for p in range(1, 6):
    src = f"{BASE}/01-crudo/.por-numero/parte {p}.mp4"
    rows = items[str(p)]["video"]; total = items[str(p)]["total_frames"]
    # muestras del video final cada 0.5 s -> (tiempo de origen, zoom)
    samples = []
    ri = 0
    for rec in range(0, total, 30):
        while not (rows[ri][2] <= rec < rows[ri][2] + rows[ri][1] - rows[ri][0]): ri += 1
        s, e, r, z, app = rows[ri]
        samples.append(((s + rec - r) / 60, z or [1.0, 0.0, 0.0], app))
    # decodifica solo los instantes necesarios (2 fps del original basta: se toma el más cercano)
    need = sorted({round(t * 2) for t, _, _ in samples})
    pr = subprocess.Popen(["ffmpeg", "-v", "error", "-i", src, "-vf", f"fps=2,scale={W}:{H},format=gray", "-f", "rawvideo", "-"], stdout=subprocess.PIPE)
    frames, idx, want = {}, 0, set(need)
    while True:
        b = pr.stdout.read(W * H)
        if len(b) < W * H: break
        if idx in want:
            f = np.frombuffer(b, np.uint8).reshape(H, W).copy()
            frames[idx] = f
        idx += 1
    cost = np.zeros((len(samples), len(CANDS)))
    for i, (t, (s, pan, tilt), app) in enumerate(samples):
        f = frames.get(round(t * 2))
        if f is None: f = frames[min(frames, key=lambda k: abs(k - t * 2))]
        f = f.astype(np.int16)
        fm = np.zeros((H, W), bool)   # zonas ya tapadas por privacidad = vacías
        for x, y, w, h in PATCH[app]:
            fm[int(y * SC):int((y + h) * SC) + 1, int(x * SC):int((x + w) * SC) + 1] = True
        for j, (cx, cy) in enumerate(CANDS):
            X = cx + gx; Y = cy + gy
            sx = (X - 960 - pan) / s + 960; sy = (Y - 540 + tilt) / s + 540
            ok = (sx >= 0) & (sx < 1920) & (sy >= 0) & (sy < 1080)
            iy, ix = np.clip((sy * SC).astype(int), 0, H - 1), np.clip((sx * SC).astype(int), 0, W - 1)
            v = f[iy, ix]; flat = fm[iy, ix]
            med = np.median(v[~flat]) if (~flat).any() else 0
            ink = ((np.abs(v - med) > 30) & ~flat & ok).mean()
            cost[i, j] = ink + (0 if (cx, cy) == DEF else 0.004)
    # Viterbi: penalización 0.08 por cambio de posición
    n, m = cost.shape; acc = cost[0].copy(); back = np.zeros((n, m), int); PEN = 0.08
    for i in range(1, n):
        trans = acc[:, None] + PEN * (1 - np.eye(m))
        back[i] = trans.argmin(0); acc = trans.min(0) + cost[i]
    path = [int(acc.argmin())]
    for i in range(n - 1, 0, -1): path.append(int(back[i, path[-1]]))
    path = path[::-1]
    segs = []
    for i, j in enumerate(path):
        rec = i * 30
        if segs and segs[-1]["pos"] == list(CANDS[j]): segs[-1]["rec_fin"] = min(total, rec + 30)
        else: segs.append({"rec_ini": rec, "rec_fin": min(total, rec + 30), "pos": list(CANDS[j])})
    tinta = [float(cost[i, j] - (0 if CANDS[j] == DEF else 0.004)) for i, j in enumerate(path)]
    plan[p] = {"segmentos": segs, "tinta_max": round(max(tinta), 4), "tinta_media": round(float(np.mean(tinta)), 5),
               "muestras_con_tinta_>2%": int(sum(1 for x in tinta if x > 0.02)), "muestras": len(tinta),
               "tinta_si_fijo_arriba_derecha_media": round(float(cost[:, CANDS.index(DEF)].mean()), 5)}
    print(p, {k: v for k, v in plan[p].items() if k != "segmentos"}, "segmentos", len(segs), flush=True)
json.dump(plan, open(f"{BASE}/04-davinci/logo-plan.json", "w"), indent=1)
