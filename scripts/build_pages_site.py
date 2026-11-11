"""Assemble the GitHub Pages teaser site into --out DIR (default: _site/).

Practice is published at the root; slides at slides/.

Teaser policy:
  exercises.json: lessons 1-2 are complete; every later lesson becomes a
  locked stub with no exercise content.
  slides deck: modules m00-m02 are complete; for every later module only
  the title slide and one new 'locked' slide are kept.

Nothing under vendor/node_modules is shipped.
"""

import argparse
import json
import shutil
import sys
from pathlib import Path

REPO = Path(__file__).resolve().parents[1]
ACADEMY_URL = "https://academy.capdesis.com/cursos/vim-mejora-velocidad-codificar"

FREE_LESSONS = 2       # lesson-1 and lesson-2 are free (1-indexed id suffix)
FREE_MODULES_MAX = 3   # m00, m01, m02 (number 0, 1, 2) are free


def _trim_exercises(src: Path) -> dict:
    data = json.loads(src.read_text(encoding="utf-8"))
    new_lessons = []
    for lesson in data.get("lessons", []):
        lid = lesson.get("id", "")
        try:
            n = int(lid.split("-")[1])
        except (IndexError, ValueError):
            n = 0
        if n <= FREE_LESSONS:
            new_lessons.append(lesson)
        else:
            stub = {
                "id": lid,
                "titleEs": lesson.get("titleEs", ""),
                "titleEn": lesson.get("titleEn", ""),
                "locked": True,
                "exercise_count": len(lesson.get("exercises", [])),
            }
            new_lessons.append(stub)
    result = dict(data)
    result["lessons"] = new_lessons
    result["academy_url"] = ACADEMY_URL
    return result


def _trim_deck(src: Path) -> dict:
    data = json.loads(src.read_text(encoding="utf-8"))
    new_modules = []
    for mod in data.get("modules", []):
        mod_num = int(mod.get("number", "0"))
        if mod_num < FREE_MODULES_MAX:
            new_modules.append(mod)
        else:
            title_slide = next(
                (s for s in mod.get("slides", []) if s["type"] == "title"),
                None,
            )
            locked_slide = {
                "type": "locked",
                "id": mod["id"] + "-locked",
                "heading": "El modulo continua en Capdesis Academy",
                "body": (
                    "El resto de este modulo y el curso completo estan en "
                    "Capdesis Academy, gratis con una cuenta."
                ),
                "academy_url": ACADEMY_URL,
            }
            new_slides = []
            if title_slide:
                new_slides.append(title_slide)
            new_slides.append(locked_slide)
            new_mod = dict(mod)
            new_mod["slides"] = new_slides
            new_modules.append(new_mod)
    result = dict(data)
    result["modules"] = new_modules
    return result


def _deck_to_js(deck: dict) -> str:
    body = json.dumps(deck, ensure_ascii=False, indent=1)
    return (
        "// Generated from deck.json by scripts/build_slides.py. Do not edit.\n"
        "window.DECK = " + body + ";\n"
    )


def build(out_dir: Path) -> None:
    out_dir.mkdir(parents=True, exist_ok=True)

    # 1. Copy practice/ to out_dir/ (strip vendor/node_modules).
    practice_src = REPO / "practice"
    for item in practice_src.iterdir():
        dst = out_dir / item.name
        if item.is_dir():
            if item.name == "vendor":
                shutil.copytree(
                    item, dst,
                    ignore=shutil.ignore_patterns("node_modules"),
                    dirs_exist_ok=True,
                )
            else:
                shutil.copytree(item, dst, dirs_exist_ok=True)
        else:
            shutil.copy2(item, dst)

    # 2. Override exercises.json with the trimmed version.
    trimmed_ex = _trim_exercises(REPO / "practice" / "exercises.json")
    ex_dst = out_dir / "exercises.json"
    ex_dst.write_text(
        json.dumps(trimmed_ex, ensure_ascii=False, indent=2),
        encoding="utf-8",
        newline="\n",
    )

    # 3. Copy course/slides/ to out_dir/slides/.
    slides_dst = out_dir / "slides"
    slides_dst.mkdir(exist_ok=True)
    slides_src = REPO / "course" / "slides"
    for item in slides_src.iterdir():
        dst = slides_dst / item.name
        if item.is_dir():
            shutil.copytree(item, dst, dirs_exist_ok=True)
        else:
            shutil.copy2(item, dst)

    # 4. Override deck.json and regenerate deck.js from the trimmed deck.
    trimmed_deck = _trim_deck(REPO / "course" / "slides" / "deck.json")
    deck_json_dst = slides_dst / "deck.json"
    deck_json_dst.write_text(
        json.dumps(trimmed_deck, ensure_ascii=False, indent=2),
        encoding="utf-8",
        newline="\n",
    )
    deck_js_dst = slides_dst / "deck.js"
    deck_js_dst.write_text(
        _deck_to_js(trimmed_deck),
        encoding="utf-8",
        newline="\n",
    )


def main() -> int:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--out",
        type=Path,
        default=REPO / "_site",
        help="Output directory (default: _site/ at repo root)",
    )
    args = parser.parse_args()
    build(args.out)
    print(f"Site assembled at {args.out}")
    return 0


if __name__ == "__main__":
    sys.exit(main())
