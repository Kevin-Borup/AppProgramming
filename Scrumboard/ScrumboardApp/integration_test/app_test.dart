import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scrumboard_app/main.dart';

void main() {
  testWidgets('Testing assign change', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that our counter starts at 0.
    expect(find.text('date'), findsOneWidget);
    expect(find.text('Kevin'), findsNothing);

    // Tap the '+' icon and trigger a frame.
    await tester.tap(find.byIcon(Icons.account_circle_rounded));
    await tester.pump();

    // Verify that our counter has incremented.
    expect(find.text('date'), findsNothing);
    expect(find.text('Kevin'), findsOneWidget);
  });
}