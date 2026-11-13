"""Escucha cada unión de corte en el video final: mide la energía del audio en ±40 ms alrededor del punto de unión.
Si hay voz justo en la unión (> -40 dBFS a ambos lados), puede haber una palabra cortada -> REVISAR.
Uso: python3 -I verificar_uniones.py  -> 03-analisis/verificacion/uniones.json"""
import json, math, os, struct, subprocess
_EST = json.load(open(os.path.expanduser("~/Movies/Capdesis-Curso-Vim/04-davinci/estructura.json"))); PRE_S = _EST['pre'] / 60
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
NAMES = {1: "01-modos-y-movimientos", 2: "02-insertar-pegar-y-buscar", 3: "03-buscar-caracteres-y-borrar", 4: "04-objetos-de-texto", 5: "05-ventanas-y-lineas"}
items = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))
def db(samples):
    if not samples: return -120.0
    r = math.sqrt(sum(x * x for x in samples) / len(samples)) / 32768
    return 20 * math.log10(r + 1e-9)
res = {}
for p, n in NAMES.items():
    f = f"{BASE}/editado/{n}.mp4"
    raw = subprocess.run(["ffmpeg", "-v", "error", "-i", f, "-vn", "-ac", "1", "-ar", "16000", "-f", "s16le", "-"], capture_output=True).stdout
    a = struct.unpack("<%dh" % (len(raw) // 2), raw)
    joints = [PRE_S + r / 60 for s, e, r in items[str(p)]["audio"][1:]]   # PRE_S: intro + lista (estructura.json)   # uniones = inicio de cada segmento tras el primero
    out = []
    for t in joints:
        i = int(t * 16000); w = int(0.04 * 16000)
        assert w <= i and i + w <= len(a), f"parte {p}: unión {t:.2f}s fuera del audio ({len(a)/16000:.1f}s)"   # antes daba -120 dB = OK
        l, rr = db(a[i - w:i]), db(a[i:i + w])
        out.append({"t_export": round(t, 3), "db_antes": round(l, 1), "db_despues": round(rr, 1), "estado": "REVISAR" if l > -40 and rr > -40 else "OK"})
    # con voz a ambos lados: si es un corte de toma mala entre palabras (ninguna palabra de Whisper partida > 30 ms) es correcto
    W = [(w["start"], w["end"]) for sg in json.load(open(f"{BASE}/03-analisis/transcripts/parte-{p}.json"))["segments"] for w in sg.get("words") or []]
    assert W, f"parte {p}: transcripción sin palabras; no se puede decidir entre palabras"
    au = items[str(p)]["audio"]
    for o, (s_, e_, r_) in zip(out, au[1:]):
        if o["estado"] != "REVISAR": continue
        k = au.index([s_, e_, r_]); e_src, s_src = au[k - 1][1] / 60, s_ / 60
        partida = [w for w in W if (w[0] + 0.03 < e_src < w[1] - 0.03) or (w[0] + 0.03 < s_src < w[1] - 0.03)]
        if not partida: o["estado"] = "OK"; o["nota"] = "voz a ambos lados, pero el corte cae entre palabras (toma mala)"
    res[p] = {"uniones": len(out), "revisar": [o for o in out if o["estado"] == "REVISAR"], "entre_palabras": [o for o in out if o.get("nota")], "detalle": out}
    print(p, "uniones", len(out), "revisar", len(res[p]["revisar"]), res[p]["revisar"][:5], flush=True)
json.dump(res, open(f"{BASE}/03-analisis/verificacion/uniones.json", "w"), indent=1)
import sys; sys.exit(1 if any(v["revisar"] for v in res.values()) else 0)
