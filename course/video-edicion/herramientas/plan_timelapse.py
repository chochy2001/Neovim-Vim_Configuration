"""Plan de aceleración (time-lapse) para silencios largos que tienen acción en pantalla.
Se ejecuta DESPUÉS de un primer render: mide silencios >= 8 s en editado/ y los pasa al original.
2x si el silencio dura < 20 s, 3x si dura más; deja 1 s a velocidad normal en cada extremo.
ANTES de aceptarlo, mirar una hoja de fotogramas de cada tramo: si no pasa nada útil, mejor cortar.
Uso: python3 -I plan_timelapse.py  -> 04-davinci/timelapse-plan.json (luego items_timeline.py y montaje de nuevo)"""
import json, os, re, subprocess
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
NAMES = {1: "01-modos-y-movimientos", 2: "02-insertar-pegar-y-buscar", 3: "03-buscar-caracteres-y-borrar", 4: "04-objetos-de-texto", 5: "05-ventanas-y-lineas"}
it = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))
out = {str(p): [] for p in NAMES}
for p, n in NAMES.items():
    e = subprocess.run(["ffmpeg", "-nostdin", "-hide_banner", "-i", f"{BASE}/editado/{n}.mp4", "-vn", "-af", "silencedetect=n=-45dB:d=8", "-f", "null", "-"],
                       capture_output=True, text=True).stderr
    for end, d in re.findall(r"silence_end: ([\d.]+) \| silence_duration: ([\d.]+)", e):
        end, d = float(end), float(d); a = end - d
        a0, b0 = a + 1.0 - 4.0, a + d - 1.0 - 4.0          # 1 s normal a cada lado, sin la intro de 4 s
        for s, e_, r in it[str(p)]["audio"]:
            ra, rb = r / 60, (r + e_ - s) / 60
            lo, hi = max(a0, ra), min(b0, rb)
            if hi - lo >= 4:
                out[str(p)].append({"src_ini": round(s / 60 + lo - ra, 3), "src_fin": round(s / 60 + hi - ra, 3), "factor": 3 if d >= 20 else 2, "silencio_export_s": round(d, 1)})
json.dump(out, open(f"{BASE}/04-davinci/timelapse-plan.json", "w"), indent=1)
for p, v in out.items(): print(p, len(v), "tramos")
