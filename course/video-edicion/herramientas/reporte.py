"""Genera editado/REPORTE-EDICION.md solo con datos medidos (paso 9). Uso: python3 -I reporte.py"""
import json, os, subprocess
_EST = json.load(open(os.path.expanduser("~/Movies/Capdesis-Curso-Vim/04-davinci/estructura.json"))); PRE_S = _EST['pre'] / 60   # intro 4 s + lista 5 s (plan_estructura.py)
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
NAMES = {1: "01-modos-y-movimientos", 2: "02-insertar-pegar-y-buscar", 3: "03-buscar-caracteres-y-borrar", 4: "04-objetos-de-texto", 5: "05-ventanas-y-lineas"}
items = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))
loud = json.load(open(f"{BASE}/03-analisis/audio/loudness/finales.json"))
unions = json.load(open(f"{BASE}/03-analisis/verificacion/uniones.json"))
logo = json.load(open(f"{BASE}/04-davinci/logo-plan.json"))
cand = json.load(open(f"{BASE}/03-analisis/verificacion/candidatos.json"))
tlap = json.load(open(f"{BASE}/04-davinci/timelapse-plan.json"))
build = json.load(open(f"{BASE}/04-davinci/construccion-timelines.json"))
def probe(f):
    o = subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration,bit_rate:stream=codec_type,codec_name,width,height,r_frame_rate,sample_rate",
                        "-of", "json", f], capture_output=True, text=True).stdout
    return json.loads(o)
def mmss(s): return f"{int(s // 60)}:{s % 60:04.1f}"
L = ["# Reporte de edición: curso de Vim", "", "Generado por `03-analisis/herramientas/reporte.py` a partir de mediciones. Nada se escribió a mano.", ""]
# originales intactos
base = {os.path.join(BASE, l.split("|")[0]): l.strip().split("|") for l in open(f"{BASE}/editado/.baseline-originales.txt")}
L += ["## Originales", "", "| Archivo | Tamaño y fecha |", "|---|---|"]
ok_all = True
for k, v in base.items():
    st = os.stat(k); same = str(st.st_size) == v[1] and str(int(st.st_mtime)) == v[2]; ok_all &= same
    L.append(f"| {os.path.basename(k)} | {'iguales' if same else 'CAMBIARON'} |")
L += ["", f"Resultado: **{'intactos' if ok_all else 'NO intactos'}**.", ""]
tecl = json.load(open(f"{BASE}/04-davinci/teclas-plan.json")); capas = json.load(open(f"{BASE}/03-analisis/verificacion/capas/capas.json"))
anb = json.load(open(f"{BASE}/04-davinci/animaciones/plan-base.json"))
txtt = json.load(open(f"{BASE}/03-analisis/verificacion/capas/textos-tarjetas.json"))
zc = json.load(open(f"{BASE}/03-analisis/verificacion/capas/zoom-comandos.json"))   # obligatorio: si falta, el reporte falla (antes {} = OK)
L += ["## Resumen", "", "| Parte | Original | Final | Veredicto |", "|---|---|---|---|"]
detail = []
for p, n in NAMES.items():
    f = f"{BASE}/editado/{n}.mp4"; pr = probe(f)
    v = next(s for s in pr["streams"] if s["codec_type"] == "video"); a = next(s for s in pr["streams"] if s["codec_type"] == "audio")
    dur = float(pr["format"]["duration"]); br = int(pr["format"]["bit_rate"]) / 1e6
    ap = json.load(open(f"{BASE}/03-analisis/edicion/aplicados-parte-{p}.json"))
    comp = json.load(open(f"{BASE}/03-analisis/verificacion/export-parte-{p}-comparacion.json"))
    raw = float(probe(f"{BASE}/01-crudo/.por-numero/parte {p}.mp4")["format"]["duration"])
    lo = loud[n]["despues"]
    checks = {
        "1920x1080 60 fps H.264": v["codec_name"] == "h264" and v["width"] == 1920 and v["height"] == 1080 and v["r_frame_rate"] == "60/1",
        "AAC 48 kHz": a["codec_name"] == "aac" and a["sample_rate"] == "48000",
        "Duración = plan": abs(dur - (items[str(p)]["total_frames"] + _EST["pre"] + _EST["partes"][str(p)]["post"]) / 60) < 0.15,
        "-16 LUFS ±0.5": abs(lo["I"] + 16) <= 0.5,
        "Pico real ≤ -1.5 dBTP": lo["TP"] <= -1.5,
        "Sin tomas erróneas": not any(comp["toma_erronea_presente"].values()),
        "Uniones en silencio": not unions[str(p)]["revisar"],
        "Sin contenido perdido (ventanas)": all(c["estado"] == "PRESENTE" for c in cand[str(p)]),
        "Montaje leído de vuelta sin fallos": build[f"Parte {p}"]["fallos_set"] == 0 and build[f"Parte {p}"]["muestra_mal"] == 0,
        "Visor de teclas y animaciones montados": len(build[f"Parte {p}"].get("v4_teclas", [])) == 1 and build[f"Parte {p}"]["v5_animaciones"] == build[f"Parte {p}"]["v5_esperadas"],
        "Caja de teclas vieja tapada (render)": capas[str(p)]["max_negro_caja_vieja"] < 0.25,
        "Teclas nuevas visibles en su momento (render)": capas[str(p)].get("teclas_no_visibles", 99) == 0,
        "Ninguna caja de teclas en todo el final (2 fps)": len(json.load(open(f"{BASE}/03-analisis/verificacion/capas/cajas-final-parte-{p}.json"))) == 0,
        "Textos de tarjetas = plan, con tildes (OCR del final)": all(v["estado"] == "OK" for k, v in txtt.items() if k.startswith(f"p{p}-")),
        "Comandos escritos legibles con zoom (OCR del final)": all(v["estado"] == "OK" for k, v in zc.items() if k.startswith(f"{p}-"))
            and len([k for k in zc if k.startswith(f"{p}-")]) == len(json.load(open(f"{BASE}/03-analisis/edicion/analisis-v2-parte-{p}.json"))["linea_comandos_visual"]),
        "Colores de logo y parche = PNG (render)": capas[str(p)]["error_color_logo_medio"] <= 6 and capas[str(p)]["error_color_parche_max"] is not None and capas[str(p)]["error_color_parche_max"] <= 6,   # None = sin medir = falla
    }
    ok = all(checks.values()); TODAS_OK = globals().get("TODAS_OK", True) and ok
    n_lc = len(json.load(open(f"{BASE}/03-analisis/edicion/analisis-v2-parte-{p}.json"))["linea_comandos_visual"])
    L.append(f"| {p} | {mmss(raw)} | {mmss(dur)} | {'APROBADO' if ok else 'NO APROBADO'} |")
    by = {}
    for it in ap["items"]:
        if it.get("aplicado"): by.setdefault(it["type"], [0, 0.0]); by[it["type"]][0] += 1; by[it["type"]][1] += it.get("dur_cortada", 0)
    zs = items[str(p)]["zooms"]
    D = [f"## Parte {p}: {n}", "", f"- Original: {mmss(raw)}. Final: {mmss(dur)} (incluye intro 4 s, lista de comandos 5 s, resumen final y cierre 4 s).",
         f"- Video: {v['codec_name']} {v['width']}x{v['height']} {v['r_frame_rate']}, {br:.1f} Mb/s de media (VBR de Resolve).",
         f"- Audio: {lo['I']} LUFS, pico real {lo['TP']} dBTP (antes: {loud[n]['antes']['I']} LUFS, {loud[n]['antes']['TP']} dBTP).", "",
         "| Cortes aplicados | Cantidad | Segundos |", "|---|---|---|"]
    for k, (c, s) in sorted(by.items()): D.append(f"| {k} | {c} | {s:.1f} |")
    D += ["", f"- Zooms del plan: {sum(1 for z in zs if z['origen'] == 'plan')}. Zooms suaves de clic/menú: {sum(1 for z in zs if z['origen'] == 'clic')} (descartados por solape o corte: {len(items[str(p)]['zooms_descartados'])}).",
          f"- Tramos acelerados (silencio largo con acción): {len(tlap[str(p)])} ({sum(1 for t in tlap[str(p)] if t['factor'] >= 6)} a 6x).",
          f"- Visor de teclas nuevo: {len(tecl[str(p)]['tramos'])} tramos con teclas; caja vieja tapada en {tecl[str(p)].get('con_parche', 0)} fotogramas; negro puro máximo en la zona vieja (render): {capas[str(p)]['max_negro_caja_vieja']*100:.1f} %.",
          f"- Animaciones Fusion: {capas[str(p)]['animaciones']} tarjetas ({', '.join(a['titulo'] for a in anb[str(p)])}).",
          f"- Logo: {len(logo[str(p)]['segmentos'])} posiciones; tinta tapada media {logo[str(p)]['tinta_media']*100:.2f} % (fijo arriba a la derecha habría sido {logo[str(p)]['tinta_si_fijo_arriba_derecha_media']*100:.1f} %).",
          f"- Transcripción del export vs original: similitud {comp['ratio_similitud']}, {len(comp['diferencias_en_contenido_conservado'])} diferencias, {len(cand[str(p)])} de 3+ palabras re-transcritas en ventana: {sum(1 for c in cand[str(p)] if c['estado'] == 'PRESENTE')} presentes, {sum(1 for c in cand[str(p)] if c['estado'] != 'PRESENTE')} por revisar.",
          f"- Uniones de corte medidas: {unions[str(p)]['uniones']}, todas en silencio." if not unions[str(p)]["revisar"] else f"- Uniones a revisar: {unions[str(p)]['revisar']}", "",
          "| Comprobación | Resultado |", "|---|---|"] + [f"| {k} | {('no aplica (0 comandos de línea en esta parte)' if k.startswith('Comandos escritos') and n_lc == 0 else 'OK') if v_ else 'FALLA'} |" for k, v_ in checks.items()]
    dud = [it for it in ap["items"] if it["type"] == "repeticion" and not it.get("aplicado")]
    if dud:
        D += ["", "Repeticiones NO cortadas (para el operador):", ""]
        for it in dud: D.append(f"- `{it['id']}` \"{it['quitar_texto'][:60]}\": {it['resultado']}")
    low = [it for it in ap["items"] if it["confidence"] == "low"]
    for it in low: D.append(f"- Sugerencia baja no aplicada `{it['id']}`: {it.get('motivo', '')[:100]}")
    detail += D + [""]
clips = json.load(open(f"{BASE}/editado/promo/clips-medicion.json")); meta = {c["id"]: c for c in json.load(open(f"{BASE}/03-analisis/edicion/clips-promo.json"))}
L += ["", "## Clips para YouTube (editado/promo/)", "", "| Archivo | Duración | Audio |", "|---|---|---|"]
for c in clips: L.append(f"| {c['archivo']} | {c.get('duracion_s', '-')} s | {c.get('audio', {}).get('I', '-')} LUFS, {c.get('audio', {}).get('TP', '-')} dBTP |")
L += ["", "Títulos y descripciones sugeridos:", ""]
for c in clips:
    m = meta[c["id"]]; L += [f"**{m['titulo_youtube']}**", "", m["descripcion_youtube"], ""]
notas = json.load(open(f"{BASE}/03-analisis/verificacion/notas-operador.json"))
L += ["", "## Para el operador (no son errores de edición)", "", "Errores de contenido del audio original (no se cortan):", "", "| Parte | Dice | Correcto |", "|---|---|---|"]
for e in notas["errores_de_contenido_del_audio_original"]: L.append(f"| {e['parte']} ({e['aprox_original']}) | {e['dice']} | {e['correcto']} |")
L += ["", notas["como_decidir"], "", "Notas visuales:", ""] + [f"- {x}" for x in notas["notas_visuales"]]
L += [""] + detail
open(f"{BASE}/editado/REPORTE-EDICION.md", "w").write("\n".join(L) + "\n")
print("\n".join(L[:30]))
import sys; sys.exit(0 if TODAS_OK else 1)
