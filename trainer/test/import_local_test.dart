import 'dart:io';

import 'package:capdesis_practice/data/content.dart';
import 'package:capdesis_practice/data/import_local.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('language map covers common extensions', () {
    expect(languageFor('a.go'), 'Go');
    expect(languageFor('a.java'), 'Java');
    expect(languageFor('a.kt'), 'Kotlin');
    expect(languageFor('a.swift'), 'Swift');
    expect(languageFor('a.sql'), 'SQL');
    expect(languageFor('a.rs'), 'Rust');
    expect(languageFor('a.exe'), isNull);
  });

  test('skip heavy vendor dirs', () {
    expect(skipDir('node_modules'), isTrue);
    expect(skipDir('.git'), isTrue);
    expect(skipDir('lib'), isFalse);
  });

  test('builtin snippets are 20 languages', () {
    expect(snippets.length, 20);
    expect(snippets.map((s) => s.language).toSet().length, 20);
    for (final s in snippets) {
      expect(s.body.trim(), isNotEmpty, reason: s.id);
    }
  });

  test('loadPaths keeps only chosen files', () async {
    final dir = await Directory.systemTemp.createTemp('capdesis_pick_');
    try {
      final a = File('${dir.path}/a.go')..writeAsStringSync('package main');
      final b = File('${dir.path}/b.java')..writeAsStringSync('class A {}');
      File('${dir.path}/skip.bin').writeAsBytesSync([0, 1, 0]);
      final got = loadPaths([a.path, b.path, '${dir.path}/skip.bin']);
      expect(got.length, 2);
      expect(got.map((s) => s.language).toSet(), {'Go', 'Java'});
    } finally {
      await dir.delete(recursive: true);
    }
  });

  test('loadProjectFolder reads a temp dart file and skips .git', () async {
    final dir = await Directory.systemTemp.createTemp('capdesis_practice_');
    try {
      await File('${dir.path}/ok.dart').writeAsString('void main() {}');
      await Directory('${dir.path}/.git').create();
      await File('${dir.path}/.git/x.dart').writeAsString('secret');
      await Directory('${dir.path}/node_modules').create();
      await File('${dir.path}/node_modules/x.js').writeAsString('nope');
      final got = await loadProjectFolder(dir.path);
      expect(got.length, 1);
      expect(got.first.body, 'void main() {}');
      expect(got.first.language.startsWith('Dart'), isTrue);
    } finally {
      await dir.delete(recursive: true);
    }
  });
}
