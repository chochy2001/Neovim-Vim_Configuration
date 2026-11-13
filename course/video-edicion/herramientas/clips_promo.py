"""Clips para YouTube desde los videos finales de editado/.
Lee 03-analisis/edicion/clips-promo.json (rangos en segundos del ORIGINAL), los pasa al tiempo del video final,
corta con recodificación (fotograma exacto), añade la tarjeta de 3 s "Curso completo gratis en academy.capdesis.com",
normaliza a -14 LUFS / -1 dBTP (dos pasadas) y mide el resultado. Salida: editado/promo/
Uso: python3 -I clips_promo.py"""
import json, os, re, subprocess
_EST = json.load(open(os.path.expanduser("~/Movies/Capdesis-Curso-Vim/04-davinci/estructura.json"))); PRE_S = _EST['pre'] / 60   # intro 4 s + lista 5 s (plan_estructura.py)
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
NAMES = {1: "01-modos-y-movimientos", 2: "02-insertar-pegar-y-buscar", 3: "03-buscar-caracteres-y-borrar", 4: "04-objetos-de-texto", 5: "05-ventanas-y-lineas"}
items = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))
clips = json.load(open(f"{BASE}/03-analisis/edicion/clips-promo.json"))
CARD = f"{BASE}/04-davinci/titulos/tarjeta-promo-3s.mp4"
OUT = f"{BASE}/editado/promo"; os.makedirs(OUT, exist_ok=True)
TMP = f"{BASE}/04-davinci/promo-tmp"; os.makedirs(TMP, exist_ok=True)
def to_out(p, t):
    for a, b, r in items[str(p)]["audio"]:
        if a / 60 <= t <= b / 60: return PRE_S + r / 60 + (t - a / 60)
def ebur(f):
    e = subprocess.run(["ffmpeg", "-nostats", "-hide_banner", "-i", f, "-vn", "-af", "ebur128=peak=true", "-f", "null", "-"], capture_output=True, text=True).stderr
    t = e[e.rfind("Summary:"):]
    return {"I": float(re.search(r"I:\s+(-?[\d.]+) LUFS", t).group(1)), "TP": float(re.search(r"Peak:\s+(-?[\d.]+) dBFS", t).group(1))}
rep = []
for c in clips:
    p = int(c["parte"]); a, b = to_out(p, c["src_ini"]), to_out(p, c["src_fin"])
    r = {"id": c["id"], "archivo": c["archivo"], "titulo": c["titulo_youtube"]}
    if a is None or b is None or not (25 <= b - a <= 95):
        r["resultado"] = f"NO GENERADO: rango fuera del video editado o duración {None if a is None or b is None else round(b - a, 1)} s"; rep.append(r); continue
    src = f"{BASE}/editado/{NAMES[p]}.mp4"; body = f"{TMP}/{c['id']}-cuerpo.mp4"; joined = f"{TMP}/{c['id']}-unido.mp4"; final = f"{OUT}/{c['archivo']}"
    subprocess.run(["ffmpeg", "-nostdin", "-v", "error", "-y", "-ss", f"{a:.3f}", "-i", src, "-t", f"{b - a:.3f}", "-vf", "fps=60,format=yuv420p",
                    "-af", "afade=t=in:d=0.08,aresample=48000", "-c:v", "libx264", "-crf", "17", "-preset", "slow", "-c:a", "aac", "-b:a", "256k", body], check=True)
    subprocess.run(["ffmpeg", "-nostdin", "-v", "error", "-y", "-i", body, "-i", CARD, "-f", "lavfi", "-t", "3", "-i", "anullsrc=r=48000:cl=stereo",
                    "-filter_complex", "[0:v][0:a][1:v][2:a]concat=n=2:v=1:a=1[v][a]", "-map", "[v]", "-map", "[a]",
                    "-c:v", "libx264", "-crf", "17", "-preset", "slow", "-r", "60", "-c:a", "aac", "-b:a", "256k", joined], check=True)
    for tp in (-2.0, -2.5, -3.0, -3.5):   # el AAC puede subir el pico: reintento con objetivo más bajo
        m = subprocess.run(["ffmpeg", "-hide_banner", "-i", joined, "-vn", "-af", f"loudnorm=I=-14:TP={tp}:LRA=11:print_format=json", "-f", "null", "-"], capture_output=True, text=True).stderr
        js = json.loads(m[m.rfind("{"):m.rfind("}") + 1])
        af = (f"loudnorm=I=-14:TP={tp}:LRA=11:measured_I={js['input_i']}:measured_TP={js['input_tp']}:measured_LRA={js['input_lra']}"
              f":measured_thresh={js['input_thresh']}:offset={js['target_offset']}:linear=true,aresample=48000")
        subprocess.run(["ffmpeg", "-nostdin", "-v", "error", "-y", "-i", joined, "-c:v", "copy", "-af", af, "-c:a", "aac", "-b:a", "256k", "-movflags", "+faststart", final], check=True)
        lv = ebur(final)
        if lv["TP"] <= -1.5 and abs(lv["I"] + 14) <= 0.5: break
    d = float(subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", final], capture_output=True, text=True).stdout)
    r.update(parte=p, export_ini=round(a, 2), export_fin=round(b, 2), duracion_s=round(d, 2), audio=lv, objetivo_tp=tp, resultado="generado" if (lv["TP"] <= -1.5 and abs(lv["I"] + 14) <= 0.5) else "NO CUMPLE audio")
    rep.append(r); print(r, flush=True)
json.dump(rep, open(f"{OUT}/clips-medicion.json", "w"), ensure_ascii=False, indent=1)
print("LISTO")
