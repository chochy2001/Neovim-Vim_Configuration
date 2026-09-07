"""Build COURSE.pdf from COURSE.md. pip install -r requirements-docs.txt first."""

from pathlib import Path
import hashlib
import html
import re
from markdown_it import MarkdownIt
from reportlab.lib import colors
from reportlab.lib.enums import TA_LEFT
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import ParagraphStyle
from reportlab.pdfbase import pdfmetrics
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.platypus import (
    SimpleDocTemplate,
    Paragraph,
    Spacer,
    Table,
    TableStyle,
    PageBreak,
)

ROOT = Path(__file__).resolve().parents[1]
SOURCE = ROOT / "COURSE.md"
PDF = ROOT / "COURSE.pdf"
FONT_OPTIONS = [
    (Path("C:/Windows/Fonts"), ("segoeui.ttf", "segoeuib.ttf", "consola.ttf")),
    (
        Path("/usr/share/fonts/truetype/dejavu"),
        ("DejaVuSans.ttf", "DejaVuSans-Bold.ttf", "DejaVuSansMono.ttf"),
    ),
    (Path("/Library/Fonts"), ("Arial.ttf", "Arial Bold.ttf", "Courier New.ttf")),
]
for directory, names in FONT_OPTIONS:
    if all((directory / name).is_file() for name in names):
        for family, name in zip(("Body", "BodyBold", "Code"), names):
            pdfmetrics.registerFont(TTFont(family, str(directory / name)))
        break
else:
    raise RuntimeError(
        "Install Segoe UI/Consolas (Windows) or DejaVu fonts (Linux) before building."
    )
pdfmetrics.registerFontFamily(
    "Body", normal="Body", bold="BodyBold", italic="Body", boldItalic="BodyBold"
)
styles = {
    "p": ParagraphStyle("p", fontName="Body", fontSize=10, leading=15, spaceAfter=8),
    "h1": ParagraphStyle(
        "h1",
        fontName="BodyBold",
        fontSize=22,
        leading=28,
        spaceBefore=12,
        spaceAfter=16,
        keepWithNext=True,
    ),
    "h2": ParagraphStyle(
        "h2",
        fontName="BodyBold",
        fontSize=15,
        leading=20,
        spaceBefore=12,
        spaceAfter=10,
        keepWithNext=True,
    ),
    "h3": ParagraphStyle(
        "h3",
        fontName="BodyBold",
        fontSize=12,
        leading=17,
        spaceBefore=10,
        spaceAfter=8,
        keepWithNext=True,
    ),
    "code": ParagraphStyle(
        "code",
        fontName="Code",
        fontSize=8,
        leading=12,
        backColor=colors.HexColor("#eef2f6"),
        borderPadding=8,
        spaceAfter=9,
    ),
    "cell": ParagraphStyle(
        "cell", fontName="Body", fontSize=8.5, leading=12, alignment=TA_LEFT
    ),
}


def clean(text):
    return (
        text.replace("\u2011", "-")
        .replace("—", "-")
        .replace("–", "-")
        .replace("→", "->")
        .replace("←", "<-")
    )


def inline(token):
    out = []
    for t in token.children or []:
        if t.type == "text":
            out.append(html.escape(clean(t.content)))
        elif t.type == "code_inline":
            out.append('<font name="Code">' + html.escape(clean(t.content)) + "</font>")
        elif t.type in ("softbreak", "hardbreak"):
            out.append("<br/>" if t.type == "hardbreak" else " ")
        elif t.type == "strong_open":
            out.append("<b>")
        elif t.type == "strong_close":
            out.append("</b>")
        elif t.type == "em_open":
            out.append("<i>")
        elif t.type == "em_close":
            out.append("</i>")
        elif t.type == "link_open":
            url = t.attrGet("href")
            if not re.match(r"https?://", url):
                url = (
                    "https://github.com/chochy2001/Neovim-Vim_Configuration/blob/main/"
                    + url
                )
            out.append(
                '<link href="' + html.escape(url, quote=True) + '" color="#145a86">'
            )
        elif t.type == "link_close":
            out.append("</link>")
        else:
            raise ValueError("Unhandled inline Markdown token: " + t.type)
    return "".join(out)


source = SOURCE.read_text(encoding="utf-8")
tokens = MarkdownIt("commonmark").enable("table").parse(source)
story = []
width = A4[0] - 96
i, heading_count = 0, 0
lists, list_marker = [], ""
while i < len(tokens):
    token = tokens[i]
    if token.type == "heading_open":
        title = tokens[i + 1]
        level = token.tag
        if level == "h1" and heading_count > 0:
            story.append(PageBreak())
        if level == "h1":
            heading_count += 1
        story.append(Paragraph(inline(title), styles.get(level, styles["h3"])))
        i += 3
        continue
    if token.type == "paragraph_open":
        body = inline(tokens[i + 1])
        story.append(Paragraph(list_marker + body, styles["p"]))
        list_marker = ""
        i += 3
        continue
    if token.type in ("fence", "code_block"):
        # Keep code lines together with normal leading and preserve indentation.
        lines = [
            html.escape(line).replace(" ", "&#160;") or "&#160;"
            for line in clean(token.content).rstrip("\n").splitlines()
        ]
        story.append(Paragraph("<br/>".join(lines), styles["code"]))
        story.append(Spacer(1, 5))
    elif token.type == "table_open":
        rows, row = [], []
        i += 1
        while tokens[i].type != "table_close":
            if tokens[i].type == "tr_open":
                row = []
            elif tokens[i].type == "inline":
                row.append(Paragraph(inline(tokens[i]), styles["cell"]))
            elif tokens[i].type == "tr_close":
                rows.append(row)
            i += 1
        table = Table(
            rows,
            colWidths=[width / len(rows[0])] * len(rows[0]),
            repeatRows=1,
            hAlign="LEFT",
            rowSplitRange=(3, -2) if len(rows) > 4 else None,
        )
        table.setStyle(
            TableStyle(
                [
                    ("BACKGROUND", (0, 0), (-1, 0), colors.HexColor("#e5edf5")),
                    (
                        "ROWBACKGROUNDS",
                        (0, 1),
                        (-1, -1),
                        [colors.white, colors.HexColor("#f7f9fb")],
                    ),
                    ("VALIGN", (0, 0), (-1, -1), "TOP"),
                    ("BOX", (0, 0), (-1, -1), 0.4, colors.HexColor("#ced8e3")),
                    ("INNERGRID", (0, 0), (-1, -1), 0.25, colors.HexColor("#dae2eb")),
                    ("LEFTPADDING", (0, 0), (-1, -1), 7),
                    ("RIGHTPADDING", (0, 0), (-1, -1), 7),
                    ("TOPPADDING", (0, 0), (-1, -1), 6),
                    ("BOTTOMPADDING", (0, 0), (-1, -1), 6),
                ]
            )
        )
        story += [table, Spacer(1, 10)]
    elif token.type in ("bullet_list_open", "ordered_list_open"):
        lists.append(
            {
                "ordered": token.type == "ordered_list_open",
                "next": int(token.attrGet("start") or 1),
            }
        )
    elif token.type in ("bullet_list_close", "ordered_list_close"):
        lists.pop()
    elif token.type == "list_item_open":
        current = lists[-1]
        list_marker = f"{current['next']}. " if current["ordered"] else "• "
        current["next"] += 1
    elif token.type == "hr":
        story.append(Spacer(1, 8))
    elif token.type not in ("list_item_open", "list_item_close"):
        raise ValueError("Unhandled Markdown token: " + token.type)
    i += 1
digest = hashlib.sha256(source.encode("utf-8")).hexdigest()


def footer(canvas, doc):
    canvas.saveState()
    canvas.setFont("Body", 8)
    canvas.setFillColor(colors.HexColor("#526477"))
    canvas.drawString(48, 27, "CAPDESIS | Neovim desde cero")
    canvas.drawRightString(A4[0] - 48, 27, str(doc.page))
    canvas.restoreState()


doc = SimpleDocTemplate(
    str(PDF),
    pagesize=A4,
    rightMargin=48,
    leftMargin=48,
    topMargin=44,
    bottomMargin=46,
    title="Neovim desde cero",
    author="CAPDESIS",
    subject="COURSE.md SHA256:" + digest,
)
doc.build(story, onFirstPage=footer, onLaterPages=footer)
print(f"Built {PDF}; source SHA256 {digest}")
