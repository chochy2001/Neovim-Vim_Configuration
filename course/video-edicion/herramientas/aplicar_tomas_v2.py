"""Valida las tomas malas nuevas (analisis-v2-parte-N.json, de agentes) contra las palabras de Whisper:
el corte va del inicio de la primera palabra a quitar al final de la última (nunca dentro de una palabra vecina),
y solo se aplica si el texto quitado coincide con "quitar_texto" (≥ 0.6). Escribe "tomas_malas_aplicables" en el mismo JSON."""
import json, os, re, difflib, unicodedata
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
def norm(s):
    s = unicodedata.normalize("NFD", s.lower()); return " ".join(re.findall(r"\w+", "".join(c for c in s if unicodedata.category(c) != "Mn")))
for p in range(1, 6):
    af = f"{BASE}/03-analisis/edicion/analisis-v2-parte-{p}.json"; A = json.load(open(af))
    W = [(w["start"], w["end"], w["w"]) for sg in json.load(open(f"{BASE}/03-analisis/transcripts/parte-{p}.json"))["segments"] for w in sg.get("words") or []]
    ok = []
    for t in A.get("tomas_malas", []):
        dentro = [i for i, (s, e, _) in enumerate(W) if (s + e) / 2 >= t["t_ini"] - 0.05 and (s + e) / 2 <= t["t_fin"] + 0.05]
        if not dentro: print(p, "SIN PALABRAS", t["t_ini"], t["quitar_texto"][:40]); continue
        i0, i1 = dentro[0], dentro[-1]
        txt = " ".join(W[i][2] for i in dentro); r = difflib.SequenceMatcher(a=norm(txt), b=norm(t["quitar_texto"])).ratio()
        a = W[i0][0] - 0.04; b = W[i1][1] + 0.04
        if i0 > 0: a = max(a, W[i0 - 1][1])          # exactamente en el límite: con palabras pegadas no deja restos
        if i1 + 1 < len(W): b = min(b, W[i1 + 1][0])
        if r < 0.6: print(p, "NO COINCIDE", round(r, 2), repr(txt[:60]), "vs", repr(t["quitar_texto"][:60])); continue
        ok.append({"t_ini": round(a, 3), "t_fin": round(b, 3), "texto": txt.strip(), "coincidencia": round(r, 2), "motivo": t.get("motivo", "")})
        print(p, "OK", round(a, 2), round(b, 2), round(r, 2), repr(txt.strip()[:70]))
    A["tomas_malas_aplicables"] = ok; json.dump(A, open(af, "w"), indent=1, ensure_ascii=False)
