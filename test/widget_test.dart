import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:offert_app/screens/home_screen.dart';

void main() {
  testWidgets('Home screen smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Offert'), findsOneWidget);
    expect(find.text('Starta nytt projekt'), findsOneWidget);
  });
}
