"""Regenera las capas PNG de las tarjetas de comando desde plan-v2.json (tarjeta_capas.swift) en una carpeta VERSIONADA
(capas-<VER>, E34: Resolve/Fusion cachean medios por ruta). Las insignias de marca no cambian: se copian de la versión anterior.
Uso: python3 -I capas_tarjetas.py v3   (animaciones_fusion.py --v2 lee la versión de 04-davinci/estructura.json "capas_tarjetas")"""
import json, os, shutil, subprocess, sys
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim"); AN = f"{BASE}/04-davinci/animaciones"; H = f"{BASE}/03-analisis/herramientas"
VER = sys.argv[1]; OUT = f"{AN}/capas-{VER}"; os.makedirs(OUT, exist_ok=True)
plan = [c for v in json.load(open(f"{AN}/plan-v2.json")).values() for c in v]
jobs = []
for c in plan:
    if c.get("tipo") == "marca":
        src = f"{AN}/capas-v2/{c['id']}"
        if not os.path.isdir(f"{OUT}/{c['id']}"): shutil.copytree(src, f"{OUT}/{c['id']}")
        continue
    os.makedirs(f"{OUT}/{c['id']}", exist_ok=True)
    jobs.append({"dir": f"{OUT}/{c['id']}", "teclas": c["teclas"], "texto": c["texto"], "categoria": c["categoria"],
                 "corrige_audio": c.get("corrige_audio", False), "demo": c.get("demo")})
json.dump(jobs, open(f"{AN}/capas-{VER}-trabajos.json", "w"), ensure_ascii=False, indent=1)
subprocess.run(["swift", f"{H}/tarjeta_capas.swift", f"{AN}/capas-{VER}-trabajos.json"], check=True)
falt = [c["id"] for c in plan if not os.path.exists(f"{OUT}/{c['id']}/metricas.json")]
E = json.load(open(f"{BASE}/04-davinci/estructura.json")); E["capas_tarjetas"] = f"capas-{VER}"; json.dump(E, open(f"{BASE}/04-davinci/estructura.json", "w"), ensure_ascii=False, indent=1)
print("tarjetas", len(jobs), "con CORRECCIÓN", sum(j["corrige_audio"] for j in jobs), "marcas copiadas", len(plan) - len(jobs), "faltan", falt)
