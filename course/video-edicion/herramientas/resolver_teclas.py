"""Combina la lectura por plantillas (leer_teclas.py) y la de Vision (ocr_teclas.swift) en un texto final por recorte,
validado con una gramática de nombres de tecla. Lo que no valida se marca y no se muestra.
Salida: 03-analisis/teclas/teclas-final.json {ruta_png: {"tokens": [...], "fuente", "valido"}}"""
import json, os, re, difflib
B = os.path.expanduser("~/Movies/Capdesis-Curso-Vim/03-analisis/teclas")
r = json.load(open(f"{B}/lectura.json"))
VOC = ["L Shift", "R Shift", "L Ctrl", "R Ctrl", "L Alt", "R Alt", "Backspace", "Space", "Enter", "Esc", "Tab", "Up", "Down", "Left", "Right",
       "Delete", "Insert", "Home", "End", "PageUp", "PageDown", "L Win", "R Win", "Caps Lock", "Apps", "PrintScreen"] + [f"Numpad {i}" for i in range(10)] + [f"F{i}" for i in range(1, 13)]
SINGLE = set("ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789?<>-~.,'´;[]/\\=?¿¡`\"") | {"+"}
FIX = {"ESC": "Esc", "TT": '"', "Ø": "0", "O0": "0"}
def toks(t):
    t = (t or "").strip()
    if not t: return []
    # el separador es " + "; la tecla "+" sola aparece como "+" entre separadores
    parts = re.split(r"\s+\+\s+", t)
    return [p.strip() for p in parts]
def snap(tok):
    tok = FIX.get(tok, tok)
    if tok in VOC or tok in SINGLE: return tok
    if len(tok) == 1: return tok.upper() if tok.upper() in SINGLE else None
    m = difflib.get_close_matches(tok, VOC, n=1, cutoff=0.6)
    return m[0] if m else None
out = {}
for f, v in r.items():
    tp = [snap(x) for x in toks(v["texto"])]
    oc = [snap(x) for x in toks(v["ocr"])] if v.get("ocr") else []
    if not tp and not oc: out[f] = {"tokens": [], "fuente": "vacio", "valido": True}; continue
    if oc and len(oc) == len(tp) and None not in oc:
        # mismo número de teclas: Vision para letras sueltas (distingue 5/S, 0/O), plantillas si Vision no dio nada válido
        fin = [o if o is not None else t for o, t in zip(oc, tp)]; src = "ocr+plantillas"
    elif oc and None not in oc and (None in tp or not tp):
        fin = oc; src = "ocr"                      # la plantilla no valida y Vision sí
    else:
        fin = tp; src = "plantillas"
    ok = bool(fin) and None not in fin and all(x for x in fin)
    out[f] = {"tokens": fin if ok else [], "fuente": src, "valido": ok, "plantillas": v["texto"], "ocr": v.get("ocr")}
# correcciones de la revisión visual por agentes (hojas/lista-NN.png): mandan sobre la lectura automática
COR = json.load(open(f"{B}/correcciones-revision.json")) if os.path.exists(f"{B}/correcciones-revision.json") else {}
for f, c in COR.items():
    t = [snap(x) for x in toks(c["texto"])]
    out[f] = {"tokens": t, "fuente": "revision", "valido": None not in t, "plantillas": r[f]["texto"], "ocr": r[f].get("ocr"),
              "no_es_caja": bool(c.get("no_es_caja"))}      # recorte que NO es la caja de teclas: no se tapa
json.dump(out, open(f"{B}/teclas-final.json", "w"), indent=1, ensure_ascii=False)
import collections
print("validos", sum(o["valido"] for o in out.values()), "de", len(out))
print("no validos:", [(o["plantillas"], o["ocr"]) for o in out.values() if not o["valido"]])
print(collections.Counter(" + ".join(o["tokens"]) for o in out.values()).most_common(200))
