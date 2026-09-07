import 'dart:convert';
import 'dart:io';

import 'package:capdesis_practice/engine/vim.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final data = jsonDecode(
    File('test/fixtures/neovim.json').readAsStringSync(),
  ) as Map<String, dynamic>;
  for (final raw in data['cases'] as List) {
    final c = raw as Map<String, dynamic>;
    test('Neovim reference: ${c['id']}', () {
      final v = Vim(
        c['start'] as String,
        row: c['row'] as int? ?? 0,
        col: c['col'] as int? ?? 0,
      );
      v.feedSeq(c['keys'] as String);
      final expected = c['expected'] as Map<String, dynamic>;
      expect({
        'text': v.text,
        'row': v.row,
        'col': v.col,
        'mode': v.mode,
      }, expected);
    });
  }
}
