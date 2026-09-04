class Snippet {
  const Snippet({
    required this.id,
    required this.language,
    required this.body,
  });
  final String id;
  final String language;
  final String body;
}

class Kata {
  const Kata({
    required this.id,
    required this.titleEn,
    required this.titleEs,
    required this.hintEn,
    required this.hintEs,
    required this.start,
    this.row = 0,
    this.col = 0,
    required this.expect,
    this.expectCol,
  });
  final String id;
  final String titleEn;
  final String titleEs;
  final String hintEn;
  final String hintEs;
  final String start;
  final int row;
  final int col;
  final String expect;
  final int? expectCol;
}

/// Short excerpts in the CAPDESIS stack. Not copied from proprietary products.
const snippets = <Snippet>[
  Snippet(
    id: 'dart',
    language: 'Dart',
    body: '''class CartItem {
  const CartItem({required this.sku, required this.qty});
  final String sku;
  final int qty;

  int get total => qty;
}''',
  ),
  Snippet(
    id: 'go',
    language: 'Go',
    body: '''func Health(w http.ResponseWriter, r *http.Request) {
    if r.Method != http.MethodGet {
        w.WriteHeader(http.StatusMethodNotAllowed)
        return
    }
    w.WriteHeader(http.StatusOK)
}''',
  ),
  Snippet(
    id: 'python',
    language: 'Python',
    body: '''def merge(left: list[int], right: list[int]) -> list[int]:
    if not left:
        return right
    if not right:
        return left
    return left + right''',
  ),
  Snippet(
    id: 'ts',
    language: 'TypeScript',
    body: '''export function formatSku(sku: string): string {
  return sku.trim().toUpperCase();
}

export const empty = (): string[] => [];''',
  ),
  Snippet(
    id: 'html',
    language: 'HTML',
    body: '''<label for="email">Email</label>
<input id="email" type="email" required />
<button type="submit">Send</button>''',
  ),
  Snippet(
    id: 'sql',
    language: 'SQL',
    body: '''SELECT id, email
FROM users
WHERE active = TRUE
ORDER BY id;''',
  ),
  Snippet(
    id: 'lua',
    language: 'Lua',
    body: '''local function map(tbl, fn)
  local out = {}
  for i, v in ipairs(tbl) do
    out[i] = fn(v)
  end
  return out
end''',
  ),
  Snippet(
    id: 'bash',
    language: 'Bash',
    body: '''set -euo pipefail
root="\$(cd "\$(dirname "\$0")" && pwd)"
echo "\$root"''',
  ),
];

const katas = <Kata>[
  Kata(
    id: 'hjkl',
    titleEn: 'Move to the last character',
    titleEs: 'Muévete al último carácter',
    hintEn: 'Use l (not the arrow keys).',
    hintEs: 'Usa l (no las flechas).',
    start: 'abc',
    expect: 'abc',
    expectCol: 2,
  ),
  Kata(
    id: 'x',
    titleEn: 'Delete the first character',
    titleEs: 'Borra el primer carácter',
    hintEn: 'x deletes the character under the cursor.',
    hintEs: 'x borra el carácter bajo el cursor.',
    start: 'Xhello',
    expect: 'hello',
  ),
  Kata(
    id: 'dd',
    titleEn: 'Delete the middle line',
    titleEs: 'Borra la línea del medio',
    hintEn: 'j then dd.',
    hintEs: 'j y luego dd.',
    start: 'keep\ndelete me\nkeep',
    expect: 'keep\nkeep',
  ),
  Kata(
    id: 'dw',
    titleEn: 'Delete the first word',
    titleEs: 'Borra la primera palabra',
    hintEn: 'dw = delete + word motion.',
    hintEs: 'dw = borrar + movimiento de palabra.',
    start: 'remove remaining text',
    expect: 'remaining text',
  ),
  Kata(
    id: 'ciw',
    titleEn: 'Change the inner word',
    titleEs: 'Cambia la palabra interior',
    hintEn: 'ciw then type ok, then Esc.',
    hintEs: 'ciw, escribe ok, Esc.',
    start: 'say NOPE now',
    col: 4,
    expect: 'say ok now',
  ),
  Kata(
    id: 'quotes',
    titleEn: 'Change text inside quotes',
    titleEs: 'Cambia el texto entre comillas',
    hintEn: 'ci" then yes then Esc.',
    hintEs: 'ci" luego yes luego Esc.',
    start: 'msg = "no";',
    col: 8,
    expect: 'msg = "yes";',
  ),
  Kata(
    id: 'insert',
    titleEn: 'Insert at the start of the line',
    titleEs: 'Inserta al inicio de la línea',
    hintEn: 'I then // then Esc.',
    hintEs: 'I luego // luego Esc.',
    start: 'todo',
    expect: '//todo',
  ),
  Kata(
    id: 'yy',
    titleEn: 'Duplicate the line',
    titleEs: 'Duplica la línea',
    hintEn: 'yy then p.',
    hintEs: 'yy y luego p.',
    start: 'row',
    expect: 'row\nrow',
  ),
];
