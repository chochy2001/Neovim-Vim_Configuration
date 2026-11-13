"""Renderiza las 5 partes desde Resolve (script externo) y espera a que terminen.
Pone primero un trabajo de relleno de 5 fotogramas: en Resolve 21.1.0.17 el primer trabajo de cada tanda sale sin video."""
import json, os, sys, time
import DaVinciResolveScript as dvr
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
OUT = f"{BASE}/04-davinci/render-resolve"
TMP = f"{BASE}/04-davinci/render-relleno"
os.makedirs(OUT, exist_ok=True); os.makedirs(TMP, exist_ok=True)
NAMES = {1: "01-modos-y-movimientos", 2: "02-insertar-pegar-y-buscar", 3: "03-buscar-caracteres-y-borrar", 4: "04-objetos-de-texto", 5: "05-ventanas-y-lineas"}
_P = [int(x) for x in sys.argv[1:]]   # uso: python3 render_final.py [partes...]  (sin partes: las 5)
if _P: NAMES = {k: v for k, v in NAMES.items() if k in _P}
for n in NAMES.values():  # no sobrescribir: si ya existe un render previo se aparta con sufijo
    f = f"{OUT}/{n}.mp4"
    if os.path.exists(f): os.rename(f, f"{OUT}/{n}.previo-{int(time.time())}.mp4")
r = dvr.scriptapp("Resolve"); p = r.GetProjectManager().GetCurrentProject()
def settl(name):
    for i in range(1, p.GetTimelineCount() + 1):
        t = p.GetTimelineByIndex(i)
        if t.GetName() == name: p.SetCurrentTimeline(t); return t
r.OpenPage("deliver"); p.DeleteAllRenderJobs()
base = {"ExportVideo": True, "ExportAudio": True, "FormatWidth": 1920, "FormatHeight": 1080, "FrameRate": 60.0, "VideoQuality": 16000,
        "AudioCodec": "aac", "AudioSampleRate": 48000}
jobs = []
settl("Parte 1"); p.SetCurrentRenderFormatAndCodec("mp4", "H264")
p.SetRenderSettings({**base, "SelectAllFrames": False, "MarkIn": 216000, "MarkOut": 216005, "TargetDir": TMP, "CustomName": "relleno"}); jobs.append(p.AddRenderJob())
for k, n in NAMES.items():
    settl(f"Parte {k}"); p.SetCurrentRenderFormatAndCodec("mp4", "H264")
    p.SetRenderSettings({**base, "SelectAllFrames": True, "TargetDir": OUT, "CustomName": n}); jobs.append(p.AddRenderJob())
ok = p.StartRendering(jobs, False)
if not ok:
    time.sleep(2); ok = p.StartRendering(jobs, False)
print("start", ok, flush=True)
while p.IsRenderingInProgress():
    time.sleep(10)
st = {j["OutputFilename"]: p.GetRenderJobStatus(j["JobId"]) for j in p.GetRenderJobList()}
print(json.dumps(st), flush=True)
bad = {k: v["JobStatus"] for k, v in st.items() if v.get("JobStatus") != "Complete"}
if bad: raise SystemExit(f"RENDER INCOMPLETO: {bad}")
print("LISTO")
