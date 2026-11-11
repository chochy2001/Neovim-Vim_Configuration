"""Browser practice page: every exercise must be solvable, and only when solved.

Runs practice/index.html in headless Chromium (python playwright). For EVERY
exercise in practice/exercises.json it checks that the page does not show it
as solved before typing, types the canonical keys into the real editor, and
requires the page to mark it correct (text, cursor and Normal mode must match
what real Neovim produced in scripts/build_practice.py).

Without playwright the browser tests are skipped with a printed reason, unless
PRACTICE_REQUIRE_BROWSER=1 (set in CI), where a missing browser is a failure.

    python -m unittest tests/test_practice.py
"""

import functools
import http.server
import json
import os
import re
import threading
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
PRACTICE = ROOT / "practice"
DATA = json.loads((PRACTICE / "exercises.json").read_text(encoding="utf-8"))
EXERCISES = [ex for lesson in DATA["lessons"] for ex in lesson.get("exercises", [])]

try:
    from playwright.sync_api import sync_playwright

    HAVE_BROWSER = True
except ImportError:
    HAVE_BROWSER = False
REQUIRE_BROWSER = os.environ.get("PRACTICE_REQUIRE_BROWSER") == "1"

# Vim key notation -> Playwright key names.
SPECIAL = {
    "Esc": "Escape",
    "BS": "Backspace",
    "CR": "Enter",
    "Tab": "Tab",
    "Space": " ",
    "lt": "<",
}


def playwright_keys(keys):
    """Split "ciw<Esc>" into Playwright key presses."""
    out = []
    for token in re.findall(r"<[^<>]+>|.", keys):
        if token.startswith("<") and token.endswith(">") and len(token) > 2:
            name = token[1:-1]
            if name in SPECIAL:
                out.append(SPECIAL[name])
            elif re.fullmatch(r"C-.", name):
                out.append("Control+" + name[2])
            else:
                raise ValueError("unknown key notation " + token)
        else:
            out.append(token)
    return out


class ExerciseData(unittest.TestCase):
    def test_every_exercise_expects_normal_mode_and_has_text(self):
        self.assertGreater(len(EXERCISES), 40)
        for ex in EXERCISES:
            self.assertEqual("n", ex["expectedMode"], ex["id"])
            for field in ("titleEs", "titleEn", "hintEs", "hintEn", "keys"):
                self.assertTrue(ex[field].strip(), ex["id"] + " has no " + field)

    def test_no_exercise_starts_already_solved(self):
        for ex in EXERCISES:
            start = (ex["start"], ex["startRow"], ex["startCol"])
            goal = (ex["expectedText"], ex["expectedRow"], ex["expectedCol"])
            if not ex["checkCursor"]:
                start, goal = start[0], goal[0]
            if ex.get("requiresChange"):
                # Undo exercises: same state, but the page demands a change first.
                self.assertIn("u", ex["keys"], ex["id"])
                continue
            self.assertNotEqual(start, goal, ex["id"] + " is solved before typing")

    def test_ids_are_unique_and_exclusions_explained(self):
        ids = [ex["id"] for ex in EXERCISES]
        self.assertEqual(len(ids), len(set(ids)))
        for item in DATA["excluded"]:
            self.assertNotIn(item["id"], ids)
            self.assertTrue(item["reason"].strip())

    def test_no_em_or_en_dashes(self):
        text = (PRACTICE / "exercises.json").read_text(encoding="utf-8")
        for name in ("index.html", "app.js", "style.css"):
            text += (PRACTICE / name).read_text(encoding="utf-8")
        self.assertNotIn("\u2014", text)
        self.assertNotIn("\u2013", text)

    def test_key_notation_is_understood(self):
        for ex in EXERCISES:
            playwright_keys(ex["keys"])


class Quiet(http.server.SimpleHTTPRequestHandler):
    def log_message(self, *args):
        pass


@unittest.skipUnless(
    HAVE_BROWSER or REQUIRE_BROWSER,
    "playwright not installed: browser tests skipped (pip install playwright)",
)
class PracticePage(unittest.TestCase):
    @classmethod
    def setUpClass(cls):
        if not HAVE_BROWSER:
            raise AssertionError("PRACTICE_REQUIRE_BROWSER=1 but playwright is missing")
        handler = functools.partial(Quiet, directory=str(PRACTICE))
        cls.server = http.server.ThreadingHTTPServer(("127.0.0.1", 0), handler)
        threading.Thread(target=cls.server.serve_forever, daemon=True).start()
        cls.url = "http://127.0.0.1:%d/" % cls.server.server_address[1]
        # PRACTICE_URL tests a deployed copy (e.g. GitHub Pages) instead.
        cls.url = os.environ.get("PRACTICE_URL", cls.url)
        cls.pw = sync_playwright().start()
        cls.browser = cls.pw.chromium.launch()

    @classmethod
    def tearDownClass(cls):
        cls.browser.close()
        cls.pw.stop()
        cls.server.shutdown()

    def open_exercise(self, page, ex):
        """Open the lesson of `ex` from the sidebar and focus its editor."""
        page.click('.sidebar-ex-btn[data-ex-id="%s"]' % ex["id"])
        content = page.locator("#cm-%s .cm-content" % ex["id"])
        content.wait_for(timeout=10_000)
        page.wait_for_function(
            "id => !!document.querySelector('#mode-' + id + ' .mode-pill')", arg=ex["id"]
        )
        # Focus without clicking: a click would move the cursor. Then wait for
        # CodeMirror to report focus and for the Vim layer to finish setting up.
        content.evaluate("el => el.focus()")
        page.locator("#cm-%s .cm-editor.cm-focused" % ex["id"]).wait_for(timeout=5_000)
        page.wait_for_timeout(150)

    def solved(self, page, ex):
        return page.locator("#ok-%s" % ex["id"]).is_visible()

    def test_every_exercise_is_solved_by_its_keys_and_not_before(self):
        context = self.browser.new_context()
        page = context.new_page()
        errors, remote_scripts = [], []
        page.on("pageerror", lambda error: errors.append(str(error)))
        page.on(
            "request",
            lambda request: remote_scripts.append(request.url)
            if request.resource_type == "script" and not request.url.startswith(self.url)
            else None,
        )
        page.goto(self.url)
        page.wait_for_selector(".sidebar-ex-btn", timeout=15_000)
        failures = []
        for ex in EXERCISES:
            self.open_exercise(page, ex)
            if self.solved(page, ex):
                failures.append(ex["id"] + ": shown as solved before typing")
                continue
            for key in playwright_keys(ex["keys"]):
                page.keyboard.press(key)
            try:
                page.locator("#ok-%s" % ex["id"]).wait_for(state="visible", timeout=2_000)
            except Exception:
                pos = page.locator("#mode-%s .cursor-pos" % ex["id"]).inner_text()
                failures.append("%s: keys %r not accepted (cursor %s)" % (ex["id"], ex["keys"], pos))
        context.close()
        self.assertEqual([], failures, "\n".join(failures))
        self.assertEqual([], errors, "JavaScript errors while practising")
        # CodeMirror is one local bundle: a CDN mix loaded two copies of
        # @codemirror/state and broke every edit.
        self.assertEqual([], remote_scripts)

    def test_undo_exercises_need_a_real_change(self):
        context = self.browser.new_context()
        page = context.new_page()
        page.goto(self.url)
        page.wait_for_selector(".sidebar-ex-btn", timeout=15_000)
        undo = [ex for ex in EXERCISES if ex.get("requiresChange")]
        self.assertTrue(undo)
        for ex in undo:
            self.open_exercise(page, ex)
            # Moving away and back returns to the start (= goal) without editing.
            for key in ("l", "h", "j", "k"):
                page.keyboard.press(key)
            page.wait_for_timeout(150)
            self.assertFalse(self.solved(page, ex), ex["id"] + " solved without a change")
        context.close()

    def fresh_page(self, **options):
        page = self.browser.new_context(**options).new_page()
        page.goto(self.url)
        page.wait_for_selector(".sidebar-ex-btn", timeout=15_000)
        return page

    def test_every_lesson_opens_from_the_sidebar(self):
        page = self.fresh_page()
        for lesson in DATA["lessons"]:
            page.click('.sidebar-lesson-title[data-lesson-id="%s"]' % lesson["id"])
            heading = page.locator(".main-content .lesson-header h2").inner_text()
            self.assertEqual(lesson["titleEs"], heading)
            cards = page.locator(".main-content .exercise-card").count()
            self.assertEqual(len(lesson.get("exercises", [])), cards, lesson["id"])
            if not cards:
                self.assertGreater(len(page.locator(".main-content").inner_text()), 200, lesson["id"])
        page.context.close()

    def test_cheat_sheet_search_filters_rows(self):
        page = self.fresh_page()
        page.click('.sidebar-lesson-title[data-lesson-id="lesson-8"]')
        rows = page.locator(".shortcut-row")
        total = rows.count()
        self.assertGreater(total, 10)
        page.fill(".cheatsheet-search", "harpoon")
        page.wait_for_timeout(100)
        visible = [r for r in rows.all() if r.is_visible()]
        self.assertTrue(visible)
        self.assertLess(len(visible), total)
        for row in visible:
            self.assertIn("harpoon", row.inner_text().lower())
        page.context.close()

    def test_progress_reset_and_language(self):
        page = self.fresh_page()
        ex = next(e for e in EXERCISES if e["id"] == "kata-x")
        self.open_exercise(page, ex)
        page.keyboard.press("x")
        page.locator("#ok-kata-x").wait_for(state="visible", timeout=2_000)
        page.reload()
        page.wait_for_selector(".sidebar-ex-btn")
        done = page.get_attribute('.sidebar-ex-btn[data-ex-id="kata-x"]', "class")
        self.assertIn("done", done, "progress was not saved")
        # Reset restores the start text and the exercise can be solved again.
        self.open_exercise(page, ex)
        card = page.locator('[data-exercise-id="kata-x"]')
        card.get_by_role("button", name="Reiniciar").click()
        self.assertEqual(ex["start"], page.locator("#cm-kata-x .cm-content").inner_text())
        page.click("#btn-lang")
        self.assertIn("Lesson", page.locator(".sidebar").inner_text())
        self.assertEqual(1, card.get_by_role("button", name="Reset").count())
        page.click("#btn-lang")
        self.assertIn("Lección", page.locator(".sidebar").inner_text())
        page.context.close()

    def test_hash_opens_a_lesson_for_links_from_the_slides(self):
        page = self.browser.new_context().new_page()
        page.goto(self.url + "#lesson-3")
        page.wait_for_selector(".sidebar-ex-btn", timeout=15_000)
        lesson = next(l for l in DATA["lessons"] if l["id"] == "lesson-3")
        self.assertEqual(lesson["titleEs"], page.locator(".main-content .lesson-header h2").inner_text())
        page.evaluate("location.hash = '#lesson-7'")
        page.wait_for_timeout(200)
        self.assertIn("terminal", page.locator(".main-content").inner_text().lower())
        page.context.close()

    def test_lessons_go_from_less_to_more(self):
        # Every lesson is numbered in order and the route ends in the config.
        ids = [l["id"] for l in DATA["lessons"]]
        self.assertEqual(["lesson-%d" % n for n in range(1, len(ids) + 1)], ids)
        self.assertTrue(DATA["lessons"][0]["exercises"], "the route starts practising")
        self.assertIn("configur", DATA["lessons"][-1]["titleEs"].lower())

    def test_language_switch_keeps_editors_working(self):
        page = self.fresh_page()
        page.click("#btn-lang")
        ex = next(e for e in EXERCISES if e["id"] == "kata-x")
        self.open_exercise(page, ex)
        self.assertEqual(ex["titleEn"], page.locator('[data-exercise-id="kata-x"] .ex-title').inner_text())
        page.keyboard.press("x")
        page.locator("#ok-kata-x").wait_for(state="visible", timeout=2_000)
        page.context.close()

    def test_progress_bar_is_shown_and_advances(self):
        page = self.fresh_page()
        fill = page.locator(".progress-bar-wrap .progress-bar-fill")
        self.assertEqual(1, fill.count(), "progress bar missing")
        self.assertEqual("0/%d" % len(EXERCISES), fill.get_attribute("title"))
        self.open_exercise(page, next(e for e in EXERCISES if e["id"] == "kata-x"))
        page.keyboard.press("x")
        page.wait_for_timeout(200)
        self.assertEqual("1/%d" % len(EXERCISES), page.locator(".progress-bar-fill").get_attribute("title"))
        page.context.close()

    def test_pending_operator_is_not_a_solution(self):
        # The cursor already sits on the goal while `d` waits for a motion.
        page = self.fresh_page()
        ex = next(e for e in EXERCISES if e["id"] == "paragraph-next")
        self.open_exercise(page, ex)
        page.keyboard.press("}")
        page.locator("#ok-paragraph-next").wait_for(state="visible", timeout=2_000)
        page.context.close()
        page = self.fresh_page()
        self.open_exercise(page, ex)
        page.keyboard.press("d")
        # A click moves the cursor onto the goal while d still waits.
        page.locator("#cm-paragraph-next .cm-line").nth(ex["expectedRow"]).click()
        page.wait_for_timeout(200)
        self.assertFalse(self.solved(page, ex), "marked solved while d was pending")
        page.context.close()

    def test_phone_width_has_no_horizontal_scroll(self):
        page = self.fresh_page(viewport={"width": 375, "height": 740})
        self.assertFalse(page.evaluate("document.documentElement.scrollWidth > innerWidth"))
        page.click('.sidebar-lesson-title[data-lesson-id="lesson-8"]')
        self.assertFalse(
            page.evaluate("document.documentElement.scrollWidth > innerWidth"),
            "cheat sheet overflows at phone width",
        )
        page.context.close()

    def test_wrong_keys_are_not_accepted(self):
        context = self.browser.new_context()
        page = context.new_page()
        page.goto(self.url)
        page.wait_for_selector(".sidebar-ex-btn", timeout=15_000)
        checked = 0
        for ex in EXERCISES[:10]:
            self.open_exercise(page, ex)
            # Half of the solution never reaches the goal state.
            keys = playwright_keys(ex["keys"])
            for key in keys[: max(1, len(keys) // 2)]:
                page.keyboard.press(key)
            page.keyboard.press("Escape")
            page.wait_for_timeout(150)
            if self.solved(page, ex):
                # Only legitimate if half the keys already produce the goal.
                continue
            checked += 1
        context.close()
        self.assertGreaterEqual(checked, 5, "too few exercises rejected a partial solution")


if __name__ == "__main__":
    unittest.main()
