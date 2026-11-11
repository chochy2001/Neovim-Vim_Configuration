"""Test the GitHub Pages teaser site assembled by scripts/build_pages_site.py.

Sections:
  (a) exercises.json trimming: locked lessons have no exercise content
  (b) content identity: lessons 1-2 and modules m00-m02 match repo data
  (c) slides trimming: locked modules have only title + locked slide
  (d) academy_url present, shortcuts unchanged
  (e) deck.js is consistent with the trimmed deck.json
  (f) no vendor/node_modules shipped
  (g) Optional Playwright: locked slide for m03 shows Academy link; no console errors
  (h) Playwright: practice lessons 3+ show the Academy call to action

Run:
  python -m unittest tests/test_pages_teaser.py
  SLIDES_REQUIRE_BROWSER=1 python -m unittest tests/test_pages_teaser.py
"""

import http.server
import json
import os
import socketserver
import subprocess
import sys
import tempfile
import threading
import time
import unittest
from pathlib import Path

REPO = Path(__file__).resolve().parent.parent
ACADEMY_URL = "https://academy.capdesis.com/cursos/vim-mejora-velocidad-codificar"
FREE_LESSONS = 2       # lesson-1 and lesson-2 are free (1-indexed id suffix)
FREE_MODULES_MAX = 3   # m00, m01, m02 (number 0, 1, 2) are free

REQUIRE_BROWSER = os.environ.get("SLIDES_REQUIRE_BROWSER", "").strip() not in ("", "0")

_VENV_PYTHON = Path(
    "/private/tmp/claude-501/-Users-jorge-Documents-Apps/"
    "ab6ef05f-bd50-4bda-9dc3-b87aa8a97d5a/scratchpad/venv/bin/python"
)


def _playwright_available() -> bool:
    try:
        import playwright  # noqa: F401
        return True
    except ImportError:
        pass
    return _VENV_PYTHON.exists()



def _build_site(out_dir: Path) -> None:
    result = subprocess.run(
        [
            sys.executable,
            str(REPO / "scripts" / "build_pages_site.py"),
            "--out",
            str(out_dir),
        ],
        capture_output=True,
        text=True,
    )
    if result.returncode != 0:
        raise RuntimeError(
            "build_pages_site.py failed:\n" + result.stdout + result.stderr
        )


def _start_http_server(root: Path):
    """Start a background HTTP server rooted at root; return (server, port)."""

    class _Handler(http.server.SimpleHTTPRequestHandler):
        def __init__(self, *args, **kwargs):
            super().__init__(*args, directory=str(root), **kwargs)

        def log_message(self, fmt, *args):  # silence output
            pass

    server = socketserver.TCPServer(("127.0.0.1", 0), _Handler)
    port = server.server_address[1]
    t = threading.Thread(target=server.serve_forever, daemon=True)
    t.start()
    time.sleep(0.1)
    return server, port


# ---------------------------------------------------------------------------
# Module-level setup: build _site once and start one HTTP server.
# ---------------------------------------------------------------------------

_tmpdir = None
_site: Path = None
_http_server = None
_http_port: int = None


def setUpModule():
    global _tmpdir, _site, _http_server, _http_port
    _tmpdir = tempfile.TemporaryDirectory()
    _site = Path(_tmpdir.name)
    _build_site(_site)
    if REQUIRE_BROWSER or _playwright_available():
        _http_server, _http_port = _start_http_server(_site)


def tearDownModule():
    global _tmpdir, _http_server
    if _http_server is not None:
        _http_server.shutdown()
        _http_server.server_close()
        _http_server = None
    if _tmpdir is not None:
        _tmpdir.cleanup()
        _tmpdir = None


# ---------------------------------------------------------------------------
# (a-b-d) exercises.json
# ---------------------------------------------------------------------------

class TestExercisesTrimming(unittest.TestCase):
    def _ex(self) -> dict:
        return json.loads((_site / "exercises.json").read_text(encoding="utf-8"))

    def _repo_ex(self) -> dict:
        return json.loads((REPO / "practice" / "exercises.json").read_text(encoding="utf-8"))

    def test_academy_url_present(self):
        ex = self._ex()
        self.assertEqual(ACADEMY_URL, ex.get("academy_url"), "academy_url missing or wrong")

    def test_free_lessons_content_identical_to_repo(self):
        repo_lessons = {l["id"]: l for l in self._repo_ex()["lessons"]}
        site_lessons = {l["id"]: l for l in self._ex()["lessons"]}
        for n in range(1, FREE_LESSONS + 1):
            lid = f"lesson-{n}"
            self.assertIn(lid, site_lessons, f"{lid} missing from site exercises.json")
            self.assertEqual(
                repo_lessons[lid], site_lessons[lid],
                f"{lid} differs from repo data",
            )

    def test_locked_lessons_have_no_exercise_content(self):
        for lesson in self._ex()["lessons"]:
            lid = lesson.get("id", "")
            try:
                n = int(lid.split("-")[1])
            except (IndexError, ValueError):
                continue
            if n <= FREE_LESSONS:
                continue
            # Must be marked locked
            self.assertTrue(lesson.get("locked", False), f"{lid} should be marked locked")
            # Must not contain exercise data
            for forbidden in ("exercises", "keys", "start", "goal"):
                self.assertNotIn(
                    forbidden, lesson,
                    f"{lid}: field '{forbidden}' must not appear in locked stub",
                )

    def test_locked_lessons_have_correct_exercise_count(self):
        repo_lessons = {l["id"]: l for l in self._repo_ex()["lessons"]}
        for lesson in self._ex()["lessons"]:
            if not lesson.get("locked"):
                continue
            lid = lesson["id"]
            self.assertIn("exercise_count", lesson, f"{lid}: locked stub missing exercise_count")
            expected = len(repo_lessons[lid].get("exercises", []))
            self.assertEqual(
                expected, lesson["exercise_count"],
                f"{lid}: exercise_count {lesson['exercise_count']} != repo {expected}",
            )

    def test_shortcuts_unchanged(self):
        self.assertEqual(
            self._repo_ex()["shortcuts"],
            self._ex()["shortcuts"],
            "shortcuts differ from repo data",
        )

    def test_all_lessons_present(self):
        repo_ids = {l["id"] for l in self._repo_ex()["lessons"]}
        site_ids = {l["id"] for l in self._ex()["lessons"]}
        self.assertEqual(repo_ids, site_ids, "lesson IDs differ")


# ---------------------------------------------------------------------------
# (b-c) slides deck.json
# ---------------------------------------------------------------------------

class TestSlidesTrimming(unittest.TestCase):
    def _deck(self) -> dict:
        return json.loads((_site / "slides" / "deck.json").read_text(encoding="utf-8"))

    def _repo_deck(self) -> dict:
        return json.loads((REPO / "course" / "slides" / "deck.json").read_text(encoding="utf-8"))

    def test_all_14_modules_present(self):
        ids = {m["id"] for m in self._deck()["modules"]}
        for n in range(14):
            self.assertIn(f"m{n:02d}", ids, f"m{n:02d} missing from site deck.json")

    def test_free_modules_content_identical_to_repo(self):
        repo_mods = {m["id"]: m for m in self._repo_deck()["modules"]}
        site_mods = {m["id"]: m for m in self._deck()["modules"]}
        for n in range(FREE_MODULES_MAX):
            mid = f"m{n:02d}"
            self.assertIn(mid, site_mods, f"{mid} missing from site deck.json")
            self.assertEqual(
                repo_mods[mid], site_mods[mid],
                f"{mid} differs from repo data",
            )

    def test_locked_modules_have_only_title_and_locked_slide(self):
        body_types = {"concept", "keys", "demo", "practice", "config", "summary"}
        for mod in self._deck()["modules"]:
            n = int(mod["number"])
            if n < FREE_MODULES_MAX:
                continue
            slides = mod["slides"]
            self.assertGreaterEqual(len(slides), 1, f"{mod['id']}: no slides")
            self.assertLessEqual(len(slides), 2, f"{mod['id']}: more than 2 slides (title + locked)")
            types = [s["type"] for s in slides]
            self.assertIn("title", types, f"{mod['id']}: title slide missing")
            self.assertIn("locked", types, f"{mod['id']}: locked slide missing")
            leaked = [t for t in types if t in body_types]
            self.assertEqual(
                [], leaked,
                f"{mod['id']}: body slide types leaked into teaser: {leaked}",
            )

    def test_locked_slides_have_academy_url(self):
        for mod in self._deck()["modules"]:
            n = int(mod["number"])
            if n < FREE_MODULES_MAX:
                continue
            for s in mod["slides"]:
                if s["type"] == "locked":
                    self.assertEqual(
                        ACADEMY_URL, s.get("academy_url"),
                        f"{s['id']}: academy_url wrong or missing",
                    )


# ---------------------------------------------------------------------------
# (e) deck.js consistency
# ---------------------------------------------------------------------------

class TestDeckJs(unittest.TestCase):
    def test_deck_js_consistent_with_deck_json(self):
        deck_json = json.loads(
            (_site / "slides" / "deck.json").read_text(encoding="utf-8")
        )
        deck_js_text = (_site / "slides" / "deck.js").read_text(encoding="utf-8")
        self.assertIn("window.DECK = ", deck_js_text, "deck.js missing window.DECK assignment")
        prefix = "window.DECK = "
        start = deck_js_text.index(prefix) + len(prefix)
        json_str = deck_js_text[start:].rstrip()
        if json_str.endswith(";"):
            json_str = json_str[:-1]
        try:
            deck_from_js = json.loads(json_str)
        except json.JSONDecodeError as exc:
            self.fail(f"deck.js JSON parse error: {exc}")
        self.assertEqual(deck_json, deck_from_js, "deck.js does not match deck.json")


# ---------------------------------------------------------------------------
# (f) no node_modules
# ---------------------------------------------------------------------------

class TestNoNodeModules(unittest.TestCase):
    def test_no_node_modules_in_site(self):
        for nm in _site.rglob("node_modules"):
            self.fail(f"node_modules found in _site at {nm}")


# ---------------------------------------------------------------------------
# (g-h) Optional Playwright browser tests
# ---------------------------------------------------------------------------

_HAVE_BROWSER = REQUIRE_BROWSER or _playwright_available()


@unittest.skipUnless(
    _HAVE_BROWSER,
    "Playwright not available; set SLIDES_REQUIRE_BROWSER=1 to require this test",
)
class TestBrowser(unittest.TestCase):
    """Browser smoke tests for the teaser site."""

    @classmethod
    def setUpClass(cls):
        try:
            from playwright.sync_api import sync_playwright
            cls._sync_playwright = staticmethod(sync_playwright)
        except ImportError:
            raise unittest.SkipTest("playwright Python package not installed")

    def _base(self) -> str:
        return f"http://127.0.0.1:{_http_port}"

    # (g) Slides: locked slide for m03 shows Academy link; no console errors.

    def test_locked_slide_m03_shows_academy_link(self):
        with self._sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()
            console_errors = []
            page.on(
                "console",
                lambda msg: console_errors.append(msg.text) if msg.type == "error" else None,
            )
            # Title slide for m03 is slide 1; advance to get the locked slide.
            page.goto(self._base() + "/slides/#m03-1", wait_until="networkidle")
            page.wait_for_selector("#stage", timeout=5000)
            page.keyboard.press("ArrowRight")
            page.wait_for_timeout(200)

            locked = page.query_selector(".slide-locked")
            self.assertIsNotNone(locked, "No .slide-locked element on m03 locked slide")

            link = page.query_selector(".locked-academy-link")
            self.assertIsNotNone(link, "No .locked-academy-link element on m03 locked slide")
            href = link.get_attribute("href") if link else ""
            self.assertEqual(ACADEMY_URL, href, f"Academy link href wrong: {href!r}")

            self.assertEqual([], console_errors, f"Console errors on slides page: {console_errors}")
            browser.close()

    def test_free_module_m02_still_navigates(self):
        with self._sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()
            console_errors = []
            page.on(
                "console",
                lambda msg: console_errors.append(msg.text) if msg.type == "error" else None,
            )
            page.goto(self._base() + "/slides/#m02-1", wait_until="networkidle")
            page.wait_for_selector("#stage", timeout=5000)
            stage_text = page.inner_text("#stage")
            self.assertTrue(len(stage_text.strip()) > 0, "Module m02 slide stage is empty")
            self.assertEqual([], console_errors, f"Console errors on m02 slide: {console_errors}")
            browser.close()

    # (h) Practice: the published teaser locks lessons 3+ behind an Academy CTA.

    def test_practice_locked_ui(self):
        """Lessons 1-2 stay playable; lesson 3 shows the Academy call to action."""
        with self._sync_playwright() as p:
            browser = p.chromium.launch(headless=True)
            page = browser.new_page()
            errors = []
            page.on("pageerror", lambda e: errors.append(str(e)))
            page.goto(self._base() + "/#lesson-3", wait_until="networkidle")
            page.wait_for_selector(".locked-lesson-cta", timeout=10_000)
            locked_titles = page.query_selector_all(".sidebar-lesson-title.locked")
            self.assertGreaterEqual(len(locked_titles), 4, "lessons 3-6 should be locked in the sidebar")
            link = page.query_selector(f'.locked-lesson-cta a[href="{ACADEMY_URL}"]')
            self.assertIsNotNone(link, "the CTA must link to the Academy course")
            self.assertIn("Capdesis Academy", page.inner_text(".locked-lesson-cta"))
            page.goto(self._base() + "/#lesson-1", wait_until="networkidle")
            page.wait_for_selector(".cm-content", timeout=10_000)
            self.assertIsNone(page.query_selector(".locked-lesson-cta"), "lesson 1 must stay playable")
            self.assertEqual([], errors)
            browser.close()


# ---------------------------------------------------------------------------
# Entry point
# ---------------------------------------------------------------------------

if __name__ == "__main__":
    unittest.main(verbosity=2)
