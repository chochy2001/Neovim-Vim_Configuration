import 'package:capdesis_practice/main.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('app title', (tester) async {
    await tester.pumpWidget(const PracticeApp());
    expect(find.text('CAPDESIS Practice'), findsOneWidget);
  });
}
