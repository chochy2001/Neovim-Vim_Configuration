"""Write course/slides/deck.js from deck.json so the slides open from file://.

Browsers block fetch() on file:// pages, so a teacher double-clicking
index.html saw empty slides. deck.json stays the source of truth; deck.js is
generated from it. Run with --check in CI to fail when deck.js is stale.
"""

import json
from pathlib import Path
import sys

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "course" / "slides" / "deck.json"
TARGET = ROOT / "course" / "slides" / "deck.js"


def render():
    deck = json.loads(SOURCE.read_text(encoding="utf-8"))
    body = json.dumps(deck, ensure_ascii=False, indent=1)
    return (
        "// Generated from deck.json by scripts/build_slides.py. Do not edit.\n"
        "window.DECK = " + body + ";\n"
    )


if __name__ == "__main__":
    text = render()
    if "--check" in sys.argv:
        current = TARGET.read_text(encoding="utf-8") if TARGET.exists() else ""
        if current != text:
            sys.exit("FAIL: course/slides/deck.js is stale; run python scripts/build_slides.py")
        print("PASS: deck.js matches deck.json")
    else:
        TARGET.write_text(text, encoding="utf-8", newline="\n")
        print("Wrote", TARGET.relative_to(ROOT))
