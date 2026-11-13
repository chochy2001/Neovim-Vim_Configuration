"""Mide actividad de pantalla en cada item medium (fotogramas cada 0.25 s, 192x108 gris,
excluye webcam x<44,y>=60 y overlay de teclas). Extrae fotogramas inicio/mitad/fin."""
import json, subprocess, sys, os
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
W, H = 192, 108
def frames(src, t0, t1, step=0.25):
    cmd = ["ffmpeg", "-v", "error", "-ss", f"{t0:.3f}", "-to", f"{t1:.3f}", "-i", src,
           "-vf", f"fps={1/step},scale={W}:{H},format=gray", "-f", "rawvideo", "-"]
    raw = subprocess.run(cmd, capture_output=True).stdout
    n = len(raw) // (W*H)
    return [raw[i*W*H:(i+1)*W*H] for i in range(n)]
def masked(x, y):
    if y < 3: return False                 # barra de título
    if x < 78 and y >= 60: return False    # webcam + overlay de teclas
    if x < 30*192/192 and y>=0 and False: return False
    return True
MASK = [(x, y) for y in range(H) for x in range(W) if masked(x, y)]
IDX = [y*W+x for x, y in MASK]
def diff(a, b):
    ch = sum(1 for i in IDX if abs(a[i]-b[i]) > 25)
    return ch
out = {}
for p in range(1, 6):
    d = json.load(open(f"{BASE}/03-analisis/edicion/parte-{p}.json"))
    src = f"{BASE}/01-crudo/.por-numero/parte {p}.mp4"
    res = []
    for it in d["items"]:
        if it["confidence"] != "medium": continue
        fr = frames(src, it["in"], it["out"])
        diffs = [diff(fr[i], fr[i+1]) for i in range(len(fr)-1)]
        total = diff(fr[0], fr[-1]) if len(fr) > 1 else 0
        active = [round(it["in"] + (i+1)*0.25, 2) for i, c in enumerate(diffs) if c > 15]
        res.append({"id": it["id"], "in": it["in"], "out": it["out"], "n": len(fr),
                    "max_step_changed_px": max(diffs) if diffs else 0,
                    "steps_active": len(active), "first_last_changed_px": total,
                    "active_times": active[:40]})
        print(p, res[-1]["id"], res[-1]["max_step_changed_px"], res[-1]["steps_active"], total, active[:12], flush=True)
        vdir = f"{BASE}/03-analisis/frames/revision-medium"
        mid = (it["in"] + it["out"]) / 2
        subprocess.run(["ffmpeg", "-v", "error", "-y",
            "-ss", f"{it['in']+0.05:.2f}", "-i", src, "-ss", f"{mid:.2f}", "-i", src, "-ss", f"{it['out']-0.05:.2f}", "-i", src,
            "-filter_complex", "[0:v]scale=640:360[a];[1:v]scale=640:360[b];[2:v]scale=640:360[c];[a][b][c]hstack=3",
            "-frames:v", "1", f"{vdir}/{it['id']}.jpg"])
    out[p] = res
json.dump(out, open(f"{BASE}/03-analisis/frames/revision-medium/actividad.json", "w"), indent=1)
