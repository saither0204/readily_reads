# Troubleshooting Guide for Readily Reads

This guide provides solutions for common issues you might encounter when developing, building, or using Readily Reads.

## Table of Contents

- [Development Environment Issues](#development-environment-issues)
- [Database Issues](#database-issues)
- [Authentication Issues](#authentication-issues)
- [UI and Rendering Issues](#ui-and-rendering-issues)
- [Book Management Issues](#book-management-issues)
- [Build and Deployment Issues](#build-and-deployment-issues)
- [Performance Issues](#performance-issues)
- [Common Error Messages](#common-error-messages)
- [Getting Additional Help](#getting-additional-help)

## Development Environment Issues

### Flutter SDK Not Found

**Problem**: Flutter commands aren't recognized or "flutter: command not found" error.

**Solutions**:

1. Verify Flutter is installed:

   ```bash
   which flutter
   ```

2. Add Flutter to your PATH:

   ```bash
   export PATH="$PATH:[PATH_TO_FLUTTER_DIRECTORY]/flutter/bin"
   ```

3. Add to your profile file (~/.bash_profile, ~/.zshrc, etc.) for permanent setup

### Dependencies Issues

**Problem**: Issues with pub get or missing dependencies.

**Solutions**:

1. Verify `pubspec.yaml` is correctly formatted
2. Run pub get with verbose flag to see detailed errors:

   ```bash
   flutter pub get -v
   ```

3. Make sure you have these key dependencies for Readily Reads:

   ```yaml
   dependencies:
     flutter:
       sdk: flutter
     sqflite: ^2.0.0
     path: ^1.8.0
     shared_preferences: ^2.0.0
   ```

4. Clear pub cache if needed:

   ```bash
   flutter pub cache clean
   ```

### IDE Issues

**Problem**: IDE not properly recognizing Flutter code or showing errors.

**Solutions**:

1. Verify Flutter and Dart plugins are installed in your IDE
2. Restart the IDE
3. Invalidate caches/restart (for Android Studio)
4. Run flutter doctor to check for issues:

   ```bash
   flutter doctor -v
   ```

## Database Issues

### Database Initialization Errors

**Problem**: App crashes with database initialization errors.

**Solutions**:

1. Check the `BookDatabaseHelper` and initialization in `book_model.dart`:
   - Verify the database version
   - Ensure tables are created correctly

2. Debug the database path:

   ```dart
   String path = join(await getDatabasesPath(), 'readily_reads_database.db');
   print('Database path: $path'); // Check this path exists and is writable
   ```

3. Check `_createDb` method for errors:

   ```dart
   Future<void> _createDb(Database db, int version) async {
     // Verify SQL syntax is correct in these CREATE TABLE statements
   }
   ```

4. If database schema changed, increment the version number and implement `_upgradeDb`

### Data Not Persisting

**Problem**: Books added to the library don't persist after app restart.

**Solutions**:

1. Verify insert/update operations are completing successfully:

   ```dart
   final success = await bookService.addBook(book);
   print('Book added successfully: $success');
   ```

2. Check for error handling in database operations:

   ```dart
   try {
     // Database operation
   } catch (e) {
     print('Database error: $e');
     // Make sure errors are properly shown to the user
   }
   ```

3. Verify the user ID is correctly associated with books:

   ```dart
   // Check that getCurrentUserId() returns the expected value
   final userId = await UserSession.getCurrentUserId();
   print('Current user ID: $userId');
   ```

4. Check database queries for correct WHERE clauses

## Authentication Issues

### Login Problems

**Problem**: Unable to log in or register.

**Solutions**:

1. Check `LoginService` methods for errors:

   ```dart
   // In login_page.dart
   final success = await _loginService.loginUser(
     _usernameController.text.trim(),
     _passwordController.text,
   );
   print('Login success: $success');
   ```

2. Verify user table is created properly in database:

   ```sql
   CREATE TABLE IF NOT EXISTS users(
     id INTEGER PRIMARY KEY AUTOINCREMENT,
     username TEXT UNIQUE,
     password TEXT
   )
   ```

3. Check for duplicate username handling during registration
4. Verify SharedPreferences initialization for user session

### Session Management Issues

**Problem**: User is logged out unexpectedly or session not maintained.

**Solutions**:

1. Check `UserSession` methods for issues:

   ```dart
   // Verify session is saved correctly
   final sessionSaved = await UserSession.saveUserSession(userId, username);
   print('Session saved: $sessionSaved');
   ```

2. Verify SharedPreferences is working:

   ```dart
   // Debug session retrieval
   final userId = await UserSession.getCurrentUserId();
   final username = await UserSession.getCurrentUsername();
   print('Current session: User ID=$userId, Username=$username');
   ```

3. Check for permission issues with app storage

## UI and Rendering Issues

### Layout Overflow

**Problem**: Yellow-black overflow warnings in UI.

**Solutions**:

1. Wrap content with `SingleChildScrollView` where appropriate:

   ```dart
   SingleChildScrollView(
     child: Column(
       children: [
         // Your widgets
       ],
     ),
   )
   ```

2. Use `Expanded` or `Flexible` in rows and columns:

   ```dart
   Row(
     children: [
       Expanded(
         child: Text('This text can shrink if needed'),
       ),
       Icon(Icons.star),
     ],
   )
   ```

3. Set appropriate constraints on containers and other widgets

### Theme and Styling Issues

**Problem**: Inconsistent colors or styling throughout the app.

**Solutions**:

1. Use the app's color scheme consistently:

   ```dart
   final ColorScheme colorScheme = Theme.of(context).colorScheme;
   
   // Use colorScheme.primary, colorScheme.surface, etc. consistently
   ```

2. Check for hardcoded colors that should use the theme instead
3. Ensure text styles are consistent

### Book Card Display Issues

**Problem**: Book cards not displaying properly in list views.

**Solutions**:

1. Check the `_buildBookCard` methods in `book_list_page.dart`, `book_management_page.dart`, etc.
2. Verify data is correctly passed to the card widgets
3. Ensure text overflow is handled:

   ```dart
   Text(
     book.title,
     overflow: TextOverflow.ellipsis,
     maxLines: 2,
   )
   ```

## Book Management Issues

### Book Creation Issues

**Problem**: Unable to add new books or missing fields.

**Solutions**:

1. Check form validation in `add_book_page.dart`:

   ```dart
   // Verify required fields are properly checked
   if (title.isEmpty || author.isEmpty || genre.isEmpty) {
     // Show error message
   }
   ```

2. Debug book object creation:

   ```dart
   final book = Book(
     title: title,
     author: author,
     // other fields
   );
   print('Book object: $book');
   ```

3. Verify the database insert operation completes:

   ```dart
   final success = await bookService.addBook(book);
   print('Book added: $success');
   ```

### Filter and Search Issues

**Problem**: Filtering or search not working as expected.

**Solutions**:

1. Debug the filter logic in `book_management_page.dart`:

   ```dart
   // Check filter values
   print('Selected genre: $_selectedGenre');
   print('Search query: $_searchQuery');
   print('Sort by: $_sortBy');
   ```

2. Verify the filter application in `_applyFilters()` method:

   ```dart
   // Place debug prints to show the size of lists at each step
   print('Before genre filter: ${booksToFilter.length}');
   // Apply genre filter
   print('After genre filter: ${booksToFilter.length}');
   // and so on
   ```

3. Check sort implementation for each sort option
4. Test search functionality with various queries

### Currently Reading Status Issues

**Problem**: Issues with marking books as "currently reading".

**Solutions**:

1. Debug the toggle method in `book_management_page.dart`:

   ```dart
   Future<void> _toggleReadingStatus(Book book) async {
     print('Toggling reading status. Current: ${book.isCurrentlyReading}');
     // Rest of method
   }
   ```

2. Verify database update is working correctly
3. Check that UI reflects the status change
4. Ensure the Currently Reading tab shows the correct books

## Build and Deployment Issues

### Android Build Failures

**Problem**: `flutter build apk` or `flutter build appbundle` fails.

**Solutions**:

1. Check Gradle version compatibility
2. Clean build cache:

   ```bash
   flutter clean
   cd android
   ./gradlew clean
   cd ..
   flutter pub get
   flutter build apk
   ```

3. Verify AndroidManifest.xml is properly configured
4. Check for Android SDK version issues in build.gradle

### iOS Build Failures

**Problem**: `flutter build ios` fails.

**Solutions**:

1. Update CocoaPods:

   ```bash
   sudo gem install cocoapods
   ```

2. Reinstall pods:

   ```bash
   cd ios
   pod deintegrate
   pod setup
   pod install
   ```

3. Check signing certificate and provisioning profile in Xcode
4. Verify Info.plist is properly configured

## Performance Issues

### Slow UI Rendering

**Problem**: UI feels sluggish or animations aren't smooth.

**Solutions**:

1. Optimize database queries:
   - Check for unnecessary frequent calls to the database
   - Add indices to frequently queried columns

2. Reduce widget rebuilds:
   - Use `const` constructors where possible
   - Extract widgets to minimize rebuild scope

3. Run in profile mode to identify issues:

   ```bash
   flutter run --profile
   ```

### Memory Usage Issues

**Problem**: App memory usage grows over time.

**Solutions**:

1. Properly dispose controllers and streams:

   ```dart
   @override
   void dispose() {
     titleController.dispose();
     authorController.dispose();
     // Other controllers
     super.dispose();
   }
   ```

2. Check for large in-memory book lists:
   - Consider pagination or limiting result sets
   - Avoid keeping duplicate lists in memory

## Common Error Messages

### "No such table: books" or "No such table: users"

**Problem**: Database tables not created.

**Solutions**:

1. Check database initialization in `BookDatabaseHelper._createDb`
2. Verify table creation SQL syntax
3. Consider dropping and recreating the database:

   ```dart
   // For development only:
   final databasesPath = await getDatabasesPath();
   final path = join(databasesPath, 'readily_reads_database.db');
   await deleteDatabase(path);
   ```

### "Unhandled Exception: DatabaseException"

**Problem**: Database query errors.

**Solutions**:

1. Check SQL syntax in queries
2. Verify table and column names
3. Add proper error handling:

   ```dart
   try {
     final Database db = await database;
     return await db.query('books', where: 'userId = ?', whereArgs: [userId]);
   } catch (e) {
     print('Database error: $e');
     // Handle error
     return [];
   }
   ```

### "setState() called after dispose()"

**Problem**: Trying to update state after widget is disposed.

**Solutions**:

1. Add mounted checks before setState:

   ```dart
   if (mounted) {
     setState(() {
       _isLoading = false;
     });
   }
   ```

2. Cancel any async operations in dispose method

## Getting Additional Help

If you're still experiencing issues after trying the solutions in this guide:

1. Check the [Flutter GitHub issues](https://github.com/flutter/flutter/issues) for similar problems
2. Search on [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter) with the Flutter tag
3. Check SQLite documentation for database-related issues
4. Create a minimal reproducible example of your issue
5. File an issue on our GitHub repository with:
   - Detailed description of the problem
   - Steps to reproduce
   - Environment details (Flutter version, device, OS)
   - Error messages and stack traces
   - Screenshots if applicable
