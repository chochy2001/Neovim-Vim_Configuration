import 'package:capdesis_practice/main.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('About does not feed hidden Vim commands', (tester) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const PracticeApp());
    await tester.tap(find.text('Acerca de'));
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyI, character: 'i');
    await tester.tap(find.text('Vim'));
    await tester.pumpAndSettle();
    expect(find.text('NORMAL'), findsOneWidget);
    expect(find.text('INSERTAR'), findsNothing);
  });
  testWidgets('check requires leaving insert mode and clears stale success', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1200, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const PracticeApp());
    await tester.tap(find.text('Vim'));
    await tester.pumpAndSettle();
    for (var i = 0; i < 2; i++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.keyL, character: 'l');
    }
    await tester.sendKeyEvent(LogicalKeyboardKey.keyI, character: 'i');
    await tester.tap(find.text('Comprobar'));
    await tester.pumpAndSettle();
    expect(find.text('Aún no'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyL, character: 'l');
    await tester.tap(find.text('Comprobar'));
    await tester.pumpAndSettle();
    expect(find.text('Hecho'), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyX, character: 'x');
    await tester.pump();
    expect(find.text('Hecho'), findsNothing);
  });
  testWidgets('tabs and about', (tester) async {
    tester.view.physicalSize = const Size(1400, 900);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const PracticeApp());
    expect(find.text('CAPDESIS Practice'), findsWidgets);
    expect(find.text('Dart'), findsOneWidget);
    expect(find.text('Go'), findsOneWidget);
    await tester.tap(find.text('Vim'));
    await tester.pumpAndSettle();
    expect(find.text('Comprobar'), findsOneWidget);
    await tester.tap(find.text('Acerca de'));
    await tester.pumpAndSettle();
    expect(find.textContaining('MIT'), findsOneWidget);
  });
}
