import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:offert_app/screens/home_screen.dart';
import 'package:offert_app/state/app_state.dart';
import 'package:offert_app/services/storage_service.dart';

void main() {
  testWidgets('Home screen renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: HomeScreen(appState: AppState(StorageService())),
      ),
    );

    expect(find.text('Offert'), findsOneWidget);
  });
}
