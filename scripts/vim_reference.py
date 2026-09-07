"""Refresh or check trainer fixtures against real Neovim 0.12+."""

import json
import os
from pathlib import Path
import subprocess
import sys

ROOT = Path(__file__).resolve().parents[1]
cases = [
    ("change-word", "old new", "cwNEW<Esc>"),
    ("change-last-word", "old", "cwNEW<Esc>"),
    ("delete-last-word", "old", "dw"),
    ("change-line", "one\ntwo", "ccNEW<Esc>"),
    ("change-tail", "keep DROP", "5lCNEW<Esc>"),
    ("cancel-operator", "hello world", "d<Esc>l"),
    ("cancel-count", "a\nb\nc\nd", "3<Esc>j"),
    ("cancel-find", "abc def", "f<Esc>l"),
    ("insert-undo", "ab", "iXY<Esc>u"),
    ("change-undo", "old new", "cwNEW<Esc>u"),
    ("delete-undo-twice", "abcd", "xxuu"),
    ("counted-gg", "a\nb\nc\nd", "3ggj"),
    ("counted-delete", "a\nb\nc\nd\ne\nf\ng", "2d3d"),
    ("counted-find", "aXbXcX", "2fX"),
    ("find-adjacent", "aXXbX", "tX"),
    ("repeat-till", "abXcdX", "tX;"),
    ("paragraph-next", "one\ntwo\n\nthree", "}"),
    ("paragraph-previous", "one\ntwo\n\nthree", "G{"),
    ("indent-cursor", "x", ">>"),
    ("join-cursor", "foo\nbar", "J"),
    ("paste-char-cursor", "hello world", "yelp"),
    ("new-line-undo", "one\ntwo", "oNEW<Esc>u"),
    ("change-empty", "", "ccNEW<Esc>"),
    ("inner-last-word", "hello", "ciwX<Esc>"),
    ("inner-quotes-at-open", 'x = "old";', '4lci"new<Esc>'),
    ("counted-replace", "abcd", "3rx"),
    ("empty-word-motion", "one\n\ntwo", "w"),
    ("cross-line-delete-word", "one\ntwo", "dw"),
    ("insert-backspace", "abc", "A<BS><Esc>"),
    ("insert-join-backspace", "one\ntwo", "ji<BS><Esc>"),
    ("insert-start", "  body", "Inew <Esc>"),
    ("open-above-undo", "one\ntwo", "ONEW<Esc>u"),
    ("yank-inner-and-paste", "cat dog", "yiw$p"),
    ("reverse-delete", "abc def", "$d0"),
    ("unindent-lines", "    one\n    two", "2<<"),
    ("backwards-till-repeat", "aXbXcXd", "$TX;"),
    ("empty-inner-change-undo", "", "ciwNEW<Esc>u"),
]
payload = [{"id": name, "start": start, "keys": keys} for name, start, keys in cases]
kata = subprocess.run(
    ["dart" + (".bat" if os.name == "nt" else ""), "run", "scripts/export_katas.dart"],
    cwd=ROOT,
    capture_output=True,
    text=True,
    encoding="utf-8",
    check=True,
)
payload += json.loads(kata.stdout)
temp = ROOT / "tmp"
temp.mkdir(exist_ok=True)
source, output = temp / "vim-cases.json", temp / "vim-reference.json"
source.write_text(json.dumps(payload, ensure_ascii=False), encoding="utf-8")
subprocess.run(
    ["nvim", "--clean", "-l", "tests/vim_reference.lua", str(source), str(output)],
    cwd=ROOT,
    check=True,
)
data = json.loads(output.read_text(encoding="utf-8"))
fixture = ROOT / "trainer/test/fixtures/neovim.json"
if "--check" in sys.argv:
    old = json.loads(fixture.read_text(encoding="utf-8"))
    assert (
        old["cases"] == data["cases"]
    ), "Neovim reference changed; inspect before refreshing fixtures"
    print(f"PASS {len(data['cases'])} cases match Neovim {data['version']}")
else:
    fixture.parent.mkdir(parents=True, exist_ok=True)
    fixture.write_text(
        json.dumps(data, indent=2, ensure_ascii=False, sort_keys=True) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    print(f"Wrote {len(data['cases'])} reference cases from Neovim {data['version']}")
