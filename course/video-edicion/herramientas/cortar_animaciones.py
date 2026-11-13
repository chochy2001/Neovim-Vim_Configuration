"""Corta fusion-todas.mov (render de Deliver con alfa) en un clip qtrle por tarjeta y escribe 04-davinci/animaciones-plan.json
(lo usa resolve_externo.py para la pista V5). Verifica que cada clip tenga 300 fotogramas, imagen a mitad y nada al inicio/fin.
Uso: python3 -I cortar_animaciones.py"""
import json, os, subprocess, sys
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); AN = f"{BASE}/04-davinci/animaciones"
V2 = "--v2" in sys.argv; ARGS = [a for a in sys.argv[1:] if not a.startswith("--")]
idx = json.load(open(f"{AN}/indice-render{'-v2' if V2 else ''}.json")); plan = json.load(open(f"{AN}/plan-v2.json" if V2 else f"{AN}/plan-base.json"))
SRC = f"{AN}/render/fusion-todas{'-v2' if V2 else ''}.mov"; OUT = f"{AN}/" + (ARGS[0] if ARGS else "clips"); os.makedirs(OUT, exist_ok=True)   # carpeta nueva por versión   # carpeta nueva por versión: Resolve cachea archivos con el mismo nombre
def alpha_px(f, n):
    b = subprocess.run(["ffmpeg", "-v", "error", "-i", f, "-vf", f"select=eq(n\\,{n}),alphaextract,scale=480:270", "-frames:v", "1", "-f", "rawvideo", "-pix_fmt", "gray", "-"], capture_output=True).stdout
    return sum(1 for x in b if x > 16)
res, bad = {}, []
for p, cards in plan.items():
    res[p] = []
    for c in cards:
        t = idx["tarjetas"][c["id"]]; a = t["inicio"]; D = c.get("frames", idx["dur"])      # solo la parte visible
        out = f"{OUT}/{c['id']}.mov"
        subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", SRC, "-vf", f"trim=start_frame={a}:end_frame={a + D},setpts=PTS-STARTPTS", "-an", "-map", "0:v:0", "-dn",
                        "-c:v", "qtrle", "-pix_fmt", "argb", out], check=True)
        nf = int(subprocess.run(["ffprobe", "-v", "error", "-count_packets", "-select_streams", "v:0", "-show_entries", "stream=nb_read_packets", "-of", "csv=p=0", out], capture_output=True, text=True).stdout.split()[0])
        mid, ini, fin = alpha_px(out, min(150, D // 2)), alpha_px(out, 0), alpha_px(out, D - 1)
        ok = nf == D and mid > (1500 if c.get("tipo") == "marca" else 3000) and ini < 200 and fin < 200
        if not ok: bad.append((c["id"], nf, ini, mid, fin))
        res[p].append({"id": c["id"], "archivo": out, "rec_ini": c["rec_ini"], "frames": D, "pos": c["pos"], "tipo": c.get("tipo", "comando"), "alpha_ini_mid_fin": [ini, mid, fin]})
        print(c["id"], nf, ini, mid, fin, "OK" if ok else "MAL", flush=True)
json.dump(res, open(f"{BASE}/04-davinci/animaciones-plan.json", "w"), indent=1)
print("clips", sum(len(v) for v in res.values()), "mal", bad)
