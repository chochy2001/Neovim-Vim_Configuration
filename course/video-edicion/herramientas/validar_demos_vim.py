"""Ejecuta cada demo de las animaciones en Neovim real (headless, sin config) y compara texto y cursor.
Comandos que entran en modo insertar: se escribe un marcador y se mide dónde quedó (punto de inserción).
Salida: 03-analisis/animaciones/validacion-demos.json"""
import json, os, subprocess, tempfile
BASE = os.path.expanduser("~/Movies/Capdesis-Curso-Vim/03-analisis/animaciones")
INS = {"A", "I", "a", "i", "s", "cw", "ce", "ciw", "o", "O", "cip", "C", "ci(", "ci{", "cc", "S", "ct)", "ct{letra}"}
# teclas concretas para demos con título genérico (f{letra}...): las usa también la tarjeta
DEMO_KEYS = {"p3-c01": "Fh", "p3-c05": "fo", "p3-c06": "Th", "p3-c08": "rx", "p3-c16": "dt)", "p3-c18": "df)", "p3-c22": "ct)"}
MARK = "§"
def run(text, cur, keys, setsearch=None, tail=""):
    with tempfile.TemporaryDirectory() as d:
        out = f"{d}/o.json"
        cmds = ["-c", f"call setline(1, {json.dumps(text)})", "-c", f"call cursor(1, {cur + 1})"]
        if setsearch: cmds += ["-c", f"let @/ = {json.dumps(setsearch)}"]
        cmds += ["-c", f'exe "normal " . {json.dumps(keys)} . "{tail}"',
                 "-c", f"call writefile([json_encode({{'t': getline(1), 'c': col('.') - 1}})], {json.dumps(out)})", "-c", "qa!"]
        subprocess.run(["nvim", "--headless", "-u", "NONE", "-i", "NONE", "-n"] + cmds, capture_output=True, timeout=20)
        return json.load(open(out))
def keys_of(m):
    t = m["titulo"]
    if t.startswith("Ctrl-"): return chr(ord(t[5].lower()) - 96)   # Ctrl-r -> carácter de control 0x12
    return t
import sys
V2 = "--v2" in sys.argv          # ronda 2: comandos de analisis-v2-parte-N.json
res = []
for p in range(1, 6):
    src = json.load(open(os.path.expanduser(f"~/Movies/Capdesis-Curso-Vim/03-analisis/edicion/analisis-v2-parte-{p}.json")))["comandos"] if V2 else json.load(open(f"{BASE}/momentos-parte-{p}.json"))
    for m in src:
        d = m.get("demo")
        if not d: continue
        t = m["titulo"]; k = DEMO_KEYS.get(m["id"], keys_of(m))
        ss = "theme" if t in ("n", "N") else None
        if t in INS:
            r = run(d["antes"], d["cursor_antes"], k + MARK, ss, tail="\\<Esc>")
            pos = r["t"].find(MARK); txt = r["t"].replace(MARK, "")
            got = {"texto": txt, "insercion": pos}
            ok = txt == d["despues"] and (d.get("cursor_despues") is None or pos == d["cursor_despues"])
        else:
            if t in ("/", "/texto"): r = run(d["antes"], d["cursor_antes"], "/theme", ss, tail="\\r")
            elif t == ";": r = run(d["antes"], 0, "f-;", ss)          # ; repite el f- anterior (el demo parte del primer -)
            else: r = run(d["antes"], d["cursor_antes"], k, ss)
            got = {"texto": r["t"], "cursor": r["c"]}
            ok = r["t"] == d["despues"] and (d.get("cursor_despues") is None or r["c"] == d["cursor_despues"])
        res.append({"id": m["id"], "titulo": t, "demo": d, "nvim": got, "ok": ok})
        print("OK " if ok else "MAL", m["id"], t, d, "->", got)
json.dump(res, open(f"{BASE}/validacion-demos{'-v2' if V2 else ''}.json", "w"), indent=1, ensure_ascii=False)
print("demos", len(res), "mal", sum(1 for r in res if not r["ok"]))
