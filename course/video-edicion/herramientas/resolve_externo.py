"""Construye y termina las líneas de tiempo "Parte N" desde fuera de Resolve (sin el límite de 60 s del MCP).
Uso: env de Resolve + python3 resolve_externo.py 1 2 3 4 5
Por parte: monta A1/V1/V2/V3/V4/V5 si falta (V2 = privacidad + parche de la caja de teclas vieja, con el zoom de V1;
V4 = visor de teclas nuevo SIN zoom; V5 = animaciones Fusion renderizadas, SIN zoom), aplica zoom (ZoomX/ZoomY/Pan/Tilt) a TODOS los clips de V1 y V2
(1.0/0/0 en los que no llevan zoom), CDL en V1, Voice Isolation 25 en A1, guarda y verifica leyendo de vuelta."""
import json, os, sys, time
import DaVinciResolveScript as dvr
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
ALL = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))
CDL = {"NodeIndex": "1", "Slope": "1.04 1.04 1.04", "Offset": "-0.01 -0.01 -0.01", "Power": "1.0 1.0 1.0", "Saturation": "1.08"}
resolve = dvr.scriptapp("Resolve"); pm = resolve.GetProjectManager(); project = pm.GetCurrentProject(); mp = project.GetMediaPool()
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
root = mp.GetRootFolder()
def _full(folder):
    for c in folder.GetClipList():
        if c.GetClipProperty("Video Codec") == "Animation" and c.GetClipProperty("Data Level") != "Full": c.SetClipProperty("Data Level", "Full")
    for sf in folder.GetSubFolderList(): _full(sf)
_full(root)
ov = {k: find(root, f"privacidad-{n}.mov") for k, n in [("as", "androidstudio"), ("vs", "vscode"), ("br", "navegador")]}
logo = find(root, "logo-capdesis.mov")
INTRO = 240; OUTRO = 240                      # 4 s de intro y 4 s de cierre (con cortinilla)
EST = json.load(open(f"{BASE}/04-davinci/estructura.json")); LISTA = EST["lista"]; PRE = EST["pre"]   # + 5 s de lista "En esta parte" (Fusion)
MUSICA = f"{BASE}/04-davinci/titulos/musica-fondo-90s.wav"
# versión de las capas regeneradas: Resolve sigue usando la versión vieja si se regenera un archivo con la MISMA ruta (E34)
CAPA_VER = EST.get("capa_ver", "r2")
LOGO_PLAN = json.load(open(f"{BASE}/04-davinci/logo-plan.json"))
ANIM = json.load(open(f"{BASE}/04-davinci/animaciones-plan.json")) if os.path.exists(f"{BASE}/04-davinci/animaciones-plan.json") else {}
LOGO_DEF = (1784, 8)                          # posición de logo-capdesis.mov; los demás lugares se logran con Pan/Tilt
def append_chunks(infos, n=1000):
    """AppendToTimeline en bloques: Resolve no se queda tanto tiempo en "no responde"."""
    out = []
    for i in range(0, len(infos), n):
        out += mp.AppendToTimeline(infos[i:i + n]) or []
    return out
_BYPATH = None
def ensure_import(path):
    """Busca el medio por RUTA completa (no por nombre: dos versiones con el mismo nombre en carpetas distintas
    hicieron que se usara la vieja, E26)."""
    global _BYPATH
    if _BYPATH is None:
        _BYPATH = {}
        def walk(fo):
            for c in fo.GetClipList(): _BYPATH[c.GetClipProperty("File Path")] = c
            for sf in fo.GetSubFolderList(): walk(sf)
        walk(root)
    c = _BYPATH.get(path)
    if not c:
        c = mp.ImportMedia([path])[0]; _BYPATH[path] = c
    assert c.GetClipProperty("File Path") == path, (path, c.GetClipProperty("File Path"))
    # capas RGB (qtrle/Animation): Resolve las toma como rango de video y las expande (x-16)*1.164 -> colores más oscuros
    # y más contraste (también el logo). Deben ser "Full".
    if c.GetClipProperty("Video Codec") == "Animation" and c.GetClipProperty("Data Level") != "Full": c.SetClipProperty("Data Level", "Full")
    return c
report = {}
for P in map(int, sys.argv[1:]):
    t_ini = time.time(); data = ALL[str(P)]; name = f"Parte {P}"
    # crudo con su título (01-crudo/.por-numero/nombres.json); se busca por ruta real
    _nm = json.load(open(f"{BASE}/01-crudo/.por-numero/nombres.json"))[str(P)]["ahora"]
    src = ensure_import(f"{BASE}/01-crudo/{_nm}")
    tl = get_tl(name)
    intro = ensure_import(f"{BASE}/04-davinci/titulos/intro-parte-{P}.mov"); cierre = ensure_import(f"{BASE}/04-davinci/titulos/cierre.mov")
    if not tl:
        tl = mp.CreateEmptyTimeline(name); project.SetCurrentTimeline(tl)
        for _ in range(6): tl.AddTrack("video")      # V1..V7
        tl.AddTrack("audio")                           # A2: música de lista y resumen
        t0 = tl.GetStartFrame(); E = EST["partes"][str(P)]; R = E["resumen_frames"]
        T = data["total_frames"]; O = t0 + PRE
        # resumen: cabecera Fusion (300 f) + la última imagen fija hasta R (ffmpeg tpad)
        rf = f"{BASE}/04-davinci/animaciones/estructura/parte-{P}/resumen-fondo-{R}.mov"
        if not os.path.exists(rf):
            import subprocess
            subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", E["resumen_cabecera"], "-vf", f"tpad=stop_mode=clone:stop={max(0, R - 300)}", "-frames:v", str(R),
                            "-c:v", "prores_ks", "-profile:v", "3", rf], check=True)
        # música cortada a medida con fundidos (la API no aplica fundidos de audio de forma fiable)
        ml = f"{BASE}/04-davinci/titulos/musica-lista.wav"; mr = f"{BASE}/04-davinci/titulos/musica-resumen-{R}.wav"
        for out_, a0, n_ in ((ml, 0, LISTA), (mr, 10, R)):
            if not os.path.exists(out_):
                import subprocess
                subprocess.run(["ffmpeg", "-v", "error", "-y", "-ss", str(a0), "-i", MUSICA, "-t", f"{n_ / 60:.4f}", "-af", f"afade=t=in:d=0.6,afade=t=out:st={n_ / 60 - 1.0:.3f}:d=1.0",
                                "-ar", "48000", "-c:a", "pcm_s24le", out_], check=True)
        lista = ensure_import(E["lista"]); resf = ensure_import(rf); musl = ensure_import(ml); musr = ensure_import(mr)
        mp.AppendToTimeline([{"mediaPoolItem": intro, "startFrame": 0, "endFrame": INTRO, "recordFrame": t0, "trackIndex": 1, "mediaType": m} for m in (1, 2)])
        mp.AppendToTimeline([{"mediaPoolItem": lista, "startFrame": 0, "endFrame": LISTA, "recordFrame": t0 + INTRO, "trackIndex": 1, "mediaType": 1}])
        mp.AppendToTimeline([{"mediaPoolItem": musl, "startFrame": 0, "endFrame": LISTA, "recordFrame": t0 + INTRO, "trackIndex": 2, "mediaType": 2}])
        mp.AppendToTimeline([{"mediaPoolItem": src, "startFrame": s, "endFrame": e, "recordFrame": O + r, "trackIndex": 1, "mediaType": 2} for s, e, r in data["audio"]])
        append_chunks([{"mediaPoolItem": src, "startFrame": s, "endFrame": e, "recordFrame": O + r, "trackIndex": 1, "mediaType": 1} for s, e, r, z, a in data["video"]])
        mp.AppendToTimeline([{"mediaPoolItem": resf, "startFrame": 0, "endFrame": R, "recordFrame": O + T, "trackIndex": 1, "mediaType": 1}])
        mp.AppendToTimeline([{"mediaPoolItem": musr, "startFrame": 0, "endFrame": R, "recordFrame": O + T, "trackIndex": 2, "mediaType": 2}])
        mp.AppendToTimeline([{"mediaPoolItem": cierre, "startFrame": 0, "endFrame": OUTRO, "recordFrame": O + T + R, "trackIndex": 1, "mediaType": m} for m in (1, 2)])
        v2med = ensure_import(f"{BASE}/04-davinci/overlays/v2-parte-{P}-{EST.get("capa_ver_parte", {}).get(str(P), CAPA_VER)}.mov")      # un solo archivo por parte, en tiempo de salida
        append_chunks([{"mediaPoolItem": v2med, "startFrame": r, "endFrame": r + (e - s), "recordFrame": O + r, "trackIndex": 2, "mediaType": 1} for s, e, r, z, a in data["video"]])
        mp.AppendToTimeline([{"mediaPoolItem": logo, "startFrame": g["rec_ini"], "endFrame": g["rec_fin"], "recordFrame": O + g["rec_ini"], "trackIndex": 3, "mediaType": 1}
                             for g in LOGO_PLAN[str(P)]["segmentos"]])
        tec = ensure_import(f"{BASE}/04-davinci/overlays/teclas-parte-{P}-{EST.get("capa_ver_parte", {}).get(str(P), CAPA_VER)}.mov")
        mp.AppendToTimeline([{"mediaPoolItem": tec, "startFrame": 0, "endFrame": T, "recordFrame": O, "trackIndex": 4, "mediaType": 1}])
        # tarjetas: V5/V6 sin solaparse en la misma pista (hasta 2 a la vez)
        fin_pista = {5: -1, 6: -1}
        for a in sorted(ANIM.get(str(P), []), key=lambda a: a["rec_ini"]):
            tr = 5 if fin_pista[5] <= a["rec_ini"] else 6
            if fin_pista[tr] > a["rec_ini"]: print("SOLAPE", a["id"]); continue
            fin_pista[tr] = a["rec_ini"] + a["frames"]
            mp.AppendToTimeline([{"mediaPoolItem": ensure_import(a["archivo"]), "startFrame": 0, "endFrame": a["frames"], "recordFrame": O + a["rec_ini"], "trackIndex": tr, "mediaType": 1}])
        # resumen: pares de tarjetas (V5 izquierda, V6 derecha)
        for par in E["pares"]:
            for k, c in enumerate(par["tarjetas"]):
                mp.AppendToTimeline([{"mediaPoolItem": ensure_import(c["archivo"]), "startFrame": 0, "endFrame": c["frames"], "recordFrame": O + T + par["rec"], "trackIndex": 5 + k, "mediaType": 1}])
        # cara a cámara ampliada (V7): mismos trozos del crudo que V1 en esos tramos
        for cr in E["cara"]:
            mp.AppendToTimeline([{"mediaPoolItem": src, "startFrame": s + max(0, cr["rec_ini"] - r), "endFrame": s + min(e - s, cr["rec_fin"] - r), "recordFrame": O + max(r, cr["rec_ini"]),
                                  "trackIndex": 7, "mediaType": 1} for s, e, r, z, a in data["video"] if r < cr["rec_fin"] and r + e - s > cr["rec_ini"]])
    project.SetCurrentTimeline(tl)
    v1all = tl.GetItemListInTrack("video", 1); v2 = tl.GetItemListInTrack("video", 2)
    v1 = v1all[2:-2]                                  # sin intro, lista, resumen ni cierre
    assert len(v1) == len(v2) == len(data["video"]), (P, len(v1), len(v2), len(data["video"]))
    t0 = tl.GetStartFrame() + PRE; fails = 0; E = EST["partes"][str(P)]
    # fundidos: intro sale, contenido entra, cierre entra
    v1all[0].SetFades({"FadeIn": 0, "FadeOut": 15}); v1[0].SetFades({"FadeIn": 15, "FadeOut": 0}); v1[-1].SetFades({"FadeIn": 0, "FadeOut": 12}); v1all[-1].SetFades({"FadeIn": 12, "FadeOut": 20})
    # lista y resumen: fundidos de imagen
    v1all[1].SetFades({"FadeIn": 12, "FadeOut": 12}); v1all[-2].SetFades({"FadeIn": 15, "FadeOut": 12})
    # tarjetas del resumen ampliadas y colocadas en su hueco (V5 izq., V6 der.)
    O_ = t0; T_ = data["total_frames"]
    for k_tr in (5, 6):
        for it in tl.GetItemListInTrack("video", k_tr) or []:
            st_ = it.GetStart() - O_
            for par in E["pares"]:
                if st_ == T_ + par["rec"] and k_tr - 5 < len(par["tarjetas"]):
                    c = par["tarjetas"][k_tr - 5]; it.SetProperty({"ZoomX": c["zoom"], "ZoomY": c["zoom"], "Pan": c["pan"], "Tilt": c["tilt"]})
    # cara ampliada (V7): recorte a la webcam + zoom limitado + fundidos
    ct = E["cara_transform"]; cx_, cy_, cw_, ch_ = ct["crop"]
    for it in tl.GetItemListInTrack("video", 7) or []:
        it.SetProperty({"CropLeft": float(cx_), "CropRight": float(1920 - cx_ - cw_), "CropTop": float(cy_), "CropBottom": float(1080 - cy_ - ch_),
                        "ZoomX": ct["zoom"], "ZoomY": ct["zoom"], "Pan": ct["pan"], "Tilt": ct["tilt"]})
    cara_items = tl.GetItemListInTrack("video", 7) or []
    for cr in E["cara"]:
        grp = [it for it in cara_items if t0 + cr["rec_ini"] <= it.GetStart() < t0 + cr["rec_fin"]]
        if grp: grp[0].SetFades({"FadeIn": 12, "FadeOut": 0}); grp[-1].SetFades({"FadeIn": 0, "FadeOut": 12})
    # logo: posición por tramo con Pan/Tilt (Tilt positivo = arriba) y fundido corto al cambiar de lugar
    lg = tl.GetItemListInTrack("video", 3); segs = LOGO_PLAN[str(P)]["segmentos"]
    assert len(lg) == len(segs), ("logo", len(lg), len(segs))
    for k, (it, g) in enumerate(zip(lg, segs)):
        dx, dy = g["pos"][0] - LOGO_DEF[0], g["pos"][1] - LOGO_DEF[1]
        it.SetProperty({"Pan": float(dx), "Tilt": float(-dy)})
        it.SetFades({"FadeIn": 15 if k == 0 else 20, "FadeOut": 20 if k < len(segs) - 1 else 12})
    for k, row in enumerate(data["video"]):
        z = row[3] or [1.0, 0.0, 0.0]
        props = {"ZoomX": z[0], "ZoomY": z[0], "Pan": z[1], "Tilt": z[2]}
        for it in (v1[k], v2[k]):
            if it.GetStart() != t0 + row[2] or not it.SetProperty(props): fails += 1
        if k % 500 == 0: print(P, k, len(v1), round(time.time() - t_ini), flush=True)
    cdl = sum(1 for it in v1 if it.SetCDL(CDL))
    tl.SetVoiceIsolationState(1, {"isEnabled": True, "amount": 25})
    # verificación por lectura de una muestra de 1 de cada 25 clips con zoom
    chk = bad = 0
    for k, row in enumerate(data["video"]):
        if row[3] and k % 25 == 0:
            chk += 1
            for it in (v1[k], v2[k]):
                if abs(it.GetProperty("ZoomX") - row[3][0]) > 1e-3 or abs(it.GetProperty("Pan") - row[3][1]) > 0.05: bad += 1
    report[name] = {"clips_v1": len(v1), "fallos_set": fails, "cdl": [cdl, len(v1)], "voice_isolation": tl.GetVoiceIsolationState(1),
                    "frames": tl.GetEndFrame() - tl.GetStartFrame(), "frames_esperados": data["total_frames"] + PRE + E["post"],
                    "muestra_verificada": chk, "muestra_mal": bad, "v3_logo": [len(lg), [(round(x.GetProperty("Pan")), round(x.GetProperty("Tilt"))) for x in lg]], "fundidos_intro_cierre": [v1all[0].GetFades(), v1all[-1].GetFades()],
                    "v4_teclas": [(x.GetStart() - t0, x.GetDuration()) for x in tl.GetItemListInTrack("video", 4)],
                    "v5_animaciones": len(tl.GetItemListInTrack("video", 5) or []) + len(tl.GetItemListInTrack("video", 6) or []),
                    "v5_esperadas": len(ANIM.get(str(P), [])) + sum(len(x["tarjetas"]) for x in E["pares"]),
                    "cara_items": len(tl.GetItemListInTrack("video", 7) or []), "cara_tramos": len(E["cara"]),
                    "cara_lectura": (lambda L: L and {k: L[0].GetProperty(k) for k in ("CropLeft", "CropTop", "ZoomX", "Pan", "Tilt")})(tl.GetItemListInTrack("video", 7) or []), "segundos": round(time.time() - t_ini)}
    pm.SaveProject()
    print(json.dumps({name: report[name]}), flush=True)
# se combina con lo que ya había: montar una sola parte no debe borrar el informe de las demás
_CT = f"{BASE}/04-davinci/construccion-timelines.json"
_prev = json.load(open(_CT)) if os.path.exists(_CT) else {}
_prev.update(report)
json.dump(_prev, open(_CT, "w"), indent=1)
print("LISTO")
