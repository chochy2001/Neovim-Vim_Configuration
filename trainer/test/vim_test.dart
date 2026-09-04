import 'package:capdesis_practice/data/content.dart';
import 'package:capdesis_practice/engine/vim.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('hjkl and line ends', () {
    final v = Vim('ab\ncd');
    v.feed('l');
    expect(v.col, 1);
    v.feed('l');
    expect(v.col, 1);
    v.feed('j');
    expect(v.row, 1);
    expect(v.col, 1);
    v.feed('0');
    expect(v.col, 0);
    v.feed('\$');
    expect(v.col, 1);
  });

  test('word motions', () {
    final v = Vim('foo(bar) baz');
    v.feed('w');
    expect(v.col, 3);
    v.feed('w');
    expect(v.col, 4);
    v.feed('w');
    expect(v.col, 7);
    v.feed('w');
    expect(v.col, 9);
    v.feed('b');
    expect(v.col, 7);
  });

  test('gg G counts', () {
    final v = Vim('a\nb\nc');
    v.feedSeq('G');
    expect(v.row, 2);
    v.feedSeq('gg');
    expect(v.row, 0);
    v.feedSeq('2G');
    expect(v.row, 1);
    v.feedSeq('3j');
    expect(v.row, 2);
  });

  test('x dd dw', () {
    final v = Vim('hello world');
    v.feed('x');
    expect(v.text, 'ello world');
    v.feedSeq('dw');
    expect(v.text, 'world');
    final v2 = Vim('one\ntwo\nthree');
    v2.feedSeq('dd');
    expect(v2.text, 'two\nthree');
    v2.feedSeq('3dd');
    expect(v2.text, '');
  });

  test('insert and escape', () {
    final v = Vim('ab');
    v.feedSeq('liX<Esc>');
    expect(v.mode, 'n');
    expect(v.text, 'aXb');
  });

  test('ciw', () {
    final v = Vim('say hello now', col: 4);
    v.feedSeq('ciwbye<Esc>');
    expect(v.text, 'say bye now');
  });

  test('ci"', () {
    final v = Vim('n = "old";', col: 6);
    v.feedSeq('ci"new<Esc>');
    expect(v.text, 'n = "new";');
  });

  test('yy p', () {
    final v = Vim('alpha\nbeta');
    v.feedSeq('yyp');
    expect(v.text, 'alpha\nalpha\nbeta');
  });

  test('u undoes delete', () {
    final v = Vim('keep');
    v.feedSeq('dd');
    expect(v.text, '');
    v.feed('u');
    expect(v.text, 'keep');
  });

  test('f char', () {
    final v = Vim('catch');
    v.feedSeq('ft');
    expect(v.col, 2);
  });

  test('cw changes word', () {
    final v = Vim('old new');
    v.feedSeq('cwNEW<Esc>');
    expect(v.text.startsWith('NEW'), true);
  });

  test('J joins lines', () {
    final v = Vim('foo\nbar');
    v.feed('J');
    expect(v.text, 'foo bar');
  });

  test('D deletes to end of line', () {
    final v = Vim('keep drop', col: 5);
    v.feed('D');
    expect(v.text, 'keep ');
  });

  test('diw deletes inner word', () {
    final v = Vim('say hello now', col: 4);
    v.feedSeq('diw');
    expect(v.text, 'say  now');
  });

  test('% jumps to matching paren on the same line', () {
    final v = Vim('foo(bar)', col: 3);
    v.feed('%');
    expect(v.col, 7);
    v.feed('%');
    expect(v.col, 3);
  });

  test('>> indents four spaces', () {
    final v = Vim('x');
    v.feedSeq('>>');
    expect(v.text, '    x');
  });

  test('t and ; find till', () {
    final v = Vim('abXcdX');
    v.feedSeq('tX');
    expect(v.col, 1);
    v.feed(';');
    expect(v.col, 4);
  });

  test('every kata solve sequence reaches expect', () {
    for (final k in katas) {
      final v = Vim(k.start, row: k.row, col: k.col);
      v.feedSeq(k.solve);
      expect(v.text, k.expect, reason: k.id);
      if (k.expectCol != null) {
        expect(v.col, k.expectCol, reason: k.id);
      }
    }
  });
}
