"""Lee el texto de cada recorte de la caja de teclas con plantillas de glifos (fuente monoespaciada blanca sobre negro).
Las plantillas salen de los recortes que Vision (ocr_teclas.swift) leyó y cuyo número de glifos coincide.
Salida: 03-analisis/teclas/lectura.json {ruta_png: {"texto", "ocr", "dist_max", "coincide"}}"""
import json, glob, os, re, subprocess
import numpy as np
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim/03-analisis/teclas")
def load(png):
    b = subprocess.run(["ffmpeg", "-v", "error", "-i", png, "-f", "rawvideo", "-pix_fmt", "gray", "-"], capture_output=True).stdout
    w, h = map(int, subprocess.run(["ffprobe", "-v", "error", "-show_entries", "stream=width,height", "-of", "csv=p=0", png], capture_output=True, text=True).stdout.strip().split(","))
    return np.frombuffer(b, np.uint8).reshape(h, w).astype(float)
def norm(t):
    t = t.replace("CtIl", "Ctrl").replace("Ctıl", "Ctrl").replace("Ctil", "Ctrl").replace("‹", "<").replace("›", ">").replace(" * ", " + ")
    t = re.sub(r"\bLCtrl\b", "L Ctrl", t); t = re.sub(r"\s*\+\s*", " + ", t).strip()
    return t
def glyphs(g):
    g = g[4:-6, 4:-14]
    mx = g.max()
    if mx < 60: return None, []
    m = g > max(45, mx * 0.45)
    ys = np.where(m.any(1))[0]; xs = np.where(m.any(0))[0]
    if len(ys) == 0: return None, []
    y0, y1 = ys[0], ys[-1] + 1
    col = m[y0:y1].any(0); blobs, s = [], None
    for x, v in enumerate(np.append(col, False)):
        if v and s is None: s = x
        if not v and s is not None: blobs.append([s, x]); s = None
    # unir piezas muy cercanas (p. ej. partes de una letra)
    merged = []
    for b in blobs:
        if merged and b[0] - merged[-1][1] <= 1: merged[-1][1] = b[1]
        else: merged.append(b)
    H = y1 - y0; feats = []
    for a, c in merged:
        cx = (a + c) / 2; half = max(H * 0.32, (c - a) / 2 + 1)
        xa, xb = int(max(0, cx - half)), int(min(m.shape[1], cx + half + 1))
        crop = m[y0:y1, xa:xb].astype(float)
        yi = (np.linspace(0, crop.shape[0] - 1, 28)).astype(int); xi = (np.linspace(0, crop.shape[1] - 1, 20)).astype(int)
        feats.append(crop[np.ix_(yi, xi)].ravel())
    gaps = [merged[i + 1][0] - merged[i][1] for i in range(len(merged) - 1)]
    return (H, gaps), feats
files = sorted(glob.glob(f"{BASE}/parte-*/?/k-*.png"))
ocr = {}
for f in glob.glob(f"{BASE}/parte-*/?/ocr.json"):
    d = os.path.dirname(f)
    for k, v in json.load(open(f)).items(): ocr[f"{d}/{k}"] = v
data = {f: glyphs(load(f)) for f in files}
T = {}   # plantillas por carácter
for f, (info, feats) in data.items():
    v = ocr.get(f)
    if not v or not v["texto"] or min(v["conf"] or [0]) < 0.5: continue
    t = norm(v["texto"]); chars = [c for c in t if c != " "]
    if len(chars) == len(feats) and feats:
        for c, ft in zip(chars, feats): T.setdefault(c, []).append(ft)
print("plantillas:", {c: len(v) for c, v in sorted(T.items())})
keys = list(T); M = [np.array(T[c]) for c in keys]
res = {}
for f, (info, feats) in data.items():
    if not feats: res[f] = {"texto": "", "ocr": ocr.get(f, {}).get("texto"), "dist_max": 0}; continue
    H, gaps = info; out, dmax = "", 0
    for i, ft in enumerate(feats):
        ds = [np.abs(m - ft).mean(1).min() for m in M]; j = int(np.argmin(ds)); dmax = max(dmax, ds[j]); out += keys[j]
        if i < len(gaps) and gaps[i] > H * 0.45: out += " "
    o = norm(ocr.get(f, {}).get("texto") or "")
    res[f] = {"texto": norm(out), "ocr": o, "dist_max": round(float(dmax), 3), "coincide": norm(out) == o}
json.dump(res, open(f"{BASE}/lectura.json", "w"), indent=1, ensure_ascii=False)
co = [r for r in res.values() if r["ocr"]]
print("recortes", len(res), "con OCR", len(co), "coinciden", sum(r["coincide"] for r in co), "dist_max>0.12", sum(1 for r in res.values() if r["dist_max"] > 0.12))
