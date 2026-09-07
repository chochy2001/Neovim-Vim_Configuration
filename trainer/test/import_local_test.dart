import 'dart:io';

import 'package:capdesis_practice/data/content.dart';
import 'package:capdesis_practice/data/import_local.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('rejects missing, oversized, empty, binary and invalid UTF-8 files', () {
    final dir = Directory.systemTemp.createTempSync('capdesis_invalid_');
    addTearDown(() => dir.deleteSync(recursive: true));
    expect(snippetFromPath('${dir.path}/missing.dart'), isNull);
    for (final entry in <String, List<int>>{
      'large.dart': List.filled(maxFileBytes + 1, 65),
      'empty.dart': [],
      'binary.dart': [65, 0, 66],
      'invalid.dart': [0xC3, 0x28],
    }.entries) {
      final file = File('${dir.path}/${entry.key}')
        ..writeAsBytesSync(entry.value);
      expect(snippetFromPath(file.path), isNull, reason: entry.key);
    }
  });

  test('selected files deduplicate and respect the 40-file limit', () {
    final dir = Directory.systemTemp.createTempSync('capdesis_limit_');
    addTearDown(() => dir.deleteSync(recursive: true));
    final paths = List.generate(maxFiles + 1, (i) {
      return (File('${dir.path}/$i.dart')..writeAsStringSync('$i')).path;
    });
    final result = loadPaths([paths.first, ...paths]);
    expect(
      result.map((s) => File(s.id).uri),
      paths.take(maxFiles).map((p) => File(p).uri),
    );
  });

  test('folder traversal is ordered and stops at the file limit', () async {
    final dir = Directory.systemTemp.createTempSync('capdesis_folder_limit_');
    addTearDown(() => dir.deleteSync(recursive: true));
    final paths = List.generate(maxFiles + 1, (i) {
      return (File(
        '${dir.path}/${i.toString().padLeft(2, '0')}.dart',
      )..writeAsStringSync('$i')).path;
    });
    final result = await loadProjectFolder(dir.path);
    expect(
      result.map((s) => File(s.id).uri),
      paths.take(maxFiles).map((p) => File(p).uri),
    );
  });

  test(
    'folder traversal handles missing roots and excludes deep files',
    () async {
      final dir = Directory.systemTemp.createTempSync('capdesis_depth_');
      addTearDown(() => dir.deleteSync(recursive: true));
      expect(await loadProjectFolder('${dir.path}/missing'), isEmpty);
      var path = dir.path;
      for (var i = 0; i < maxDepth; i++) {
        path = '$path/child';
      }
      Directory('$path/child').createSync(recursive: true);
      final boundary = File('$path/ok.dart')..writeAsStringSync('at depth 6');
      File('$path/child/excluded.dart').writeAsStringSync('at depth 7');
      final result = await loadProjectFolder(dir.path);
      expect(result.map((s) => File(s.id).uri), [boundary.uri]);
    },
  );

  test('CRLF and BOM imports are typeable using Enter', () async {
    final dir = await Directory.systemTemp.createTemp('capdesis_crlf_');
    try {
      final file = File('${dir.path}/example.py');
      file.writeAsStringSync('\uFEFFone\r\ntwo\r\n');
      expect(snippetFromPath(file.path)!.body, 'one\ntwo\n');
    } finally {
      await dir.delete(recursive: true);
    }
  });
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
    expect(skipDir('venv'), isTrue);
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
