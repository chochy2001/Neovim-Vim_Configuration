import 'dart:io';

import 'package:capdesis_practice/data/content.dart';
import 'package:capdesis_practice/data/import_local.dart';
import 'package:capdesis_practice/engine/vim.dart';
import 'package:capdesis_practice/i18n.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PracticeApp());
}

const _bg = Color(0xFF0D1117);
const _panel = Color(0xFF161B22);
const _hair = Color(0xFF30363D);
const _text = Color(0xFFE6EDF3);
const _muted = Color(0xFF8B949E);
const _accent = Color(0xFF58A6FF);
const _ok = Color(0xFF3FB950);
const _bad = Color(0xFFF85149);

class PracticeApp extends StatelessWidget {
  const PracticeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CAPDESIS Practice',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _bg,
        colorScheme: const ColorScheme.dark(
          surface: _panel,
          primary: _accent,
        ),
        fontFamily: 'Segoe UI',
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool es = true;
  int tab = 0;
  int snippet = 0;
  int kata = 0;
  late Vim vim;
  final typed = StringBuffer();
  DateTime? started;
  int typedCount = 0;
  int correctCount = 0;
  String? vimStatus;
  List<Snippet> imported = [];
  String? importNote;

  T get t => T(es);
  List<Snippet> get pool => imported.isEmpty ? snippets : imported;

  @override
  void initState() {
    super.initState();
    _resetVim();
  }

  void _resetVim() {
    final k = katas[kata];
    vim = Vim(k.start, row: k.row, col: k.col);
    vimStatus = null;
  }

  void _resetType() {
    typed.clear();
    started = null;
    typedCount = 0;
    correctCount = 0;
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    if (tab == 0) {
      _typeKey(event);
      return KeyEventResult.handled;
    }
    _vimKey(event);
    return KeyEventResult.handled;
  }

  void _typeKey(KeyDownEvent event) {
    final target = snippets[snippet].body;
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      final s = typed.toString();
      if (s.isNotEmpty) {
        typed.clear();
        typed.write(s.substring(0, s.length - 1));
        setState(() {});
      }
      return;
    }
    var ch = event.character;
    if (event.logicalKey == LogicalKeyboardKey.enter) ch = '\n';
    if (ch == null || ch.isEmpty) return;
    started ??= DateTime.now();
    typedCount++;
    final next = typed.length;
    if (next < target.length && ch == target[next]) correctCount++;
    typed.write(ch);
    setState(() {});
  }

  void _vimKey(KeyDownEvent event) {
    if (event.logicalKey == LogicalKeyboardKey.arrowLeft ||
        event.logicalKey == LogicalKeyboardKey.arrowRight ||
        event.logicalKey == LogicalKeyboardKey.arrowUp ||
        event.logicalKey == LogicalKeyboardKey.arrowDown) {
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.escape) {
      vim.feed('Escape');
      setState(() {});
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.enter) {
      vim.feed('Enter');
      setState(() {});
      return;
    }
    if (event.logicalKey == LogicalKeyboardKey.backspace) {
      vim.feed('Backspace');
      setState(() {});
      return;
    }
    final ch = event.character;
    if (ch == null || ch.isEmpty) return;
    vim.feed(ch);
    setState(() {});
  }

  void _checkVim() {
    final k = katas[kata];
    final textOk = vim.text == k.expect;
    final colOk = k.expectCol == null || vim.col == k.expectCol;
    setState(() => vimStatus = textOk && colOk ? 'ok' : 'no');
  }

  @override
  Widget build(BuildContext context) {
    return Focus(
      autofocus: true,
      onKeyEvent: _onKey,
      child: Scaffold(
        body: Column(
          children: [
            _top(),
            Expanded(
              child: tab == 0 ? _typewriter() : (tab == 1 ? _vim() : _about()),
            ),
          ],
        ),
      ),
    );
  }

  Widget _top() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: _panel,
        border: Border(bottom: BorderSide(color: _hair)),
      ),
      child: Wrap(
        spacing: 8,
        runSpacing: 4,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          const Text('CAPDESIS Practice',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
          _tab(0, t.typewriter),
          _tab(1, t.vim),
          _tab(2, t.about),
          TextButton(
            onPressed: () => setState(() => es = !es),
            child: Text(t.lang, style: const TextStyle(color: _muted)),
          ),
        ],
      ),
    );
  }

  Widget _tab(int i, String label) {
    final on = tab == i;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: TextButton(
        onPressed: () => setState(() {
          tab = i;
          vimStatus = null;
        }),
        child: Text(label,
            style: TextStyle(color: on ? _accent : _muted, fontSize: 13)),
      ),
    );
  }

  Future<void> _importFiles() async {
    final exts = langByExt.keys.map((e) => e.substring(1)).toList();
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: exts,
    );
    if (result == null) return;
    final paths = result.paths.whereType<String>();
    final got = loadPaths(paths);
    setState(() {
      imported = got;
      snippet = 0;
      importNote = got.isEmpty ? t.importFail : '${got.length}';
      _resetType();
    });
  }

  Future<void> _importFolder() async {
    final path = await FilePicker.platform.getDirectoryPath();
    if (path == null) return;
    final got = await loadProjectFolder(path);
    setState(() {
      imported = got;
      snippet = 0;
      importNote = got.isEmpty ? t.importFail : '${got.length}';
      _resetType();
    });
  }

  void _removeImported(int i) {
    setState(() {
      imported = [...imported]..removeAt(i);
      if (imported.isEmpty) {
        snippet = 0;
        importNote = null;
      } else {
        snippet = snippet.clamp(0, imported.length - 1);
      }
      _resetType();
    });
  }

  void _dropImport() {
    setState(() {
      imported = [];
      snippet = 0;
      importNote = null;
      _resetType();
    });
  }

  Widget _typewriter() {
    final list = pool;
    final i = snippet.clamp(0, list.length - 1);
    final s = list[i];
    final target = s.body;
    final got = typed.toString();
    final secs = started == null
        ? 1.0
        : DateTime.now().difference(started!).inMilliseconds / 1000.0;
    final wpm = secs < 0.4 ? 0 : ((correctCount / 5) / (secs / 60));
    final acc = typedCount == 0 ? 100 : (100 * correctCount / typedCount);

    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(t.typeHint, style: const TextStyle(color: _muted, fontSize: 13)),
          const SizedBox(height: 8),
          Text(t.privacy, style: const TextStyle(color: _muted, fontSize: 12)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              FilledButton(onPressed: _importFiles, child: Text(t.importFiles)),
              OutlinedButton(onPressed: _importFolder, child: Text(t.importFolder)),
              if (imported.isNotEmpty)
                TextButton(onPressed: _dropImport, child: Text(t.clearImport)),
              if (importNote != null)
                Text(importNote!, style: const TextStyle(color: _muted, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 96),
            child: SingleChildScrollView(
              child: Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (var i = 0; i < list.length; i++)
                InputChip(
                  label: Text(
                    imported.isEmpty
                        ? list[i].language
                        : '${list[i].language} ${File(list[i].id).uri.pathSegments.last}',
                  ),
                  selected: i == snippet,
                  onPressed: () => setState(() {
                    snippet = i;
                    _resetType();
                  }),
                  onDeleted: imported.isEmpty ? null : () => _removeImported(i),
                ),
            ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${t.wpm} ${wpm.toStringAsFixed(0)}   ${t.acc} ${acc.toStringAsFixed(0)}%',
            style: const TextStyle(color: _muted, fontFeatures: [FontFeature.tabularFigures()]),
          ),
          const SizedBox(height: 12),
          Expanded(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _panel,
                border: Border.all(color: _hair),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SingleChildScrollView(
                child: Text.rich(_typedSpan(target, got),
                    style: const TextStyle(
                      fontFamily: 'Consolas',
                      fontSize: 16,
                      height: 1.45,
                    )),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextButton(onPressed: () => setState(_resetType), child: Text(t.reset)),
        ],
      ),
    );
  }

  TextSpan _typedSpan(String target, String got) {
    final spans = <InlineSpan>[];
    for (var i = 0; i < target.length; i++) {
      Color c = _muted.withValues(alpha: 0.45);
      if (i < got.length) {
        c = got[i] == target[i] ? _ok : _bad;
      } else if (i == got.length) {
        c = _accent;
      }
      spans.add(TextSpan(text: target[i], style: TextStyle(color: c)));
    }
    return TextSpan(children: spans);
  }

  Widget _vim() {
    final k = katas[kata];
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        children: [
          SizedBox(
            width: 280,
            child: ListView.builder(
              itemCount: katas.length,
              itemBuilder: (context, i) {
                final item = katas[i];
                return ListTile(
                  dense: true,
                  selected: i == kata,
                  title: Text(es ? item.titleEs : item.titleEn,
                      style: const TextStyle(fontSize: 13)),
                  onTap: () => setState(() {
                    kata = i;
                    _resetVim();
                  }),
                );
              },
            ),
          ),
          const VerticalDivider(color: _hair, width: 1),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(es ? k.titleEs : k.titleEn,
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Text(es ? k.hintEs : k.hintEn,
                      style: const TextStyle(color: _muted)),
                  const SizedBox(height: 8),
                  Text(t.vimHint, style: const TextStyle(color: _muted, fontSize: 12)),
                  const SizedBox(height: 8),
                  Text(vim.mode == 'i' ? t.modeI : t.modeN,
                      style: TextStyle(
                        color: vim.mode == 'i' ? const Color(0xFFD29922) : _accent,
                        fontFamily: 'Consolas',
                      )),
                  const SizedBox(height: 12),
                  Expanded(child: _buffer()),
                  const SizedBox(height: 12),
                  if (vimStatus != null)
                    Text(vimStatus == 'ok' ? t.ok : t.notYet,
                        style: TextStyle(color: vimStatus == 'ok' ? _ok : _bad)),
                  Wrap(
                    spacing: 8,
                    children: [
                      FilledButton(onPressed: _checkVim, child: Text(t.check)),
                      TextButton(
                        onPressed: () => setState(_resetVim),
                        child: Text(t.reset),
                      ),
                      TextButton(
                        onPressed: () => setState(() {
                          kata = (kata + 1) % katas.length;
                          _resetVim();
                        }),
                        child: Text(t.next),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buffer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _panel,
        border: Border.all(color: _hair),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DefaultTextStyle(
        style: const TextStyle(fontFamily: 'Consolas', fontSize: 16, color: _text, height: 1.45),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (var r = 0; r < vim.lines.length; r++) _bufferLine(r),
          ],
        ),
      ),
    );
  }

  Widget _bufferLine(int r) {
    final line = vim.lines[r];
    if (r != vim.row) return Text(line.isEmpty ? ' ' : line);
    final c = vim.col.clamp(0, line.length);
    final before = line.substring(0, c);
    final at = c < line.length ? line[c] : ' ';
    final after = c < line.length ? line.substring(c + 1) : '';
    return Text.rich(TextSpan(children: [
      TextSpan(text: before),
      TextSpan(
        text: at,
        style: const TextStyle(backgroundColor: _accent, color: _bg),
      ),
      TextSpan(text: after),
    ]));
  }

  Widget _about() {
    return Padding(
      padding: const EdgeInsets.all(32),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 640),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(t.subset, style: const TextStyle(fontSize: 15, height: 1.5)),
            const SizedBox(height: 12),
            Text(t.keys, style: const TextStyle(fontFamily: 'Consolas', color: _muted)),
            const SizedBox(height: 24),
            Text(t.copy, style: const TextStyle(color: _muted)),
            const SizedBox(height: 8),
            Text(t.unsigned, style: const TextStyle(color: _muted, fontSize: 13)),
          ],
        ),
      ),
    );
  }
}
