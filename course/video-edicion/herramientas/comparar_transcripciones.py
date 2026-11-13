"""Compara la transcripción original con la del export (paso 8c). Uso: comparar_transcripciones.py <parte> <export.json>"""
import difflib, json, os, re, sys, unicodedata
_EST = json.load(open(os.path.expanduser("~/Movies/Capdesis-Curso-Vim/04-davinci/estructura.json"))); PRE_S = _EST['pre'] / 60   # intro 4 s + lista 5 s (plan_estructura.py)
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
p, exp_json = int(sys.argv[1]), sys.argv[2]
def norm(s):
    s = unicodedata.normalize("NFD", s.lower()); s = "".join(c for c in s if unicodedata.category(c) != "Mn")
    return re.sub(r"[^\w]", "", s)
EQUIV = {"skip": "esc", "bim": "vim", "jeturings": "jetbrains"}
def words(js):
    out = []
    for s in js["segments"]:
        for w in s.get("words", []):
            t = w.get("w", w.get("word", ""))
            n = norm(t)
            if n: out.append((EQUIV.get(n, n), w["start"], w["end"], t.strip()))
    return out
orig = words(json.load(open(f"{BASE}/03-analisis/transcripts/parte-{p}.json")))
expo = words(json.load(open(exp_json)))
plan = json.load(open(f"{BASE}/03-analisis/edicion/aplicados-parte-{p}.json"))
cuts = [tuple(r) for it in plan["items"] for r in it.get("aplicado", [])]
def in_cut(a, b): return any(a < cb and b > ca for ca, cb in cuts)
AUD = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))[str(p)]["audio"]   # [src_ini, src_fin, rec] en fotogramas
def src_to_out(t):
    for a, b, r in AUD:
        if a/60 <= t < b/60: return PRE_S + r/60 + (t - a/60)   # intro + lista
    return None
sm = difflib.SequenceMatcher(a=[w[0] for w in orig], b=[w[0] for w in expo], autojunk=False)
ok_removed, lost, extra = [], [], []
for tag, i1, i2, j1, j2 in sm.get_opcodes():
    if tag in ("delete", "replace"):
        seg = orig[i1:i2]
        cut = [w for w in seg if in_cut(w[1], w[2])]
        kept = [w for w in seg if not in_cut(w[1], w[2])]
        if cut: ok_removed.append(" ".join(w[3] for w in cut))
        if kept: lost.append({"t_origen": round(kept[0][1], 2), "t_export": round(src_to_out(kept[0][1]) or -1, 2), "palabras": " ".join(w[3] for w in kept),
                              "export_dice": " ".join(w[3] for w in expo[j1:j2]), "n": len(kept)})
    if tag == "insert":
        extra.append({"t_export": round(expo[j1][1], 2), "palabras": " ".join(w[3] for w in expo[j1:j2])})
txt = " ".join(w[0] for w in expo)
wrong_take = {k: (k in txt) for k in ["eso se corta", "se borratea", "copiarlo con u"]}
# palabras a menos de 0.15 s de un corte en el export (posible palabra truncada)
bounds = [PRE_S] + [PRE_S + r/60 for a, b, r in AUD[1:]]   # uniones en el video final
near = [{"t_export": round(w[1], 2), "palabra": w[3]} for w in expo if any(abs(w[1]-x) < 0.05 or abs(w[2]-x) < 0.05 for x in bounds) and len(w[0]) <= 2]
serious = [l for l in lost if l["n"] >= 3]
res = {"parte": p, "ratio_similitud": round(sm.ratio(), 4), "palabras_original": len(orig), "palabras_export": len(expo),
       "quitadas_a_proposito": ok_removed, "diferencias_en_contenido_conservado": lost, "candidatos_error_contenido(>=3 palabras)": serious,
       "insertadas_por_whisper": extra[:200], "toma_erronea_presente": wrong_take, "palabras_cortas_pegadas_a_un_corte": near}
out = exp_json.replace(".json", "-comparacion.json")
json.dump(res, open(out, "w"), ensure_ascii=False, indent=1)
print(json.dumps({k: res[k] for k in ["parte", "ratio_similitud", "palabras_original", "palabras_export", "toma_erronea_presente"]}, ensure_ascii=False),
      "| diferencias:", len(lost), "| candidatas >=3:", len(serious), "| cortas junto a corte:", len(near))
