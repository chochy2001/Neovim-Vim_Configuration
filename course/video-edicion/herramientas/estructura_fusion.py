"""Pantallas completas en FUSION por parte: "lista" (En esta parte vas a aprender: título + comandos escalonados, 5 s)
y "resumen" (cabecera del resumen final). Render desde Deliver (ProRes 4444) y corte por parte.
Uso (env de Resolve, SIN -I): python3 estructura_fusion.py -> 04-davinci/animaciones/estructura/parte-N/{lista,resumen-cabecera}.mov"""
import json, os, time, subprocess
import DaVinciResolveScript as dvr
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); AN = f"{BASE}/04-davinci/animaciones"; FONDO = f"{BASE}/04-davinci/titulos/generadas/fondo-tarjeta.png"
jobs = json.load(open(f"{AN}/estructura-trabajos.json"))
r = dvr.scriptapp("Resolve"); pm = r.GetProjectManager(); p = pm.GetCurrentProject(); mp = p.GetMediaPool(); r.OpenPage("edit")
tl = mp.CreateEmptyTimeline("Estructura Fusion " + time.strftime("%m%d-%H%M%S")); p.SetCurrentTimeline(tl)
FPS, D = 60, 300
def tc(f):
    f += 216000; return "%02d:%02d:%02d:%02d" % (f // (3600 * FPS), f // (60 * FPS) % 60, f // FPS % 60, f % FPS)
def spline(tool, inp, keys):
    tool.AddModifier(inp, "BezierSpline")
    for t, v in keys: tool.SetInput(inp, v, t)
def path(tool, inp, keys):
    tool.AddModifier(inp, "XYPath"); pt = tool[inp].GetConnectedOutput().GetTool()
    pt.AddModifier("X", "BezierSpline"); pt.AddModifier("Y", "BezierSpline")
    for t, x, y in keys: pt.SetInput("X", x, t); pt.SetInput("Y", y, t)
idx = {}; n = 0
for j in jobs:
    d = j["dir"]
    for kind in ("lista", "resumen"):
        tl.SetCurrentTimecode(tc(n * (D + 60))); it = tl.InsertFusionCompositionIntoTimeline(); comp = it.GetFusionCompByIndex(1); comp.Lock()
        mo = [t for t in comp.GetToolList(False).values() if t.GetAttrs()["TOOLS_RegID"] == "MediaOut"][0]
        bg = comp.AddTool("Loader", -6, 0); bg.SetInput("Clip", FONDO)
        def layer(png, y, t0, dy=16):
            global cur
            L = comp.AddTool("Loader", -6, y); L.SetInput("Clip", png)
            m = comp.AddTool("Merge", -2, y); m.ConnectInput("Background", cur); m.ConnectInput("Foreground", L)
            spline(m, "Blend", [(0, 0.0), (t0, 0.0), (t0 + 12, 1.0)])
            path(m, "Center", [(0, 0.5, 0.5), (t0, 0.5, 0.5 - dy / 1080), (t0 + 14, 0.5, 0.5)])
            cur = m
        cur = bg
        if kind == "lista":
            layer(f"{d}/titulo.png", 1, 4, 20)
            for i in range(len(j["items"])): layer(f"{d}/item-{i:02d}-capa.png", 2 + i, 22 + i * 7)   # sin número al final: el Loader lo tomaría como secuencia (E27)
        else:
            layer(f"{d}/resumen-titulo.png", 1, 4, 20)
        mo.ConnectInput("Input", cur); comp.Unlock()
        idx[f"{j['parte']}-{kind}"] = n * (D + 60); n += 1
pm.SaveProject()
RD = f"{AN}/render"; os.makedirs(RD, exist_ok=True)
r.OpenPage("deliver"); p.DeleteAllRenderJobs(); p.SetCurrentRenderFormatAndCodec("mov", "ProRes422HQ")
base = {"ExportVideo": True, "ExportAudio": False, "FormatWidth": 1920, "FormatHeight": 1080, "FrameRate": 60.0}; st = tl.GetStartFrame()
p.SetRenderSettings({**base, "SelectAllFrames": False, "MarkIn": st, "MarkOut": st + 4, "TargetDir": f"{BASE}/04-davinci/render-relleno", "CustomName": "relleno-estructura"}); j0 = p.AddRenderJob()
p.SetRenderSettings({**base, "SelectAllFrames": False, "MarkIn": st, "MarkOut": st + (n - 1) * (D + 60) + D - 1, "TargetDir": RD, "CustomName": "estructura-todas"}); j1 = p.AddRenderJob()
p.StartRendering([j0, j1], False)
while p.IsRenderingInProgress(): time.sleep(5)
print({k["OutputFilename"]: p.GetRenderJobStatus(k["JobId"])["JobStatus"] for k in p.GetRenderJobList()})
r.OpenPage("edit")
for k, a in idx.items():
    pa, kind = k.split("-"); out = f"{AN}/estructura/parte-{pa}/{'lista' if kind == 'lista' else 'resumen-cabecera'}.mov"
    subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", f"{RD}/estructura-todas.mov", "-vf", f"trim=start_frame={a}:end_frame={a + D},setpts=PTS-STARTPTS",
                    "-map", "0:v:0", "-c:v", "prores_ks", "-profile:v", "3", "-pix_fmt", "yuv422p10le", out], check=True)
    print(k, out)
json.dump(idx, open(f"{AN}/estructura/indice.json", "w"))
print("LISTO")
