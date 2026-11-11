"""Build practice/exercises.json from katas and reference cases.

Usage:
    python scripts/build_practice.py           # rebuild exercises.json
    python scripts/build_practice.py --check   # fail if exercises.json is stale
"""

import datetime
import json
import os
import re
import shutil
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[1]

# ---------------------------------------------------------------------------
# Case metadata: titles and hints for the 37 reference cases.
# Kata metadata is read from content.dart via export_katas.dart.
# ---------------------------------------------------------------------------

REF_META = {
    "insert-before": {
        "titleEs": "Insertar antes del cursor (i)",
        "titleEn": "Insert before the cursor (i)",
        "hintEs": "i entra en modo Insertar justo antes del carácter del cursor. Escribe a y vuelve a Normal con Esc.",
        "hintEn": "i enters Insert mode right before the character under the cursor. Type a and go back to Normal with Esc.",
    },
    "append-after": {
        "titleEs": "Añadir después del cursor (a)",
        "titleEn": "Append after the cursor (a)",
        "hintEs": "a entra en modo Insertar justo después del carácter del cursor. Escribe b y pulsa Esc.",
        "hintEn": "a enters Insert mode right after the character under the cursor. Type b and press Esc.",
    },
    "append-end": {
        "titleEs": "Añadir al final de la línea (A)",
        "titleEn": "Append at the end of the line (A)",
        "hintEs": "A entra en modo Insertar al final de la línea, esté donde esté el cursor. Escribe ! y pulsa Esc.",
        "hintEn": "A enters Insert mode at the end of the line wherever the cursor is. Type ! and press Esc.",
    },
    "open-below": {
        "titleEs": "Abrir una línea debajo (o)",
        "titleEn": "Open a line below (o)",
        "hintEs": "o crea una línea nueva debajo y entra en modo Insertar. Escribe two y pulsa Esc.",
        "hintEn": "o creates a new line below and enters Insert mode. Type two and press Esc.",
    },
    "open-above": {
        "titleEs": "Abrir una línea encima (O)",
        "titleEn": "Open a line above (O)",
        "hintEs": "O (mayúscula) crea una línea nueva encima y entra en modo Insertar. Escribe one y pulsa Esc.",
        "hintEn": "O (capital) creates a new line above and enters Insert mode. Type one and press Esc.",
    },
    "change-word": {
        "titleEs": "Cambia una palabra (cw)",
        "titleEn": "Change a word (cw)",
        "hintEs": "cw cambia hasta el final de la palabra (igual que ce, no como dw): el espacio que sigue se conserva. Escribe el nuevo texto y pulsa Esc.",
        "hintEn": "cw changes to the end of the word (like ce, unlike dw): the following space is kept. Type the new text and press Esc.",
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
        "hintEs": "Si empiezas un conteo numérico (3...) y pulsas Esc, el conteo se cancela. Luego j baja una línea.",
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
        "hintEs": "2fX busca la segunda aparición de X hacia adelante en la línea. fX buscaría solo la primera.",
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
        "hintEs": '4l mueve el cursor a la comilla de apertura ". ci" desde la propia comilla aún funciona: cambia el texto entre comillas.',
        "hintEn": '4l moves the cursor to the opening " character. ci" from the opening quote still works: it changes the text inside the quotes.',
    },
    "counted-replace": {
        "titleEs": "Reemplazar 3 caracteres con 3rx",
        "titleEn": "Replace 3 characters with 3rx",
        "hintEs": "3rx reemplaza 3 caracteres, empezando por el que está bajo el cursor, por x. No entras en modo insertar: todo ocurre en normal.",
        "hintEn": "3rx replaces 3 characters, starting with the one under the cursor, with x. You never enter insert mode.",
    },
    "empty-word-motion": {
        "titleEs": "w sobre una línea vacía",
        "titleEn": "w over an empty line",
        "hintEs": "w avanza al inicio de la siguiente palabra. Vim cuenta una línea vacía como una palabra, así que w se detiene en ella.",
        "hintEn": "w moves to the start of the next word. Vim counts an empty line as a word, so w stops on it.",
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
        "hintEs": "I (mayúscula) entra en insertar al primer carácter no-espacio de la línea. Escribe el nuevo texto y pulsa Esc.",
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
        "hintEs": "yiw copia la palabra bajo el cursor. $ va al último carácter de la línea. p pega después del cursor.",
        "hintEn": "yiw copies the word under the cursor. $ goes to the last character of the line. p pastes after the cursor.",
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
    # --- New lesson-1 exercises ---
    "ctrl-w-insert": {
        "titleEs": "Borrar la palabra anterior en modo insertar (Ctrl-w)",
        "titleEn": "Delete the previous word in insert mode (Ctrl-w)",
        "hintEs": "Ctrl-w en modo Insertar borra desde el cursor hasta el inicio de la palabra anterior. A va al final de la linea; Ctrl-w borra la ultima palabra; Esc vuelve a Normal.",
        "hintEn": "Ctrl-w in Insert mode deletes from the cursor back to the start of the previous word. A goes to end of line; Ctrl-w deletes the last word; Esc returns to Normal.",
    },
    "ctrl-u-insert": {
        "titleEs": "Borrar hasta el inicio de la linea en modo insertar (Ctrl-u)",
        "titleEn": "Delete to start of line in insert mode (Ctrl-u)",
        "hintEs": "Ctrl-u en modo Insertar borra desde el cursor hasta el inicio de la linea actual. A va al final; Ctrl-u limpia toda la linea; Esc sale de Insertar.",
        "hintEn": "Ctrl-u in Insert mode deletes from the cursor to the start of the current line. A goes to end; Ctrl-u clears the whole line; Esc leaves Insert mode.",
    },
    "replace-mode": {
        "titleEs": "Modo Reemplazar: sobreescribir caracteres (R)",
        "titleEn": "Replace mode: overwrite characters (R)",
        "hintEs": "R entra en modo Reemplazar. Cada caracter que escribes sobreescribe el que hay bajo el cursor en lugar de insertar. Esc vuelve a Normal y retrocede un caracter.",
        "hintEn": "R enters Replace mode. Each character you type overwrites the one under the cursor instead of inserting. Esc returns to Normal and moves back one character.",
    },
    # --- New lesson-2 exercises ---
    "move-h": {
        "titleEs": "Mover el cursor a la izquierda (h)",
        "titleEn": "Move the cursor left (h)",
        "hintEs": "h mueve el cursor un caracter a la izquierda. Desde el final de 'abcde' (col 4), hh retrocede dos posiciones hasta la columna 2. Ninguna otra tecla de movimiento llega a esa columna exacta.",
        "hintEn": "h moves the cursor one character to the left. From the end of 'abcde' (col 4), hh moves two positions back to column 2. No other single motion key reaches that exact column.",
    },
    "move-k": {
        "titleEs": "Mover el cursor hacia arriba (k)",
        "titleEn": "Move the cursor up (k)",
        "hintEs": "k sube una linea manteniendo la columna. kk desde la fila 2 columna 2 llega a la fila 0 columna 2. gg llegaria a la misma fila pero en la columna 0, no en la columna 2.",
        "hintEn": "k moves up one line keeping the column. kk from row 2 column 2 reaches row 0 column 2. gg would reach the same row but at column 0, not column 2.",
    },
    "move-l": {
        "titleEs": "Mover el cursor a la derecha (l)",
        "titleEn": "Move the cursor right (l)",
        "hintEs": "l mueve el cursor un caracter a la derecha. ll lo mueve dos posiciones, llegando a la columna 2 de 'abcde'. Ningun otro movimiento de una sola tecla llega a esa columna exacta.",
        "hintEn": "l moves the cursor one character to the right. ll moves it two positions, landing on column 2 of 'abcde'. No other single-key motion reaches that exact column.",
    },
    "move-b": {
        "titleEs": "Retroceder al inicio de la palabra (b)",
        "titleEn": "Move back to the start of the word (b)",
        "hintEs": "b retrocede al inicio de la palabra actual o de la anterior. 3w avanza tres palabras hasta 'dd'; b retrocede al inicio de 'cc' en la columna 6.",
        "hintEn": "b moves back to the start of the current or previous word. 3w advances three words to 'dd'; b moves back to the start of 'cc' at column 6.",
    },
    "move-e": {
        "titleEs": "Ir al final de la palabra actual (e)",
        "titleEn": "Move to the end of the current word (e)",
        "hintEs": "e avanza hasta el ultimo caracter de la palabra actual. Desde el inicio de 'hello world', e llega a la 'o' final de 'hello' en la columna 4.",
        "hintEn": "e advances to the last character of the current word. From the start of 'hello world', e reaches the final 'o' of 'hello' at column 4.",
    },
    "move-ge": {
        "titleEs": "Ir al final de la palabra anterior (ge)",
        "titleEn": "Move to the end of the previous word (ge)",
        "hintEs": "ge retrocede hasta el ultimo caracter de la palabra anterior. 2w avanza dos palabras hasta 'foo'; ge vuelve al ultimo caracter de 'world' (col 10).",
        "hintEn": "ge moves back to the last character of the previous word. 2w advances two words to 'foo'; ge returns to the last character of 'world' at column 10.",
    },
    "move-W": {
        "titleEs": "Avanzar una PALABRA incluyendo puntuacion (W)",
        "titleEn": "Advance one WORD including punctuation (W)",
        "hintEs": "W avanza al inicio de la siguiente PALABRA, donde una PALABRA es cualquier secuencia sin espacios en blanco. 'foo(bar)' es una sola PALABRA; W salta hasta 'baz'.",
        "hintEn": "W advances to the start of the next WORD, where a WORD is any non-whitespace sequence. 'foo(bar)' counts as one WORD; W jumps straight to 'baz'.",
    },
    "move-E": {
        "titleEs": "Ir al final de la PALABRA actual (E)",
        "titleEn": "Move to the end of the current WORD (E)",
        "hintEs": "E avanza hasta el ultimo caracter de la PALABRA actual (secuencia sin espacios). 'foo(bar)' es una PALABRA; E llega al ')' final en columna 7.",
        "hintEn": "E advances to the last character of the current WORD (non-whitespace sequence). 'foo(bar)' is one WORD; E reaches the closing ')' at column 7.",
    },
    "move-0": {
        "titleEs": "Ir al primer caracter de la linea (0)",
        "titleEn": "Move to the first character of the line (0)",
        "hintEs": "0 (cero) mueve al primer caracter absoluto de la linea, incluidos los espacios. El cursor empieza en la columna 5 de '  hello world'; 0 lo lleva a la columna 0.",
        "hintEn": "0 (zero) moves to the absolute first character of the line, including spaces. The cursor starts at column 5 of '  hello world'; 0 brings it to column 0.",
    },
    "move-caret": {
        "titleEs": "Ir al primer caracter no espacio de la linea (^)",
        "titleEn": "Move to the first non-space character of the line (^)",
        "hintEs": "^ mueve al primer caracter que no sea espacio en blanco. El cursor empieza en la columna 10 de '  hello world'; ^ salta a la 'h' en la columna 2, ignorando los espacios iniciales.",
        "hintEn": "^ moves to the first non-whitespace character. The cursor starts at column 10 of '  hello world'; ^ jumps to the 'h' at column 2, skipping the leading spaces.",
    },
    "move-G": {
        "titleEs": "Ir a la ultima linea del archivo (G)",
        "titleEn": "Move to the last line of the file (G)",
        "hintEs": "G (mayuscula) salta al primer caracter no espacio de la ultima linea del archivo.",
        "hintEn": "G (capital) jumps to the first non-space character of the last line of the file.",
    },
    "move-gg-from-end": {
        "titleEs": "Ir a la primera linea desde el final (gg)",
        "titleEn": "Move to the first line from the end (gg)",
        "hintEs": "gg salta a la primera linea del archivo. El cursor empieza en 'three' (fila 3); gg lo lleva a 'one' (fila 0). { solo llegaria a la linea vacia en fila 2, no a la fila 0.",
        "hintEn": "gg jumps to the first line of the file. The cursor starts on 'three' (row 3); gg brings it to 'one' (row 0). { would only reach the blank line at row 2, not row 0.",
    },
    "count-j": {
        "titleEs": "Bajar varias lineas con contador (5j)",
        "titleEn": "Move down multiple lines with a count (5j)",
        "hintEs": "Un numero delante de j repite el movimiento hacia abajo. 5j baja cinco lineas de golpe y llega a la linea 6 (fila 5), que es 'f'. G llegaria a la ultima linea (fila 7), no a la fila 5.",
        "hintEn": "A number before j repeats the downward motion. 5j moves down five lines and lands on line 6 (row 5), which is 'f'. G would reach the last line (row 7), not row 5.",
    },
    "comma-repeat": {
        "titleEs": "Repetir busqueda de caracter en sentido contrario (,)",
        "titleEn": "Repeat the last character search in reverse direction (,)",
        "hintEs": ", invierte la direccion de la ultima busqueda de caracter. 3fX busca la tercera X adelante (col 8); , busca la X anterior hacia atras (col 5).",
        "hintEn": ", reverses the direction of the last character search. 3fX finds the third X forward (col 8); , searches backward for the previous X (col 5).",
    },
    "move-F": {
        "titleEs": "Buscar caracter hacia atras en la linea (F)",
        "titleEn": "Find a character backward on the line (F)",
        "hintEs": "F busca un caracter hacia atras desde el cursor. $ va al final de 'hello world'; Fl busca la 'l' mas proxima hacia la izquierda.",
        "hintEn": "F searches for a character backward from the cursor. $ goes to the end of 'hello world'; Fl finds the nearest 'l' to the left.",
    },
    # --- New lesson-3 exercises ---
    "dot-dw": {
        "titleEs": "Repetir el ultimo cambio con . (dw.)",
        "titleEn": "Repeat the last change with . (dw.)",
        "hintEs": ". repite el ultimo cambio en la posicion actual del cursor. dw borra la primera palabra 'aa '; . repite el borrado y elimina 'bb ', dejando solo 'cc'.",
        "hintEn": ". repeats the last change at the current cursor position. dw deletes the first word 'aa '; . repeats the deletion and removes 'bb ', leaving only 'cc'.",
    },
    "swap-chars": {
        "titleEs": "Intercambiar dos caracteres con xp",
        "titleEn": "Swap two characters with xp",
        "hintEs": "x borra el caracter bajo el cursor y lo guarda en el registro. p lo pega despues del cursor. xp intercambia el caracter con el siguiente.",
        "hintEn": "x deletes the character under the cursor and stores it in the register. p pastes it after the cursor. xp swaps the character with the next one.",
    },
    "delete-end-word": {
        "titleEs": "Borrar hasta el final de la palabra (de)",
        "titleEn": "Delete to the end of the word (de)",
        "hintEs": "de borra desde el cursor hasta el ultimo caracter de la palabra actual sin incluir el espacio que sigue. Distinto de dw, que si incluye el espacio.",
        "hintEn": "de deletes from the cursor to the last character of the current word without including the following space. Unlike dw, which includes the space.",
    },
    "delete-back-word": {
        "titleEs": "Borrar hacia atras hasta el inicio de la palabra (db)",
        "titleEn": "Delete backward to the start of the word (db)",
        "hintEs": "db borra desde el cursor hacia atras hasta el inicio de la palabra anterior. w avanza a 'world'; db borra 'hello ' hacia atras, dejando solo 'world'.",
        "hintEn": "db deletes from the cursor backward to the start of the previous word. w moves to 'world'; db deletes 'hello ' backward, leaving only 'world'.",
    },
    "delete-to-eol": {
        "titleEs": "Borrar hasta el final de la linea (d$)",
        "titleEn": "Delete to the end of the line (d$)",
        "hintEs": "d$ borra desde el cursor hasta el final de la linea. w avanza a 'world'; d$ borra 'world', dejando 'hello ' con el cursor en el ultimo caracter.",
        "hintEn": "d$ deletes from the cursor to the end of the line. w moves to 'world'; d$ deletes 'world', leaving 'hello ' with the cursor on the last character.",
    },
    "delete-to-first-line": {
        "titleEs": "Borrar hasta la primera linea (dgg)",
        "titleEn": "Delete to the first line (dgg)",
        "hintEs": "dgg borra desde la linea actual hasta la primera linea del archivo inclusive. j baja a 'two'; dgg borra 'one' y 'two', dejando solo 'three'.",
        "hintEn": "dgg deletes from the current line to the first line of the file inclusive. j moves to 'two'; dgg deletes 'one' and 'two', leaving only 'three'.",
    },
    "yank-eol-paste": {
        "titleEs": "Copiar hasta el final de la linea y pegar (y$p)",
        "titleEn": "Yank to end of line and paste (y$p)",
        "hintEs": "y$ copia desde el cursor hasta el final de la linea. p pega despues del cursor. En 'ab', y$p duplica el contenido y el cursor queda en la segunda 'b'.",
        "hintEn": "y$ yanks from the cursor to the end of the line. p pastes after the cursor. On 'ab', y$p duplicates the content and the cursor lands on the second 'b'.",
    },
    "yank-word-paste": {
        "titleEs": "Copiar palabra con espacio y pegar al final (yw$p)",
        "titleEn": "Yank word with trailing space and paste at end (yw$p)",
        "hintEs": "yw copia desde el cursor hasta el inicio de la siguiente palabra, incluido el espacio. A diferencia de yiw, si incluye el espacio. $ va al ultimo caracter; p pega al final.",
        "hintEn": "yw yanks from the cursor to the start of the next word, including the trailing space. Unlike yiw, it includes the space. $ goes to the last character; p pastes at the end.",
    },
    "paste-before": {
        "titleEs": "Pegar antes del cursor o de la linea actual (P)",
        "titleEn": "Paste before the cursor or current line (P)",
        "hintEs": "P (mayuscula) pega antes del cursor, o antes de la linea actual en el caso de un yank de linea. yy copia 'one'; P la pega encima.",
        "hintEn": "P (capital) pastes before the cursor, or before the current line for a linewise yank. yy copies 'one'; P pastes it above the current line.",
    },
    "move-line": {
        "titleEs": "Mover una linea hacia abajo con dd y p",
        "titleEn": "Move a line down with dd and p",
        "hintEs": "dd borra la linea actual y la guarda en el registro. p la pega despues de la linea siguiente, desplazando la linea original una posicion hacia abajo.",
        "hintEn": "dd deletes the current line and saves it in the register. p pastes it after the next line, moving the original line one position down.",
    },
    "ce-word": {
        "titleEs": "Cambiar hasta el final de la palabra (ce)",
        "titleEn": "Change to the end of the word (ce)",
        "hintEs": "ce cambia desde el cursor hasta el final de la palabra actual y entra en modo Insertar. En la practica, cw y ce tienen el mismo efecto.",
        "hintEn": "ce changes from the cursor to the end of the current word and enters Insert mode. In practice, cw and ce have the same effect.",
    },
    "count-J": {
        "titleEs": "Juntar varias lineas con contador (3J)",
        "titleEn": "Join multiple lines with a count (3J)",
        "hintEs": "NJ junta N lineas en una sola, separadas por un espacio. 3J junta 'a', 'b' y 'c' en 'a b c'.",
        "hintEn": "NJ joins N lines into one, separated by a space. 3J joins 'a', 'b', and 'c' into 'a b c'.",
    },
    "tilde-char": {
        "titleEs": "Cambiar mayuscula o minuscula con ~",
        "titleEn": "Toggle uppercase or lowercase with ~",
        "hintEs": "~ cambia el caso del caracter bajo el cursor y avanza al siguiente. Tres ~ convierten las tres primeras letras de 'hello' en 'HEL'.",
        "hintEn": "~ toggles the case of the character under the cursor and advances to the next. Three ~ turn the first three letters of 'hello' into 'HEL'.",
    },
    "gU-word": {
        "titleEs": "Convertir a mayusculas con operador gU (gUw)",
        "titleEn": "Convert to uppercase with gU operator (gUw)",
        "hintEs": "gU seguido de un movimiento convierte el texto a mayusculas. gUw convierte desde el cursor hasta el inicio de la siguiente palabra ('hello ') en 'HELLO '.",
        "hintEn": "gU followed by a motion converts the text to uppercase. gUw converts from the cursor to the start of the next word ('hello ') into 'HELLO '.",
    },
    "gu-word": {
        "titleEs": "Convertir a minusculas con operador gu (guw)",
        "titleEn": "Convert to lowercase with gu operator (guw)",
        "hintEs": "gu seguido de un movimiento convierte el texto a minusculas. guw convierte 'HELLO ' en 'hello '.",
        "hintEn": "gu followed by a motion converts the text to lowercase. guw converts 'HELLO ' into 'hello '.",
    },
    "g-tilde-word": {
        "titleEs": "Invertir mayusculas y minusculas con g~ (g~w)",
        "titleEn": "Toggle case of a word with g~ (g~w)",
        "hintEs": "g~ seguido de un movimiento invierte el caso de cada caracter. g~w invierte 'Hello ' convirtiendo cada letra de mayuscula a minuscula y viceversa.",
        "hintEn": "g~ followed by a motion toggles the case of each character. g~w inverts 'Hello ' converting each letter from uppercase to lowercase and vice versa.",
    },
    "count-indent": {
        "titleEs": "Indentar varias lineas con contador (3>>)",
        "titleEn": "Indent multiple lines with a count (3>>)",
        "hintEs": "Un numero delante de >> indenta varias lineas a la vez. 3>> indenta las tres lineas del buffer.",
        "hintEn": "A count before >> indents multiple lines at once. 3>> indents all three lines of the buffer.",
    },
    "dot-repeat": {
        "titleEs": "Repetir el ultimo cambio con .",
        "titleEn": "Repeat the last change with .",
        "hintEs": ". repite el ultimo cambio en la posicion actual del cursor. ciwfoo<Esc> cambia 'hello' por 'foo'; w avanza; . repite el cambio en 'world'.",
        "hintEn": ". repeats the last change at the current cursor position. ciwfoo<Esc> replaces 'hello' with 'foo'; w advances; . repeats the same change on 'world'.",
    },
    "redo-ctrl-r": {
        "titleEs": "Rehacer el ultimo cambio deshecho (Ctrl-r)",
        "titleEn": "Redo the last undone change (Ctrl-r)",
        "hintEs": "Ctrl-r rehace el cambio que u acaba de deshacer. x borra 'a'; u lo restaura; Ctrl-r vuelve a borrarlo.",
        "hintEn": "Ctrl-r redoes the change that u just undid. x deletes 'a'; u restores it; Ctrl-r deletes it again.",
    },
    # --- New lesson-4 exercises ---
    "delete-around-word": {
        "titleEs": "Borrar la palabra y el espacio adyacente (daw)",
        "titleEn": "Delete the word and adjacent whitespace (daw)",
        "hintEs": "daw borra la palabra entera mas el espacio que la sigue (o el que la precede si esta al final). w avanza a 'world'; daw borra 'world ' y deja 'hello foo'.",
        "hintEn": "daw deletes the whole word plus the trailing space (or leading space if at the end). w advances to 'world'; daw deletes 'world ' and leaves 'hello foo'.",
    },
    "change-inner-paren": {
        "titleEs": "Cambiar el interior de los parentesis (ci()",
        "titleEn": "Change the inside of parentheses (ci()",
        "hintEs": "ci( cambia el contenido dentro de los parentesis mas cercanos, dejando los parentesis intactos. 4l mueve el cursor dentro de '(bar)'; ci( borra 'bar' y entra en Insertar.",
        "hintEn": "ci( changes the content inside the nearest parentheses, leaving the parentheses intact. 4l moves the cursor inside '(bar)'; ci( deletes 'bar' and enters Insert mode.",
    },
    "change-around-paren": {
        "titleEs": "Cambiar los parentesis y su contenido (ca()",
        "titleEn": "Change parentheses and their content (ca()",
        "hintEs": "ca( cambia los parentesis y todo su contenido, incluidos los propios '(' y ')'. A diferencia de ci(, borra tambien los parentesis.",
        "hintEn": "ca( changes the parentheses and all their content, including '(' and ')' themselves. Unlike ci(, it also removes the parentheses.",
    },
    "change-inner-brace": {
        "titleEs": "Cambiar el interior de las llaves (ci{)",
        "titleEn": "Change the inside of braces (ci{)",
        "hintEs": "ci{ cambia el contenido dentro de las llaves mas cercanas. 9l mueve el cursor dentro de '{ y }'; ci{ borra ' y ' y entra en Insertar.",
        "hintEn": "ci{ changes the content inside the nearest braces. 9l moves the cursor inside '{ y }'; ci{ deletes ' y ' and enters Insert mode.",
    },
    "delete-inner-bracket": {
        "titleEs": "Borrar el interior de los corchetes (di[)",
        "titleEn": "Delete the inside of brackets (di[)",
        "hintEs": "di[ borra el contenido dentro de los corchetes mas cercanos, dejando '[' y ']' en su lugar. 4l mueve el cursor dentro de '[idx]'; di[ borra 'idx'.",
        "hintEn": "di[ deletes the content inside the nearest brackets, leaving '[' and ']' in place. 4l moves the cursor inside '[idx]'; di[ deletes 'idx'.",
    },
    "delete-around-bracket": {
        "titleEs": "Borrar los corchetes y su contenido (da[)",
        "titleEn": "Delete the brackets and their content (da[)",
        "hintEs": "da[ borra los corchetes y todo su contenido. 4l mueve el cursor dentro de '[idx]'; da[ borra '[idx]' incluyendo los propios corchetes.",
        "hintEn": "da[ deletes the brackets and their entire content. 4l moves the cursor inside '[idx]'; da[ deletes '[idx]' including the brackets themselves.",
    },
    "change-inner-tag": {
        "titleEs": "Cambiar el interior de una etiqueta HTML (cit)",
        "titleEn": "Change the inside of an HTML tag (cit)",
        "hintEs": "cit cambia el contenido entre etiquetas HTML sin borrar las etiquetas. 4l mueve el cursor dentro de '<p>foo</p>'; cit borra 'foo' y entra en Insertar.",
        "hintEn": "cit changes the content between HTML tags without deleting the tags. 4l moves the cursor inside '<p>foo</p>'; cit deletes 'foo' and enters Insert mode.",
    },
    'yank-inner-quote': {
        "titleEs": 'Copiar el texto entre comillas y pegar (yi")',
        "titleEn": 'Yank text inside quotes and paste (yi")',
        "hintEs": 'yi" copia el texto dentro de las comillas dobles mas cercanas sin incluirlas. 5l mueve el cursor dentro de "hello"; yi" copia "hello"; $ va al final; p pega.',
        "hintEn": 'yi" copies the text inside the nearest double quotes without including them. 5l moves the cursor inside "hello"; yi" copies "hello"; $ goes to end; p pastes.',
    },
    "gUiw": {
        "titleEs": "Convertir la palabra a mayusculas (gUiw)",
        "titleEn": "Convert the word to uppercase (gUiw)",
        "hintEs": "gUiw convierte la palabra completa bajo el cursor a mayusculas, independientemente de donde este el cursor dentro de ella.",
        "hintEn": "gUiw converts the entire word under the cursor to uppercase, regardless of where the cursor is within the word.",
    },
    "guiw": {
        "titleEs": "Convertir la palabra a minusculas (guiw)",
        "titleEn": "Convert the word to lowercase (guiw)",
        "hintEs": "guiw convierte la palabra completa bajo el cursor a minusculas, independientemente de donde este el cursor dentro de ella.",
        "hintEn": "guiw converts the entire word under the cursor to lowercase, regardless of where the cursor is within the word.",
    },
    "delete-around-para": {
        "titleEs": "Borrar el parrafo completo (dap)",
        "titleEn": "Delete the entire paragraph (dap)",
        "hintEs": "dap borra el parrafo bajo el cursor, incluidas las lineas vacias adyacentes. El parrafo 'one' y 'two' mas la linea vacia desaparecen; queda 'three'.",
        "hintEn": "dap deletes the paragraph under the cursor, including adjacent blank lines. The paragraph 'one' and 'two' plus the blank line disappear; 'three' remains.",
    },
    "change-inner-para": {
        "titleEs": "Cambiar el interior del parrafo (cip)",
        "titleEn": "Change the inside of the paragraph (cip)",
        "hintEs": "cip cambia las lineas del parrafo sin borrar las lineas vacias contiguas. 'one' y 'two' se reemplazan por 'NEW'; la linea vacia y 'three' se conservan.",
        "hintEn": "cip changes the lines of the paragraph without deleting adjacent blank lines. 'one' and 'two' are replaced by 'NEW'; the blank line and 'three' are preserved.",
    },
    # --- New lesson-4 exercises (visual mode + around text objects) ---
    "delete-around-quote": {
        "titleEs": 'Borrar las comillas y su contenido (da")',
        "titleEn": 'Delete the quotes and their content (da")',
        "hintEs": 'da" borra el texto entre comillas dobles incluyendo las propias comillas. Desde dentro de "b" en a"b"c (col 2), da" elimina "b" y deja ac con el cursor en la c.',
        "hintEn": 'da" deletes the text inside double quotes including the quote characters themselves. From inside "b" in a"b"c (col 2), da" removes "b" and leaves ac with the cursor on c.',
    },
    "delete-around-brace": {
        "titleEs": "Borrar las llaves y su contenido (da{)",
        "titleEn": "Delete the braces and their content (da{)",
        "hintEs": "da{ borra el bloque entre llaves incluyendo las propias llaves. Desde dentro de '{ x }' (col 3), da{ elimina todo el bloque y deja solo 'fn'.",
        "hintEn": "da{ deletes the block inside braces including the brace characters themselves. From inside '{ x }' (col 3), da{ removes the whole block and leaves only 'fn'.",
    },
    "visual-vd": {
        "titleEs": "Modo visual: seleccionar y borrar (vlld)",
        "titleEn": "Visual mode: select and delete (vlld)",
        "hintEs": "v entra en modo Visual caracter por caracter. ll extiende la seleccion dos caracteres a la derecha. d borra la seleccion. El resultado es el texto fuera de la seleccion.",
        "hintEn": "v enters character-wise Visual mode. ll extends the selection two characters to the right. d deletes the selection. The result is the text outside the selection.",
    },
    "visual-Vd": {
        "titleEs": "Modo visual de linea: seleccionar y borrar (Vjd)",
        "titleEn": "Linewise visual mode: select and delete (Vjd)",
        "hintEs": "V entra en modo Visual de linea, que selecciona lineas enteras. j extiende la seleccion a la linea siguiente. d borra todas las lineas seleccionadas.",
        "hintEn": "V enters linewise Visual mode, which selects whole lines. j extends the selection to the next line. d deletes all selected lines.",
    },
    # --- New lesson-5 exercises (Buscar y sustituir) ---
    "search-forward": {
        "titleEs": "Buscar hacia adelante en el buffer (/)",
        "titleEn": "Search forward in the buffer (/)",
        "hintEs": "/three<CR> busca la cadena 'three' hacia adelante y coloca el cursor en su primera letra. El cursor salta desde el inicio hasta la columna 8.",
        "hintEn": "/three<CR> searches for 'three' forward and places the cursor on its first character. The cursor jumps from the start to column 8.",
    },
    "search-next": {
        "titleEs": "Ir a la siguiente coincidencia de busqueda (n)",
        "titleEn": "Move to the next search match (n)",
        "hintEs": "/X<CR> encuentra la primera 'X'; n avanza a la siguiente. En 'aXbXcX', la primera X esta en col 1 y la siguiente en col 3.",
        "hintEn": "/X<CR> finds the first 'X'; n advances to the next match. In 'aXbXcX', the first X is at col 1 and the next at col 3.",
    },
    "search-star": {
        "titleEs": "Buscar la palabra bajo el cursor (*)",
        "titleEn": "Search for the word under the cursor (*)",
        "hintEs": "* busca hacia adelante la siguiente aparicion de la palabra exacta bajo el cursor. En 'foo bar foo', el cursor empieza en 'foo' (col 0) y salta al segundo 'foo' (col 8).",
        "hintEn": "* searches forward for the next occurrence of the exact word under the cursor. In 'foo bar foo', the cursor starts on 'foo' (col 0) and jumps to the second 'foo' (col 8).",
    },
    "search-backward": {
        "titleEs": "Buscar hacia atras en el buffer (?)",
        "titleEn": "Search backward in the buffer (?)",
        "hintEs": "?patron<CR> busca hacia atras desde el cursor. Desde la segunda linea en col 8, ?two<CR> cruza a la primera linea y coloca el cursor al inicio de 'two' en col 4.",
        "hintEn": "?pattern<CR> searches backward from the cursor. From the second line at col 8, ?two<CR> crosses to the first line and places the cursor at the start of 'two' at col 4.",
    },
    "search-hash": {
        "titleEs": "Buscar la palabra bajo el cursor hacia atras (#)",
        "titleEn": "Search for the word under the cursor backward (#)",
        "hintEs": "# busca hacia atras la anterior aparicion de la palabra exacta bajo el cursor. Desde 'bar' en la fila 0 col 4, # salta a 'bar' al inicio de la fila 1 (col 0).",
        "hintEn": "# searches backward for the previous occurrence of the exact word under the cursor. From 'bar' on row 0 col 4, # jumps to 'bar' at the start of row 1 (col 0).",
    },
    "substitute": {
        "titleEs": "Sustituir texto en la linea actual (:s/viejo/nuevo/)",
        "titleEn": "Substitute text on the current line (:s/old/new/)",
        "hintEs": ":s/world/vim/<CR> sustituye la primera aparicion de 'world' por 'vim' en la linea actual. El cursor queda al inicio del texto sustituido.",
        "hintEn": ":s/world/vim/<CR> replaces the first occurrence of 'world' with 'vim' on the current line. The cursor lands at the start of the substituted text.",
    },
    "global-substitute": {
        "titleEs": "Sustituir en todas las lineas (:%s/viejo/nuevo/g)",
        "titleEn": "Substitute across all lines (:%s/old/new/g)",
        "hintEs": ":%s/foo/baz/g sustituye todas las apariciones de 'foo' por 'baz' en cada linea del archivo. El modificador g aplica el cambio mas de una vez por linea.",
        "hintEn": ":%s/foo/baz/g replaces every occurrence of 'foo' with 'baz' on every line of the file. The g flag applies the change more than once per line.",
    },
    # --- New lesson-6 exercises (Registros y macros) ---
    "register-yank-paste": {
        "titleEs": "Copiar en un registro nombrado y pegar (\"ayy ... \"ap)",
        "titleEn": "Yank into a named register and paste (\"ayy ... \"ap)",
        "hintEs": "\"ayy copia la linea actual en el registro 'a'. j baja una linea. \"ap pega el contenido del registro 'a' despues de la linea actual.",
        "hintEn": "\"ayy yanks the current line into register 'a'. j moves down one line. \"ap pastes the contents of register 'a' after the current line.",
    },
    "macro-record": {
        "titleEs": "Grabar y ejecutar una macro (qa ... q, @a)",
        "titleEn": "Record and play a macro (qa ... q, @a)",
        "hintEs": "qa empieza a grabar en el registro 'a'. A;<Esc>j anade ';' al final de la linea y baja. q detiene la grabacion. @a repite la macro en la linea siguiente.",
        "hintEn": "qa starts recording into register 'a'. A;<Esc>j appends ';' at the end of the line and moves down. q stops recording. @a plays the macro on the next line.",
    },
    "macro-double-at": {
        "titleEs": "Repetir la ultima macro ejecutada (@@)",
        "titleEn": "Repeat the last played macro (@@)",
        "hintEs": "qa graba la macro en el registro 'a'. @a la ejecuta una vez mas. @@ repite la ultima macro ejecutada sin indicar de nuevo el registro.",
        "hintEn": "qa records the macro into register 'a'. @a plays it once more. @@ repeats the last played macro without specifying the register again.",
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
    # Adversarial false-positive removals (goal reachable by a shorter/simpler key)
    "kata-hjkl": (
        "Start text 'abc' allows $ to reach the same goal column (col 2 on a 3-char line), "
        "bypassing the l motion being taught. Replaced by move-l (start 'abcde', keys 'll') "
        "where no single key among $,w,e,b,0,j,G,x reaches col 2."
    ),
    "cancel-count": (
        "Plain j reaches the same goal (row 1). "
        "A cursor-only goal cannot prove Esc cancelled a pending count. Excluded."
    ),
    "cancel-operator": (
        "Plain l reaches the same goal (col 1 on 'hello world'). "
        "A cursor-only goal cannot prove Esc cancelled a pending operator. Excluded."
    ),
    "cancel-find": (
        "Plain l reaches the same goal (col 1 on 'abc def'). "
        "A cursor-only goal cannot prove Esc cancelled a pending f search. Excluded."
    ),
    # CodeMirror redo limitation
    "redo-ctrl-r": (
        "The redone state is always reached by a prefix of the canonical sequence "
        "(the editing step before undo), so the browser test fails: exercise solved "
        "prematurely after typing the initial change before the undo/redo pair."
    ),
    # CodeMirror gU/gu/g~ operator not fully implemented
    "gU-word": (
        "CodeMirror vim gU operator is not implemented: gUw has no effect in the browser."
    ),
    "gu-word": (
        "CodeMirror vim gu operator is not implemented: guw has no effect in the browser."
    ),
    "g-tilde-word": (
        "CodeMirror vim g~ operator is not implemented: g~w has no effect in the browser."
    ),
    "gUiw": (
        "CodeMirror vim gU operator is not implemented: gUiw has no effect in the browser."
    ),
    "guiw": (
        "CodeMirror vim gu operator is not implemented: guiw has no effect in the browser."
    ),
    # CodeMirror 3>> cursor lands on a different row/col than Neovim
    "count-indent": (
        "CodeMirror vim leaves the cursor at a different row after 3>>. "
        "Neovim: row 0 col 4; CodeMirror: row 1 col 5."
    ),
    # CodeMirror :s / :%s cursor lands at a different position than Neovim
    "substitute": (
        "CodeMirror vim :s/world/vim/<CR> leaves the cursor at a different position "
        "than Neovim after the substitution."
    ),
    "global-substitute": (
        "CodeMirror vim :%s/foo/baz/g<CR> leaves the cursor at a different position "
        "than Neovim after the global substitution."
    ),
    # CodeMirror cit/dit not implemented
    "change-inner-tag": (
        "CodeMirror vim does not implement the it (inner tag) text object: cit has no effect."
    ),
    # dap/cip paragraph text objects have incomplete CodeMirror support
    "delete-around-para": (
        "CodeMirror vim paragraph text object (ap) is not fully supported: "
        "dap does not remove adjacent blank lines as Neovim does."
    ),
    "change-inner-para": (
        "CodeMirror vim paragraph text object (ip) is not fully supported: "
        "cip does not match Neovim's exact selection of paragraph lines."
    ),
}

# ---------------------------------------------------------------------------
# Lesson definitions: each maps to a COURSE.md section (2-9).
# Only sections 2-5 have interactive exercises; 6-9 are reference only.
# ---------------------------------------------------------------------------

# Course route, from less to more: each lesson only uses what earlier ones
# taught (the slides follow the same numbering, course/slides/deck.json).
LESSONS = [
    {
        "id": "lesson-1",
        "section": 1,
        "titleEs": "Lección 1: Modos y sobrevivir",
        "titleEn": "Lesson 1: Modes and survival",
        "descriptionEs": (
            "Vim es un editor modal: en modo Normal las teclas son órdenes y en modo "
            "Insertar escriben texto. i, a, I, A, o y O entran a Insertar en sitios "
            "distintos; Esc vuelve a Normal."
        ),
        "descriptionEn": (
            "Vim is modal: in Normal mode keys are commands, in Insert mode they type "
            "text. i, a, I, A, o and O enter Insert mode at different places; Esc goes "
            "back to Normal."
        ),
        "exerciseIds": [
            "insert-before",
            "append-after",
            "kata-insert",
            "insert-start",
            "append-end",
            "open-below",
            "open-above",
            "insert-backspace",
            "ctrl-w-insert",
            "ctrl-u-insert",
            "replace-mode",
        ],
    },
    {
        "id": "lesson-2",
        "section": 2,
        "titleEs": "Lección 2: Moverse sin flechas",
        "titleEn": "Lesson 2: Moving without arrow keys",
        "descriptionEs": (
            "h j k l, palabras (w b e W E B ge), columna (0 ^ $), lineas (gg G), "
            "buscar en la linea (f F t ; ,) y la pareja de un parentesis (%). "
            "Un numero delante multiplica el movimiento: 3gg, 2fX, 5j."
        ),
        "descriptionEn": (
            "h j k l, words (w b e W E B ge), column (0 ^ $), lines (gg G), "
            "find on the line (f F t ; ,) and a bracket's pair (%). "
            "A number in front multiplies the motion: 3gg, 2fX, 5j."
        ),
        "exerciseIds": [
            "move-l",
            "move-h",
            "empty-word-motion",
            "move-b",
            "move-e",
            "move-ge",
            "move-W",
            "move-E",
            "move-0",
            "move-caret",
            "move-G",
            "move-gg-from-end",
            "count-j",
            "move-k",
            "paragraph-next",
            "paragraph-previous",
            "counted-gg",
            "counted-find",
            "comma-repeat",
            "move-F",
            "repeat-till",
            "backwards-till-repeat",
            "kata-percent",
            "insert-join-backspace",
        ],
    },
    {
        "id": "lesson-3",
        "section": 3,
        "titleEs": "Lección 3: Gramática: operador + movimiento",
        "titleEn": "Lesson 3: Grammar: operator + motion",
        "descriptionEs": (
            "Un operador (d borrar, c cambiar, y copiar, > sangrar) seguido de un "
            "movimiento actua sobre ese tramo; doblado (dd, cc, yy, >>) actua sobre la "
            "linea. x borra un caracter, ~ cambia mayusculas, u deshace, . repite."
        ),
        "descriptionEn": (
            "An operator (d delete, c change, y yank, > indent) followed by a motion "
            "acts on that stretch; doubled (dd, cc, yy, >>) it acts on the line. "
            "x deletes a character, ~ toggles case, u undoes, . repeats."
        ),
        "exerciseIds": [
            "kata-x",
            "swap-chars",
            "kata-dd",
            "kata-dw",
            "delete-end-word",
            "delete-back-word",
            "delete-last-word",
            "delete-to-eol",
            "delete-to-first-line",
            "kata-D",
            "reverse-delete",
            "change-word",
            "ce-word",
            "change-last-word",
            "change-line",
            "change-empty",
            "change-tail",
            "kata-yy",
            "yank-eol-paste",
            "yank-word-paste",
            "paste-before",
            "move-line",
            "kata-join",
            "count-J",
            "tilde-char",
            "gU-word",
            "gu-word",
            "g-tilde-word",
            "counted-replace",
            "kata-indent",
            "unindent-lines",
            "count-indent",
            "delete-undo-twice",
            "insert-undo",
            "dot-dw",
            "redo-ctrl-r",
        ],
    },
    {
        "id": "lesson-4",
        "section": 4,
        "titleEs": "Lección 4: Objetos de texto",
        "titleEn": "Lesson 4: Text objects",
        "descriptionEs": (
            "i (interior) y a (alrededor) seleccionan una palabra, unas comillas o unos "
            "parentesis completos sin importar donde este el cursor dentro. La receta "
            "mas usada al programar: ciw, ci\", ci{, cit."
        ),
        "descriptionEn": (
            "i (inner) and a (around) select a whole word, quotes or brackets wherever "
            "the cursor is inside them. The most-used recipe when coding: ciw, ci\", ci{."
        ),
        "exerciseIds": [
            "kata-diw",
            "delete-around-word",
            "kata-ciw",
            "inner-last-word",
            "gUiw",
            "guiw",
            "kata-quotes",
            "yank-inner-quote",
            "inner-quotes-at-open",
            "delete-around-quote",
            "change-inner-paren",
            "change-around-paren",
            "change-inner-brace",
            "delete-inner-bracket",
            "delete-around-bracket",
            "delete-around-brace",
            "change-inner-tag",
            "yank-inner-and-paste",
            "empty-inner-change-undo",
            "delete-around-para",
            "change-inner-para",
            "visual-vd",
            "visual-Vd",
            "dot-repeat",
        ],
    },
    {
        "id": "lesson-5",
        "section": 5,
        "titleEs": "Lección 5: Buscar y sustituir",
        "titleEn": "Lesson 5: Search and replace",
        "descriptionEs": (
            "/ busca hacia adelante, ? hacia atras. n va a la siguiente coincidencia, "
            "N a la anterior. * busca la palabra bajo el cursor. "
            ":s/viejo/nuevo/ sustituye en la linea; :%s/viejo/nuevo/g en todo el archivo."
        ),
        "descriptionEn": (
            "/ searches forward, ? backward. n goes to the next match, N to the previous. "
            "* searches for the word under the cursor. "
            ":s/old/new/ substitutes on the line; :%s/old/new/g across the whole file."
        ),
        "exerciseIds": [
            "search-forward",
            "search-backward",
            "search-next",
            "search-star",
            "search-hash",
            "substitute",
            "global-substitute",
        ],
    },
    {
        "id": "lesson-6",
        "section": 6,
        "titleEs": "Lección 6: Registros y macros",
        "titleEn": "Lesson 6: Registers and macros",
        "descriptionEs": (
            "\"a a \"a seleccionan el registro 'a' para copiar y pegar. "
            "qa ... q graba una macro en 'a'; @a la ejecuta; @@ repite la ultima. "
            "Los registros 0-9, \"+, \"_ y \"% tienen usos especiales."
        ),
        "descriptionEn": (
            "\"a selects register 'a' for yank and paste. "
            "qa ... q records a macro into 'a'; @a plays it back; @@ repeats the last. "
            "Registers 0-9, \"+, \"_ and \"% have special uses."
        ),
        "exerciseIds": [
            "register-yank-paste",
            "macro-record",
            "macro-double-at",
        ],
    },
]

REFERENCE_SECTION_NOTES = [
    {
        "id": "lesson-7",
        "section": 7,
        "titleEs": "Lección 7: Buffers, ventanas y terminales",
        "titleEn": "Lesson 7: Buffers, windows and terminals",
        "exerciseIds": [],
    },
    {
        "id": "lesson-8",
        "section": 8,
        "titleEs": "Lección 8: Tu configuración",
        "titleEn": "Lesson 8: Your configuration",
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
    # which() follows PATHEXT on Windows (dart.exe from the SDK or Flutter's dart.bat).
    dart_bin = shutil.which("dart") or "dart"
    result = subprocess.run(
        [dart_bin, "run", "scripts/export_katas.dart"],
        cwd=ROOT,
        capture_output=True,
        text=True,
        encoding="utf-8",
        check=True,
    )
    return json.loads(result.stdout)


# WORKFLOW.md sections that list keys usable while editing. Dashboard keys only
# work on the start screen; the prefix table and tips are not shortcuts.
SKIP_SECTIONS = ("Dashboard Quick Actions", "Prefix Reference", "Useful Commands", "Workflow Tips")


def read_shortcuts():
    """Shortcut groups parsed from WORKFLOW.md, the single source of the keys."""
    groups, current, skip = [], None, False
    for line in (ROOT / "WORKFLOW.md").read_text(encoding="utf-8").splitlines():
        heading = re.match(r"^(##+) (.+)$", line)
        if heading:
            title = heading.group(2).strip()
            if heading.group(1) == "##":
                skip = title.startswith(SKIP_SECTIONS)
            current = None if skip else {"title": title, "rows": []}
            if current:
                groups.append(current)
            continue
        row = re.match(r"^\| `([^|]+?)` \| ([^|]+?) \| ([^|]+?) \|$", line)
        if current is not None and row:
            # "af` / `if" and "<leader>1` - `<leader>9" hold several keys.
            key = re.sub(r"`\s*([/-])\s*`", r" \1 ", row.group(1).strip())
            current["rows"].append({"key": key, "mode": row.group(2).strip(), "desc": row.group(3).strip()})
    return [g for g in groups if g["rows"]]


def build_exercises_json():
    """Build exercises.json and return it as a dict."""
    # --- Step 1: collect all cases ----------------------------------------
    # Reference cases.  3-tuple: (id, start, keys).
    # 5-tuple: (id, start, keys, startRow, startCol) for non-default cursor.
    _REF_CASES_RAW = [
        # --- original cases from vim_reference.py ---
        ("insert-before", "bc", "ia<Esc>"),
        ("append-after", "ac", "ab<Esc>"),
        ("append-end", "end", "A!<Esc>"),
        ("open-below", "one", "otwo<Esc>"),
        ("open-above", "two", "Oone<Esc>"),
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
        # --- New lesson-1 exercises ---
        ("ctrl-w-insert", "hello world", "A<C-w><Esc>"),
        ("ctrl-u-insert", "hello", "A<C-u><Esc>"),
        ("replace-mode", "hello", "RHi<Esc>"),
        # --- New lesson-2 exercises ---
        # move-l: teach l; $ reaches col 4, never col 2 on a 5-char word
        ("move-l", "abcde", "ll"),
        # move-b: 3w goes to 'dd' (col 9); b backs to 'cc' (col 6).  No single
        # key among $,w,e,b,0,j,G,x reaches col 6 from col 0 on this text.
        ("move-b", "aa bb cc dd", "3wb"),
        ("move-e", "hello world", "e"),
        # move-ge: 2w reaches 'foo' (col 12); ge backs to end of 'world' (col 10)
        ("move-ge", "hello world foo", "2wge"),
        ("move-W", "foo(bar) baz", "W"),
        ("move-E", "foo(bar) baz", "E"),
        # move-0: start at col 5 so 0 (goal col 0) != start col
        ("move-0", "  hello world", "0", 0, 5),
        # move-caret: start at col 10 so ^ (goal col 2) != start col;
        # $ alone goes to col 12 and 0 to col 0 -- neither is col 2
        ("move-caret", "  hello world", "^", 0, 10),
        ("move-G", "one\ntwo\nthree", "G"),
        # move-gg-from-end: start row 3; { from row 3 only reaches blank row 2
        ("move-gg-from-end", "one\ntwo\n\nthree", "gg", 3, 0),
        # count-j: 8-line text so G (row 7) != 5j goal (row 5)
        ("count-j", "a\nb\nc\nd\ne\nf\ng\nh", "5j"),
        # comma-repeat: 3fX reaches col 8; , backs to col 5; l alone -> col 1
        ("comma-repeat", "abXcdXefXg", "3fX,"),
        ("move-F", "hello world", "$Fl"),
        # move-h: start col 4; hh -> col 2.  No single key (0,^,b,w,$,e) reaches col 2.
        ("move-h", "abcde", "hh", 0, 4),
        # move-k: start row 2 col 2; kk -> row 0 col 2.  gg -> (0,0) [wrong col].
        ("move-k", "abc\ndef\nghi", "kk", 2, 2),
        # --- New lesson-3 exercises ---
        ("swap-chars", "ba", "xp"),
        ("delete-end-word", "hello world", "de"),
        ("delete-back-word", "hello world", "wdb"),
        ("delete-to-eol", "hello world", "wd$"),
        ("delete-to-first-line", "one\ntwo\nthree", "jdgg"),
        ("yank-eol-paste", "ab", "y$p"),
        ("yank-word-paste", "ab cd", "yw$p"),
        ("paste-before", "one\ntwo", "yyP"),
        ("move-line", "one\ntwo\nthree", "ddp"),
        ("ce-word", "hello world", "ceHOWDY<Esc>"),
        ("count-J", "a\nb\nc", "3J"),
        ("tilde-char", "hello", "~~~"),
        ("gU-word", "hello world", "gUw"),
        ("gu-word", "HELLO world", "guw"),
        ("g-tilde-word", "Hello World", "g~w"),
        ("count-indent", "one\ntwo\nthree", "3>>"),
        ("dot-repeat", "hello world", "ciwfoo<Esc>w."),
        ("redo-ctrl-r", "abc", "ciwXYZ<Esc>u<C-r>"),
        # dot-dw: dw deletes "aa "; . repeats and deletes "bb "; only "cc" remains.
        ("dot-dw", "aa bb cc", "dw."),
        # --- New lesson-4 exercises ---
        ("delete-around-word", "hello world foo", "wdaw"),
        ("change-inner-paren", "foo(bar)", "4lci(NEW<Esc>"),
        ("change-around-paren", "foo(bar) baz", "4lca(NEW<Esc>"),
        ("change-inner-brace", "if (x) { y }", "9lci{z<Esc>"),
        ("delete-inner-bracket", "arr[idx]", "4ldi["),
        ("delete-around-bracket", "arr[idx] + 1", "4lda["),
        ("change-inner-tag", "<p>foo</p>", "4lcitbar<Esc>"),
        ('yank-inner-quote', 'say "hello" now', '5lyi"$p'),
        ("gUiw", "hello world", "gUiw"),
        ("guiw", "HELLO world", "guiw"),
        ("delete-around-para", "one\ntwo\n\nthree", "dap"),
        ("change-inner-para", "one\ntwo\n\nthree", "cipNEW<Esc>"),
        # delete-around-quote: start col 2 (inside "b"); da" removes "b" -> "ac", cursor col 1
        ('delete-around-quote', 'a"b"c', 'da"', 0, 2),
        # delete-around-brace: start col 3 (inside { x }); da{ removes "{ x }" -> "fn"
        ("delete-around-brace", "fn{ x }", "da{", 0, 3),
        # visual-vd: v + ll selects "hel"; d removes it -> "lo world"
        ("visual-vd", "hello world", "vlld"),
        # visual-Vd: V selects line "one"; j extends to "two"; d removes both -> "three"
        ("visual-Vd", "one\ntwo\nthree", "Vjd"),
        # --- New lesson-5 exercises (search and substitute) ---
        ("search-forward", "one two three", "/three<CR>"),
        ("search-next", "aXbXcX", "/X<CR>n"),
        ("search-star", "foo bar foo", "*"),
        # search-backward: start row 1 col 8 ("two"); ?two<CR> wraps back -> row 0 col 4
        ("search-backward", "aaa two bbb\nbbb bbb two", "?two<CR>", 1, 8),
        # search-hash: start row 0 col 4 ("bar"); # searches back -> row 1 col 0 ("bar")
        ("search-hash", "foo bar\nbar baz\nfoo qux", "#", 0, 4),
        ("substitute", "hello world", ":s/world/vim/<CR>"),
        ("global-substitute", "foo foo bar", ":%s/foo/baz/g<CR>"),
        # --- New lesson-6 exercises (registers and macros) ---
        (
            "register-yank-paste",
            "cat\ndog",
            '"ayyj"ap',
        ),
        ("macro-record", "one\ntwo\nthree", "qaA;<Esc>jq@a"),
        # macro-double-at: qa records "A;<Esc>j"; @a plays on "two"; @@ replays on "three"
        ("macro-double-at", "one\ntwo\nthree", "qaA;<Esc>jq@a@@"),
    ]

    ref_cases = []
    for _item in _REF_CASES_RAW:
        if len(_item) == 3:
            _name, _start, _keys = _item
            ref_cases.append({"id": _name, "start": _start, "keys": _keys})
        else:
            _name, _start, _keys, _row, _col = _item
            ref_cases.append(
                {"id": _name, "start": _start, "keys": _keys, "row": _row, "col": _col}
            )

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
        "shortcuts": read_shortcuts(),
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
