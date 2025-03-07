import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readily_reads/main.dart';

Widget createTestApp() {
  return const MaterialApp(
    home: HomePage(),
  );
}

void main() {
  testWidgets('Welcome message test', (WidgetTester tester) async {
    // Build our test app with HomePage directly
    await tester.pumpWidget(createTestApp());

    // Verify that the welcome message is present
    expect(find.text('Welcome to Readily Reads'), findsOneWidget);
    expect(find.text('Your personal reading habit tracker'), findsOneWidget);
  });
}
