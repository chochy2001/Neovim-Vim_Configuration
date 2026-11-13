"""Detecta el recuadro de teclas de la grabación (caja negra abajo a la izquierda, herramienta de Windows)
fotograma a fotograma (cada 2 fotogramas a 60 fps) y guarda un PNG por cada estado distinto del texto.
Salida: 03-analisis/teclas/parte-N/estados.json + estado-XXXX.png. Uso: .venv/bin/python -I medir_teclas.py N A|B"""
import json, os, subprocess, sys, hashlib
import numpy as np
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim")
# Dos posiciones fijas medidas (x0, y0, x1, y1 exclusivos, 1920x1080): A abajo-izquierda (todas las partes), B abajo-centro (parte 1)
POS = {"A": (3, 704, 411, 818), "B": (303, 957, 769, 1075)}
STEP = 2
p = int(sys.argv[1]); POSN = sys.argv[2]; BX0, BY0, BX1, BY1 = POS[POSN]
X0, Y0, W, H = BX0, BY0, BX1 - BX0, BY1 - BY0
out = f"{BASE}/03-analisis/teclas/parte-{p}/{POSN}"; os.makedirs(out, exist_ok=True)
cmd = ["ffmpeg", "-nostdin", "-v", "error", "-i", f"{BASE}/01-crudo/.por-numero/parte {p}.mp4", "-vf", f"select='not(mod(n\\,{STEP}))',crop={W}:{H}:{X0}:{Y0},format=rgb24",
       "-fps_mode", "passthrough", "-f", "rawvideo", "-"]
pr = subprocess.Popen(cmd, stdout=subprocess.PIPE)
fs = W * H * 3; estados, cur, i = [], None, 0
while True:
    b = pr.stdout.read(fs)
    if len(b) < fs: break
    a = np.frombuffer(b, np.uint8).reshape(H, W, 3)
    g = a.mean(2)
    inner = g[5:H - 6, 5:W - 14]   # sin el borde ni el agarre de esquina
    blk = (inner < 24).mean(); wht = (inner > 170).mean()
    present = bool(blk > 0.6 and blk + wht > 0.93)
    if present:
        bits = np.packbits(inner[::4, ::4] > 110); key = hashlib.md5(bits.tobytes()).hexdigest()[:10]
        vacio = bool(wht < 0.002)
    else:
        key, vacio = None, None
    f = i * STEP
    if cur and cur["key"] == key: cur["fin"] = f + STEP
    else:
        if cur: estados.append(cur)
        cur = {"ini": f, "fin": f + STEP, "key": key, "presente": present, "vacio": vacio}
        if present and not vacio:
            n = sum(1 for e in estados if e["key"] == key)
            ppm = f"{out}/k-{key}.ppm"
            if not os.path.exists(ppm):
                c = a
                open(ppm, "wb").write(b"P6 %d %d 255\n" % (c.shape[1], c.shape[0]) + c.tobytes())
    i += 1
if cur: estados.append(cur)
json.dump({"step": STEP, "caja": [BX0, BY0, BX1, BY1], "estados": estados}, open(f"{out}/estados.json", "w"))
pres = sum(e["fin"] - e["ini"] for e in estados if e["presente"]); tot = i * STEP
print(p, POSN, "fotogramas", tot, "caja presente %.1f%%" % (100 * pres / max(tot, 1)), "estados", len(estados),
      "textos distintos", len({e["key"] for e in estados if e["presente"] and not e["vacio"]}))
