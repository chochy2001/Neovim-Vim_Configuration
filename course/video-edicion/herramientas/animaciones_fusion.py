"""Construye cada tarjeta animada como composición de FUSION dentro de Resolve y las renderiza desde Deliver (ProRes 4444 con alfa). NO usar comp.Render(): deja un diálogo modal
"Render completed!" que bloquea la API de Resolve hasta que alguien pulsa OK.
Nodos: Loader (capas de tarjeta_capas.swift) -> Merge/Transform con fotogramas clave (BezierSpline / XYPath):
entrada deslizando + fundido, pulsación de teclas, resaltado de lo que se borra, cambio de texto, cursor que se mueve
(bloque en modo normal, barra en modo insertar) y salida. Línea de tiempo aparte: "Animaciones Fusion".
Uso (env de Resolve, SIN -I): python3 animaciones_fusion.py [ids...]
-> 04-davinci/animaciones/render/fusion-todas.mov + indice-render.json (inicio de cada tarjeta) ; luego cortar_animaciones.py"""
import json, os, sys, time, shutil
import DaVinciResolveScript as dvr
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); AN = f"{BASE}/04-davinci/animaciones"
V2 = "--v2" in sys.argv; ARGS = [a for a in sys.argv[1:] if not a.startswith("--")]
plan = [c for v in json.load(open(f"{AN}/plan-v2.json" if V2 else f"{AN}/plan-base.json")).values() for c in v]
CAPAS = f"{AN}/" + json.load(open(f"{BASE}/04-davinci/estructura.json")).get("capas_tarjetas", "capas-v2") if V2 else f"{AN}/capas"   # carpeta versionada (E34)
if ARGS: plan = [c for c in plan if c["id"] in ARGS]
r = dvr.scriptapp("Resolve"); pm = r.GetProjectManager(); p = pm.GetCurrentProject(); mp = p.GetMediaPool()
r.OpenPage("edit")
tl = mp.CreateEmptyTimeline("Animaciones Fusion " + time.strftime("%m%d-%H%M%S")); p.SetCurrentTimeline(tl)
FPS = 60; D = 300
def tc(f):
    f += 216000; return "%02d:%02d:%02d:%02d" % (f // (3600 * FPS), f // (60 * FPS) % 60, f // FPS % 60, f % FPS)
def spline(tool, inp, keys):
    tool.AddModifier(inp, "BezierSpline")
    for t, v in keys: tool.SetInput(inp, v, t)
def path(tool, inp, keys):
    """keys: [(t, x, y)] en coordenadas normalizadas de Fusion (origen abajo-izquierda)."""
    tool.AddModifier(inp, "XYPath")
    pt = tool[inp].GetConnectedOutput().GetTool()
    pt.AddModifier("X", "BezierSpline"); pt.AddModifier("Y", "BezierSpline")
    for t, x, y in keys: pt.SetInput("X", x, t); pt.SetInput("Y", y, t)
rep = {}
for n, c in enumerate(plan):
    cid = c["id"]; L = f"{CAPAS}/{cid}"; met = json.load(open(f"{L}/metricas.json")); W, H = met["W"], met["H"]
    DC = c.get("frames", D)             # duración visible de esta tarjeta (la composición dura 300)
    marca = c.get("tipo") == "marca"
    tl.SetCurrentTimecode(tc(n * (D + 60)))
    it = tl.InsertFusionCompositionIntoTimeline(); comp = it.GetFusionCompByIndex(1)
    comp.Lock()
    mo = [t for t in comp.GetToolList(False).values() if t.GetAttrs()["TOOLS_RegID"] == "MediaOut"][0]
    def loader(name, y):
        t = comp.AddTool("Loader", -6, y); t.SetInput("Clip", f"{L}/{name}.png"); t.SetAttrs({"TOOLS_Name": name}); return t
    def merge(bg, fg, y, name):
        m = comp.AddTool("Merge", -2, y); m.ConnectInput("Background", bg); m.ConnectInput("Foreground", fg); m.SetAttrs({"TOOLS_Name": name}); return m
    def cx(px): return px / W
    def cy(py): return 1 - py / H
    card = loader("card", 0)
    if marca: cur = card; d = None
    else:
        keys = loader("keys", 1); tk = comp.AddTool("Transform", -4, 1); tk.ConnectInput("Input", keys)
        tk.SetInput("Pivot", [cx(met["keys_cx"]), cy(met["keys_cy"])])
        spline(tk, "Size", [(0, 1.0), (36, 1.0), (42, 0.9), (52, 1.04), (60, 1.0)])           # pulsación de las teclas
        cur = merge(card, tk, 1, "teclas")
        d = c["demo"]
    if d:
        cw, x0, ly = met["char_w"], met["text_x"], met["line_cy"]
        def ccx(i, bar=False): return cx(x0 + i * cw + (0 if bar else cw / 2))
        change = d["antes"] != d["despues"]
        t_mv0, t_mv1 = (100, 112) if change else (70, 100)
        hl = loader("hl", 2); mhl = merge(cur, hl, 2, "resaltado")
        spline(mhl, "Blend", [(0, 0.0), (56, 0.0), (66, 1.0), (100, 1.0), (112, 0.0)] if change else [(0, 0.0)])
        a = loader("antes", 3); ma = merge(mhl, a, 3, "texto_antes")
        spline(ma, "Blend", [(0, 1.0), (100, 1.0), (104, 0.0)] if change else [(0, 1.0)])
        b = loader("despues", 4); mb = merge(ma, b, 4, "texto_despues")
        spline(mb, "Blend", [(0, 0.0), (102, 0.0), (106, 1.0)] if change else [(0, 0.0)])
        blk = loader("cur_block", 5); mblk = merge(mb, blk, 5, "cursor_bloque")
        fin_bar = d["insertar"]
        path(mblk, "Center", [(0, ccx(d["cur_ini"]), cy(ly)), (t_mv0, ccx(d["cur_ini"]), cy(ly)), (t_mv1, ccx(d["cur_fin"]), cy(ly))])
        spline(mblk, "Blend", [(0, 1.0), (t_mv1, 1.0), (t_mv1 + 8, 0.0)] if fin_bar else [(0, 1.0)])
        bar = loader("cur_bar", 6); mbar = merge(mblk, bar, 6, "cursor_barra")
        mbar.SetInput("Center", [ccx(d["cur_fin"], True), cy(ly)])
        spline(mbar, "Blend", [(0, 0.0), (t_mv1, 0.0), (t_mv1 + 8, 1.0)] if fin_bar else [(0, 0.0)])
        cur = mbar
    # entrada/salida de la tarjeta completa sobre el cuadro 1920x1080
    ta = comp.AddTool("Transform", 0, 3); ta.ConnectInput("Input", cur)
    spline(ta, "Size", [(0, 0.96), (18, 1.0), (DC - 20, 1.0), (DC - 1, 0.98)])
    bgf = comp.AddTool("Background", 0, 5); bgf.SetInput("Width", 1920); bgf.SetInput("Height", 1080); bgf.SetInput("TopLeftAlpha", 0.0)
    bgf.SetInput("TopLeftRed", 0.0); bgf.SetInput("TopLeftGreen", 0.0); bgf.SetInput("TopLeftBlue", 0.0)
    fin = comp.AddTool("Merge", 2, 4); fin.ConnectInput("Background", bgf); fin.ConnectInput("Foreground", ta)
    px, py = c["pos"]; ccx0, ccy0 = (px + W / 2) / 1920, 1 - (py + H / 2) / 1080
    dx0 = (0 if marca else 24 / 1920); dy0 = (18 / 1080 if marca else 0)          # marca: baja desde arriba; tarjeta: entra desde la derecha
    path(fin, "Center", [(0, ccx0 + dx0, ccy0 + dy0), (18, ccx0, ccy0), (DC - 1, ccx0, ccy0)])
    spline(fin, "Blend", [(0, 0.0), (18, 1.0), (DC - 20, 1.0), (DC - 1, 0.0), (D - 1, 0.0)])
    mo.ConnectInput("Input", fin)
    comp.Unlock()
    rep[cid] = {"inicio": it.GetStart() - tl.GetStartFrame(), "dur": it.GetDuration(), "visible": DC, "herramientas": len(comp.GetToolList(False))}
    print(cid, rep[cid], flush=True)
pm.SaveProject()
# render desde Deliver: trabajo de relleno primero (el primer trabajo de cada tanda sale sin video en 21.1)
RD = f"{AN}/render"; os.makedirs(RD, exist_ok=True)
for f in os.listdir(RD):
    if f.startswith("fusion-todas" + ("-v2" if V2 else "")): os.rename(f"{RD}/{f}", f"{RD}/previo-{int(time.time())}-{f}")
r.OpenPage("deliver"); p.DeleteAllRenderJobs(); p.SetCurrentRenderFormatAndCodec("mov", "ProRes4444")
base = {"ExportVideo": True, "ExportAudio": False, "FormatWidth": 1920, "FormatHeight": 1080, "FrameRate": 60.0, "ExportAlpha": True}
st = tl.GetStartFrame()
p.SetRenderSettings({**base, "SelectAllFrames": False, "MarkIn": st, "MarkOut": st + 4, "TargetDir": f"{BASE}/04-davinci/render-relleno", "CustomName": "relleno-fusion"}); j0 = p.AddRenderJob()
p.SetRenderSettings({**base, "SelectAllFrames": False, "MarkIn": st, "MarkOut": st + (len(plan) - 1) * (D + 60) + D - 1, "TargetDir": RD, "CustomName": "fusion-todas" + ("-v2" if V2 else "")}); j1 = p.AddRenderJob()
p.StartRendering([j0, j1], False)
while p.IsRenderingInProgress(): time.sleep(5)
print({j["OutputFilename"]: p.GetRenderJobStatus(j["JobId"]) for j in p.GetRenderJobList()})
json.dump({"stride": D + 60, "dur": D, "tarjetas": rep, "linea": tl.GetName()}, open(f"{AN}/indice-render{'-v2' if V2 else ''}.json", "w"), indent=1)
r.OpenPage("edit")
print("LISTO", len(rep))
