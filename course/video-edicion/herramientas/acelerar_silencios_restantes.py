"""Segunda pasada de time-lapse: para silencios que siguen largos en el export (ya con time-lapse),
sube a 6x los tramos ya acelerados que caen dentro y acelera a 3x los trozos a 1x de >=2 s interiores.
Deja 1 s a velocidad normal en cada borde del silencio. Uso: python3 acelerar_silencios_restantes.py P:ini:fin ...
(tiempos del export final, en s). Luego items_timeline.py, colocar_logo.py y el montaje."""
import json, os, sys
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); FPS = 60
it = json.load(open(f"{BASE}/04-davinci/items-timeline.json"))
tl = json.load(open(f"{BASE}/04-davinci/timelapse-plan.json"))
for arg in sys.argv[1:]:
    p, a, b = arg.split(":"); a, b = float(a), float(b)
    mp = {}
    for v in it[p]["video"]:
        for k in range(v[1] - v[0]): mp[v[2] + k] = v[0] + k
    r0, r1 = round((a - 4 + 1) * FPS), round((b - 4 - 1) * FPS)       # 1 s normal en cada borde
    srcs = [mp[r] for r in range(r0, r1)]
    lo, hi = srcs[0] / FPS, srcs[-1] / FPS
    for t in tl[p]:
        if t["src_ini"] < hi and t["src_fin"] > lo and t["factor"] < 6:
            t["factor"] = 6; t["segunda_pasada"] = True
    runs, st = [], 0
    for i in range(1, len(srcs) + 1):
        if i == len(srcs) or srcs[i] - srcs[i - 1] != 1:
            runs.append((srcs[st], srcs[i - 1])); st = i
    for s, e in runs:
        if (e - s) / FPS >= 2.0 and not any(t["src_ini"] <= s / FPS + 0.1 and e / FPS - 0.1 <= t["src_fin"] for t in tl[p]):
            tl[p].append({"src_ini": round(s / FPS + 0.05, 3), "src_fin": round(e / FPS - 0.05, 3), "factor": 3, "silencio_export_s": round(b - a, 1), "segunda_pasada": True})
    tl[p].sort(key=lambda t: t["src_ini"])
    print(p, a, b, [(t["src_ini"], t["src_fin"], t["factor"]) for t in tl[p] if t.get("segunda_pasada")])
json.dump(tl, open(f"{BASE}/04-davinci/timelapse-plan.json", "w"), indent=1)
