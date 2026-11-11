"""The course route keeps its promise: what the slides teach is practised.

For modules 01 to 07, every command a slide module introduces (deck.json
`introduces`) must appear in an exercise of the practice page lesson with the
same number or an earlier one, unless it is listed below with the reason the
browser cannot practise it. A new command in the slides therefore needs an
exercise (or an explicit, reviewed exception) before CI passes.

    python -m unittest tests/test_route.py
"""

import importlib.util
import json
import unittest
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]
DECK = json.loads((ROOT / "course/slides/deck.json").read_text(encoding="utf-8"))
PRACTICE = json.loads((ROOT / "practice/exercises.json").read_text(encoding="utf-8"))
_spec = importlib.util.spec_from_file_location("test_practice", ROOT / "tests/test_practice.py")
_practice = importlib.util.module_from_spec(_spec)
_spec.loader.exec_module(_practice)

# Commands the browser page cannot practise, and why. Keep this list short.
NOT_PRACTISED_IN_BROWSER = {
    ":w": "writes a file: practised in Neovim (COURSE.md chapter 1)",
    ":q": "quits the editor",
    ":wq": "writes and quits",
    ":q!": "quits discarding changes",
    "ZZ": "writes and quits",
    "ZQ": "quits discarding changes",
    ":help": "opens Neovim's manual",
    ":Tutor": "opens Neovim's tutorial",
    ":reg": "lists registers in a Neovim window",
    "<C-r>": "the redone text is already reached by the first edit, before u and Ctrl-r, so the page would accept it early",
    "jj": "exists only in this configuration, not in plain Vim",
    "Esc": "used by every insert exercise as <Esc>",
    ":s": "the browser emulator leaves the cursor elsewhere than Neovim (measured)",
    ":%s": "the browser emulator leaves the cursor elsewhere than Neovim (measured)",
    ":e": "opens files: lesson 7 is practised in Neovim",
    ":ls": "lists buffers: lesson 7 is practised in Neovim",
    ":b": "switches buffers: lesson 7 is practised in Neovim",
    ":bd": "closes buffers: lesson 7 is practised in Neovim",
    ":sp": "splits windows: lesson 7 is practised in Neovim",
    ":vsp": "splits windows: lesson 7 is practised in Neovim",
    "Ctrl-w": "moves between windows: lesson 7 is practised in Neovim",
}


def practised(lesson_number):
    """Command tokens and raw key sequences used up to that lesson."""
    tokens, sequences = set(), []
    for lesson in PRACTICE["lessons"]:
        if int(lesson["id"].split("-")[1]) > lesson_number:
            continue
        for ex in lesson.get("exercises", []):
            tokens |= set(_practice.normal_commands(ex["keys"]))
            sequences.append(ex["keys"])
    return tokens, sequences


class Route(unittest.TestCase):
    def test_every_taught_command_is_practised_or_explained(self):
        missing = []
        for module in DECK["modules"]:
            number = int(module["id"][1:])
            if not 1 <= number <= 7:
                continue
            tokens, sequences = practised(number)
            for command in module.get("introduces", []):
                if command in NOT_PRACTISED_IN_BROWSER:
                    continue
                # Multi-key commands (dd, 3gg, "a, qa) are found inside a solution.
                if command in tokens or any(command in keys for keys in sequences):
                    continue
                missing.append("%s %s" % (module["id"], command))
        self.assertEqual([], missing, "taught in the slides but never practised")


if __name__ == "__main__":
    unittest.main()
