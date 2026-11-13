"""Plan de las tarjetas animadas (Fusion): tiempo en el video final, posición sin tapar contenido y parámetros de la demo.
Entradas: 03-analisis/animaciones/momentos-parte-N.json (elegidos por agentes), validacion-demos.json (Neovim real), items-timeline.json.
Posición: como el logo, mide la "tinta" bajo cada candidata en el encuadre final (con el zoom) y elige la de menos.
Salida: 04-davinci/animaciones/plan-base.json. Uso: .venv/bin/python -I plan_animaciones.py"""
import json, os, subprocess, difflib
import numpy as np
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); A = f"{BASE}/03-analisis/animaciones"
items = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))
val = {v["id"]: v for v in json.load(open(f"{A}/validacion-demos.json"))}
DUR = 300                                     # 5 s: duración de una composición Fusion insertada por la API
CW = 640
CANDS = [(980, 110), (980, 430), (980, 760), (560, 110), (560, 430)]    # fuera de la columna del logo, del visor de teclas y de la webcam
INS = {"A", "I", "a", "i", "s", "cw", "ce", "ciw", "o", "O", "cip"}
W2, H2, SC = 960, 540, 0.5
out = {}
for p in range(1, 6):
    au = items[str(p)]["audio"]; rows = items[str(p)]["video"]; total = items[str(p)]["total_frames"]
    def to_rec(t):
        f = round(t * 60)
        for s, e, r in au:
            if s <= f < e: return r + f - s
    ms = json.load(open(f"{A}/momentos-parte-{p}.json")); plan = []
    # tildes: el texto en pantalla no puede ir sin acentos (E25)
    SIN = {"linea", "lineas", "ultima", "ultimo", "busqueda", "caracter", "despues", "parentesis", "mayuscula", "minuscula", "parrafo",
           "numero", "posicion", "accion", "tambien", "mas", "segun", "automatico", "rapido", "codigo", "funcion", "seleccion", "edicion"}
    import re as _re
    mal = [(m["id"], w) for m in ms for w in _re.findall(r"\w+", m["texto"].lower()) if w in SIN]
    if mal: raise SystemExit(f"TEXTO SIN TILDES: {mal}")
    need = {}
    for m in ms:
        rec = to_rec(m["src"])
        if rec is None or rec + DUR > total: print("DESCARTADO", m["id"], "cae en un corte o al final"); continue
        H = 252 if m.get("demo") else 168
        plan.append({"m": m, "rec": rec, "H": H})
    # tinta por candidata
    src = f"{BASE}/01-crudo/.por-numero/parte {p}.mp4"
    pr = subprocess.Popen(["ffmpeg", "-v", "error", "-i", src, "-vf", f"fps=2,scale={W2}:{H2},format=gray", "-f", "rawvideo", "-"], stdout=subprocess.PIPE)
    frames = []
    while True:
        b = pr.stdout.read(W2 * H2)
        if len(b) < W2 * H2: break
        frames.append(np.frombuffer(b, np.uint8).reshape(H2, W2))
    rowat = {}
    for s, e, r, z, a in rows:
        for k in range(0, e - s, 1): pass
    def sample(rec):
        for s, e, r, z, a in rows:
            if r <= rec < r + e - s: return (s + rec - r) / 60, (z or [1.0, 0.0, 0.0])
    sel = []
    for c in plan:
        H = c["H"]; gy, gx = np.mgrid[0:24, 0:48]; gy = (gy + 0.5) / 24 * H; gx = (gx + 0.5) / 48 * CW
        costs = []
        for (cx, cy) in CANDS:
            inks = []
            for rec in range(c["rec"], c["rec"] + DUR, 30):
                t, (s, pan, tilt) = sample(rec); f = frames[min(len(frames) - 1, round(t * 2))].astype(np.int16)
                X = cx + gx; Y = cy + gy; sx = (X - 960 - pan) / s + 960; sy = (Y - 540 + tilt) / s + 540
                iy = np.clip((sy * SC).astype(int), 0, H2 - 1); ix = np.clip((sx * SC).astype(int), 0, W2 - 1)
                v = f[iy, ix]; med = np.median(v); inks.append(float((np.abs(v - med) > 30).mean()))
            costs.append(max(inks) * 0.5 + np.mean(inks))
        j = int(np.argmin(costs)); c["pos"] = CANDS[j]; c["tinta"] = round(costs[j], 4); c["tinta_cands"] = [round(x, 4) for x in costs]
    for c in plan:
        m = c["m"]; d = m.get("demo"); dem = None
        if d:
            v = val[m["id"]]; assert v["ok"], m["id"]
            a, b = d["antes"], d["despues"]
            i0 = 0
            while i0 < min(len(a), len(b)) and a[i0] == b[i0]: i0 += 1
            j = 0
            while j < min(len(a), len(b)) - i0 and a[len(a) - 1 - j] == b[len(b) - 1 - j]: j += 1
            hl = (i0, len(a) - j) if a != b else (0, 0)
            ins = m["titulo"] in INS
            fin = v["nvim"].get("insercion") if ins else v["nvim"].get("cursor")
            ini = 0 if m["titulo"] == ";" else d["cursor_antes"]
            if m["titulo"] == ";": ini = 1
            dem = {"antes": a, "despues": b, "hl_ini": hl[0], "hl_fin": hl[1], "cur_ini": ini, "cur_fin": fin, "insertar": ins}
        sel.append({"id": m["id"], "parte": p, "rec_ini": c["rec"], "frames": DUR, "pos": c["pos"], "alto": c["H"], "tinta": c["tinta"], "tinta_cands": c["tinta_cands"],
                    "titulo": m["titulo"], "teclas": m["teclas"], "texto": m["texto"], "categoria": m["categoria"], "corrige_audio": m.get("corrige_audio", False), "demo": dem})
        print(p, m["id"], m["titulo"], "rec", c["rec"], "pos", c["pos"], "tinta", c["tinta"], c["tinta_cands"])
    out[str(p)] = sel
os.makedirs(f"{BASE}/04-davinci/animaciones", exist_ok=True)
json.dump(out, open(f"{BASE}/04-davinci/animaciones/plan-base.json", "w"), indent=1, ensure_ascii=False)
