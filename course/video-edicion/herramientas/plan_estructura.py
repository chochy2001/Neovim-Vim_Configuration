"""Estructura de cada video (ronda 2): intro 4 s + lista "En esta parte" 5 s (Fusion) + contenido + resumen (cabecera Fusion
y las tarjetas de los comandos clave, de 2 en 2, ampliadas) + cierre 4 s. Música suave solo en lista y resumen.
También los tramos "a cámara" (agentes) sin teclas pulsadas >= 3 s -> ya NO se usa aquí (cara = []): la cara se amplía con un zoom real 2.4x en items_timeline.py (E31, E38).
Salida: 04-davinci/estructura.json (la leen resolve_externo, finalizar_audio, reporte y verificadores). Uso: python3 -I plan_estructura.py"""
import json, os
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); AN = f"{BASE}/04-davinci/animaciones"
INTRO, LISTA, OUTRO, CAB = 240, 300, 240, 50
items = json.load(open(f"{BASE}/04-davinci/items-timeline.json")); anim = json.load(open(f"{BASE}/04-davinci/animaciones-plan.json"))
plan2 = json.load(open(f"{AN}/plan-v2.json")); tp = json.load(open(f"{BASE}/04-davinci/teclas-plan.json"))
CAM = (0, 820, 320, 260); ZC = 1.8; TARGET = (300, 760)                       # webcam en el crudo y dónde queda ampliada
_prev = json.load(open(f"{BASE}/04-davinci/estructura.json")) if os.path.exists(f"{BASE}/04-davinci/estructura.json") else {}
est = {"capa_ver": _prev.get("capa_ver", "r2"), "capa_ver_parte": _prev.get("capa_ver_parte", {}), "capas_tarjetas": _prev.get("capas_tarjetas", "capas-v2"), "intro": INTRO, "lista": LISTA, "pre": INTRO + LISTA, "outro": OUTRO, "partes": {}}
for p in range(1, 6):
    P = str(p); T = items[P]["total_frames"]; A = json.load(open(f"{BASE}/03-analisis/edicion/analisis-v2-parte-{p}.json"))
    clip = {a["id"]: a for a in anim[P]}; bytit = {}
    for e in plan2[P]:
        if e["tipo"] == "comando" and e["titulo"] not in bytit and e["id"] in clip: bytit[e["titulo"]] = clip[e["id"]] | {"alto": e["alto"]}
    res = [bytit[t] for t in A["resumen"][:12] if t in bytit]
    pares, rec = [], CAB
    for i in range(0, len(res), 2):
        par = res[i:i + 2]; n = max(c["frames"] for c in par)
        slots = [(980, 640)] if len(par) == 1 else [(560, 640), (1360, 640)]
        lado = []
        for c, (tx, ty) in zip(par, slots):
            cx, cy = c["pos"][0] + 320, c["pos"][1] + c["alto"] / 2; Z = 1.2
            lado.append({"archivo": c["archivo"], "frames": c["frames"], "zoom": Z, "pan": round(tx - ((cx - 960) * Z + 960), 1), "tilt": round(((cy - 540) * Z + 540) - ty, 1), "id": c["id"]})
        pares.append({"rec": rec, "frames": n, "tarjetas": lado}); rec += n + 12
    R = rec + 30
    # cara a cámara: tramos de agentes, en tiempo de salida, sin teclas y >= 3 s
    au = items[P]["audio"]
    def to_rec(t):
        f = round(t * 60)
        for s, e, r in au:
            if s <= f < e: return r + f - s
    teclas = [(t["rec_ini"], t["rec_fin"]) for t in tp[P]["tramos"]]
    cara = []
    for c in A.get("camara", []):
        recs = [to_rec(c["t_ini"] + k / 60) for k in range(0, int((c["t_fin"] - c["t_ini"]) * 60))]
        recs = sorted(r for r in recs if r is not None)
        runs, s0 = [], None
        for i, r in enumerate(recs):
            if s0 is None: s0 = r; prev = r; continue
            if r != prev + 1: runs.append((s0, prev + 1)); s0 = r
            prev = r
        if s0 is not None: runs.append((s0, prev + 1))
        for a, b in runs:
            if any(x < b and y > a for x, y in teclas): continue
            if b - a >= 180: cara.append({"rec_ini": a + 20, "rec_fin": b - 20, "nota": c.get("nota", "")[:60]})
    cara = []      # la webcam está recortada con croma sobre el IDE: en vez de ventana ampliada, zoom real 1.8x (items_timeline.py, origen "cara")
    est["partes"][P] = {"total_frames": T, "post": R + OUTRO, "resumen_frames": R, "pares": pares, "lista": f"{AN}/estructura/parte-{p}/lista.mov",
                        "resumen_cabecera": f"{AN}/estructura/parte-{p}/resumen-cabecera.mov", "cara": cara,
                        "cara_transform": {"crop": CAM, "zoom": ZC, "pan": round(TARGET[0] - ((CAM[0] + CAM[2] / 2 - 960) * ZC + 960), 1),
                                           "tilt": round(((CAM[1] + CAM[3] / 2 - 540) * ZC + 540) - TARGET[1], 1)}}
    print(p, "resumen", len(res), "tarjetas en", len(pares), "pares =", round(R / 60, 1), "s; cara", len(cara), "tramos", round(sum(c["rec_fin"] - c["rec_ini"] for c in cara) / 60, 1), "s")
json.dump(est, open(f"{BASE}/04-davinci/estructura.json", "w"), indent=1)
