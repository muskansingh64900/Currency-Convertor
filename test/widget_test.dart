import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:currency/main.dart';

void main() {
  testWidgets('Currency Converter UI Test', (WidgetTester tester) async {
    // Build the app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is displayed.
    expect(find.text('Currency Converter'), findsOneWidget);

    // Verify that the input field is present.
    expect(find.byType(TextField), findsOneWidget);

    // Verify that the convert button is present.
    expect(find.text('Convert'), findsOneWidget);

    // Enter a value into the input field.
    await tester.enterText(find.byType(TextField), '10');

    // Tap the 'Convert' button.
    await tester.tap(find.text('Convert'));
    await tester.pump();

    // Verify that the result is displayed correctly.
    expect(find.text('₹800.00'), findsOneWidget); // 10 * 80 = 800
  });
}
