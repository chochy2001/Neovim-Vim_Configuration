"""Hojas de fotogramas del render FINAL (editado/) para revisar las capas nuevas:
 - visor de teclas: 12 tramos por parte (mitad del tramo), incluidos con zoom
 - animaciones Fusion: cada tarjeta a 1.0 s, 1.9 s y 3.5 s
Además mide en cada muestra de teclas que la caja negra vieja NO aparezca (fracción de negro puro en su zona, con el zoom de ese fotograma).
Salida: 03-analisis/verificacion/capas/parte-N-teclas.jpg, parte-N-animaciones.jpg y capas.json. Uso: .venv/bin/python -I verificar_capas.py"""
import json, os, subprocess
import numpy as np
import os
_EST = json.load(open(os.path.expanduser("~/Movies/Capdesis-Curso-Vim/04-davinci/estructura.json"))); PRE_S = _EST['pre'] / 60   # intro 4 s + lista 5 s (plan_estructura.py)
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); OUT = f"{BASE}/03-analisis/verificacion/capas"; os.makedirs(OUT, exist_ok=True)
NAMES = {1: "01-modos-y-movimientos", 2: "02-insertar-pegar-y-buscar", 3: "03-buscar-caracteres-y-borrar", 4: "04-objetos-de-texto", 5: "05-ventanas-y-lineas"}
items = json.load(open(f"{BASE}/04-davinci/items-timeline.json")); tp = json.load(open(f"{BASE}/04-davinci/teclas-plan.json"))
an = json.load(open(f"{BASE}/04-davinci/animaciones-plan.json"))
POS = {"A": (3, 704, 411, 818), "B": (303, 957, 769, 1075)}
def frame(f, t):
    b = subprocess.run(["ffmpeg", "-v", "error", "-ss", f"{t:.3f}", "-i", f, "-frames:v", "1", "-f", "rawvideo", "-pix_fmt", "rgb24", "-"], capture_output=True).stdout
    return np.frombuffer(b, np.uint8).reshape(1080, 1920, 3)
def sheet(imgs, labels, out, cols=3):
    import math
    tiles = []
    for im in imgs: tiles.append(im[::3, ::3])
    h, w = tiles[0].shape[:2]; rows = math.ceil(len(tiles) / cols)
    S = np.zeros((rows * h, cols * w, 3), np.uint8)
    for i, t in enumerate(tiles): S[(i // cols) * h:(i // cols + 1) * h, (i % cols) * w:(i % cols + 1) * w] = t
    p = subprocess.run(["ffmpeg", "-v", "error", "-y", "-f", "rawvideo", "-pix_fmt", "rgb24", "-s", f"{S.shape[1]}x{S.shape[0]}", "-i", "-", "-q:v", "3", out], input=S.tobytes())
logo_png = np.frombuffer(subprocess.run(["ffmpeg", "-v", "error", "-i", f"{BASE}/04-davinci/overlays/logo-capdesis-120.png", "-f", "rawvideo", "-pix_fmt", "rgba", "-"],
                                        capture_output=True).stdout, np.uint8).reshape(120, 120, 4).astype(int)
LOGOP = json.load(open(f"{BASE}/04-davinci/logo-plan.json")); COLP = json.load(open(f"{BASE}/03-analisis/teclas/color-parche.json"))
rep = {}
for p, n in NAMES.items():
    f = f"{BASE}/editado/{n}.mp4"; rows = items[str(p)]["video"]
    zmap = {}
    def zoom_at(rec):
        for s, e, r, z, a in rows:
            if r <= rec < r + e - s: return z or [1.0, 0.0, 0.0]
    tr = [t for t in tp[str(p)]["tramos"] if t["rec_fin"] - t["rec_ini"] >= 40]
    pick = [tr[int(i * (len(tr) - 1) / 11)] for i in range(12)]
    zoomed = [t for t in tr if zoom_at((t["rec_ini"] + t["rec_fin"]) // 2)[0] > 1.05]
    pick += zoomed[:: max(1, len(zoomed) // 6)][:6]
    imgs, labs, caja = [], [], []
    for t in pick:
        rec = (t["rec_ini"] + t["rec_fin"]) // 2; im = frame(f, rec / 60 + PRE_S); s, pan, tilt = zoom_at(rec)
        x0, y0, x1, y1 = POS.get(t["pos"], POS["A"])
        # zona de la caja vieja en pantalla con el zoom de ese fotograma
        X0, X1 = (x0 - 960) * s + 960 + pan, (x1 - 960) * s + 960 + pan; Y0, Y1 = (y0 - 540) * s + 540 - tilt, (y1 - 540) * s + 540 - tilt
        xa, xb, ya, yb = int(max(0, X0)), int(min(1920, X1)), int(max(0, Y0)), int(min(1080, Y1))
        blk = float((im[ya:yb, xa:xb].mean(2) < 8).mean()) if xb > xa and yb > ya else 0.0
        # la tecla nueva debe VERSE en el final en ese instante (detecta capas viejas en caché de Resolve, E34)
        ax0, ay0, ax1, ay1 = (16, 728, 260, 800) if t["pos"] == "A" else (380, 984, 692, 1052)
        blanco = float((im[ay0:ay1, ax0:ax1].min(2) > 225).mean())
        caja.append({"rec": rec, "teclas": t["teclas"], "zoom": s, "negro_puro_en_caja_vieja": round(blk, 3), "tecla_visible": round(blanco, 3)})
        imgs.append(im); labs.append(str(t["teclas"]))
    sheet(imgs, labs, f"{OUT}/parte-{p}-teclas.jpg")
    imgs = []
    for a in an[str(p)]:
        for dt in (1.0, 1.9, min(3.5, a["frames"] / 60 - 0.5)): imgs.append(frame(f, (a["rec_ini"] / 60) + PRE_S + dt))
    sheet(imgs, None, f"{OUT}/parte-{p}-animaciones.jpg")
    # color: logo (píxeles opacos) y parche de la caja vieja deben salir como en sus PNG (Data Level Full)
    g = LOGOP[str(p)]["segmentos"][0]; x, y = g["pos"]; im = frame(f, (g["rec_ini"] + g["rec_fin"]) / 120 + PRE_S)[y:y + 120, x:x + 120].astype(int)
    m = logo_png[..., 3] > 250; dlogo = float(np.abs(im[m] - logo_png[..., :3][m]).mean())
    dpar = None
    # parche: un fotograma sin zoom donde haya caja detectada (cajas-parte-N.json); color medido vs color esperado del panel
    cj = {round(c_[0] * 2): c_[1:5] for c_ in json.load(open(f"{BASE}/03-analisis/teclas/cajas-parte-{p}.json"))}
    dpar = None
    for s_, e_, r_, z_, a_ in rows:
        sm = s_ + (e_ - s_) // 2; rc = cj.get(round(sm / 60 * 2))
        rec = r_ + (e_ - s_) // 2
        libre = not any(t_["rec_ini"] - 20 <= rec < t_["rec_fin"] + 20 for t_ in tp[str(p)]["tramos"])   # sin tecla nueva encima (E23)
        if z_ is None and e_ - s_ > 300 and a_ == "as" and rc and libre:
            x0, y0, x1, y1 = rc; im = frame(f, rec / 60 + PRE_S)
            med = np.median(im[y0 + 10:y0 + 30, x0 + 12:x0 + 60].reshape(-1, 3), 0)
            pos = "A" if (x0 < 200 and y0 > 600) else "B"; ref = COLP.get(f"{p}-{pos}-as")
            dpar = float(np.abs(med - np.array(ref)).max()) if ref else None
            break
    rep[str(p)] = {"error_color_logo_medio": round(dlogo, 2), "error_color_parche_max": dpar, "muestras_teclas": caja, "max_negro_caja_vieja": max(c["negro_puro_en_caja_vieja"] for c in caja),
                   "teclas_no_visibles": sum(1 for c in caja if c["tecla_visible"] < 0.04), "animaciones": len(an[str(p)])}
    print(p, "color logo", round(dlogo, 2), "color parche", dpar, "muestras", len(caja), "max negro en caja vieja", rep[str(p)]["max_negro_caja_vieja"], flush=True)
json.dump(rep, open(f"{OUT}/capas.json", "w"), indent=1)
