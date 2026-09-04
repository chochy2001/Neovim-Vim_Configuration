/// Subset of Vim used by CAPDESIS Practice. Not Neovim.
/// Commands are listed in [supported] and covered by test/vim_test.dart.
class Vim {
  Vim(String text, {this.row = 0, this.col = 0})
      : lines = text.isEmpty ? [''] : text.split('\n') {
    col = _clampCol(row, col);
  }

  List<String> lines;
  int row;
  int col;
  String mode = 'n';
  String count = '';
  String? op;
  String? pending;
  String register = '';
  bool linewise = false;
  _Snap? _undo;
  String? _findChar;
  int _findDir = 1;
  bool _findTill = false;

  static const supported = [
    'h j k l  0 ^ \$  w e b  gg G  { }',
    'i a I A o O  Esc  Enter  Backspace',
    'x X  dd dw D  cc C  ciw diw  ci"  J',
    'yy Y  p P  u  r{char}  f t F T ;  % (same line)',
    '>> <<  counts: 3j 2w 3dd',
  ];

  String get text => lines.join('\n');

  void feed(String key) {
    if (pending == 'r') {
      pending = null;
      if (key.length == 1 && mode == 'n' && lines[row].isNotEmpty) {
        _save();
        final line = lines[row];
        lines[row] = line.substring(0, col) + key + line.substring(col + 1);
      }
      return;
    }
    if (pending == 'f' || pending == 'F' || pending == 't' || pending == 'T') {
      _findDir = (pending == 'f' || pending == 't') ? 1 : -1;
      _findTill = pending == 't' || pending == 'T';
      _findChar = key;
      pending = null;
      _doFind();
      return;
    }
    if (pending == 'g') {
      pending = null;
      if (key == 'g') _set(0, 0);
      return;
    }

    if (mode == 'i') {
      if (key == 'Escape') {
        mode = 'n';
        _set(row, col > 0 ? col - 1 : 0);
        return;
      }
      if (key == 'Enter') {
        _save();
        final line = lines[row];
        lines[row] = line.substring(0, col);
        lines.insert(row + 1, line.substring(col));
        row++;
        col = 0;
        return;
      }
      if (key == 'Backspace') {
        if (col > 0) {
          final line = lines[row];
          lines[row] = line.substring(0, col - 1) + line.substring(col);
          col--;
        } else if (row > 0) {
          col = lines[row - 1].length;
          lines[row - 1] += lines[row];
          lines.removeAt(row);
          row--;
        }
        return;
      }
      if (key.length == 1) {
        final line = lines[row];
        lines[row] = line.substring(0, col) + key + line.substring(col);
        col++;
      }
      return;
    }

    if ((op == 'c' || op == 'd' || op == 'y') && key == 'i') {
      pending = '${op}i';
      return;
    }
    if (pending == 'ci' || pending == 'di' || pending == 'yi') {
      final innerOp = pending![0];
      pending = null;
      op = null;
      _changeInner(key, innerOp);
      return;
    }
    if (RegExp(r'^[1-9]$').hasMatch(key) || (count.isNotEmpty && key == '0')) {
      count += key;
      return;
    }
    if (op != null) {
      _doOp(key);
      op = null;
      return;
    }
    if (key == 'd' || key == 'c' || key == 'y') {
      op = key;
      return;
    }
    if (key == 'x') {
      final n = _n();
      final line = lines[row];
      final b = (col + n).clamp(0, line.length);
      _delete(row, col, row, b, false);
      return;
    }
    if (key == 'X') {
      final n = _n();
      final a = (col - n).clamp(0, col);
      _delete(row, a, row, col, false);
      return;
    }
    if (key == 'D') {
      _delete(row, col, row, lines[row].length, false);
      return;
    }
    if (key == 'C') {
      _delete(row, col, row, lines[row].length, false);
      mode = 'i';
      return;
    }
    if (key == 'Y') {
      register = lines[row];
      linewise = true;
      return;
    }
    if (key == 'J') {
      _join();
      return;
    }
    if (key == '%') {
      _percent();
      return;
    }
    if (key == ';') {
      _doFind();
      return;
    }
    if (key == '>' || key == '<') {
      op = key;
      return;
    }
    if (key == 'i') {
      mode = 'i';
      return;
    }
    if (key == 'a') {
      mode = 'i';
      col = (col + 1).clamp(0, lines[row].length);
      return;
    }
    if (key == 'I') {
      mode = 'i';
      final m = lines[row].indexOf(RegExp(r'\S'));
      col = m < 0 ? 0 : m;
      return;
    }
    if (key == 'A') {
      mode = 'i';
      col = lines[row].length;
      return;
    }
    if (key == 'o') {
      _save();
      lines.insert(row + 1, '');
      row++;
      col = 0;
      mode = 'i';
      return;
    }
    if (key == 'O') {
      _save();
      lines.insert(row, '');
      col = 0;
      mode = 'i';
      return;
    }
    if (key == 'p') {
      _paste(true);
      return;
    }
    if (key == 'P') {
      _paste(false);
      return;
    }
    if (key == 'u' && _undo != null) {
      final cur = _Snap(lines, row, col);
      lines = [..._undo!.lines];
      row = _undo!.row;
      col = _undo!.col;
      _undo = cur;
      mode = 'n';
      return;
    }
    if (key == 'r') {
      pending = 'r';
      return;
    }
    if (key == 'f' || key == 'F' || key == 't' || key == 'T') {
      pending = key;
      return;
    }
    if (key == 'g') {
      pending = 'g';
      return;
    }
    _motion(key);
  }

  void feedSeq(String seq) {
    var i = 0;
    while (i < seq.length) {
      if (seq.startsWith('<Esc>', i)) {
        feed('Escape');
        i += 5;
      } else if (seq.startsWith('<CR>', i)) {
        feed('Enter');
        i += 4;
      } else {
        feed(seq[i]);
        i++;
      }
    }
  }

  int _n() {
    final v = int.tryParse(count.isEmpty ? '1' : count) ?? 1;
    count = '';
    return v < 1 ? 1 : v;
  }

  int _clampCol(int r, int c) {
    final line = lines[r];
    final max = mode == 'i' ? line.length : (line.isEmpty ? 0 : line.length - 1);
    return c.clamp(0, max);
  }

  void _set(int r, int c) {
    row = r.clamp(0, lines.length - 1);
    col = _clampCol(row, c);
  }

  void _save() {
    _undo = _Snap(lines, row, col);
  }

  String _kind(String? c) {
    if (c == null || c.isEmpty) return 'end';
    if (RegExp(r'\s').hasMatch(c)) return 'ws';
    if (RegExp(r'[A-Za-z0-9_]').hasMatch(c)) return 'kw';
    return 'punct';
  }

  void _motion(String key) {
    final times = key == '0' || key == '^' || key == '\$' || key == 'G' ? 1 : _n();
    if (key == 'h') {
      _set(row, col - times);
    } else if (key == 'j') {
      _set(row + times, col);
    } else if (key == 'k') {
      _set(row - times, col);
    } else if (key == 'l') {
      _set(row, col + times);
    } else if (key == '0') {
      count = '';
      _set(row, 0);
    } else if (key == '^') {
      final m = lines[row].indexOf(RegExp(r'\S'));
      _set(row, m < 0 ? 0 : m);
    } else if (key == '\$') {
      _set(row, lines[row].isEmpty ? 0 : lines[row].length - 1);
    } else if (key == 'w') {
      for (var i = 0; i < times; i++) {
        _w();
      }
    } else if (key == 'e') {
      for (var i = 0; i < times; i++) {
        _e();
      }
    } else if (key == 'b') {
      for (var i = 0; i < times; i++) {
        _b();
      }
    } else if (key == 'G') {
      final r = count.isEmpty ? lines.length - 1 : int.parse(count) - 1;
      count = '';
      _set(r, 0);
    } else if (key == '{') {
      _blank(-1);
    } else if (key == '}') {
      _blank(1);
    }
  }

  void _w() {
    final line = lines[row];
    final k = _kind(col < line.length ? line[col] : null);
    if (k == 'kw' || k == 'punct') {
      final t = k;
      while (col < line.length && _kind(line[col]) == t) {
        col++;
      }
    }
    while (true) {
      final L = lines[row];
      while (col < L.length && _kind(L[col]) == 'ws') {
        col++;
      }
      if (col < L.length) break;
      if (row == lines.length - 1) {
        col = L.isEmpty ? 0 : L.length - 1;
        break;
      }
      row++;
      col = 0;
    }
  }

  void _e() {
    var line = lines[row];
    if (col < line.length - 1) {
      col++;
    } else if (row < lines.length - 1) {
      row++;
      col = 0;
      line = lines[row];
    }
    while (true) {
      final L = lines[row];
      if (_kind(col < L.length ? L[col] : null) != 'ws') break;
      if (col < L.length - 1) {
        col++;
      } else if (row < lines.length - 1) {
        row++;
        col = 0;
      } else {
        break;
      }
    }
    line = lines[row];
    final t = _kind(col < line.length ? line[col] : null);
    if (t == 'kw' || t == 'punct') {
      while (col < line.length - 1 && _kind(line[col + 1]) == t) {
        col++;
      }
    }
  }

  void _b() {
    if (col == 0 && row == 0) return;
    if (col == 0) {
      row--;
      col = lines[row].isEmpty ? 0 : lines[row].length - 1;
    } else {
      col--;
    }
    while (row > 0 || col > 0) {
      final L = lines[row];
      if (_kind(col < L.length ? L[col] : null) == 'ws') {
        if (col > 0) {
          col--;
        } else if (row > 0) {
          row--;
          col = lines[row].isEmpty ? 0 : lines[row].length - 1;
        } else {
          break;
        }
      } else {
        break;
      }
    }
    final L = lines[row];
    final t = _kind(col < L.length ? L[col] : null);
    if (t == 'kw' || t == 'punct') {
      while (col > 0 && _kind(L[col - 1]) == t) {
        col--;
      }
    }
  }

  void _doOp(String key) {
    if (op == '>' || op == '<') {
      if (key == '>' || key == '<') _indent(op == '>');
      return;
    }
    final startRow = row;
    final startCol = col;
    if (key == op) {
      final times = _n();
      if (op == 'y') {
        register = lines.sublist(row, (row + times).clamp(1, lines.length)).join('\n');
        linewise = true;
      } else {
        _delete(row, 0, row + times - 1, 0, true);
        if (op == 'c') mode = 'i';
      }
      return;
    }
    if ('we\$0hl'.contains(key)) {
      _motion(key);
      final endCol = key == '\$'
          ? lines[startRow].length
          : key == 'e'
              ? col + 1
              : col;
      row = startRow;
      col = startCol;
      if (startRow == row) {
        final a = startCol < endCol ? startCol : endCol;
        final b = startCol < endCol ? endCol : startCol;
        if (op == 'y') {
          register = lines[row].substring(a.clamp(0, lines[row].length), b.clamp(0, lines[row].length));
          linewise = false;
        } else {
          _delete(row, a, row, b, false);
          if (op == 'c') mode = 'i';
        }
      }
    }
  }

  void _changeInner(String key, String innerOp) {
    final line = lines[row];
    int? a;
    int? b;
    if (key == 'w') {
      if (line.isEmpty) {
        if (innerOp == 'c') mode = 'i';
        return;
      }
      final t = _kind(line[col]);
      if (t == 'ws') return;
      a = col;
      b = col;
      while (a! > 0 && _kind(line[a - 1]) == t) {
        a--;
      }
      while (b! < line.length && _kind(line[b]) == t) {
        b++;
      }
    } else {
      final pairs = {'"': '"', "'": "'", '(': ')', '{': '}', '[': ']'};
      final close = pairs[key];
      if (close == null) return;
      final i = line.lastIndexOf(key, col);
      final j = line.indexOf(close, col);
      if (i >= 0 && j > i) {
        a = i + 1;
        b = j;
      }
    }
    if (a == null || b == null) return;
    if (innerOp == 'y') {
      register = line.substring(a, b);
      linewise = false;
      return;
    }
    _delete(row, a, row, b, false);
    if (innerOp == 'c') mode = 'i';
  }

  void _join() {
    if (row >= lines.length - 1) return;
    _save();
    var a = lines[row];
    final b = lines[row + 1].replaceFirst(RegExp(r'^\s+'), '');
    if (a.isNotEmpty && !a.endsWith(' ') && b.isNotEmpty) a += ' ';
    final joinAt = a.length - (a.endsWith(' ') && b.isNotEmpty ? 1 : 0);
    lines[row] = a + b;
    lines.removeAt(row + 1);
    _set(row, joinAt.clamp(0, lines[row].isEmpty ? 0 : lines[row].length - 1));
  }

  void _indent(bool add) {
    _save();
    final n = _n();
    for (var i = 0; i < n && row + i < lines.length; i++) {
      if (add) {
        lines[row + i] = '    ${lines[row + i]}';
      } else {
        lines[row + i] = lines[row + i].replaceFirst(RegExp(r'^ {1,4}'), '');
      }
    }
    _set(row, 0);
  }

  void _blank(int dir) {
    var r = row + dir;
    while (r >= 0 && r < lines.length && lines[r].trim().isNotEmpty) {
      r += dir;
    }
    while (r >= 0 && r < lines.length && lines[r].trim().isEmpty) {
      r += dir;
    }
    if (dir < 0) {
      while (r > 0 && lines[r - 1].trim().isNotEmpty) {
        r--;
      }
    }
    _set(r.clamp(0, lines.length - 1), 0);
  }

  void _doFind() {
    if (_findChar == null) return;
    final line = lines[row];
    final ch = _findChar!;
    if (_findDir > 0) {
      var from = col + 1;
      while (from < line.length) {
        final i = line.indexOf(ch, from);
        if (i < 0) return;
        final land = _findTill ? i - 1 : i;
        if (land > col && land >= 0) {
          col = land;
          return;
        }
        from = i + 1;
      }
    } else {
      var from = col - 1;
      while (from >= 0) {
        final i = line.lastIndexOf(ch, from);
        if (i < 0) return;
        final land = _findTill ? i + 1 : i;
        if (land < col && land < line.length) {
          col = land;
          return;
        }
        from = i - 1;
      }
    }
  }

  void _percent() {
    const openTo = {'(': ')', '[': ']', '{': '}'};
    const closeTo = {')': '(', ']': '[', '}': '{'};
    final line = lines[row];
    if (line.isEmpty) return;
    var c = col < line.length ? line[col] : line[line.length - 1];
    if (!openTo.containsKey(c) && !closeTo.containsKey(c)) {
      for (var i = col; i < line.length; i++) {
        if (openTo.containsKey(line[i]) || closeTo.containsKey(line[i])) {
          col = i;
          c = line[i];
          break;
        }
      }
    }
    if (openTo.containsKey(c)) {
      final close = openTo[c]!;
      var depth = 0;
      for (var i = col; i < line.length; i++) {
        if (line[i] == c) depth++;
        if (line[i] == close) {
          depth--;
          if (depth == 0) {
            col = i;
            return;
          }
        }
      }
    }
    if (closeTo.containsKey(c)) {
      final open = closeTo[c]!;
      var depth = 0;
      for (var i = col; i >= 0; i--) {
        if (line[i] == c) depth++;
        if (line[i] == open) {
          depth--;
          if (depth == 0) {
            col = i;
            return;
          }
        }
      }
    }
  }

  void _delete(int r1, int c1, int r2, int c2, bool lw) {
    _save();
    if (lw) {
      final from = r1 < r2 ? r1 : r2;
      final to = r1 < r2 ? r2 : r1;
      final end = (to + 1).clamp(0, lines.length);
      register = lines.sublist(from, end).join('\n');
      linewise = true;
      lines.removeRange(from, end);
      if (lines.isEmpty) lines = [''];
      _set(from.clamp(0, lines.length - 1), 0);
      return;
    }
    if (r1 != r2) return;
    final line = lines[r1];
    final a = (c1 < c2 ? c1 : c2).clamp(0, line.length);
    final b = (c1 < c2 ? c2 : c1).clamp(0, line.length);
    register = line.substring(a, b);
    linewise = false;
    lines[r1] = line.substring(0, a) + line.substring(b);
    _set(r1, a);
  }

  void _paste(bool after) {
    if (register.isEmpty) return;
    _save();
    if (linewise) {
      final block = register.split('\n');
      final at = after ? row + 1 : row;
      lines.insertAll(at, block);
      _set(at, 0);
      return;
    }
    final line = lines[row];
    final i = after ? (col + 1).clamp(0, line.length) : col;
    lines[row] = line.substring(0, i) + register + line.substring(i);
    _set(row, i);
  }
}

class _Snap {
  _Snap(List<String> l, this.row, this.col) : lines = [...l];
  final List<String> lines;
  final int row;
  final int col;
}
