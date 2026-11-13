"""Convierte el plan de cortes + zooms + zonas de privacidad en items de línea de tiempo (fotogramas a 60 fps)."""
import json, os
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
FPS = 60
plan = json.load(open(f"{BASE}/03-analisis/edicion/plan-resolve.json"))
zp = json.load(open(f"{BASE}/03-analisis/frames/zoom-plan.json"))
APPS = {1: [(0, 51.3, "as"), (51.3, 212.8, "vs"), (212.8, 1e9, "as")],
        2: [(0, 47.9, "vs"), (47.9, 1e9, "as")],
        3: [(0, 1e9, "as")], 4: [(0, 1e9, "as")],
        5: [(0, 828.3, "as"), (828.3, 855.2, "br"), (855.2, 861.6, "as"), (861.6, 915.6, "br"), (915.6, 1e9, "as")]}
def app_at(p, t):
    for a, b, k in APPS[p]:
        if a <= t < b: return k
def merged_zooms(p):
    zs = sorted(zp[str(p)], key=lambda z: z["t_start"]); out = []
    for z in zs:
        if out and z["scale"] == out[-1]["scale"] and z["crop_rect_px"] == out[-1]["rect"] and z["t_start"] - out[-1]["t_end"] <= 2.0:
            out[-1]["t_end"] = z["t_end"]; out[-1]["ids"].append(z["id"])
        else:
            out.append({"ids": [z["id"]], "t_start": z["t_start"], "t_end": z["t_end"], "scale": z["scale"], "rect": z["crop_rect_px"], "ease": z["ease_in_s"]})
    return out
# Ronda 2 (operador): todo silencio sin voz se corta -> sin time-lapse. Lo conservado = plan de cortes ∩ máscara de voz − tomas malas nuevas.
TIMELAPSE = {}
def recortar_por_voz(p, keep):
    hf = f"{BASE}/03-analisis/edicion/habla-parte-{p}.json"
    if not os.path.exists(hf): return keep
    voz = [(round(a * FPS), round(b * FPS)) for a, b in json.load(open(hf))["tramos"]]
    # el comando escrito en la línea de comandos se conserva aunque no hable (se ve lo que se teclea): ventana visual
    af_ = f"{BASE}/03-analisis/edicion/analisis-v2-parte-{p}.json"
    if os.path.exists(af_):
        voz += [(round((e["t_ini"] - 0.6) * FPS), round((e["t_fin"] + 1.2) * FPS)) for e in json.load(open(af_)).get("linea_comandos_visual", [])]
        voz.sort(); mv = []
        for a_, b_ in voz:
            if mv and a_ <= mv[-1][1]: mv[-1] = (mv[-1][0], max(mv[-1][1], b_))
            else: mv.append((a_, b_))
        voz = mv
    af = f"{BASE}/03-analisis/edicion/analisis-v2-parte-{p}.json"
    malas = [(round(t["t_ini"] * FPS), round(t["t_fin"] * FPS)) for t in (json.load(open(af)).get("tomas_malas_aplicables", []) if os.path.exists(af) else [])]
    out = []
    for k0, k1 in keep:
        for v0, v1 in voz:
            a, b = max(k0, v0), min(k1, v1)
            if b - a <= 0: continue
            segs = [(a, b)]
            for m0, m1 in malas:
                nxt = []
                for x0, x1 in segs:
                    if m1 <= x0 or m0 >= x1: nxt.append((x0, x1)); continue
                    if m0 > x0: nxt.append((x0, m0))
                    if m1 < x1: nxt.append((m1, x1))
                segs = nxt
            out += [[x0, x1] for x0, x1 in segs if x1 - x0 >= 15]      # trozos < 0.25 s fuera
    return out
CLICS = json.load(open(f"{BASE}/03-analisis/frames/zoom-clics.json"))
def all_zooms(p, keep):
    plan_z = merged_zooms(p)
    for z in plan_z: z["origen"] = "plan"
    def seg_of(t):
        for a, b in keep:
            if a/FPS <= t < b/FPS: return a/FPS, b/FPS
    auto, descartados = [], []
    for c in CLICS[str(p)]:
        z = {"ids": [c["id"]], "t_start": c["t_start"], "t_end": c["t_end"], "scale": c["scale"], "rect": c["crop_rect_px"], "ease": c["ease_in_s"], "origen": "clic"}
        sg = seg_of(z["t_start"])
        if not sg: descartados.append((c["id"], "empieza dentro de un corte")); continue
        z["t_end"] = min(z["t_end"], sg[1] - 0.05)
        if any(z["t_start"] < q["t_end"] + 0.8 and z["t_end"] > q["t_start"] - 0.8 for q in plan_z):
            descartados.append((c["id"], "se solapa con un zoom del plan")); continue
        if auto and z["t_start"] < auto[-1]["t_end"]:
            auto[-1]["t_end"] = z["t_start"]
            if auto[-1]["t_end"] - auto[-1]["t_start"] < 1.6: descartados.append((auto.pop()["ids"][0], "demasiado corto tras evitar solape"))
        if z["t_end"] - z["t_start"] < 1.6: descartados.append((c["id"], "demasiado corto dentro del segmento")); continue
        auto.append(z)
    # ronda 2: zoom a lugares que nombra y a la línea de comandos (prioridad sobre los de clic)
    extra = []
    af = f"{BASE}/03-analisis/edicion/analisis-v2-parte-{p}.json"
    if os.path.exists(af):
        A = json.load(open(af))
        RX = {"izquierda": 0, "centro": 320, "derecha": 640}; RY = {"arriba": 0, "centro": 180, "abajo": 360}
        for l in A.get("lugares", []):
            reg = l["region"]; v = "arriba" if reg.startswith("arriba") else ("abajo" if reg.startswith("abajo") else "centro")
            h_ = "izquierda" if reg.endswith("izquierda") else ("derecha" if reg.endswith("derecha") else "centro")
            extra.append({"ids": ["lugar"], "t_start": l["t_ini"], "t_end": max(l["t_fin"] + 1.2, l["t_ini"] + 2.4), "scale": 1.5,
                          "rect": [RX[h_], RY[v], 1280, 720], "ease": 0.8, "origen": "lugar", "nota": l["frase"]})
        # zoom a la línea de comandos cuando el comando SE VE escrito (detectar_linea_comandos.py), no cuando se dice
        for c in A.get("linea_comandos_visual", A.get("linea_comandos", [])):
            extra.append({"ids": ["comando"], "t_start": max(0, c["t_ini"] - 0.9), "t_end": c["t_fin"] + 1.6, "scale": 1.6,
                          "rect": [0, 405, 1200, 675], "ease": 0.8, "origen": "comando", "nota": c.get("texto", c.get("comando", ""))})
        # cara: habla a cámara sin pulsar teclas -> zoom 2.4x hacia la webcam (abajo-izquierda), E38: 1.8x apenas se notaba
        def hay_teclas(t0, t1):
            for pos in (("D",) if p == 1 else ("A",)):
                fe = f"{BASE}/03-analisis/teclas/parte-{p}/{pos}/estados.json"
                if not os.path.exists(fe): continue
                for st in json.load(open(fe))["estados"]:
                    if st.get("presente") and not st.get("vacio") and st["ini"] < t1 * FPS and st["fin"] > t0 * FPS: return True
            return False
        for c in A.get("camara", []):
            if c["t_fin"] - c["t_ini"] < 3.5 or hay_teclas(c["t_ini"], c["t_fin"]): continue
            extra.append({"ids": ["cara"], "t_start": c["t_ini"] + 0.3, "t_end": c["t_fin"] - 0.3, "scale": 2.4, "rect": [0, 630, 800, 450],
                          "ease": 0.8, "origen": "cara", "nota": c.get("nota", "")[:50]})
    ok_extra = []
    def kept_secs(a, b): return sum(max(0, min(b, k1 / FPS) - max(a, k0 / FPS)) for k0, k1 in keep)
    for z in sorted(extra, key=lambda z: z["t_start"]):
        # con los silencios cortados los tramos son cortos: el zoom puede abarcar varios (se calcula en tiempo de salida);
        # si empieza en un corte, se mueve al siguiente fotograma conservado (máx. 1.5 s)
        if not seg_of(z["t_start"]):
            nxt = [k0 / FPS for k0, k1 in keep if k0 / FPS > z["t_start"]]
            if not nxt or nxt[0] - z["t_start"] > 1.5: descartados.append((z["origen"], "empieza dentro de un corte")); continue
            z["t_start"] = nxt[0] + 0.02
        if kept_secs(z["t_start"], z["t_end"]) < 1.2: descartados.append((z["origen"], "demasiado corto")); continue
        if any(z["t_start"] < q["t_end"] + 0.5 and z["t_end"] > q["t_start"] - 0.5 for q in plan_z + ok_extra): descartados.append((z["origen"], "solape")); continue
        ok_extra.append(z)
    auto = [a for a in auto if not any(a["t_start"] < q["t_end"] + 0.5 and a["t_end"] > q["t_start"] - 0.5 for q in ok_extra)]
    for z in plan_z:
        sg = seg_of(z["t_start"])
        z["dentro_de_un_segmento"] = bool(sg and z["t_end"] <= sg[1] + 1e-6)
    todos = sorted(plan_z + auto + ok_extra, key=lambda z: z["t_start"])
    # números de línea siempre visibles: el recorte no empieza a la derecha del borde del editor
    gf = f"{BASE}/03-analisis/edicion/gutter-parte-{p}.json"
    if os.path.exists(gf):
        G = json.load(open(gf))
        for z in todos:
            if app_at(p, z["t_start"]) not in ("as", "vs") or z["origen"] == "cara": continue
            i = min(len(G["x"]) - 1, int(z["t_start"] / G["paso"])); g = G["x"][i] or 420
            if z["rect"][0] > g - 8: z["rect"] = [max(0, g - 8)] + list(z["rect"][1:]); z["ajuste_gutter"] = g
    return todos, descartados
EASE_F = {"plan": 60, "clic": 48, "lugar": 48, "comando": 48, "cara": 48}   # rampas en fotogramas del video FINAL: 1.0 s (plan) y 0.8 s (clic)
def full_state(z):
    S = z["scale"]; x, y, w, h = z["rect"]; cx, cy = x + w/2, y + h/2
    return (S, -(cx - 960) * S, (cy - 540) * S)
def mix(a, b, u):
    e = u * u * (3 - 2 * u)                    # smoothstep
    return tuple(a[i] + (b[i] - a[i]) * e for i in range(3))
IDENT = (1.0, 0.0, 0.0)
def zoom_track(zs, out_src):
    """Zoom por fotograma de salida. Las ventanas se pasan de tiempo del original a tiempo final; si dos zooms
    quedan cerca, se encadenan (la cámara se desplaza de un encuadre a otro sin alejarse)."""
    n = len(out_src); win = []
    import bisect
    srcs = out_src   # crecientes
    for z in zs:
        r0 = bisect.bisect_left(srcs, round(z["t_start"] * FPS)); r1 = bisect.bisect_left(srcs, round(z["t_end"] * FPS))
        if r1 - r0 < 30: continue
        win.append([r0, r1, full_state(z), 90 if z["scale"] >= 2 else EASE_F[z["origen"]]])   # 2x: rampa de 1.5 s
    win.sort()
    for i in range(1, len(win)):                # sin solapes en tiempo final
        if win[i][0] < win[i-1][1]: win[i-1][1] = win[i][0]
    win = [w for w in win if w[1] - w[0] >= 30]
    for i, w in enumerate(win):                 # cada zoom necesita sitio para entrar y salir completo
        lim = win[i + 1][0] if i + 1 < len(win) else n
        if w[1] - w[0] < 2 * w[3]: w[1] = min(w[0] + 2 * w[3], lim)
        w[3] = min(w[3], (w[1] - w[0]) // 2)
    track = [None] * n
    chains, cur = [], []
    for w in win:
        if cur and w[0] - cur[-1][1] < cur[-1][3] + w[3]: cur.append(w)
        else:
            if cur: chains.append(cur)
            cur = [w]
    if cur: chains.append(cur)
    for ch in chains:
        for k, (r0, r1, st, ez) in enumerate(ch):
            ez_in = min(ez, (r1 - r0) // 2)
            if k == 0:
                for r in range(r0, min(r1, r0 + ez_in)): track[r] = mix(IDENT, st, (r - r0 + 1) / (ez_in + 1))
                start_full = r0 + ez_in
            else:
                start_full = r0
            nxt = ch[k + 1] if k + 1 < len(ch) else None
            if nxt is None:
                end_full = max(start_full, r1 - ez)
                lim = next((c[0][0] for c in chains if c[0][0] > r0), n)   # no invadir el siguiente zoom
                end = min(lim, end_full + ez); ez_out = max(1, end - end_full)
                for r in range(start_full, end_full): track[r] = st
                for r in range(end_full, end): track[r] = mix(st, IDENT, (r - end_full + 1) / (ez_out + 1))
            else:
                t0 = max(start_full, r1 - ez); t1 = max(t0 + ez, min(nxt[1] - nxt[3], nxt[0] + nxt[3]))   # desplazamiento entre encuadres, al menos `ez` fotogramas
                for r in range(start_full, t0): track[r] = st
                for r in range(t0, t1): track[r] = mix(st, nxt[2], (r - t0 + 1) / (t1 - t0 + 1))
                ch[k + 1] = [t1, nxt[1], nxt[2], nxt[3]]
    return [None if (t is None or abs(t[0] - 1) < 1e-4 and abs(t[1]) < 0.01 and abs(t[2]) < 0.01) else (round(t[0], 4), round(t[1], 2), round(t[2], 2)) for t in track]
out = {}
for p in range(1, 6):
    keep = recortar_por_voz(p, plan[str(p)]["keep_frames"]); zs, descartados = all_zooms(p, keep)
    audio, out_src, rec = [], [], 0
    for k0, k1 in keep:
        # fotogramas de salida: normales, o 1 de cada `factor` dentro de un tramo acelerado (silencio largo con acción)
        tl_r = [(round(t["src_ini"] * FPS), round(t["src_fin"] * FPS), t["factor"]) for t in TIMELAPSE.get(str(p), []) if k0 <= round(t["src_ini"] * FPS) and round(t["src_fin"] * FPS) <= k1]
        frames_out, runs, f = [], [], k0
        for a, b, fac in sorted(tl_r):
            if f < a: frames_out += range(f, a); runs.append((f, a))
            sel = list(range(a, b, fac)); frames_out += sel; runs.append((a, a + len(sel)))   # audio: silencio contiguo de la misma duración
            f = b
        if f < k1: frames_out += range(f, k1); runs.append((f, k1))
        for a, b in runs:
            audio.append([a, b, rec]); rec += b - a
        out_src += frames_out
    assert len(out_src) == rec
    zt = zoom_track(zs, out_src)
    video, cur = [], None
    for i, f in enumerate(out_src):
        st = (zt[i], app_at(p, f/FPS))
        if cur and cur[3] == st and cur[1] == f:
            cur[1] = f + 1
        else:
            if cur: video.append(cur)
            cur = [f, f + 1, i, st]
    video.append(cur)
    # filas: [src_ini, src_fin_excl, rec, zoom|None, app]
    out[p] = {"audio": audio, "video": [[a, b, r, s[0], s[1]] for a, b, r, s in video], "total_frames": rec, "zooms": zs, "zooms_descartados": descartados}
    # control de suavidad: salto máximo de escala entre fotogramas consecutivos
    sc = [(z[0] if z else 1.0) for z in zt]; dmax = max(abs(sc[i+1] - sc[i]) for i in range(len(sc) - 1))
    out[p]["salto_max_escala_por_fotograma"] = round(dmax, 4)
    nz = sum(1 for v in out[p]["video"] if v[3])
    print(p, "video", len(video), "zoom-items", nz, "dur", round(rec/FPS, 2), "plan", sum(1 for z in zs if z["origen"] == "plan"), "clic", sum(1 for z in zs if z["origen"] == "clic"), "descartados", len(descartados), "salto max escala/fotograma", round(dmax, 4))
json.dump(out, open(f"{BASE}/04-davinci/items-timeline.json", "w"))
