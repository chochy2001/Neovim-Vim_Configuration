import 'dart:async';
import 'dart:io';

import 'package:capdesis_practice/data/content.dart';
import 'package:capdesis_practice/main.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

// Only the native selection dialog is replaced. Import validation reads real files.
final class SelectedFile extends PlatformFile {
  SelectedFile(String path) : uri = File(path).uri;
  @override
  final Uri uri;
  @override
  String get name => uri.pathSegments.last;
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class Picker extends FilePickerPlatform {
  List<PlatformFile> files = [];
  Completer<List<PlatformFile>>? pending;
  List<String>? extensions;
  int calls = 0;

  @override
  Future<List<PlatformFile>> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) {
    calls++;
    extensions = allowedExtensions;
    return pending?.future ?? Future.value(files);
  }
}

Future<void> openApp(WidgetTester tester) async {
  tester.view.physicalSize = const Size(1400, 900);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
  await tester.pumpWidget(const PracticeApp());
  await tester.pumpAndSettle();
}

Finder codePanel() => find.byWidgetPredicate(
  (widget) => widget is Text && widget.textSpan != null,
);

List<TextSpan> codeSpans(WidgetTester tester) =>
    (tester.widget<Text>(codePanel()).textSpan! as TextSpan).children!
        .cast<TextSpan>();

void main() {
  late Directory dir;
  late Picker picker;
  late FilePickerPlatform previous;
  setUp(() {
    dir = Directory.systemTemp.createTempSync('practice_ui_');
    previous = FilePickerPlatform.instance;
    picker = Picker();
    FilePickerPlatform.instance = picker;
  });
  tearDown(() {
    FilePickerPlatform.instance = previous;
    dir.deleteSync(recursive: true);
  });
  void select(String name, String body) {
    final file = File('${dir.path}/$name')..writeAsStringSync(body);
    picker.files.add(SelectedFile(file.path));
  }

  testWidgets('import, select and remove files restores built-in exercises', (
    tester,
  ) async {
    select('first.dart', 'a');
    select('second.py', 'b');
    await openApp(tester);
    await tester.tap(find.text('Elegir archivos'));
    await tester.pumpAndSettle();
    expect(find.byType(InputChip), findsNWidgets(2));
    expect(picker.extensions, containsAll(['dart', 'py']));
    expect(find.text('2'), findsOneWidget);
    await tester.tap(find.text('Python second.py'));
    await tester.pump();
    expect(codeSpans(tester).map((s) => s.text).join(), 'b');
    final second = tester.widget<InputChip>(
      find.widgetWithText(InputChip, 'Python second.py'),
    );
    second.onDeleted!();
    await tester.pumpAndSettle();
    expect(find.byType(InputChip), findsOneWidget);
    expect(codeSpans(tester).map((s) => s.text).join(), 'a');
    tester.widget<InputChip>(find.byType(InputChip)).onDeleted!();
    await tester.pumpAndSettle();
    expect(find.text('Dart'), findsOneWidget);
    expect(find.text('Soltar archivos'), findsNothing);
  });

  testWidgets('cancel preserves imported files; drop clears them', (
    tester,
  ) async {
    select('first.dart', 'a');
    await openApp(tester);
    await tester.tap(find.text('Elegir archivos'));
    await tester.pumpAndSettle();
    picker.files = [];
    await tester.tap(find.text('Elegir archivos'));
    await tester.pumpAndSettle();
    expect(find.text('Dart first.dart'), findsOneWidget);
    await tester.tap(find.text('Soltar archivos'));
    await tester.pumpAndSettle();
    expect(find.text('Dart first.dart'), findsNothing);
    expect(find.text('Dart'), findsOneWidget);
  });

  testWidgets('invalid import reports failure in the selected language', (
    tester,
  ) async {
    select('binary.dart', '\u0000');
    await openApp(tester);
    await tester.tap(find.text('Español'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Choose files'));
    await tester.pumpAndSettle();
    expect(find.textContaining('No code files read'), findsOneWidget);
    expect(find.text('Drop files'), findsNothing);
    await tester.tap(find.text('About'));
    await tester.pumpAndSettle();
    expect(find.textContaining('This is not Neovim'), findsOneWidget);
  });

  testWidgets('late picker completion after closing the app is harmless', (
    tester,
  ) async {
    select('first.dart', 'a');
    picker.pending = Completer<List<PlatformFile>>();
    await openApp(tester);
    await tester.tap(find.text('Elegir archivos'));
    await tester.pump();
    await tester.pumpWidget(const SizedBox.shrink());
    picker.pending!.complete(picker.files);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('typing measures errors, corrects with Backspace, and resets', (
    tester,
  ) async {
    select('first.dart', 'ab\n');
    await openApp(tester);
    await tester.tap(find.text('Elegir archivos'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA, character: 'a');
    await tester.sendKeyEvent(LogicalKeyboardKey.keyX, character: 'x');
    await tester.pump();
    expect(find.textContaining('Precisión 50%'), findsOneWidget);
    expect(codeSpans(tester)[1].style!.color, const Color(0xFFF85149));
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyB, character: 'b');
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(codeSpans(tester).single.text, 'ab\n');
    expect(codeSpans(tester).single.style!.color, const Color(0xFF3FB950));
    expect(picker.calls, 1, reason: 'Enter types a newline after importing');
    await tester.sendKeyEvent(LogicalKeyboardKey.keyX, character: 'x');
    await tester.pump();
    expect(
      codeSpans(tester).single.text,
      'ab\n',
      reason: 'completion stops typing',
    );
    await tester.tap(find.text('Reiniciar'));
    await tester.pump();
    expect(find.textContaining('Precisión 100%'), findsOneWidget);
    expect(codeSpans(tester).first.style!.color, const Color(0xFF58A6FF));
  });

  testWidgets('typing can complete imported source containing a tab', (
    tester,
  ) async {
    select('indented.go', '\t');
    await openApp(tester);
    await tester.tap(find.text('Elegir archivos'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.pump();
    expect(codeSpans(tester).single.text, '\t');
    expect(codeSpans(tester).single.style!.color, const Color(0xFF3FB950));
  });

  testWidgets('Vim Enter, Backspace, reset and exercise navigation', (
    tester,
  ) async {
    await openApp(tester);
    await tester.tap(find.text('Vim'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyI, character: 'i');
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.sendKeyEvent(LogicalKeyboardKey.backspace);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pump();
    expect(find.text('NORMAL'), findsOneWidget);
    await tester.tap(find.text('Reiniciar'));
    await tester.tap(find.text('Siguiente'));
    await tester.pumpAndSettle();
    expect(find.text(katas[1].titleEs), findsNWidgets(2));
    await tester.tap(find.widgetWithText(ListTile, katas[0].titleEs));
    await tester.pumpAndSettle();
    expect(find.text(katas[0].titleEs), findsNWidgets(2));
  });
}
