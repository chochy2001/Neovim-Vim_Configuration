"""Genera, por parte, en tiempo del video final (sin intro):
  04-davinci/overlays/v2-parte-N.mov    privacidad de la app + parche que tapa la caja de teclas vieja (va en V2, CON el zoom de V1)
  04-davinci/overlays/teclas-parte-N.mov visor de teclas nuevo (va en V4, SIN zoom: siempre visible y nítido)
  04-davinci/teclas-plan.json            tramos mostrados (para verificar)
Entradas: items-timeline.json, 03-analisis/teclas/parte-N/{A,B}/estados.json, teclas-final.json, color-parche.json.
Uso: python3 -I generar_capas_teclas.py [partes...]"""
import json, os, subprocess, sys, hashlib
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); H = f"{BASE}/03-analisis/herramientas"
T = f"{BASE}/03-analisis/teclas"; O = f"{BASE}/04-davinci/overlays"; W = f"{O}/teclas-png"; os.makedirs(W, exist_ok=True)
items = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))
fin = json.load(open(f"{T}/teclas-final.json")); col = json.load(open(f"{T}/color-parche.json"))
PATCH = {"A": (1, 702, 412, 118), "B": (301, 955, 470, 122)}      # caja + 2 px de margen (x, y, w, h)
PRIV = {"as": "androidstudio", "vs": "vscode", "br": "navegador"}
MOD = {"L Shift": "Shift", "R Shift": "Shift", "L Ctrl": "Ctrl", "R Ctrl": "Ctrl", "L Alt": "Alt", "R Alt": "Alt", "L Win": "Win", "R Win": "Win"}
NAME = {"Up": "↑", "Down": "↓", "Left": "←", "Right": "→", "Caps Lock": "Bloq Mayús"}
MIN_RUN, FADE = 4, 5
def groups(tok):
    t = list(tok); out, cur = [], []
    i = 0
    while i < len(t):
        k = t[i]
        if k in ("L Ctrl", "R Ctrl") and i + 1 < len(t) and t[i + 1] == "R Alt": cur.append("AltGr"); i += 2; continue
        if k in MOD: cur.append(MOD[k]); i += 1; continue
        shift = "Shift" in cur
        lab = NAME.get(k, k)
        if len(lab) == 1 and lab.isalpha(): lab = lab.upper() if shift else lab.lower()
        cur.append(lab); out.append(cur); cur = []; i += 1
    if cur: out.append(cur)
    return out
def COLR(p, app, r):
    pos = "A" if (r[0] < 200 and r[1] > 600) else "B"
    return col.get(f"{p}-{pos}-{app}") or col.get(f"{p}-{pos}-as") or [49, 52, 51]
def color(p, pos, app):
    c = col.get(f"{p}-{pos}-{app}") or col.get(f"{p}-{pos}-as") or [49, 52, 51]
    return "0x%02X%02X%02X" % tuple(c)
def png_teclas(g, pos, alpha, todo):
    key = hashlib.md5(json.dumps([g, pos, alpha]).encode()).hexdigest()[:12]; f = f"{W}/t-{key}.png"
    if not os.path.exists(f): todo.append({"out": f, "pos": pos, "groups": g, "alpha": alpha})
    return f
VACIO = f"{W}/vacio.png"
if not os.path.exists(VACIO):
    subprocess.run(["ffmpeg", "-v", "error", "-y", "-f", "lavfi", "-i", "color=c=black@0.0:s=1920x1080:d=0.04,format=rgba", "-frames:v", "1", "-update", "1", VACIO], check=True)
def png_v2(p, app, rects):
    """rects: tupla de (x0, y0, x1, y1, "0xRRGGBB") ya con margen. Un PNG por combinación."""
    f = f"{W}/v2-{p}-{app}-" + (hashlib.md5(json.dumps(rects).encode()).hexdigest()[:10] if rects else "0") + ".png"
    if not os.path.exists(f):
        vf = [f"drawbox=x={x0}:y={y0}:w={x1 - x0}:h={y1 - y0}:color={c}@1:t=fill:replace=1" for x0, y0, x1, y1, c in rects]
        src = f"{O}/privacidad-{PRIV[app]}.png"
        subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", src] + (["-vf", ",".join(vf)] if vf else []) + ["-frames:v", "1", "-update", "1", f], check=True)
    return f
def encode(runs, out):
    """Cada tramo (imagen, n fotogramas) se codifica aparte con -loop 1 (memoria baja) y se cachea por (imagen, n);
    luego se unen con el demuxer concat sin recodificar. (concat de imágenes + fps llegó a usar 12 GB.)"""
    seg_dir = f"{W}/segmentos"; os.makedirs(seg_dir, exist_ok=True); lst = out + ".txt"
    with open(lst, "w") as fh:
        for img, n in runs:
            sg = f"{seg_dir}/{os.path.basename(img)[:-4]}-{n}.mov"
            if not os.path.exists(sg):
                subprocess.run(["ffmpeg", "-v", "error", "-y", "-loop", "1", "-framerate", "60", "-i", img, "-frames:v", str(n), "-c:v", "qtrle", "-pix_fmt", "argb", sg + ".tmp.mov"], check=True)
                os.rename(sg + ".tmp.mov", sg)
            fh.write(f"file '{sg}'\n")
    subprocess.run(["ffmpeg", "-v", "error", "-y", "-f", "concat", "-safe", "0", "-i", lst, "-c", "copy", out], check=True)
plan = json.load(open(f"{BASE}/04-davinci/teclas-plan.json")) if os.path.exists(f"{BASE}/04-davinci/teclas-plan.json") else {}
for p in [int(x) for x in sys.argv[1:]] or [1, 2, 3, 4, 5]:
    d = items[str(p)]; N = d["total_frames"]
    out_src, app_of = [None] * N, [None] * N
    for s, e, r, z, a in d["video"]:
        for k in range(e - s): out_src[r + k] = s + k; app_of[r + k] = a
    assert None not in out_src
    nsrc = max(out_src) + 2
    # parche: rectángulo de la caja en cada instante (buscar_cajas_negras.py, 2 fps), con 4 px de margen; nunca donde
    # la revisión dijo "no es la caja". Etiquetas: parte 1 desde D (caja que se mueve), resto desde A (fija).
    q4 = lambda v: int(round(v / 4.0) * 4)
    MARG = 4
    cajas = {}
    cf = f"{T}/cajas-parte-{p}.json"
    for t_, x0, y0, x1, y1, fl in (json.load(open(cf)) if os.path.exists(cf) else []):
        k = round(t_ * 2)
        if k not in cajas or (x1 - x0) * (y1 - y0) > (cajas[k][2] - cajas[k][0]) * (cajas[k][3] - cajas[k][1]): cajas[k] = (x0, y0, x1, y1)
    noc = {k for k, v in fin.items() if v.get("no_es_caja")}
    lab = [None] * nsrc; anc = ["A"] * nsrc; rect_l = [None] * nsrc; col_l = [None] * nsrc
    if p == 1:
        for st in json.load(open(f"{T}/parte-1/D/estados.json"))["estados"]:
            if not st["presente"] or not st["rect"]: continue
            kp = f"{T}/parte-1/D/k-{st['key']}.png"
            if kp in noc: continue
            toks = [] if st["vacio"] else fin.get(kp, {}).get("tokens", [])
            x0, y0, x1, y1 = st["rect"]; c = st.get("color") or [49, 52, 51]
            if max(c) < 20: c = None          # el borde muestreado cayó en una zona negra: se usa el color habitual del panel (E36)
            for k in range(st["ini"], min(st["fin"], nsrc)):
                rect_l[k] = (x0, y0, x1, y1); col_l[k] = c; lab[k] = tuple(toks) if toks else None; anc[k] = "A" if (x0 < 200 and y0 > 600) else "B"
    else:
        fe = f"{T}/parte-{p}/A/estados.json"
        for st in json.load(open(fe))["estados"]:
            if not st["presente"]: continue
            toks = [] if st["vacio"] else fin.get(f"{T}/parte-{p}/A/k-{st['key']}.png", {}).get("tokens", [])
            for k in range(st["ini"], min(st["fin"], nsrc)): lab[k] = tuple(toks) if toks else None; rect_l[k] = (3, 704, 411, 818)
    # por fotograma de salida
    L, P2 = [], []
    for f in range(N):
        s = out_src[f]; app = app_of[f]; rs = []
        r1 = rect_l[s]; r2 = cajas.get(round(s / 60 * 2)) if p != 1 or r1 else None
        for r in [r1, r2]:
            if r:
                c = col_l[s] or COLR(p, app, r)
                rs.append((max(0, q4(r[0]) - MARG), max(0, q4(r[1]) - MARG), min(1920, q4(r[2]) + MARG), min(1080, q4(r[3]) + MARG), "0x%02X%02X%02X" % tuple(c)))
        t = lab[s]
        L.append((t, anc[s]) if t else None); P2.append((app, tuple(sorted(set(rs)))))
    # tramos cortos (destellos de transición) -> se quedan con la tecla anterior
    runs = []
    for v in L:
        if runs and runs[-1][0] == v: runs[-1][1] += 1
        else: runs.append([v, 1])
    for i in range(1, len(runs)):
        if runs[i][1] < MIN_RUN and runs[i][0] is not None and runs[i - 1][0] is not None: runs[i][0] = runs[i - 1][0]
    merged = []
    for v, n in runs:
        if merged and merged[-1][0] == v: merged[-1][1] += n
        else: merged.append([v, n])
    # cadena de PNG con fundido al aparecer y al desaparecer
    todo, seq, shown = [], [], []
    rec = 0
    for i, (v, n) in enumerate(merged):
        if v is None: seq.append((VACIO, n)); rec += n; continue
        g = groups(v[0]); pos = v[1]; full = png_teclas(g, pos, 1.0, todo)
        prev_none = i == 0 or merged[i - 1][0] is None; next_none = i == len(merged) - 1 or merged[i + 1][0] is None
        fi = FADE if prev_none and n >= 2 * FADE else 0; fo = FADE if next_none and n >= 2 * FADE + fi else 0
        for k in range(fi): seq.append((png_teclas(g, pos, round((k + 1) / (FADE + 1), 3), todo), 1))
        seq.append((full, n - fi - fo))
        for k in range(fo): seq.append((png_teclas(g, pos, round((FADE - k) / (FADE + 1), 3), todo), 1))
        shown.append({"rec_ini": rec, "rec_fin": rec + n, "teclas": g, "pos": pos, "original": list(v[0])}); rec += n
    seq = [(f, n) for f, n in seq if n > 0]
    if todo:
        for i in range(0, len(todo), 400):
            jf = f"{W}/trabajos-{p}-{i}.json"; json.dump(todo[i:i + 400], open(jf, "w"), ensure_ascii=False)
            subprocess.run(["swift", f"{H}/teclas_png.swift", jf], check=True, capture_output=True)
    _E = json.load(open(f"{BASE}/04-davinci/estructura.json")) if os.path.exists(f"{BASE}/04-davinci/estructura.json") else {}
    VER = _E.get("capa_ver_parte", {}).get(str(p), _E.get("capa_ver", "r2"))
    encode(seq, f"{O}/teclas-parte-{p}-{VER}.mov")   # nombre nuevo por versión (E34)
    # V2
    r2 = []
    for v in P2:
        if r2 and r2[-1][0] == v: r2[-1][1] += 1
        else: r2.append([v, 1])
    encode([(png_v2(p, a, rs), n) for (a, rs), n in r2], f"{O}/v2-parte-{p}-{VER}.mov")
    nf = {}
    for m in ("teclas", "v2"):
        nf[m] = int(subprocess.run(["ffprobe", "-v", "error", "-count_packets", "-select_streams", "v:0", "-show_entries", "stream=nb_read_packets", "-of", "csv=p=0",
                                    f"{O}/{m}-parte-{p}-{VER}.mov"], capture_output=True, text=True).stdout.strip())
    plan[str(p)] = {"total_frames": N, "frames_teclas_mov": nf["teclas"], "frames_v2_mov": nf["v2"], "tramos": shown,
                    "con_parche": sum(1 for v in P2 if v[1]), "pngs_nuevos": len(todo)}
    print(p, "frames", N, nf, "tramos", len(shown), "con parche", plan[str(p)]["con_parche"], flush=True)
    json.dump(plan, open(f"{BASE}/04-davinci/teclas-plan.json", "w"), ensure_ascii=False)
