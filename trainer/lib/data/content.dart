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
    required this.solve,
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
  final String solve;
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
  Snippet(
    id: 'php',
    language: 'PHP',
    body: '''function sku(string \$raw): string {
    return strtoupper(trim(\$raw));
}''',
  ),
  Snippet(
    id: 'js',
    language: 'JavaScript',
    body: '''export function clamp(n, min, max) {
  return Math.min(max, Math.max(min, n));
}''',
  ),
  Snippet(
    id: 'java',
    language: 'Java',
    body: '''public final class Sku {
    public static String normalize(String raw) {
        return raw.trim().toUpperCase();
    }
}''',
  ),
  Snippet(
    id: 'kotlin',
    language: 'Kotlin',
    body: '''fun normalize(raw: String): String =
    raw.trim().uppercase()''',
  ),
  Snippet(
    id: 'swift',
    language: 'Swift',
    body: '''func normalize(_ raw: String) -> String {
    raw.trimmingCharacters(in: .whitespaces).uppercased()
}''',
  ),
  Snippet(
    id: 'css',
    language: 'CSS',
    body: '''.card {
  display: flex;
  gap: 8px;
  color: #e6edf3;
}''',
  ),
  Snippet(
    id: 'c',
    language: 'C',
    body: '''int clamp(int n, int min, int max) {
    if (n < min) return min;
    if (n > max) return max;
    return n;
}''',
  ),
  Snippet(
    id: 'cpp',
    language: 'C++',
    body: '''template <typename T>
T clamp(T n, T lo, T hi) {
    return n < lo ? lo : (n > hi ? hi : n);
}''',
  ),
  Snippet(
    id: 'rust',
    language: 'Rust',
    body: '''fn clamp(n: i32, lo: i32, hi: i32) -> i32 {
    n.max(lo).min(hi)
}''',
  ),
  Snippet(
    id: 'csharp',
    language: 'C#',
    body: '''public static class Sku {
    public static string Normalize(string raw) =>
        raw.Trim().ToUpperInvariant();
}''',
  ),
  Snippet(
    id: 'ruby',
    language: 'Ruby',
    body: '''def normalize(raw)
  raw.strip.upcase
end''',
  ),
  Snippet(
    id: 'json',
    language: 'JSON',
    body: '''{
  "ok": true,
  "items": 3
}''',
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
    solve: 'll',
  ),
  Kata(
    id: 'x',
    titleEn: 'Delete the first character',
    titleEs: 'Borra el primer carácter',
    hintEn: 'x deletes the character under the cursor.',
    hintEs: 'x borra el carácter bajo el cursor.',
    start: 'Xhello',
    expect: 'hello',
    solve: 'x',
  ),
  Kata(
    id: 'dd',
    titleEn: 'Delete the middle line',
    titleEs: 'Borra la línea del medio',
    hintEn: 'j then dd.',
    hintEs: 'j y luego dd.',
    start: 'keep\ndelete me\nkeep',
    expect: 'keep\nkeep',
    solve: 'jdd',
  ),
  Kata(
    id: 'dw',
    titleEn: 'Delete the first word',
    titleEs: 'Borra la primera palabra',
    hintEn: 'dw = delete + word motion.',
    hintEs: 'dw = borrar + movimiento de palabra.',
    start: 'remove remaining text',
    expect: 'remaining text',
    solve: 'dw',
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
    solve: 'ciwok<Esc>',
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
    solve: 'ci"yes<Esc>',
  ),
  Kata(
    id: 'insert',
    titleEn: 'Insert at the start of the line',
    titleEs: 'Inserta al inicio de la línea',
    hintEn: 'I then // then Esc.',
    hintEs: 'I luego // luego Esc.',
    start: 'todo',
    expect: '//todo',
    solve: 'I//<Esc>',
  ),
  Kata(
    id: 'yy',
    titleEn: 'Duplicate the line',
    titleEs: 'Duplica la línea',
    hintEn: 'yy then p.',
    hintEs: 'yy y luego p.',
    start: 'row',
    expect: 'row\nrow',
    solve: 'yyp',
  ),
  Kata(
    id: 'join',
    titleEn: 'Join two lines',
    titleEs: 'Junta dos líneas',
    hintEn: 'J',
    hintEs: 'J',
    start: 'foo\nbar',
    expect: 'foo bar',
    solve: 'J',
  ),
  Kata(
    id: 'D',
    titleEn: 'Delete to the end of the line',
    titleEs: 'Borra hasta el final de la línea',
    hintEn: 'D (same as d\$).',
    hintEs: 'D (igual que d\$).',
    start: 'keep DROP',
    col: 5,
    expect: 'keep ',
    solve: 'D',
  ),
  Kata(
    id: 'diw',
    titleEn: 'Delete the word, stay in normal',
    titleEs: 'Borra la palabra y sigue en normal',
    hintEn: 'diw',
    hintEs: 'diw',
    start: 'say hello now',
    col: 4,
    expect: 'say  now',
    solve: 'diw',
  ),
  Kata(
    id: 'percent',
    titleEn: 'Jump to the matching parenthesis',
    titleEs: 'Salta al paréntesis pareja',
    hintEn: '%  (same line only in this app).',
    hintEs: '%  (solo en la misma línea aquí).',
    start: 'foo(bar)',
    col: 3,
    expect: 'foo(bar)',
    expectCol: 7,
    solve: '%',
  ),
  Kata(
    id: 'indent',
    titleEn: 'Indent the line',
    titleEs: 'Indenta la línea',
    hintEn: '>>  (four spaces).',
    hintEs: '>>  (cuatro espacios).',
    start: 'x',
    expect: '    x',
    solve: '>>',
  ),
];
