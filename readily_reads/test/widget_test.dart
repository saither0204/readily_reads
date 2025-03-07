import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:readily_reads/main.dart';
import 'package:readily_reads/add_book_page.dart';

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

  testWidgets('Open add book page', (WidgetTester tester) async {
    // Build with HomePage directly
    await tester.pumpWidget(createTestApp());

    // Find and tap the FloatingActionButton
    expect(find.byType(FloatingActionButton), findsOneWidget);
    await tester.tap(find.byType(FloatingActionButton));
    await tester.pumpAndSettle();

    // Verify that the add book page is opened
    expect(find.text('Add Book'), findsOneWidget);
  });
  testWidgets('Drawer menu test', (WidgetTester tester) async {
    await tester.pumpWidget(createTestApp());

    // Open the drawer
    await tester.dragFrom(
        tester.getTopLeft(find.byType(MaterialApp)), const Offset(300, 0));
    await tester.pumpAndSettle();

    // Check drawer items exist
    expect(find.text('Books'), findsOneWidget);
    expect(find.text('Authors'), findsOneWidget);
    expect(find.text('Genres'), findsOneWidget);
  });
  testWidgets('Add book form test', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: AddBookPage()));

    // Tap the plus icon to show the form
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    // Verify form fields appear
    expect(find.byType(TextField), findsNWidgets(3));
    expect(find.text('Title'), findsOneWidget);
    expect(find.text('Author'), findsOneWidget);
    expect(find.text('Genre'), findsOneWidget);

    // Fill in the form
    await tester.enterText(
        find.widgetWithText(TextField, 'Title'), 'Test Book');
    await tester.enterText(
        find.widgetWithText(TextField, 'Author'), 'Test Author');
    await tester.enterText(
        find.widgetWithText(TextField, 'Genre'), 'Test Genre');

    // Submit the form
    await tester.tap(find.text('Save'));
    await tester.pumpAndSettle();
  });
}
