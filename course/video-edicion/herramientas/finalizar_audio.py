"""Espera los renders de Resolve, normaliza el audio (EBU R128 dos pasadas, -16 LUFS, TP <= -1.5 dBTP)
copiando el video sin recodificar, y mide antes/después. Uso: python3 -I finalizar_audio.py [partes...]
(sin partes: las 5; con partes, conserva en finales.json las mediciones de las demás)"""
import json, os, re, subprocess, sys, time
_EST = json.load(open(os.path.expanduser("~/Movies/Capdesis-Curso-Vim/04-davinci/estructura.json"))); PRE_S = _EST['pre'] / 60   # intro 4 s + lista 5 s (plan_estructura.py)
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
SRC = f"{BASE}/04-davinci/render-resolve"
DST = f"{BASE}/editado"
_ITEMS = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))
_N = ["01-modos-y-movimientos", "02-insertar-pegar-y-buscar", "03-buscar-caracteres-y-borrar", "04-objetos-de-texto", "05-ventanas-y-lineas"]
_P = [int(x) for x in sys.argv[1:]] or [1, 2, 3, 4, 5]
EXP = {n: _ITEMS[str(i + 1)]["total_frames"] for i, n in enumerate(_N) if i + 1 in _P}   # fotogramas del contenido (sin intro/cierre)
def dur(f):
    r = subprocess.run(["ffprobe", "-v", "error", "-show_entries", "format=duration", "-of", "csv=p=0", f], capture_output=True, text=True)
    try: return float(r.stdout.strip())
    except ValueError: return None
def ebur(f):
    e = subprocess.run(["ffmpeg", "-nostats", "-hide_banner", "-i", f, "-vn", "-af", "ebur128=peak=true", "-f", "null", "-"], capture_output=True, text=True).stderr
    tail = e[e.rfind("Summary:"):]
    return {"I": float(re.search(r"I:\s+(-?[\d.]+) LUFS", tail).group(1)), "LRA": float(re.search(r"LRA:\s+(-?[\d.]+) LU", tail).group(1)),
            "TP": float(re.search(r"Peak:\s+(-?[\d.]+) dBFS", tail).group(1))}
pending = dict(EXP)
_FJ = f"{BASE}/03-analisis/audio/loudness/finales.json"
results = {k: v for k, v in json.load(open(_FJ)).items() if k not in EXP} if os.path.exists(_FJ) and len(EXP) < 5 else {}
os.makedirs(DST, exist_ok=True); os.makedirs(f"{BASE}/03-analisis/audio/loudness", exist_ok=True)
t_limite = time.time() + 3 * 3600   # si un render falla, no esperar para siempre
while pending:
    if time.time() > t_limite: raise SystemExit(f"TIEMPO AGOTADO esperando: {list(pending)}")
    for name, frames in list(pending.items()):
        f = f"{SRC}/{name}.mp4"
        d = dur(f) if os.path.exists(f) else None
        if d and abs(d - (frames + _EST["pre"] + _EST["partes"][str(_N.index(name) + 1)]["post"]) / 60) < 0.1:   # + intro/lista y resumen/cierre
            time.sleep(5)
            before = ebur(f)
            out = f"{DST}/{name}.mp4"
            if os.path.exists(out):   # no sobrescribir: la versión anterior se aparta
                prev = f"{BASE}/04-davinci/versiones-previas/editado"; os.makedirs(prev, exist_ok=True)
                os.rename(out, f"{prev}/{name}.{int(time.time())}.mp4")
            tmp = f"{DST}/.{name}.tmp.mp4"
            # el AAC puede subir el pico real tras normalizar: se reintenta con un objetivo de pico más bajo
            for tp in (-2.0, -2.5, -3.0, -3.5, -4.0):
                m = subprocess.run(["ffmpeg", "-hide_banner", "-i", f, "-vn", "-af", f"loudnorm=I=-16:TP={tp}:LRA=11:print_format=json", "-f", "null", "-"],
                                   capture_output=True, text=True).stderr
                js = json.loads(m[m.rfind("{"):m.rfind("}") + 1])
                af = (f"loudnorm=I=-16:TP={tp}:LRA=11:measured_I={js['input_i']}:measured_TP={js['input_tp']}:measured_LRA={js['input_lra']}"
                      f":measured_thresh={js['input_thresh']}:offset={js['target_offset']}:linear=true,aresample=48000")
                subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", f, "-map", "0:v:0", "-map", "0:a:0", "-c:v", "copy", "-af", af,
                                "-c:a", "aac", "-b:a", "192k", "-ar", "48000", "-movflags", "+faststart", tmp], check=True)
                after = ebur(tmp)
                if after["TP"] <= -1.5 and abs(after["I"] + 16) <= 0.5: break
            os.rename(tmp, out)
            results[name] = {"salida": out, "cumple": after["TP"] <= -1.5 and abs(after["I"] + 16) <= 0.5, "antes": before, "despues": after, "objetivo_tp_usado": tp, "loudnorm_pass1": js}
            print(name, results[name]["antes"], "->", results[name]["despues"], flush=True)
            del pending[name]
    if pending: time.sleep(20)
json.dump(results, open(f"{BASE}/03-analisis/audio/loudness/finales.json", "w"), indent=1)
print("LISTO")
