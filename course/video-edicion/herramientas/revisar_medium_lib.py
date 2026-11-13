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
