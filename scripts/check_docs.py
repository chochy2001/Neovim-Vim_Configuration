"""Check local Markdown links and whether COURSE.pdf matches its Markdown source."""

import hashlib
from pathlib import Path
import re
from urllib.parse import unquote
from pypdf import PdfReader

ROOT = Path(__file__).resolve().parents[1]
paths = [
    ROOT / n for n in ("README.md", "COURSE.md", "WORKFLOW.md", "UDEMY.md", "AGENTS.md")
]
paths += list((ROOT / "docs").glob("*.md"))
paths += [ROOT / ".config/nvim/README.md", ROOT / "trainer/README.md"]
for path in paths:
    text = path.read_text(encoding="utf-8")
    for target in re.findall(r"\]\(([^)]+)\)", text):
        target = target.split("#", 1)[0].strip("<>")
        if not target or re.match(r"[a-z]+://", target):
            continue
        assert (path.parent / unquote(target)).exists(), (
            f"{path.relative_to(ROOT)}: broken link {target}"
        )
reader = PdfReader(ROOT / "COURSE.pdf")
digest = hashlib.sha256(
    (ROOT / "COURSE.md").read_text(encoding="utf-8").encode("utf-8")
).hexdigest()
assert reader.metadata.subject == "COURSE.md SHA256:" + digest, (
    "COURSE.pdf is stale; rebuild it"
)
text = "\n".join(page.extract_text() for page in reader.pages)
for word in ("configuración", "Evaluación práctica", "Fuentes y mantenimiento"):
    assert word in text, f"PDF text missing/corrupted: {word}"
assert "\ufffd" not in text, "PDF contains replacement characters"
print(f"PASS local links and current PDF ({len(reader.pages)} pages)")
