"""Paso 8: verifica cada video final de editado/.
a) ffprobe -> editado/verificacion-ffprobe.txt
b) transcribe el export (Whisper) -> 03-analisis/verificacion/export-parte-N.{json,txt}
c) compara palabra por palabra con la transcripción original (comparar_transcripciones.py)
d) 10 fotogramas repartidos + 1 por zoom (mitad) -> 03-analisis/frames/verificacion-exports/ y hojas de contacto
Uso: .venv/bin/python -I verificar_exports.py [partes...]"""
import json, os, subprocess, sys
_EST = json.load(open(os.path.expanduser("~/Movies/Capdesis-Curso-Vim/04-davinci/estructura.json"))); PRE_S = _EST['pre'] / 60   # intro 4 s + lista 5 s (plan_estructura.py)
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
NAMES = {1: "01-modos-y-movimientos", 2: "02-insertar-pegar-y-buscar", 3: "03-buscar-caracteres-y-borrar", 4: "04-objetos-de-texto", 5: "05-ventanas-y-lineas"}
items = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))
partes = [int(x) for x in sys.argv[1:]] or list(NAMES)
os.makedirs(f"{BASE}/03-analisis/verificacion", exist_ok=True)
FR = f"{BASE}/03-analisis/frames/verificacion-exports"; os.makedirs(FR, exist_ok=True)
open(f"{BASE}/editado/verificacion-ffprobe.txt", "w").close()   # se reescribe en cada ejecución
def run(*a, **k): return subprocess.run(list(a), capture_output=True, text=True, **k)
for p in partes:
    f = f"{BASE}/editado/{NAMES[p]}.mp4"
    pr = run("ffprobe", "-v", "error", "-show_entries", "format=duration,bit_rate:stream=codec_type,codec_name,width,height,r_frame_rate,sample_rate,channels,bit_rate", "-of", "default=nw=1", f).stdout
    with open(f"{BASE}/editado/verificacion-ffprobe.txt", "a") as fh: fh.write(f"== {NAMES[p]}.mp4\n{pr}\n")
    # fotogramas: 10 repartidos
    d = float(run("ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", f).stdout)
    shots = []
    for i in range(10):
        t = d * (i + 0.5) / 10; o = f"{FR}/p{p}-reparto-{i:02d}.jpg"
        run("ffmpeg", "-v", "error", "-y", "-ss", f"{t:.2f}", "-i", f, "-frames:v", "1", "-q:v", "3", o); shots.append(o)
    # un fotograma a mitad de cada zoom (tiempo de salida)
    keep = items[str(p)]["audio"]
    def out_t(ts):
        for s, e, r in keep:
            if s / 60 <= ts < e / 60: return PRE_S + r / 60 + ts - s / 60   # intro + lista
    zs = []
    for z in items[str(p)]["zooms"]:
        tm = out_t((z["t_start"] + z["t_end"]) / 2)
        if tm is None: continue
        o = f"{FR}/p{p}-zoom-{z['ids'][0]}.jpg"
        run("ffmpeg", "-v", "error", "-y", "-ss", f"{tm:.2f}", "-i", f, "-frames:v", "1", "-q:v", "4", "-vf", "scale=640:360", o); zs.append(o)
    for nm, lst, cols in [("reparto", shots, 5), ("zooms", zs, 6)]:
        for k in range(0, len(lst), cols * 4):
            grp = lst[k:k + cols * 4]; args = []
            for g in grp: args += ["-i", g]
            lay = "|".join(f"{(j % cols)*640}_{(j // cols)*360}" for j in range(len(grp)))
            run("ffmpeg", "-v", "error", "-y", *args, "-filter_complex", "".join(f"[{j}:v]scale=640:360[s{j}];" for j in range(len(grp))) + "".join(f"[s{j}]" for j in range(len(grp))) + f"xstack=inputs={len(grp)}:layout={lay}:fill=black" if len(grp) > 1 else "null",
                f"{FR}/hoja-p{p}-{nm}-{k // (cols*4)}.jpg")
    # transcripción + comparación
    out = f"{BASE}/03-analisis/verificacion/export-parte-{p}"
    for viejo in (out + ".json", out + "-comparacion.json"):
        if os.path.exists(viejo): os.remove(viejo)   # nunca usar el de una ejecución anterior (revisión 2026-11-13)
    t = run(f"{BASE}/.venv/bin/python", "-I", f"{BASE}/03-analisis/herramientas/transcribir.py", f, out)
    print(t.stdout.strip(), t.stderr.strip()[-300:], flush=True)
    if t.returncode: sys.exit(f"transcribir.py falló en la parte {p}")
    c = run("python3", "-I", f"{BASE}/03-analisis/herramientas/comparar_transcripciones.py", str(p), out + ".json")
    print(c.stdout.strip(), c.stderr.strip()[-500:], flush=True)
    if c.returncode or not os.path.exists(out + "-comparacion.json"): sys.exit(f"comparar_transcripciones.py falló en la parte {p}")
print("LISTO")
