"""Ronda 2: TODAS las tarjetas de comandos (analisis-v2-parte-N.json) y de marcas, en tiempo del video final.
- Aparecen 0.25 s DESPUÉS de que termina de nombrar el comando o la marca (sin spoilers); si ese instante cae en un corte, en el siguiente fotograma conservado.
- Duración 5 s (300 f); si llega otra antes, la anterior se acorta (mín. 150 f). Máximo 2 a la vez en posiciones distintas.
- Posición: la de menos tinta (con el zoom de cada instante), sin pisar otra tarjeta activa.
- Marcas: la primera mención de cada marca en la parte (o si pasaron > 120 s); insignia de 3 s.
- Textos con tildes obligatorias (E25). Demos solo si validaron en Neovim (validacion-demos-v2.json).
Salida: 04-davinci/animaciones/plan-v2.json. Uso: .venv/bin/python -I plan_animaciones_v2.py"""
import json, os, re, subprocess
import numpy as np
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); E = f"{BASE}/03-analisis/edicion"
items = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))
val = {v["id"]: v for v in json.load(open(f"{BASE}/03-analisis/animaciones/validacion-demos-v2.json"))}
INS = {"A", "I", "a", "i", "s", "cw", "ce", "ciw", "o", "O", "cip", "C", "ci(", "ci{", "cc", "S", "ct)", "ct{letra}"}
SIN = {"linea", "lineas", "ultima", "ultimo", "busqueda", "caracter", "despues", "parentesis", "mayuscula", "minuscula", "parrafo",
       "numero", "posicion", "accion", "tambien", "segun", "automatico", "rapido", "codigo", "funcion", "seleccion", "edicion", "pagina"}
CW, W2, H2, SC = 640, 960, 540, 0.5
CARD_C = [(1240, 150), (1240, 440), (1240, 760), (980, 110), (980, 430), (980, 760), (560, 110), (560, 430)]   # a la derecha suele haber hueco
LOGOP = json.load(open(f"{BASE}/04-davinci/logo-plan.json"))
MARCA_C = [(700, 24), (1100, 24), (700, 140)]; MW, MH = 520, 104
def overlap(a, b): return a[0] < b[2] and b[0] < a[2] and a[1] < b[3] and b[1] < a[3]
out = {}
for p in range(1, 6):
    A = json.load(open(f"{E}/analisis-v2-parte-{p}.json")); au = items[str(p)]["audio"]; rows = items[str(p)]["video"]; total = items[str(p)]["total_frames"]
    mal = [(c["id"], w) for c in A["comandos"] for w in re.findall(r"\w+", c["texto"].lower()) if w in SIN]
    if mal: raise SystemExit(f"TEXTO SIN TILDES: {mal}")
    def to_rec(t):
        f = round(t * 60)
        for s, e, r in au:
            if f < s: return r                     # cae en un corte: siguiente fotograma conservado
            if s <= f < e: return r + f - s
    # revisión manual del flag CORRECCIÓN (E44): el análisis por agentes marcó como corrección comandos bien explicados
    CORR = json.load(open(f"{BASE}/03-analisis/edicion/correcciones-tarjetas.json"))
    ev = []
    for c in A["comandos"]:
        rec = to_rec(c["t_mencion_fin"] + 0.25)
        if rec is None or rec > total - 150: continue
        d = c.get("demo"); dem = None
        if d and c["id"] in val and val[c["id"]]["ok"]:
            a, b = d["antes"], d["despues"]; i0 = 0
            while i0 < min(len(a), len(b)) and a[i0] == b[i0]: i0 += 1
            j = 0
            while j < min(len(a), len(b)) - i0 and a[len(a) - 1 - j] == b[len(b) - 1 - j]: j += 1
            ins = c["titulo"] in INS; v = val[c["id"]]["nvim"]
            dem = {"antes": a, "despues": b, "hl_ini": i0 if a != b else 0, "hl_fin": len(a) - j if a != b else 0,
                   "cur_ini": d["cursor_antes"], "cur_fin": v.get("insercion") if ins else v.get("cursor"), "insertar": ins}
        ev.append({"tipo": "comando", "id": c["id"], "rec_ini": rec, "titulo": c["titulo"], "teclas": c["teclas"], "texto": c["texto"],
                   "categoria": c["categoria"], "corrige_audio": CORR.get(c["id"], {}).get("corrige_audio", c.get("corrige_audio", False)), "demo": dem, "alto": 252 if dem else 168})
    last = {}
    for k, m in enumerate(sorted(A["marcas"], key=lambda m: m["t_fin"])):
        rec = to_rec(m["t_fin"] + 0.25); nm = m["marca"]
        if rec is None or rec > total - 200: continue
        if nm in last and rec - last[nm] < 120 * 60: continue
        last[nm] = rec
        ev.append({"tipo": "marca", "id": f"p{p}-m{k + 1:02d}", "rec_ini": rec, "marca": nm, "alto": MH})
    ev.sort(key=lambda e: e["rec_ini"])
    # tinta del original (2 fps) para elegir posición
    pr = subprocess.Popen(["ffmpeg", "-v", "error", "-i", f"{BASE}/01-crudo/.por-numero/parte {p}.mp4", "-vf", f"fps=2,scale={W2}:{H2},format=gray", "-f", "rawvideo", "-"], stdout=subprocess.PIPE)
    frames = []
    while True:
        b_ = pr.stdout.read(W2 * H2)
        if len(b_) < W2 * H2: break
        frames.append(np.frombuffer(b_, np.uint8).reshape(H2, W2))
    def sample(rec):
        for s, e, r, z, a in rows:
            if r <= rec < r + e - s: return (s + rec - r) / 60, (z or [1.0, 0.0, 0.0])
        return None, [1.0, 0.0, 0.0]
    def ink(x, y, w, h, r0, r1):
        gy, gx = np.mgrid[0:16, 0:32]; gy = (gy + 0.5) / 16 * h; gx = (gx + 0.5) / 32 * w; vals = []
        for rec in range(r0, r1, 30):
            t, (s, pan, tilt) = sample(rec)
            if t is None: continue
            f = frames[min(len(frames) - 1, round(t * 2))].astype(np.int16)
            sx = (x + gx - 960 - pan) / s + 960; sy = (y + gy - 540 + tilt) / s + 540
            v = f[np.clip((sy * SC).astype(int), 0, H2 - 1), np.clip((sx * SC).astype(int), 0, W2 - 1)]; vals.append(float((np.abs(v - np.median(v)) > 30).mean()))
        return (max(vals) * 0.5 + np.mean(vals)) if vals else 0
    # duraciones y posiciones
    for i, e in enumerate(ev):
        D = 300 if e["tipo"] == "comando" else 180
        e["frames"] = D
    placed = []
    for e in ev:
        act = [q for q in placed if q["rec_ini"] + q["frames"] > e["rec_ini"]]
        if len(act) >= 2:                                   # máximo 2 a la vez: se acorta la más antigua
            q = min(act, key=lambda q: q["rec_ini"]); q["frames"] = max(150 if q["tipo"] == "comando" else 120, e["rec_ini"] - q["rec_ini"])
            act = [q for q in placed if q["rec_ini"] + q["frames"] > e["rec_ini"]]
            if len(act) >= 2: e["rec_ini"] = min(q["rec_ini"] + q["frames"] for q in act)
        busy = [q["rect"] for q in placed if q["rec_ini"] + q["frames"] > e["rec_ini"]]
        busy += [(g["pos"][0] - 10, g["pos"][1] - 10, g["pos"][0] + 130, g["pos"][1] + 130) for g in LOGOP[str(p)]["segmentos"]
                 if g["rec_ini"] < e["rec_ini"] + e["frames"] and g["rec_fin"] > e["rec_ini"]]          # nunca encima del logo
        C = CARD_C if e["tipo"] == "comando" else MARCA_C; w, h = (CW, e["alto"]) if e["tipo"] == "comando" else (MW, MH)
        best = None
        for (x, y) in C:
            r = (x, y, x + w, y + h)
            if any(overlap(r, b) for b in busy): continue
            c_ = ink(x, y, w, h, e["rec_ini"], min(total, e["rec_ini"] + e["frames"]))
            if best is None or c_ < best[0]: best = (c_, (x, y), r)
        if best is None: best = (1, C[0], (C[0][0], C[0][1], C[0][0] + w, C[0][1] + h))
        e["tinta"], e["pos"], e["rect"] = round(best[0], 4), best[1], best[2]
        placed.append(e)
    out[str(p)] = ev
    print(p, "comandos", sum(1 for e in ev if e["tipo"] == "comando"), "marcas", sum(1 for e in ev if e["tipo"] == "marca"),
          "acortadas", sum(1 for e in ev if e["frames"] < (300 if e["tipo"] == "comando" else 180)), "tinta>0.06", sum(1 for e in ev if e["tinta"] > 0.06), flush=True)
os.makedirs(f"{BASE}/04-davinci/animaciones", exist_ok=True)
json.dump(out, open(f"{BASE}/04-davinci/animaciones/plan-v2.json", "w"), indent=1, ensure_ascii=False)
