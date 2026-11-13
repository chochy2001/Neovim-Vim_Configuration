"""Para cada comando escrito que se vio en el crudo (linea_comandos_visual), lee con OCR el VIDEO FINAL en ese instante:
el comando debe leerse (con el zoom). Además comprueba que la columna de números de línea se vea (dígitos a la izquierda).
Salida: 03-analisis/verificacion/capas/zoom-comandos.json. Uso: python3 -I verificar_zoom_comandos.py"""
import json, os, re, subprocess
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); H = f"{BASE}/03-analisis/herramientas"; OUT = f"{BASE}/03-analisis/verificacion/capas/zoomcmd"
os.makedirs(OUT, exist_ok=True)
E = json.load(open(f"{BASE}/04-davinci/estructura.json")); it = json.load(open(f"{BASE}/04-davinci/items-timeline.json")); PRE = E["pre"] / 60
NAMES = {1: "01-modos-y-movimientos", 2: "02-insertar-pegar-y-buscar", 3: "03-buscar-caracteres-y-borrar", 4: "04-objetos-de-texto", 5: "05-ventanas-y-lineas"}
res, imgs, meta = {}, [], {}
# texto de referencia corregido a ojo cuando el OCR del CRUDO se equivocó (con evidencia). No da OK: el final debe leerse igual.
REVC = json.load(open(f"{BASE}/03-analisis/edicion/comandos-revisados.json")) if os.path.exists(f"{BASE}/03-analisis/edicion/comandos-revisados.json") else {}
for p, n in NAMES.items():
    A = json.load(open(f"{BASE}/03-analisis/edicion/analisis-v2-parte-{p}.json")); au = it[str(p)]["audio"]
    for k, c in enumerate(A.get("linea_comandos_visual", [])):
        # "texto" es lo MÁS LARGO que se vio (suele ser al final del tramo): a mitad del tramo aún se está escribiendo.
        # Se miran 3 instantes (fin, fin-0.4 s, mitad); vale si en alguno se lee el comando entero con números de línea.
        hay = False
        for j, t in enumerate((c["t_fin"], c["t_fin"] - 0.4, (c["t_ini"] + c["t_fin"]) / 2)):
            f = round(t * 60); rec = next((r + f - s for s, e, r in au if s <= f < e), None)
            if rec is None: continue
            hay = True; fn = f"{OUT}/p{p}-{k}-{j}.png"
            subprocess.run(["ffmpeg", "-v", "error", "-y", "-ss", f"{rec / 60 + PRE:.3f}", "-i", f"{BASE}/editado/{n}.mp4", "-frames:v", "1", fn], check=True)
            imgs.append(fn); meta[os.path.basename(fn)] = (f"{p}-{k}", REVC.get(f"{p}-{k}", {}).get("texto", c["texto"]))
        if not hay: res[f"{p}-{k}"] = {"texto": c["texto"], "estado": "NO_CONSERVADO"}
o = json.loads(subprocess.run(["swift", f"{H}/ocr_cajas.swift"] + imgs, capture_output=True, text=True).stdout or "{}")
# Vision no lee textos muy cortos (":q") en el fotograma entero: segunda pasada sobre la franja inferior ampliada 2x (E42)
tiras = []
for fn in imgs:
    tf = fn.replace(".png", "-abajo.png"); tiras.append(tf)
    subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", fn, "-vf", "crop=1920:300:0:780,scale=3840:600", tf], check=True)
o2 = json.loads(subprocess.run(["swift", f"{H}/ocr_cajas.swift"] + tiras, capture_output=True, text=True).stdout or "{}")
norm = lambda s: re.sub(r"[^a-z0-9:/!]", "", s.lower()).replace("9", "q")   # Vision confunde q con 9 junto al cursor de bloque
# El cursor de bloque al final se lee como "l", "1", "i" o "|" (en el crudo: "/Themel", "/sty1l", ":help ggl"): se quita al final
# de AMBOS textos y después se exige el comando entero. Solo se toleran esos caracteres: ":wq" leído ":w" sigue fallando.
def limpio(s):
    t = norm(s)
    while len(t) > 2 and t[-1] in "l1i|": t = t[:-1]
    return t
def igual(leido, want):
    l = limpio(leido)
    return bool(want) and (l == want or (l.startswith(want) and set(l[len(want):]) <= set("l1i")))
for b, (key, txt) in meta.items():
    boxes = o.get(b, []); want = limpio(txt)   # comando COMPLETO (antes want[:2]: ":wq" leído ":w" pasaba, revisión 2026-11-13)
    cands = [t for t, x, y, w, h, cf in boxes if y > 700] + [t for t, x, y, w, h, cf in o2.get(b.replace(".png", "-abajo.png"), [])]
    vis = [t for t in cands if igual(t, want)]
    leido_todo = [t for t in cands if norm(t)[:1] in (":", "/")][:4]
    # números de línea: el gutter queda en x≈720 con el zoom 1.6x del comando, a la izquierda del código
    nums = [t for t, x, y, w, h, cf in boxes if re.fullmatch(r"\d{1,4}", t.strip()) and x < 1000]
    r = {"texto": txt, "esperado_limpio": want, "fotograma": b, "leido": vis[:3], "leido_linea": leido_todo, "numeros_de_linea": len(nums), "estado": "OK" if vis and len(nums) >= 3 else "REVISAR"}
    if key not in res or (res[key]["estado"] != "OK" and r["estado"] == "OK"): res[key] = r   # basta un instante con el comando entero
json.dump(res, open(f"{BASE}/03-analisis/verificacion/capas/zoom-comandos.json", "w"), indent=1, ensure_ascii=False)
for k, v in sorted(res.items()): print(k, v)
print("comandos", len(res), "OK", sum(1 for v in res.values() if v["estado"] == "OK"))
print("partes sin comandos de línea (no aplica):", [p for p in NAMES if not any(k.startswith(f"{p}-") for k in res)])
import sys; sys.exit(0 if all(v["estado"] == "OK" for v in res.values()) else 1)
