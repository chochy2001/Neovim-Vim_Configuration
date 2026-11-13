# Se ejecuta dentro de Resolve (run_script_unsafe del MCP "DaVinci Resolve"). Definir antes: PARTE (int), FASE y, para "zoom", DESDE/HASTA.
# FASE: "crudo"   -> línea "Parte N (crudo)" con el clip completo
#       "base"    -> línea "Parte N": A1 (audio), V1 (video partido en cortes/zooms), V2 (capa de privacidad), V3 (logo)
#       "zoom"    -> ZoomX/ZoomY/Pan/Tilt en V1 y V2 para las filas [DESDE, HASTA) de items-timeline.json
#       "acabado" -> corrección de color (CDL) en V1 + Voice Isolation 25 en A1, y guarda el proyecto
import json, os
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
data = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))[str(PARTE)]
CDL = {"NodeIndex": "1", "Slope": "1.04 1.04 1.04", "Offset": "-0.01 -0.01 -0.01", "Power": "1.0 1.0 1.0", "Saturation": "1.08"}
mp = project.GetMediaPool(); root = mp.GetRootFolder()
def find(folder, name):
    for c in folder.GetClipList():
        if c.GetName() == name: return c
    for f in folder.GetSubFolderList():
        r = find(f, name)
        if r: return r
def get_tl(name):
    for i in range(1, project.GetTimelineCount() + 1):
        t = project.GetTimelineByIndex(i)
        if t.GetName() == name: return t
src = find(root, f"parte {PARTE}.mp4")
name = f"Parte {PARTE}"
res = {}
if FASE == "crudo":
    cname = f"Parte {PARTE} (crudo)"
    if not get_tl(cname):
        tl = mp.CreateEmptyTimeline(cname); project.SetCurrentTimeline(tl); mp.AppendToTimeline([src])
    tl = get_tl(cname); res = {"timeline": cname, "frames": tl.GetEndFrame() - tl.GetStartFrame()}
elif FASE == "base":
    assert not get_tl(name), "ya existe " + name
    ov = {k: find(root, f"privacidad-{n}.mov") for k, n in [("as", "androidstudio"), ("vs", "vscode"), ("br", "navegador")]}
    logo = find(root, "logo-capdesis.mov")
    tl = mp.CreateEmptyTimeline(name); project.SetCurrentTimeline(tl)
    tl.AddTrack("video"); tl.AddTrack("video")
    t0 = tl.GetStartFrame()
    a = mp.AppendToTimeline([{"mediaPoolItem": src, "startFrame": s, "endFrame": e, "recordFrame": t0 + r, "trackIndex": 1, "mediaType": 2} for s, e, r in data["audio"]])
    v = mp.AppendToTimeline([{"mediaPoolItem": src, "startFrame": s, "endFrame": e, "recordFrame": t0 + r, "trackIndex": 1, "mediaType": 1} for s, e, r, z, app in data["video"]])
    o = mp.AppendToTimeline([{"mediaPoolItem": ov[app], "startFrame": r, "endFrame": r + (e - s), "recordFrame": t0 + r, "trackIndex": 2, "mediaType": 1} for s, e, r, z, app in data["video"]])
    l = mp.AppendToTimeline([{"mediaPoolItem": logo, "startFrame": 0, "endFrame": data["total_frames"], "recordFrame": t0, "trackIndex": 3, "mediaType": 1}])
    res = {"timeline": name, "audio": len(a or []), "v1": len(v or []), "v2": len(o or []), "v3": len(l or []),
           "esperado": [len(data["audio"]), len(data["video"])], "frames": tl.GetEndFrame() - tl.GetStartFrame(), "frames_esperados": data["total_frames"]}
elif FASE == "zoom":
    tl = get_tl(name); project.SetCurrentTimeline(tl)
    v1 = tl.GetItemListInTrack("video", 1); v2 = tl.GetItemListInTrack("video", 2)
    assert len(v1) == len(data["video"]) == len(v2), (len(v1), len(v2), len(data["video"]))
    bad = setn = 0
    for k in range(DESDE, min(HASTA, len(v1))):
        z = data["video"][k][3]
        if z and z[0] != 1.0:
            for it in (v1[k], v2[k]):
                ok = it.SetProperty("ZoomX", z[0]) and it.SetProperty("ZoomY", z[0]) and it.SetProperty("Pan", z[1]) and it.SetProperty("Tilt", z[2])
                bad += 0 if ok else 1; setn += 1
    res = {"timeline": name, "rango": [DESDE, HASTA], "ajustados": setn, "fallos": bad, "total_filas": len(v1)}
elif FASE == "acabado":
    tl = get_tl(name); project.SetCurrentTimeline(tl)
    v1 = tl.GetItemListInTrack("video", 1)
    cdl_ok = sum(1 for it in v1 if it.SetCDL(CDL))
    vi = tl.SetVoiceIsolationState(1, {"isEnabled": True, "amount": 25})
    res = {"timeline": name, "cdl": [cdl_ok, len(v1)], "voice_isolation": tl.GetVoiceIsolationState(1), "guardado": resolve.GetProjectManager().SaveProject()}
result = res
