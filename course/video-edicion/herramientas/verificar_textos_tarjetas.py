"""Lee con OCR (Vision, local) el texto de cada tarjeta en el VIDEO FINAL y lo compara con el plan, con tildes.
Detecta: tarjeta vieja usada por error (E26), texto sin tildes (E25), tarjeta ausente.
Salida: 03-analisis/verificacion/capas/textos-tarjetas.json. Uso: python3 -I verificar_textos_tarjetas.py"""
import json, os, subprocess, unicodedata, difflib
_EST = json.load(open(os.path.expanduser("~/Movies/Capdesis-Curso-Vim/04-davinci/estructura.json"))); PRE_S = _EST['pre'] / 60   # intro 4 s + lista 5 s (plan_estructura.py)
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); H = f"{BASE}/03-analisis/herramientas"; OUT = f"{BASE}/03-analisis/verificacion/capas/ocr"
os.makedirs(OUT, exist_ok=True)
NAMES = {1: "01-modos-y-movimientos", 2: "02-insertar-pegar-y-buscar", 3: "03-buscar-caracteres-y-borrar", 4: "04-objetos-de-texto", 5: "05-ventanas-y-lineas"}
plan = json.load(open(f"{BASE}/04-davinci/animaciones/plan-v2.json")); an = json.load(open(f"{BASE}/04-davinci/animaciones-plan.json"))   # ronda 2: todas las tarjetas
imgs, meta = [], {}
for p, n in NAMES.items():
    rec = {a["id"]: a for a in an[str(p)]}
    for c in [c for c in plan[str(p)] if c.get("tipo", "comando") == "comando"]:
        x, y = c["pos"]; t = rec[c["id"]]["rec_ini"] / 60 + PRE_S + min(3.2, rec[c["id"]]["frames"] / 60 - 0.6)
        f = f"{OUT}/{c['id']}.png"
        subprocess.run(["ffmpeg", "-nostdin", "-v", "error", "-y", "-ss", f"{t:.3f}", "-i", f"{BASE}/editado/{n}.mp4", "-frames:v", "1",
                        "-vf", f"crop=640:{c['alto']}:{x}:{y},scale=1280:-1", f], check=True)
        imgs.append(f); meta[os.path.basename(f)] = c
ocr = json.loads(subprocess.run(["swift", f"{H}/ocr_teclas.swift"] + imgs, capture_output=True, text=True).stdout)
HOMO = str.maketrans({"у": "y", "о": "o", "е": "e", "а": "a", "с": "c", "р": "p", "х": "x", "і": "i"})   # cirílicas que Vision devuelve
REV = json.load(open(f"{BASE}/03-analisis/verificacion/capas/textos-revisados.json")) if os.path.exists(f"{BASE}/03-analisis/verificacion/capas/textos-revisados.json") else {}
def sin(s): return "".join(ch for ch in unicodedata.normalize("NFD", s) if unicodedata.category(ch) != "Mn")
res, mal = {}, []
for k, c in meta.items():
    txt = ocr.get(k, {}).get("texto", "").translate(HOMO); want = c["texto"]
    ok_exact = want in txt
    ratio = difflib.SequenceMatcher(a=want.lower(), b=txt.lower()).find_longest_match(0, len(want), 0, len(txt)).size / len(want)
    ok_sin = sin(want).lower() in sin(txt).lower()
    estado = "OK" if ok_exact else ("SIN_TILDES_O_DISTINTO" if ok_sin else "NO_ENCONTRADO")
    if estado != "OK" and REV.get(c["id"], {}).get("texto") == want: estado = "OK"; res_nota = REV[c["id"]]["evidencia"]
    res[c["id"]] = {"esperado": want, "ocr": txt, "estado": estado, "coincidencia": round(ratio, 2)}
    # etiqueta CORRECCIÓN: solo en las tarjetas con corrige_audio (revisadas a mano, E44)
    tiene = "CORRECCION" in sin(txt).upper(); quiere = bool(c.get("corrige_audio"))
    if estado == "OK" and tiene != quiere: estado = "CORRECCION_SOBRA" if tiene else "CORRECCION_FALTA"
    res[c["id"]]["correccion"] = tiene
    if estado != "OK": res[c["id"]]["estado"] = estado; mal.append((c["id"], estado, want, txt[:120]))
json.dump(res, open(f"{BASE}/03-analisis/verificacion/capas/textos-tarjetas.json", "w"), indent=1, ensure_ascii=False)
print("tarjetas", len(res), "OK", sum(1 for v in res.values() if v["estado"] == "OK"), "con CORRECCIÓN", sum(1 for v in res.values() if v.get("correccion")))
for m in mal: print("REVISAR", m)
import sys; sys.exit(1 if mal else 0)
