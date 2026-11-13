"""Detecta en el crudo CUÁNDO aparece escrito un comando en la línea de comandos de IdeaVim (franja inferior del editor,
y≈1000-1040) para que el zoom vaya a lo que se VE, no a lo que se dice (la revisión vio zooms sin el comando escrito).
5 fps; OCR (Vision) solo cuando la franja cambia. Texto que empieza por ':' o '/'.
Salida: clave "linea_comandos_visual" en analisis-v2-parte-N.json: [{t_ini, t_fin, texto, x, y}]. Uso: .venv/bin/python -I detectar_linea_comandos.py [N...]"""
import json, os, subprocess, sys, tempfile
import numpy as np
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); H = f"{BASE}/03-analisis/herramientas"
X0, Y0, W, HH, FPS = 380, 995, 900, 50, 5
for p in [int(x) for x in sys.argv[1:]] or [1, 2, 3, 4, 5]:
    pr = subprocess.Popen(["ffmpeg", "-v", "error", "-i", f"{BASE}/01-crudo/.por-numero/parte {p}.mp4", "-vf", f"fps={FPS},crop={W}:{HH}:{X0}:{Y0},format=gray",
                          "-f", "rawvideo", "-"], stdout=subprocess.PIPE)
    prev, i, todo = None, 0, []
    tmp = tempfile.mkdtemp()
    while True:
        b = pr.stdout.read(W * HH)
        if len(b) < W * HH: break
        g = np.frombuffer(b, np.uint8).reshape(HH, W)
        sig = (g > np.median(g) + 40)[:, :400]                      # texto claro sobre el fondo, primera parte de la franja
        if sig.mean() > 0.004 and (prev is None or (sig != prev).mean() > 0.002):
            f = f"{tmp}/f{i:06d}.pgm"; open(f, "wb").write(b"P5 %d %d 255\n" % (W, HH) + g.tobytes()); todo.append((i, f))
        prev = sig; i += 1
    # OCR por lotes (convertir a PNG para Vision)
    hits = []
    for k in range(0, len(todo), 300):
        pngs = []
        for j, f in todo[k:k + 300]:
            pn = f[:-4] + ".png"; subprocess.run(["ffmpeg", "-v", "error", "-y", "-i", f, "-vf", "scale=iw*2:ih*2", pn]); pngs.append((j, pn))
        o = json.loads(subprocess.run(["swift", f"{H}/ocr_cajas.swift"] + [pn for _, pn in pngs], capture_output=True, text=True).stdout or "{}")
        for j, pn in pngs:
            for t, x, y, w, h, c in o.get(os.path.basename(pn), []):
                t = t.strip()
                if t[:1] in (":", "/") and len(t) >= 2 and x < 500: hits.append((j / FPS, t, X0 + x // 2, Y0 + y // 2))
    # agrupar apariciones consecutivas (huecos < 1.2 s)
    ev = []
    for t, txt, x, y in sorted(hits):
        if ev and t - ev[-1]["t_fin"] < 1.2: ev[-1]["t_fin"] = t; ev[-1]["texto"] = max(ev[-1]["texto"], txt, key=len)
        else: ev.append({"t_ini": t, "t_fin": t, "texto": txt, "x": x, "y": y})
    af = f"{BASE}/03-analisis/edicion/analisis-v2-parte-{p}.json"; A = json.load(open(af)); A["linea_comandos_visual"] = ev
    json.dump(A, open(af, "w"), indent=1, ensure_ascii=False)
    print(p, "fotogramas", i, "a OCR", len(todo), "comandos vistos", [(round(e["t_ini"], 1), round(e["t_fin"], 1), e["texto"]) for e in ev], flush=True)
