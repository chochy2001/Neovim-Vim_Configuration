"""Build practice/exercises.json from katas and reference cases.

Usage:
    python scripts/build_practice.py           # rebuild exercises.json
    python scripts/build_practice.py --check   # fail if exercises.json is stale
"""

import datetime
import json
import os
import re
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# ---------------------------------------------------------------------------
# Case metadata: titles and hints for the 37 reference cases.
# Kata metadata is read from content.dart via export_katas.dart.
# ---------------------------------------------------------------------------

REF_META = {
    "change-word": {
        "titleEs": "Cambia una palabra (cw)",
        "titleEn": "Change a word (cw)",
        "hintEs": "cw borra desde el cursor hasta el inicio de la siguiente palabra y te deja en modo insertar. Escribe el nuevo texto y pulsa Esc.",
        "hintEn": "cw deletes from the cursor to the start of the next word and enters insert mode. Type the new text and press Esc.",
    },
    "change-last-word": {
        "titleEs": "cw sobre la única palabra del buffer",
        "titleEn": "cw on the only word in the buffer",
        "hintEs": "cw también funciona cuando la palabra es la única en el buffer. Borra la palabra y te deja en modo insertar.",
        "hintEn": "cw also works when the word is the only one in the buffer. It deletes the word and enters insert mode.",
    },
    "delete-last-word": {
        "titleEs": "Borra la única palabra con dw",
        "titleEn": "Delete the only word with dw",
        "hintEs": "dw borra desde el cursor hasta el inicio de la siguiente palabra. Cuando no hay más texto, el buffer queda vacío.",
        "hintEn": "dw deletes from the cursor to the start of the next word. When there is no more text, the buffer becomes empty.",
    },
    "change-line": {
        "titleEs": "Cambia la línea completa (cc)",
        "titleEn": "Change the entire line (cc)",
        "hintEs": "cc borra el contenido de la línea actual y te deja en modo insertar. Escribe el nuevo contenido y pulsa Esc.",
        "hintEn": "cc clears the current line's content and enters insert mode. Type the new content and press Esc.",
    },
    "change-tail": {
        "titleEs": "Cambia desde el cursor hasta el final (C)",
        "titleEn": "Change from cursor to end of line (C)",
        "hintEs": "C cambia hasta el final de la línea (equivale a c$). Muévete primero con 5l y luego usa C.",
        "hintEn": "C changes to end of line (same as c$). Move to position first with 5l, then use C.",
    },
    "cancel-operator": {
        "titleEs": "Cancela un operador pendiente con Esc",
        "titleEn": "Cancel a pending operator with Esc",
        "hintEs": "Si pulsas d pero no has dado el movimiento, Esc cancela el operador y vuelves a normal. Luego l avanza un carácter.",
        "hintEn": "If you press d but have not yet given a motion, Esc cancels the operator and returns to normal. Then l advances one character.",
    },
    "cancel-count": {
        "titleEs": "Cancela un conteo con Esc",
        "titleEn": "Cancel a count with Esc",
        "hintEs": "Si empiezas un conteo numerico (3...) y pulsas Esc, el conteo se cancela. Luego j baja una línea.",
        "hintEn": "If you start a numeric count (3...) and press Esc, the count is canceled. Then j moves down one line.",
    },
    "cancel-find": {
        "titleEs": "Cancela una búsqueda de carácter con Esc",
        "titleEn": "Cancel a character search with Esc",
        "hintEs": "f espera el carácter a buscar. Si pulsas Esc, cancelas sin mover el cursor. Luego l avanza un carácter.",
        "hintEn": "f waits for the character to find. Pressing Esc cancels without moving the cursor. Then l advances one character.",
    },
    "insert-undo": {
        "titleEs": "Deshacer una inserción (u)",
        "titleEn": "Undo an insertion (u)",
        "hintEs": "i entra en insertar, escribe XY, Esc vuelve a normal. u deshace toda la inserción como si nunca hubiera pasado.",
        "hintEn": "i enters insert mode, type XY, Esc returns to normal. u undoes the whole insertion as if it never happened.",
    },
    "change-undo": {
        "titleEs": "Deshacer un cambio con cw (u)",
        "titleEn": "Undo a change with cw (u)",
        "hintEs": "cw cambia la palabra, Esc completa el cambio. u deshace el cw entero y el texto vuelve a su estado original.",
        "hintEn": "cw changes the word, Esc completes the change. u undoes the entire cw and the text returns to its original state.",
    },
    "delete-undo-twice": {
        "titleEs": "Deshacer dos borrados (uu)",
        "titleEn": "Undo two deletions (uu)",
        "hintEs": "x borra el carácter bajo el cursor. Dos x borran dos caracteres. Dos u los restauran en orden inverso.",
        "hintEn": "x deletes the character under the cursor. Two x's delete two characters. Two u's restore them in reverse order.",
    },
    "counted-gg": {
        "titleEs": "Ir a la línea 3 con 3gg, luego bajar con j",
        "titleEn": "Go to line 3 with 3gg, then down with j",
        "hintEs": "3gg salta a la línea 3. j baja una línea más. El resultado es la última línea (4).",
        "hintEn": "3gg jumps to line 3. j moves down one more line. The result is the last line (4).",
    },
    "counted-find": {
        "titleEs": "Buscar la segunda X con 2fX",
        "titleEn": "Find the second X with 2fX",
        "hintEs": "2fX busca la segunda aparición de X hacia adelante en la línea. fX buscaria solo la primera.",
        "hintEn": "2fX finds the second occurrence of X forward on the line. fX would find only the first.",
    },
    "find-adjacent": {
        "titleEs": "Ir justo antes de X con tX",
        "titleEn": "Move just before X with tX",
        "hintEs": "t se detiene un carácter ANTES de la X encontrada. Desde col=0, la X más próxima está en col=1; t para en col=0 (el cursor no se mueve porque ya esta justo antes).",
        "hintEn": "t stops one character BEFORE the found X. From col=0, the nearest X is at col=1; t stops at col=0 (cursor does not move because it is already just before it).",
    },
    "repeat-till": {
        "titleEs": "Repetir el movimiento till con ;",
        "titleEn": "Repeat the till motion with ;",
        "hintEs": "tX se detiene antes de la primera X (col=1 en 'abXcdX'). ; repite el movimiento y para antes de la siguiente X (col=4).",
        "hintEn": "tX stops before the first X (col=1 in 'abXcdX'). ; repeats the motion and stops before the next X (col=4).",
    },
    "paragraph-next": {
        "titleEs": "Avanzar al siguiente párrafo con }",
        "titleEn": "Move to the next paragraph with }",
        "hintEs": "} salta a la línea vacía que separa párrafos. Desde la primera línea llega a la línea vacía entre 'two' y 'three'.",
        "hintEn": "} jumps to the empty line that separates paragraphs. From the first line it reaches the empty line between 'two' and 'three'.",
    },
    "paragraph-previous": {
        "titleEs": "G y luego párrafo anterior con {",
        "titleEn": "G then previous paragraph with {",
        "hintEs": "G salta al final del archivo (línea 'three'). { retrocede al párrafo anterior, que es la línea vacía.",
        "hintEn": "G jumps to the end of the file ('three'). { goes back to the previous paragraph, which is the empty line.",
    },
    "new-line-undo": {
        "titleEs": "Abrir línea debajo y deshacer (ou)",
        "titleEn": "Open line below and undo (ou)",
        "hintEs": "o abre una línea nueva debajo y entra en insertar. Esc termina. u deshace: la nueva línea desaparece y el cursor regresa.",
        "hintEn": "o opens a new line below and enters insert mode. Esc ends. u undoes: the new line disappears and the cursor returns.",
    },
    "change-empty": {
        "titleEs": "cc en un buffer vacío",
        "titleEn": "cc on an empty buffer",
        "hintEs": "cc funciona incluso con el buffer vacío: entra en insertar y puedes escribir texto nuevo. Esc vuelve a normal.",
        "hintEn": "cc works even on an empty buffer: it enters insert mode and you can type new text. Esc returns to normal.",
    },
    "inner-last-word": {
        "titleEs": "ciw sobre la única palabra del buffer",
        "titleEn": "ciw on the only word in the buffer",
        "hintEs": "ciw cambia la palabra completa bajo el cursor, aunque sea la única en el buffer. Escribe el nuevo texto y pulsa Esc.",
        "hintEn": "ciw changes the entire word under the cursor, even if it is the only one in the buffer. Type the new text and press Esc.",
    },
    "inner-quotes-at-open": {
        "titleEs": 'ci" desde la comilla de apertura',
        "titleEn": 'ci" from the opening quote',
        "hintEs": '4l mueve el cursor a la comilla de apertura ". ci" desde la propia comilla aun funciona: cambia el texto entre comillas.',
        "hintEn": '4l moves the cursor to the opening " character. ci" from the opening quote still works: it changes the text inside the quotes.',
    },
    "counted-replace": {
        "titleEs": "Reemplazar 3 caracteres con 3rx",
        "titleEn": "Replace 3 characters with 3rx",
        "hintEs": "3r reemplaza los 3 caracteres siguientes con la letra que escribas. No entras en modo insertar: todo ocurre en normal.",
        "hintEn": "3r replaces the next 3 characters with the letter you type. You do not enter insert mode: everything happens in normal mode.",
    },
    "empty-word-motion": {
        "titleEs": "w sobre una línea vacía",
        "titleEn": "w over an empty line",
        "hintEs": "w avanza al inicio de la siguiente 'palabra'. Una línea vacía es una frontera de párrafo y cuenta como destino de w.",
        "hintEn": "w advances to the start of the next 'word'. An empty line is a paragraph boundary and counts as a w destination.",
    },
    "insert-backspace": {
        "titleEs": "Backspace en modo insertar (A<BS>)",
        "titleEn": "Backspace in insert mode (A<BS>)",
        "hintEs": "A entra en insertar al final de la línea. Backspace en modo insertar borra el carácter anterior. Esc vuelve a normal.",
        "hintEn": "A enters insert mode at the end of the line. Backspace in insert mode deletes the previous character. Esc returns to normal.",
    },
    "insert-join-backspace": {
        "titleEs": "Backspace al inicio de línea une las líneas",
        "titleEn": "Backspace at start of line joins lines",
        "hintEs": "j baja a la segunda línea. i entra en insertar al inicio. Backspace al inicio de una línea la une con la anterior.",
        "hintEn": "j moves to the second line. i enters insert mode at the start. Backspace at the start of a line joins it with the previous one.",
    },
    "insert-start": {
        "titleEs": "Insertar antes del primer carácter no-espacio (I)",
        "titleEn": "Insert before the first non-space character (I)",
        "hintEs": "I (mayuscula) entra en insertar al primer carácter no-espacio de la línea. Escribe el nuevo texto y pulsa Esc.",
        "hintEn": "I (uppercase) enters insert mode at the first non-space character of the line. Type the new text and press Esc.",
    },
    "open-above-undo": {
        "titleEs": "Abrir línea encima y deshacer (Ou)",
        "titleEn": "Open line above and undo (Ou)",
        "hintEs": "O abre una nueva línea ENCIMA de la actual y entra en insertar. u deshace: la línea desaparece y el cursor vuelve.",
        "hintEn": "O opens a new line ABOVE the current one and enters insert mode. u undoes: the line disappears and the cursor returns.",
    },
    "yank-inner-and-paste": {
        "titleEs": "Copiar palabra y pegar al final (yiw$p)",
        "titleEn": "Yank word and paste at end (yiw$p)",
        "hintEs": "yiw copia la palabra sin entrar en insertar. $ va al final de la línea. p pega después del cursor.",
        "hintEn": "yiw copies the word without entering insert mode. $ goes to end of line. p pastes after the cursor.",
    },
    "reverse-delete": {
        "titleEs": "Borrar hacia atrás hasta el inicio ($d0)",
        "titleEn": "Delete backward to start of line ($d0)",
        "hintEs": "$ mueve al último carácter de la línea. d0 borra desde el inicio de la línea hasta (sin incluir) la posición actual.",
        "hintEn": "$ moves to the last character of the line. d0 deletes from the start of the line up to (not including) the current position.",
    },
    "unindent-lines": {
        "titleEs": "Desindentar 2 líneas con 2<<",
        "titleEn": "Unindent 2 lines with 2<<",
        "hintEs": "2<< desindenta 2 líneas desde la actual. Cada línea pierde un nivel de indentación (4 espacios con shiftwidth=4).",
        "hintEn": "2<< unindents 2 lines starting from the current one. Each line loses one indent level (4 spaces with shiftwidth=4).",
    },
    "backwards-till-repeat": {
        "titleEs": "TX hacia atrás y repetir con ;",
        "titleEn": "TX backward and repeat with ;",
        "hintEs": "$ va al final. TX busca X hacia atrás y para un carácter después de la X encontrada (hacia la derecha). ; repite el mismo TX.",
        "hintEn": "$ goes to the end. TX searches X backward and stops one character after the found X (toward the right). ; repeats the same TX.",
    },
    "empty-inner-change-undo": {
        "titleEs": "ciw en buffer vacío y deshacer",
        "titleEn": "ciw on empty buffer and undo",
        "hintEs": "ciw sobre un buffer vacío: escribe texto nuevo, Esc vuelve a normal. u deshace y el buffer queda vacío de nuevo.",
        "hintEn": "ciw on an empty buffer: type new text, Esc returns to normal. u undoes and the buffer is empty again.",
    },
    # Duplicates kept only for exclusion record
    "indent-cursor": {
        "titleEs": "Indentar (duplicado de kata-indent)",
        "titleEn": "Indent (duplicate of kata-indent)",
        "hintEs": "",
        "hintEn": "",
    },
    "join-cursor": {
        "titleEs": "Juntar líneas (duplicado de kata-join)",
        "titleEn": "Join lines (duplicate of kata-join)",
        "hintEs": "",
        "hintEn": "",
    },
    # Excluded entries still need stub meta so the excluded list can be built
    "counted-delete": {
        "titleEs": "Borrado complejo 2d3d (excluido)",
        "titleEn": "Complex delete 2d3d (excluded)",
        "hintEs": "",
        "hintEn": "",
    },
    "cross-line-delete-word": {
        "titleEs": "dw cruzando salto de línea (excluido)",
        "titleEn": "dw crossing line boundary (excluded)",
        "hintEs": "",
        "hintEn": "",
    },
    "paste-char-cursor": {
        "titleEs": "Cursor tras pegar en medio de línea (excluido)",
        "titleEn": "Cursor after mid-line paste (excluded)",
        "hintEs": "",
        "hintEn": "",
    },
}

# ---------------------------------------------------------------------------
# Exclusions: cases where CodeMirror vim does not reproduce Neovim exactly.
# ---------------------------------------------------------------------------

EXCLUSIONS = {
    # Measured with tests/test_practice.py: after u, CodeMirror's Vim mode puts
    # the cursor somewhere other than Neovim, so the expected state is unreachable.
    "change-undo": "After u, CodeMirror vim leaves the cursor at a different column than Neovim.",
    "new-line-undo": "After u, CodeMirror vim leaves the cursor on the removed line's neighbour, not where Neovim does.",
    "open-above-undo": "After u, CodeMirror vim leaves the cursor at a different position than Neovim.",
    "counted-delete": (
        "CodeMirror vim does not support nested count-operator notation (2d3d). "
        "Neovim interprets 2d3d as 'delete 6 lines'; CodeMirror deletes 3."
    ),
    "cross-line-delete-word": (
        "Neovim dw from the last word on a line preserves the newline, "
        "producing a leading empty line (result: '\\ntwo'). "
        "CodeMirror vim deletes through the newline and returns 'two'."
    ),
    "paste-char-cursor": (
        "CodeMirror vim places the cursor at a different column after pasting "
        "a multi-character yank mid-line. "
        "Neovim lands at col 6; CodeMirror lands at col 2."
    ),
    "indent-cursor": (
        "Duplicate of kata-indent (same start text 'x', same keys '>>', same expected result). "
        "kata-indent is kept; this duplicate is excluded."
    ),
    "join-cursor": (
        "Duplicate of kata-join (same start text 'foo\\nbar', same keys 'J', same expected result). "
        "kata-join is kept; this duplicate is excluded."
    ),
}

# ---------------------------------------------------------------------------
# Lesson definitions: each maps to a COURSE.md section (2-9).
# Only sections 2-5 have interactive exercises; 6-9 are reference only.
# ---------------------------------------------------------------------------

LESSONS = [
    {
        "id": "lesson-2",
        "section": 2,
        "titleEs": "Lección 2: Modos",
        "titleEn": "Lesson 2: Modes",
        "descriptionEs": (
            "Vim es un editor modal. La misma tecla hace cosas distintas "
            "segun el modo. Estos ejercicios practican entrar y salir del "
            "modo insertar con distintas teclas."
        ),
        "descriptionEn": (
            "Vim is a modal editor. The same key does different things "
            "depending on the mode. These exercises practise entering and "
            "exiting insert mode using different keys."
        ),
        "exerciseIds": [
            "kata-insert",
            "insert-start",
            "change-line",
            "change-empty",
        ],
    },
    {
        "id": "lesson-3",
        "section": 3,
        "titleEs": "Lección 3: Moverse sin flechas",
        "titleEn": "Lesson 3: Moving without arrow keys",
        "descriptionEs": (
            "hjkl, word motions, f/t, {/}, gg/G y %. "
            "Poner un número delante de casi cualquier movimiento lo multiplica: "
            "3j baja tres líneas, 2fX busca la segunda X."
        ),
        "descriptionEn": (
            "hjkl, word motions, f/t, {/}, gg/G and %. "
            "Prepending a number to almost any motion multiplies it: "
            "3j moves down three lines, 2fX finds the second X."
        ),
        "exerciseIds": [
            "kata-hjkl",
            "counted-gg",
            "paragraph-next",
            "paragraph-previous",
            "empty-word-motion",
            "counted-find",
            "find-adjacent",
            "repeat-till",
            "backwards-till-repeat",
            "kata-percent",
            "cancel-count",
        ],
    },
    {
        "id": "lesson-4",
        "section": 4,
        "titleEs": "Lección 4: Gramática: operador + movimiento",
        "titleEn": "Lesson 4: Grammar: operator + motion",
        "descriptionEs": (
            "d, c, y más un movimiento (o doble = línea completa). "
            "u para deshacer, Ctrl-r para rehacer. "
            ". repite el último cambio."
        ),
        "descriptionEn": (
            "d, c, y plus a motion (or doubled = whole line). "
            "u to undo, Ctrl-r to redo. "
            ". repeats the last change."
        ),
        "exerciseIds": [
            "kata-x",
            "kata-dd",
            "kata-dw",
            "delete-last-word",
            "kata-D",
            "change-word",
            "change-last-word",
            "change-tail",
            "reverse-delete",
            "kata-join",
            "kata-yy",
            "counted-replace",
            "insert-backspace",
            "insert-join-backspace",
            "cancel-operator",
            "cancel-find",
            "delete-undo-twice",
            "insert-undo",
            "change-undo",
            "new-line-undo",
            "open-above-undo",
        ],
    },
    {
        "id": "lesson-5",
        "section": 5,
        "titleEs": "Lección 5: Objetos de texto",
        "titleEn": "Lesson 5: Text objects",
        "descriptionEs": (
            "i (inner) y a (around) aplicados a palabras, comillas, "
            "parentesis, etc. La receta mas usada al programar: "
            "ciw, ci\", ci{."
        ),
        "descriptionEn": (
            "i (inner) and a (around) applied to words, quotes, "
            "parentheses, etc. The most-used recipe when coding: "
            "ciw, ci\", ci{."
        ),
        "exerciseIds": [
            "kata-ciw",
            "inner-last-word",
            "kata-diw",
            "kata-quotes",
            "inner-quotes-at-open",
            "yank-inner-and-paste",
            "empty-inner-change-undo",
            "kata-indent",
            "unindent-lines",
        ],
    },
]

REFERENCE_SECTION_NOTES = [
    {
        "id": "lesson-6",
        "section": 6,
        "titleEs": "Lección 6: Buscar y sustituir",
        "titleEn": "Lesson 6: Search and replace",
        "descriptionEs": (
            "/palabra busca hacia adelante, ?palabra hacia atrás. "
            "n/N siguiente/anterior. :%s/viejo/nuevo/g sustituye en todo el archivo. "
            "Estos comandos no se pueden practicar directamente en este entrenador "
            "(requieren la línea de comandos de Vim)."
        ),
        "descriptionEn": (
            "/word searches forward, ?word backward. "
            "n/N next/previous. :%s/old/new/g substitutes across the whole file. "
            "These commands cannot be practised directly in this trainer "
            "(they require Vim's command line)."
        ),
        "exerciseIds": [],
    },
    {
        "id": "lesson-7",
        "section": 7,
        "titleEs": "Lección 7: Buffers, ventanas y pestañas",
        "titleEn": "Lesson 7: Buffers, windows and tabs",
        "descriptionEs": (
            ":e archivo, :ls, :b2, Ctrl-w v/s, Ctrl-w hjkl. "
            "No se pueden practicar en el navegador."
        ),
        "descriptionEn": (
            ":e file, :ls, :b2, Ctrl-w v/s, Ctrl-w hjkl. "
            "Cannot be practised in the browser."
        ),
        "exerciseIds": [],
    },
    {
        "id": "lesson-8",
        "section": 8,
        "titleEs": "Lección 8: Registros y macros",
        "titleEn": "Lesson 8: Registers and macros",
        "descriptionEs": (
            "\"ayy copia al registro a. \"ap pega. "
            "qa graba macro, q para, @a reproduce. "
            "No se pueden practicar en el navegador (los registros "
            "y macros tienen soporte parcial)."
        ),
        "descriptionEn": (
            "\"ayy copies to register a. \"ap pastes. "
            "qa records a macro, q stops, @a replays. "
            "Cannot be practised in the browser (registers and macros "
            "have only partial support)."
        ),
        "exerciseIds": [],
    },
    {
        "id": "lesson-9",
        "section": 9,
        "titleEs": "Lección 9: Ayuda, guardar, salir",
        "titleEn": "Lesson 9: Help, save, quit",
        "descriptionEs": (
            ":w guardar, :q salir, :wq o ZZ guardar y salir, :q! descartar. "
            ":help x, :help :w, Ctrl-] seguir enlace. "
            "No se pueden practicar en el navegador."
        ),
        "descriptionEn": (
            ":w save, :q quit, :wq or ZZ save and quit, :q! discard. "
            ":help x, :help :w, Ctrl-] follow link. "
            "Cannot be practised in the browser."
        ),
        "exerciseIds": [],
    },
]


def run_nvim_reference(cases):
    """Run all cases through real Neovim and return the annotated case list."""
    temp = ROOT / "tmp"
    temp.mkdir(exist_ok=True)
    source = temp / "practice-cases.json"
    output = temp / "practice-reference.json"
    source.write_text(json.dumps(cases, ensure_ascii=False), encoding="utf-8")
    subprocess.run(
        [
            "nvim",
            "--clean",
            "-l",
            "tests/vim_reference.lua",
            str(source),
            str(output),
        ],
        cwd=ROOT,
        check=True,
    )
    return json.loads(output.read_text(encoding="utf-8"))


def export_katas():
    """Export kata metadata from Dart via export_katas.dart."""
    dart_bin = "dart" + (".bat" if os.name == "nt" else "")
    result = subprocess.run(
        [dart_bin, "run", "scripts/export_katas.dart"],
        cwd=ROOT,
        capture_output=True,
        text=True,
        encoding="utf-8",
        check=True,
    )
    return json.loads(result.stdout)


def build_exercises_json():
    """Build exercises.json and return it as a dict."""
    # --- Step 1: collect all cases ----------------------------------------
    # 37 reference cases from vim_reference.py
    ref_cases = [
        {"id": name, "start": start, "keys": keys}
        for name, start, keys in [
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
    ]

    # 13 kata cases from Dart (adds row/col/kataExpected/kataColumn)
    kata_cases = export_katas()

    all_cases = ref_cases + kata_cases

    # --- Step 2: run through real Neovim ----------------------------------
    nvim_data = run_nvim_reference(all_cases)
    # Release builds report "0.12.6+v0.12.6", Homebrew "0.12.6": keep the number.
    nvim_version = nvim_data["version"].split("+")[0]
    case_map = {c["id"]: c for c in nvim_data["cases"]}

    # --- Step 3: build exercise objects -----------------------------------
    exercises_by_id = {}
    for case in nvim_data["cases"]:
        cid = case["id"]
        exp = case["expected"]
        # Determine start row/col (defaults to 0)
        start_row = case.get("row", 0)
        start_col = case.get("col", 0)

        if cid.startswith("kata-"):
            # Kata: read title/hint from the kata data embedded in the case
            kata_id = cid[len("kata-"):]
            # We need to look up the kata metadata from content.dart.
            # The kata cases already carry kataExpected/kataColumn; titles
            # are embedded in content.dart which we cannot easily parse here.
            # We embed kata metadata directly below.
            meta = KATA_META.get(kata_id, {})
        else:
            meta = REF_META.get(cid, {})

        exercises_by_id[cid] = {
            "id": cid,
            "titleEs": meta.get("titleEs", cid),
            "titleEn": meta.get("titleEn", cid),
            "hintEs": meta.get("hintEs", ""),
            "hintEn": meta.get("hintEn", ""),
            "start": case["start"],
            "startRow": start_row,
            "startCol": start_col,
            "keys": case["keys"],
            "expectedText": exp["text"],
            "expectedRow": exp["row"],
            "expectedCol": exp["col"],
            "expectedMode": exp["mode"],
            # Katas without a column in the trainer grade the text only, like
            # the trainer does; every other exercise also grades the cursor.
            "checkCursor": not cid.startswith("kata-") or case.get("kataColumn") is not None,
        }

    # An exercise whose start already equals the goal is "solved" before any
    # key is typed: the page could never tell a right answer from no answer.
    exclusions = dict(EXCLUSIONS)
    for eid, ex in exercises_by_id.items():
        start = (ex["start"], ex["startRow"], ex["startCol"])
        goal = (ex["expectedText"], ex["expectedRow"], ex["expectedCol"])
        if not ex["checkCursor"]:
            start, goal = start[0], goal[0]
        if start == goal and "u" in ex["keys"]:
            # Undo exercises end where they began: they count only after the
            # text was changed first (the page tracks that), never for no keys.
            ex["requiresChange"] = True
        elif start == goal and eid not in exclusions:
            exclusions[eid] = (
                "The start state already equals the goal in real Neovim, so the page "
                "would mark it solved before any key is pressed."
            )

    # --- Step 4: build lesson list ----------------------------------------
    lessons_out = []
    included_ids = set()
    excluded_ids = set(exclusions.keys())

    for lesson in LESSONS:
        exs = []
        for eid in lesson["exerciseIds"]:
            if eid in excluded_ids:
                continue
            if eid not in exercises_by_id:
                print(f"WARNING: exercise {eid!r} not found in Neovim results", file=sys.stderr)
                continue
            exs.append(exercises_by_id[eid])
            included_ids.add(eid)
        lesson_entry = {k: v for k, v in lesson.items() if k != "exerciseIds"}
        lesson_entry["exercises"] = exs
        lessons_out.append(lesson_entry)

    # Add reference-only sections (no exercises, just descriptions)
    for note in REFERENCE_SECTION_NOTES:
        note_entry = {k: v for k, v in note.items() if k != "exerciseIds"}
        note_entry["exercises"] = []
        lessons_out.append(note_entry)

    # --- Step 5: build excluded list --------------------------------------
    excluded_out = []
    for eid, reason in exclusions.items():
        entry = {"id": eid, "reason": reason}
        if eid in exercises_by_id:
            entry["keys"] = exercises_by_id[eid]["keys"]
            entry["start"] = exercises_by_id[eid]["start"]
        excluded_out.append(entry)

    # --- Step 6: assemble final JSON --------------------------------------
    result = {
        "version": "0.1.0",
        "neovim_version": nvim_version,
        "built_at": datetime.datetime.now(datetime.timezone.utc).strftime(
            "%Y-%m-%dT%H:%M:%SZ"
        ),
        "lessons": lessons_out,
        "excluded": excluded_out,
    }
    return result


# ---------------------------------------------------------------------------
# Kata metadata (mirrors content.dart titles/hints).
# ---------------------------------------------------------------------------

def read_kata_text():
    """Titles and hints of each kata, read from the trainer's content.dart.

    The trainer is the single source: accents and wording stay identical.
    """
    source = (ROOT / "trainer/lib/data/content.dart").read_text(encoding="utf-8")
    string = r"'((?:[^'\\]|\\.)*)'"
    meta = {}
    for block in re.findall(r"Kata\((.*?)\n  \),", source, re.S):
        fields = dict(re.findall(r"(\w+):\s*" + string, block))
        # Skip the class constructor, keep only real kata entries.
        if all(key in fields for key in ("id", "titleEs", "titleEn", "hintEs", "hintEn")):
            meta[fields["id"]] = {
                key: re.sub(r"\\(.)", r"\1", fields[key])
                for key in ("titleEs", "titleEn", "hintEs", "hintEn")
            }
    return meta


KATA_META = read_kata_text()


def main():
    check_mode = "--check" in sys.argv
    output_path = ROOT / "practice" / "exercises.json"

    new_data = build_exercises_json()

    if check_mode:
        if not output_path.exists():
            print("FAIL: practice/exercises.json does not exist. Run without --check to build it.", file=sys.stderr)
            sys.exit(1)
        old_data = json.loads(output_path.read_text(encoding="utf-8"))
        # Compare excluding built_at timestamp
        def strip_ts(d):
            d = dict(d)
            d.pop("built_at", None)
            return d

        if strip_ts(old_data) != strip_ts(new_data):
            print(
                "FAIL: practice/exercises.json is stale. Run 'python scripts/build_practice.py' to refresh.",
                file=sys.stderr,
            )
            # Show what changed
            old_lessons = {l["id"]: len(l["exercises"]) for l in old_data.get("lessons", [])}
            new_lessons = {l["id"]: len(l["exercises"]) for l in new_data.get("lessons", [])}
            if old_lessons != new_lessons:
                print(f"  Lesson exercise counts changed: {old_lessons} -> {new_lessons}", file=sys.stderr)
            old_s, new_s = strip_ts(old_data), strip_ts(new_data)
            for key in sorted(set(old_s) | set(new_s)):
                if old_s.get(key) != new_s.get(key) and key != "lessons":
                    print(f"  {key}: {old_s.get(key)!r} -> {new_s.get(key)!r}", file=sys.stderr)
            old_ex = {e["id"]: e for l in old_data.get("lessons", []) for e in l["exercises"]}
            for l in new_data.get("lessons", []):
                for e in l["exercises"]:
                    if old_ex.get(e["id"]) != e:
                        print(f"  exercise {e['id']}: {old_ex.get(e['id'])!r} -> {e!r}", file=sys.stderr)
            sys.exit(1)

        total = sum(len(l["exercises"]) for l in new_data["lessons"])
        excluded = len(new_data["excluded"])
        print(
            f"PASS: exercises.json is up to date "
            f"({total} exercises, {excluded} excluded) "
            f"Neovim {new_data['neovim_version']}"
        )
        return

    # Write to disk
    output_path.parent.mkdir(parents=True, exist_ok=True)
    output_path.write_text(
        json.dumps(new_data, indent=2, ensure_ascii=False) + "\n",
        encoding="utf-8",
        newline="\n",
    )
    total = sum(len(l["exercises"]) for l in new_data["lessons"])
    excluded = len(new_data["excluded"])
    lesson_counts = {l["id"]: len(l["exercises"]) for l in new_data["lessons"]}
    print(f"Wrote practice/exercises.json")
    print(f"  Neovim version: {new_data['neovim_version']}")
    print(f"  Total exercises: {total}")
    print(f"  Excluded: {excluded}")
    print(f"  Lessons: {lesson_counts}")
    print(f"  Excluded IDs: {[e['id'] for e in new_data['excluded']]}")


if __name__ == "__main__":
    main()
