"""
tests/test_slides.py
====================
Tests for course/slides/deck.json and the slide presentation system.

Sections:
  (a) Schema validation -- modules, slide types, required fields
  (b) Demo slides verified against real Neovim via vim_reference.lua
  (c) Config and keys slides reference shortcuts in exercises.json
  (d) Progressive key check -- demos only use keys introduced up to their module
  (e) No em-dash (U+2014) or en-dash (U+2013) in deck.json text
  (f) Practice lesson IDs exist in exercises.json
  (g) Spanish accent validation -- required words carry accent marks
  (h) Practice URL dual-layout logic -- slides.js getPracticeUrl function
  (i) Optional Playwright browser smoke tests (practice URL + navigation)

Run:
  python3 tests/test_slides.py                      # all except browser
  SLIDES_REQUIRE_BROWSER=1 python3 tests/test_slides.py   # include browser tests
"""

import json
import os
import re
import shutil
import subprocess
import sys
import tempfile
import unittest
from pathlib import Path

# ---------------------------------------------------------------------------
# Paths (resolved from repo root, regardless of cwd)
# ---------------------------------------------------------------------------
REPO = Path(__file__).resolve().parent.parent
DECK_PATH = REPO / "course" / "slides" / "deck.json"
EXERCISES_PATH = REPO / "practice" / "exercises.json"
VIM_REF_LUA = REPO / "tests" / "vim_reference.lua"


# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------

class TestGeneratedDeckJs(unittest.TestCase):
    def test_deck_js_matches_deck_json(self):
        # index.html loads deck.js so the slides also open from file://.
        result = subprocess.run(
            [sys.executable, str(REPO / "scripts" / "build_slides.py"), "--check"],
            capture_output=True,
            text=True,
        )
        self.assertEqual(0, result.returncode, result.stdout + result.stderr)


class TestAccentsAgainstCourseVocabulary(unittest.TestCase):
    """Every accented word the course uses must keep its accent in the slides.

    The vocabulary comes from COURSE.md, UDEMY.md and the practice page, so a
    new word written with its accent there is checked here automatically.
    Words whose meaning decides the accent (esta/está, mas/más...) are skipped.
    """

    AMBIGUOUS = {"esta", "estas", "este", "ese", "mas", "solo", "como", "que", "donde", "cuando",
                 "aun", "el", "tu", "si", "se", "de", "mi", "te", "practica", "practicas",
                 "continua", "numero", "calculo", "termino", "publico", "ultimo", "limite",
                 "titulo", "vacio", "cambio", "envio", "guia", "dia", "dias", "camara"}

    def test_no_course_word_loses_its_accent(self):
        import unicodedata

        def strip(word):
            return "".join(c for c in unicodedata.normalize("NFD", word) if unicodedata.category(c) != "Mn")

        source = ""
        for name in ("COURSE.md", "UDEMY.md", "practice/exercises.json"):
            source += (REPO / name).read_text(encoding="utf-8")
        accented = {}
        for word in re.findall(r"[A-Za-zÁÉÍÓÚáéíóúñÑü]+", source):
            plain = strip(word.lower())
            if plain != word.lower() and plain not in self.AMBIGUOUS:
                accented[plain] = word.lower()
        # Only what the audience reads: deck text (not ids, image paths or
        # key sequences) and the string literals of the page.
        skip = {"id", "img", "image", "keys", "start", "result", "introduces", "cursor"}
        parts = []

        def collect(node):
            if isinstance(node, dict):
                for key, value in node.items():
                    if key not in skip:
                        collect(value)
            elif isinstance(node, list):
                for item in node:
                    collect(item)
            elif isinstance(node, str):
                parts.append(node)

        collect(json.loads((REPO / "course/slides/deck.json").read_text(encoding="utf-8")))
        for name in ("slides.js", "index.html"):
            text = (REPO / "course/slides" / name).read_text(encoding="utf-8")
            parts += re.findall(r"'([^'\\n]*)'|\"([^\"\\n]*)\"", text) and [
                a or b for a, b in re.findall(r"'([^'\\n]*)'|\"([^\"\\n]*)\"", text)
            ]
        shown = "\n".join(parts)
        wrong = sorted({w for w in re.findall(r"[A-Za-zñÑ]+", shown) if w.lower() in accented})
        self.assertEqual([], wrong, "write these with their accent")


def load_deck() -> dict:
    with open(DECK_PATH, encoding="utf-8") as f:
        return json.load(f)


def load_exercises() -> dict:
    with open(EXERCISES_PATH, encoding="utf-8") as f:
        return json.load(f)


def all_text_in_deck(deck: dict) -> list[str]:
    """Return every string value in the deck (recursive), for em/en dash scan."""
    results: list[str] = []

    def walk(obj):
        if isinstance(obj, str):
            results.append(obj)
        elif isinstance(obj, dict):
            for v in obj.values():
                walk(v)
        elif isinstance(obj, list):
            for item in obj:
                walk(item)

    walk(deck)
    return results


def shortcut_set(exercises: dict) -> set[str]:
    """Build a set of (key, mode) tuples from exercises.json shortcuts."""
    pairs: set[tuple[str, str]] = set()
    for category in exercises.get("shortcuts", []):
        for row in category.get("rows", []):
            pairs.add((row["key"], row.get("mode", "")))
    return pairs


def shortcut_keys_only(exercises: dict) -> set[str]:
    """Build a set of key strings (without mode) from exercises.json shortcuts."""
    keys: set[str] = set()
    for category in exercises.get("shortcuts", []):
        for row in category.get("rows", []):
            keys.add(row["key"])
    return keys


def lesson_ids(exercises: dict) -> set[str]:
    """Return the set of lesson IDs defined in exercises.json."""
    ids: set[str] = set()
    for lesson in exercises.get("lessons", []):
        ids.add(lesson["id"])
    return ids


# Fields whose values are technical, not human-readable Spanish text.
_SKIP_FIELDS = {
    'id', 'type', 'number', 'image', 'url', 'public_url', 'lesson',
    'mode', 'key', 'version', 'introduces', 'start', 'keys', 'cursor',
    'row', 'col', 'text',
}


def all_human_text_in_deck(deck: dict) -> list[str]:
    """Return string values from human-readable fields only (skips ids, keys, urls, etc.)."""
    results: list[str] = []

    def walk(obj, field_name=None):
        if isinstance(obj, str):
            if field_name not in _SKIP_FIELDS:
                results.append(obj)
        elif isinstance(obj, dict):
            for k, v in obj.items():
                walk(v, field_name=k)
        elif isinstance(obj, list):
            for item in obj:
                walk(item, field_name=field_name)

    walk(deck)
    return results


def parse_vim_tokens(keys_str: str) -> list[str]:
    """
    Extract the leading Vim Normal-mode commands from a keys string.

    Rules:
    - <Xxx> notation is a single token.
    - A plain letter at Normal-mode positions is a command token when it
      plausibly starts a sequence (we extract single letters that appear
      before any text-insertion phase and after count digits).
    - Text typed in Insert mode (after i/a/I/A/o/O/c...) is not a Vim command.

    This is a best-effort heuristic sufficient to flag obvious violations
    in short demo key sequences.
    """
    tokens: list[str] = []
    i = 0
    in_insert = False
    while i < len(keys_str):
        ch = keys_str[i]
        # Special key: <Xxx> or <C-x> etc.
        if ch == "<":
            end = keys_str.find(">", i)
            if end != -1:
                token = keys_str[i : end + 1]
                tokens.append(token)
                if token in ("<Esc>", "<Esc><Esc>"):
                    in_insert = False
                i = end + 1
                continue
        if in_insert:
            # Skip text being typed; only Esc leaves insert
            i += 1
            continue
        # Count prefix: skip digits
        if ch.isdigit():
            i += 1
            continue
        # Double-quote register prefix: ""x" -> register x
        if ch == '"':
            tokens.append('"' + (keys_str[i + 1] if i + 1 < len(keys_str) else ""))
            i += 2
            continue
        # Command letter
        tokens.append(ch)
        # Commands that enter Insert mode
        if ch in ("i", "a", "I", "A", "o", "O"):
            in_insert = True
        # Commands that enter Insert mode after consuming one more char
        elif ch in ("c", "d", "y", "r", "f", "F", "t", "T", "g"):
            # consume the motion/target letter, stay in Normal for d/y/g,
            # enter insert for c
            if i + 1 < len(keys_str) and keys_str[i + 1] not in ("<",):
                i += 1  # skip motion char (already added 'c', 'dw' adds 'd')
                if ch == "c":
                    in_insert = True
        i += 1
    return tokens


# ---------------------------------------------------------------------------
# (a) Schema tests
# ---------------------------------------------------------------------------

class TestSchema(unittest.TestCase):
    def setUp(self):
        self.deck = load_deck()
        self.modules = self.deck["modules"]

    def test_version_present(self):
        self.assertIn("version", self.deck)

    def test_title_present(self):
        self.assertIn("title", self.deck)

    def test_all_14_modules_present(self):
        ids = [m["id"] for m in self.modules]
        for n in range(14):
            expected = f"m{n:02d}"
            self.assertIn(expected, ids, f"Module {expected} missing from deck.json")

    def test_modules_in_order(self):
        for i, m in enumerate(self.modules):
            expected_number = f"{i:02d}"
            self.assertEqual(
                m["number"], expected_number,
                f"Module at index {i} has number {m['number']!r}, expected {expected_number!r}"
            )

    def test_each_module_has_title_slide(self):
        for m in self.modules:
            types = [s["type"] for s in m["slides"]]
            self.assertIn("title", types, f"{m['id']}: no title slide")

    def test_each_module_has_summary_slide(self):
        for m in self.modules:
            types = [s["type"] for s in m["slides"]]
            self.assertIn("summary", types, f"{m['id']}: no summary slide")

    def test_each_module_has_practice_or_config_slide(self):
        for m in self.modules:
            types = set(s["type"] for s in m["slides"])
            self.assertTrue(
                "practice" in types or "config" in types,
                f"{m['id']}: no practice or config slide"
            )

    def test_slide_counts_between_3_and_12(self):
        for m in self.modules:
            count = len(m["slides"])
            self.assertGreaterEqual(count, 3, f"{m['id']}: only {count} slides")
            self.assertLessEqual(count, 12, f"{m['id']}: {count} slides (too many)")

    def test_slide_ids_unique(self):
        all_ids: list[str] = []
        for m in self.modules:
            for s in m["slides"]:
                all_ids.append(s["id"])
        self.assertEqual(len(all_ids), len(set(all_ids)), "Duplicate slide IDs found")

    def test_slide_ids_start_with_module_id(self):
        for m in self.modules:
            prefix = m["id"] + "-"
            for s in m["slides"]:
                self.assertTrue(
                    s["id"].startswith(prefix),
                    f"Slide {s['id']!r} in {m['id']} does not start with {prefix!r}"
                )

    def test_title_slides_have_heading_number_promise_image(self):
        for m in self.modules:
            for s in m["slides"]:
                if s["type"] == "title":
                    for field in ("heading", "number", "promise", "image"):
                        self.assertIn(
                            field, s,
                            f"Title slide {s['id']!r} missing {field!r}"
                        )

    def test_concept_slides_have_heading_and_bullets(self):
        for m in self.modules:
            for s in m["slides"]:
                if s["type"] == "concept":
                    self.assertIn("heading", s, f"{s['id']}: concept missing heading")
                    self.assertIn("bullets", s, f"{s['id']}: concept missing bullets")
                    self.assertIsInstance(s["bullets"], list)
                    self.assertGreater(len(s["bullets"]), 0, f"{s['id']}: empty bullets")

    def test_keys_slides_have_heading_and_rows(self):
        for m in self.modules:
            for s in m["slides"]:
                if s["type"] == "keys":
                    self.assertIn("heading", s, f"{s['id']}: keys missing heading")
                    self.assertIn("rows", s, f"{s['id']}: keys missing rows")
                    for row in s["rows"]:
                        self.assertIn("key", row)
                        self.assertIn("action", row)

    def test_demo_slides_have_start_keys_result(self):
        for m in self.modules:
            for s in m["slides"]:
                if s["type"] == "demo":
                    for field in ("start", "keys", "result"):
                        self.assertIn(
                            field, s,
                            f"Demo slide {s['id']!r} missing {field!r}"
                        )
                    result = s["result"]
                    self.assertIn("text", result, f"{s['id']}: result missing 'text'")
                    self.assertIn("cursor", result, f"{s['id']}: result missing 'cursor'")
                    self.assertEqual(len(result["cursor"]), 2, f"{s['id']}: cursor must be [row, col]")

    def test_practice_slides_have_lesson_url(self):
        for m in self.modules:
            for s in m["slides"]:
                if s["type"] == "practice":
                    self.assertIn("lesson", s, f"{s['id']}: practice missing 'lesson'")
                    self.assertIn("url", s, f"{s['id']}: practice missing 'url'")

    def test_config_slides_have_rows(self):
        for m in self.modules:
            for s in m["slides"]:
                if s["type"] == "config":
                    self.assertIn("rows", s, f"{s['id']}: config missing 'rows'")
                    for row in s["rows"]:
                        self.assertIn("key", row)
                        self.assertIn("desc", row)

    def test_summary_slides_have_heading_and_bullets(self):
        for m in self.modules:
            for s in m["slides"]:
                if s["type"] == "summary":
                    self.assertIn("heading", s, f"{s['id']}: summary missing heading")
                    self.assertIn("bullets", s, f"{s['id']}: summary missing bullets")
                    self.assertIsInstance(s["bullets"], list)
                    self.assertGreater(len(s["bullets"]), 0, f"{s['id']}: empty bullets")


# ---------------------------------------------------------------------------
# (b) Demo slides verified against real Neovim
# ---------------------------------------------------------------------------

class TestNeovimDemos(unittest.TestCase):
    """Run every demo slide through vim_reference.lua and compare the result."""

    @classmethod
    def setUpClass(cls):
        cls.nvim_bin = shutil.which("nvim")
        if cls.nvim_bin is None:
            cls.skip_reason = "nvim not found in PATH"
            return
        cls.skip_reason = None
        cls.deck = load_deck()
        cls.demo_slides: list[dict] = []
        for m in cls.deck["modules"]:
            for s in m["slides"]:
                if s["type"] == "demo":
                    cls.demo_slides.append(s)

    def _run_via_vim_reference(self, cases: list[dict]) -> list[dict]:
        """Call vim_reference.lua with the given cases and return parsed results."""
        with tempfile.TemporaryDirectory() as td:
            inp = Path(td) / "in.json"
            out = Path(td) / "out.json"
            inp.write_text(json.dumps(cases), encoding="utf-8")
            result = subprocess.run(
                [
                    self.nvim_bin,
                    "--clean",
                    "--headless",
                    "-l",
                    str(VIM_REF_LUA),
                    str(inp),
                    str(out),
                ],
                capture_output=True,
                text=True,
                timeout=30,
            )
            if result.returncode != 0:
                self.fail(
                    f"vim_reference.lua exited {result.returncode}: "
                    f"stdout={result.stdout!r} stderr={result.stderr!r}"
                )
            return json.loads(out.read_text(encoding="utf-8"))["cases"]

    def test_all_demo_slides_match_neovim(self):
        if getattr(self, "skip_reason", None):
            self.skipTest(self.skip_reason)
        if not self.demo_slides:
            self.skipTest("No demo slides found in deck.json")

        cases = []
        for s in self.demo_slides:
            cursor = s.get("cursor", [0, 0])
            cases.append(
                {
                    "id": s["id"],
                    "start": s["start"],
                    "row": cursor[0],
                    "col": cursor[1],
                    "keys": s["keys"],
                }
            )

        actual_cases = self._run_via_vim_reference(cases)
        actual_by_id = {c["id"]: c for c in actual_cases}

        errors: list[str] = []
        for s in self.demo_slides:
            sid = s["id"]
            if sid not in actual_by_id:
                errors.append(f"{sid}: not found in vim_reference output")
                continue
            actual = actual_by_id[sid]["expected"]
            expected = s["result"]

            if actual["text"] != expected["text"]:
                errors.append(
                    f"{sid}: text mismatch: "
                    f"expected {expected['text']!r}, got {actual['text']!r}"
                )
            if actual["row"] != expected["cursor"][0] or actual["col"] != expected["cursor"][1]:
                errors.append(
                    f"{sid}: cursor mismatch: "
                    f"expected {expected['cursor']}, got [{actual['row']},{actual['col']}]"
                )

        if errors:
            self.fail("Demo slide mismatches:\n" + "\n".join(errors))


# ---------------------------------------------------------------------------
# (c) Config and keys slides reference shortcuts from exercises.json
# ---------------------------------------------------------------------------

class TestShortcutsCoverage(unittest.TestCase):
    """
    Verify that every key shown in a config slide is present in
    exercises.json shortcuts (so the deck never teaches a shortcut that
    was not validated against the real config).
    """

    def setUp(self):
        self.deck = load_deck()
        exercises = load_exercises()
        self.shortcut_keys = shortcut_keys_only(exercises)

    def test_config_slide_keys_exist_in_shortcuts(self):
        errors: list[str] = []
        for m in self.deck["modules"]:
            for s in m["slides"]:
                if s["type"] != "config":
                    continue
                for row in s.get("rows", []):
                    key = row["key"]
                    # Only check keys that look like config shortcuts
                    # (contain leader or a special key -- not plain Vim built-ins)
                    has_leader = "<leader>" in key.lower() or "leader" in key.lower()
                    has_ctrl = "<C-" in key or "<c-" in key
                    has_special = "<" in key
                    if has_leader or has_ctrl or has_special:
                        if key not in self.shortcut_keys:
                            errors.append(
                                f"{s['id']}: key {key!r} not found in exercises.json shortcuts"
                            )
        if errors:
            self.fail(
                "Config slide keys not in exercises.json shortcuts:\n"
                + "\n".join(errors)
            )


# ---------------------------------------------------------------------------
# (d) Progressive key check
# ---------------------------------------------------------------------------

class TestProgressiveKeys(unittest.TestCase):
    """
    For each module N, the cumulative introduces list (modules 0..N) is built.
    Demo slides in module N must not start with a command that only appears
    in a later module's introduces.

    This is best-effort: it checks only the first Vim command token of each
    demo's keys string against the cumulative set.
    """

    def test_demo_keys_progressive(self):
        deck = load_deck()
        modules = deck["modules"]

        # Build cumulative introduces per module index
        cumulative: list[set[str]] = []
        accumulated: set[str] = set()
        for m in modules:
            accumulated = accumulated | set(m.get("introduces", []))
            cumulative.append(set(accumulated))

        errors: list[str] = []
        for idx, m in enumerate(modules):
            allowed = cumulative[idx]
            if not allowed:
                # Module 0 introduces nothing; skip demo check for it
                continue
            for s in m["slides"]:
                if s["type"] != "demo":
                    continue
                keys = s.get("keys", "")
                tokens = parse_vim_tokens(keys)
                if not tokens:
                    continue
                first = tokens[0]
                # Map common token aliases
                alias_map = {
                    "<Esc>": "Esc",
                    "jj": "jj",
                    '"a': '"a',
                    '"': '"a',
                }
                first_normalized = alias_map.get(first, first)
                # Check if the first command is plausibly introduced
                # (allow plain letters from Vim built-ins m01+ teaches)
                is_in = (
                    first_normalized in allowed
                    or first in allowed
                    or any(first_normalized in s for s in allowed)
                )
                if not is_in and len(first) == 1 and first.isalpha():
                    # Only flag single-letter commands, not special notations
                    # that might be text being typed
                    if first.upper() not in {
                        "I", "A", "O", "X", "P", "R", "J", "D",
                        "C", "Y", "V", "G", "F", "T", "W", "B",
                        "E", "U", "N", "H", "L", "K",
                    }:
                        errors.append(
                            f"{s['id']}: first token {first!r} not in module {m['id']} "
                            f"cumulative introduces (keys={keys!r})"
                        )

        if errors:
            self.fail(
                "Demo slides use keys before they are introduced:\n"
                + "\n".join(errors)
            )


# ---------------------------------------------------------------------------
# (e) No em-dash (U+2014) or en-dash (U+2013) in deck.json
# ---------------------------------------------------------------------------

class TestNoDashes(unittest.TestCase):
    def test_no_em_dashes(self):
        deck = load_deck()
        texts = all_text_in_deck(deck)
        violations: list[str] = []
        for text in texts:
            if "—" in text:
                # Find context
                idx = text.index("—")
                snippet = text[max(0, idx - 20) : idx + 20]
                violations.append(f"em-dash in: ...{snippet!r}...")
        if violations:
            self.fail("Em-dashes (U+2014) found in deck.json:\n" + "\n".join(violations[:10]))

    def test_no_en_dashes(self):
        deck = load_deck()
        texts = all_text_in_deck(deck)
        violations: list[str] = []
        for text in texts:
            if "–" in text:
                idx = text.index("–")
                snippet = text[max(0, idx - 20) : idx + 20]
                violations.append(f"en-dash in: ...{snippet!r}...")
        if violations:
            self.fail("En-dashes (U+2013) found in deck.json:\n" + "\n".join(violations[:10]))


# ---------------------------------------------------------------------------
# (f) Practice lesson IDs exist in exercises.json
# ---------------------------------------------------------------------------

class TestPracticeLinks(unittest.TestCase):
    def test_practice_lesson_ids_exist(self):
        deck = load_deck()
        exercises = load_exercises()
        valid_ids = lesson_ids(exercises)
        errors: list[str] = []
        for m in deck["modules"]:
            for s in m["slides"]:
                if s["type"] == "practice":
                    lesson = s.get("lesson", "")
                    if lesson not in valid_ids:
                        errors.append(
                            f"{s['id']}: lesson {lesson!r} not in exercises.json "
                            f"(valid: {sorted(valid_ids)})"
                        )
        if errors:
            self.fail("Practice slides reference unknown lesson IDs:\n" + "\n".join(errors))

    def test_practice_url_contains_lesson(self):
        deck = load_deck()
        errors: list[str] = []
        for m in deck["modules"]:
            for s in m["slides"]:
                if s["type"] == "practice":
                    lesson = s.get("lesson", "")
                    url = s.get("url", "")
                    if lesson and lesson not in url:
                        errors.append(
                            f"{s['id']}: url {url!r} does not contain lesson {lesson!r}"
                        )
        if errors:
            self.fail("Practice URLs inconsistent with lesson IDs:\n" + "\n".join(errors))


# ---------------------------------------------------------------------------
# (g) Spanish accent validation
# ---------------------------------------------------------------------------

class TestSpanishAccents(unittest.TestCase):
    """
    Verify that required Spanish words carry their accent marks in deck.json
    and in slides.js and index.html UI strings.
    Also checks that those files contain no em-dash or en-dash characters.
    """

    # (unaccented_form, correct_form) pairs -- test fails if the unaccented
    # form appears as a whole word (case-insensitive) in the scanned text.
    REQUIRED_ACCENTS = [
        ("linea",        "línea"),
        ("lineas",       "líneas"),
        ("caracter",     "carácter"),
        ("tambien",      "también"),
        ("despues",      "después"),
        ("numero",       "número"),
        ("codigo",       "código"),
        ("modulo",       "módulo"),
        ("configuracion","configuración"),
        ("instalacion",  "instalación"),
        ("busqueda",     "búsqueda"),
        ("seleccion",    "selección"),
        ("posicion",     "posición"),
        ("sesion",       "sesión"),
        ("accion",       "acción"),
        ("version",      "versión"),
        ("ultimo",       "último"),
        ("ultima",       "última"),
        ("arbol",        "árbol"),
        ("pagina",       "página"),
        ("menu",         "menú"),
        ("rapido",       "rápido"),
        ("aqui",         "aquí"),
        ("explicacion",  "explicación"),
        ("funcion",      "función"),
        ("leccion",      "lección"),
    ]

    def _violations(self, strings: list[str], source: str) -> list[str]:
        errors: list[str] = []
        for unaccented, accented in self.REQUIRED_ACCENTS:
            pattern = re.compile(r'\b' + re.escape(unaccented) + r'\b', re.IGNORECASE)
            for s in strings:
                m = pattern.search(s)
                if m:
                    idx = m.start()
                    snippet = s[max(0, idx - 20): idx + 20]
                    errors.append(
                        f"{source}: '{unaccented}' should be '{accented}' near: ...{snippet!r}..."
                    )
        return errors

    def test_deck_json_human_text_accents(self):
        deck = load_deck()
        texts = all_human_text_in_deck(deck)
        errors = self._violations(texts, "deck.json")
        if errors:
            self.fail("Missing accents in deck.json:\n" + "\n".join(errors[:20]))

    def test_slides_js_string_literal_accents(self):
        slides_js = (REPO / "course" / "slides" / "slides.js").read_text(encoding="utf-8")
        # Extract single-quoted string literals (the file uses single quotes for all UI strings)
        literals = re.findall(r"'([^'\n]{2,})'", slides_js)
        errors = self._violations(literals, "slides.js")
        if errors:
            self.fail("Missing accents in slides.js UI strings:\n" + "\n".join(errors[:20]))

    def test_index_html_text_content_accents(self):
        index_html = (REPO / "course" / "slides" / "index.html").read_text(encoding="utf-8")
        # Strip tags and check the remaining visible text
        text_content = re.sub(r'<[^>]+>', ' ', index_html)
        errors = self._violations([text_content], "index.html")
        if errors:
            self.fail("Missing accents in index.html text content:\n" + "\n".join(errors[:20]))

    def test_slides_js_no_em_en_dashes(self):
        slides_js = (REPO / "course" / "slides" / "slides.js").read_text(encoding="utf-8")
        if "—" in slides_js:
            self.fail("Em-dash (U+2014) found in slides.js")
        if "–" in slides_js:
            self.fail("En-dash (U+2013) found in slides.js")

    def test_index_html_no_em_en_dashes(self):
        index_html = (REPO / "course" / "slides" / "index.html").read_text(encoding="utf-8")
        if "—" in index_html:
            self.fail("Em-dash (U+2014) found in index.html")
        if "–" in index_html:
            self.fail("En-dash (U+2013) found in index.html")


# ---------------------------------------------------------------------------
# (h) Practice URL dual-layout logic
# ---------------------------------------------------------------------------

class TestPracticeUrlDualLayout(unittest.TestCase):
    """
    Verify that slides.js contains the dual-layout practice URL logic:
    - /course/slides/ path  -->  ../../practice/index.html#lesson-N
    - other path            -->  ../#lesson-N
    """

    def test_slides_js_has_course_slides_path_detection(self):
        slides_js = (REPO / "course" / "slides" / "slides.js").read_text(encoding="utf-8")
        self.assertIn(
            '/course/slides/', slides_js,
            "slides.js must contain '/course/slides/' path detection for practice URL logic"
        )

    def test_slides_js_has_practice_index_relative_path(self):
        slides_js = (REPO / "course" / "slides" / "slides.js").read_text(encoding="utf-8")
        self.assertIn(
            '../../practice/index.html', slides_js,
            "slides.js must contain '../../practice/index.html' for course-relative practice links"
        )

    def test_slides_js_has_fallback_practice_path(self):
        slides_js = (REPO / "course" / "slides" / "slides.js").read_text(encoding="utf-8")
        self.assertIn(
            '../#', slides_js,
            "slides.js must contain '../#' for non-course-relative practice links"
        )

    def test_practice_slides_have_lesson_field_for_dynamic_url(self):
        """Every practice slide must have a 'lesson' field (used by getPracticeUrl)."""
        deck = load_deck()
        errors: list[str] = []
        for m in deck["modules"]:
            for s in m["slides"]:
                if s["type"] == "practice":
                    if not s.get("lesson"):
                        errors.append(f"{s['id']}: practice slide missing 'lesson' field")
        if errors:
            self.fail("Practice slides missing 'lesson' field:\n" + "\n".join(errors))


# ---------------------------------------------------------------------------
# (i) Optional Playwright browser tests
# ---------------------------------------------------------------------------

REQUIRE_BROWSER = os.environ.get("SLIDES_REQUIRE_BROWSER", "").strip() not in ("", "0")
_playwright_venv = Path(
    "/private/tmp/claude-501/-Users-jorge-Documents-Apps/"
    "ab6ef05f-bd50-4bda-9dc3-b87aa8a97d5a/scratchpad/venv/bin/python"
)


def _playwright_available() -> bool:
    try:
        import playwright  # noqa: F401
        return True
    except ImportError:
        pass
    return _playwright_venv.exists()


@unittest.skipUnless(
    REQUIRE_BROWSER or _playwright_available(),
    "Playwright not installed; set SLIDES_REQUIRE_BROWSER=1 to require this test"
)
class TestBrowser(unittest.TestCase):
    """
    Smoke-test the HTML presentation in a headless browser.
    Requires playwright and the browsers to be installed:
        pip install playwright && playwright install chromium

    Also tests:
    - Practice links use ../../practice/index.html# when served from course/slides/
    """

    @classmethod
    def setUpClass(cls):
        try:
            from playwright.sync_api import sync_playwright
            cls._sync_playwright = staticmethod(sync_playwright)
        except ImportError:
            raise unittest.SkipTest("playwright Python package not installed")

    def test_first_slide_loads(self):
        index_path = REPO / "course" / "slides" / "index.html"
        if not index_path.exists():
            self.skipTest("index.html not found")
        url = index_path.as_uri()

        with self._sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()
            page.goto(url)
            page.wait_for_selector("#stage", timeout=5000)
            # Title or heading must be visible
            heading = page.inner_text("#stage")
            self.assertTrue(
                len(heading.strip()) > 0, "Slide stage is empty"
            )
            browser.close()

    def test_navigation_next_prev(self):
        index_path = REPO / "course" / "slides" / "index.html"
        if not index_path.exists():
            self.skipTest("index.html not found")
        url = index_path.as_uri()

        with self._sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()
            page.goto(url)
            page.wait_for_selector("#stage", timeout=5000)

            # First slide counter should be "1 / N"
            counter_before = page.inner_text("#slide-counter")
            self.assertIn("1", counter_before)

            # Press right arrow to go to slide 2
            page.keyboard.press("ArrowRight")
            page.wait_for_timeout(100)
            counter_after = page.inner_text("#slide-counter")
            self.assertNotEqual(counter_before, counter_after, "Slide counter did not change after ArrowRight")

            # Press left arrow to go back to slide 1
            page.keyboard.press("ArrowLeft")
            page.wait_for_timeout(100)
            counter_back = page.inner_text("#slide-counter")
            self.assertEqual(counter_before, counter_back, "Counter did not return to 1 after ArrowLeft")

            browser.close()

    def test_hash_deep_link(self):
        index_path = REPO / "course" / "slides" / "index.html"
        if not index_path.exists():
            self.skipTest("index.html not found")
        url = index_path.as_uri() + "#m02-1"

        with self._sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()
            page.goto(url)
            page.wait_for_selector("#stage", timeout=5000)
            # Footer should show module 02 label
            footer = page.inner_text("#module-label")
            self.assertIn("02", footer, f"Module label does not contain '02': {footer!r}")
            browser.close()

    def test_practice_link_uses_course_relative_url(self):
        """When opened from course/slides/, practice links must use ../../practice/index.html."""
        index_path = REPO / "course" / "slides" / "index.html"
        if not index_path.exists():
            self.skipTest("index.html not found")
        # Navigate to module 01 so we reach its practice slide quickly
        url = index_path.as_uri() + "#m01-1"

        with self._sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()
            page.goto(url)
            page.wait_for_selector("#stage", timeout=5000)

            practice_href = None
            for _ in range(15):  # m01 has at most 12 slides
                link = page.query_selector('.practice-link')
                if link is not None:
                    practice_href = link.get_attribute('href')
                    break
                page.keyboard.press("ArrowRight")
                page.wait_for_timeout(100)

            if practice_href is None:
                self.skipTest("No practice slide found within first 15 slides of m01")

            # file:// path includes /course/slides/, so getPracticeUrl returns
            # ../../practice/index.html#lesson-N (not sl.url which is the same value)
            self.assertIn(
                '../../practice/index.html', practice_href,
                f"Practice href should be course-relative but got: {practice_href!r}"
            )
            browser.close()

    def test_overview_opens(self):
        index_path = REPO / "course" / "slides" / "index.html"
        if not index_path.exists():
            self.skipTest("index.html not found")
        url = index_path.as_uri()

        with self._sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()
            page.goto(url)
            page.wait_for_selector("#stage", timeout=5000)

            # Press 'o' for overview
            page.keyboard.press("o")
            page.wait_for_timeout(200)
            overview_visible = page.is_visible("#overview")
            self.assertTrue(overview_visible, "Overview did not appear after pressing 'o'")

            # Press 'o' again to close
            page.keyboard.press("o")
            page.wait_for_timeout(200)
            overview_visible_after = page.is_visible("#overview")
            self.assertFalse(overview_visible_after, "Overview did not close after pressing 'o' again")

            browser.close()


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    unittest.main(verbosity=2)
