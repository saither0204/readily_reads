import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:readily_reads/main.dart';

void main() {
  testWidgets('New feature test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ReadilyReads());

    // Verify that a specific widget is present.
    expect(find.text('Welcome to Readily Reads'), findsOneWidget);

    // Interact with the widget and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
  });

  testWidgets('Open add book page', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ReadilyReads());

    // Verify that the add button is present.
    expect(find.byIcon(Icons.add), findsOneWidget);

    // Tap the add button and trigger a frame.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    // Verify that the add book page is opened.
    expect(find.text('Add Book'), findsOneWidget);
  });
}
