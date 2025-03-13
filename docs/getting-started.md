# Getting Started with Readily Reads

This guide will walk you through setting up the Readily Reads project for development.

## Prerequisites

Before you begin, ensure you have the following installed:

- **Flutter SDK** (version: 3.0.0 or later)
  - Download from [flutter.dev](https://flutter.dev/docs/get-started/install)
  - Add Flutter to your PATH
  - Verify installation with `flutter doctor`

- **Dart SDK** (version: 2.17.0 or later)
  - Usually comes with Flutter
  - Verify installation with `dart --version`

- **Android Studio** (for Android development)
  - Download from [developer.android.com](https://developer.android.com/studio)
  - Install Flutter and Dart plugins

- **Xcode** (for iOS development, Mac only)
  - Download from the Mac App Store
  - Install command-line tools with `xcode-select --install`

- **VS Code** (recommended IDE)
  - Download from [code.visualstudio.com](https://code.visualstudio.com/)
  - Install Flutter and Dart extensions

- **Git**
  - Download from [git-scm.com](https://git-scm.com/)
  - Verify installation with `git --version`

## Setting Up the Project

### 1. Clone the Repository

```bash
# Clone the repository
git clone [repository URL]

# Navigate to the project directory
cd readily_reads
```

### 2. Install Dependencies

```bash
# Get Flutter dependencies
flutter pub get
```

Make sure to add the following packages to your `pubspec.yaml` if they're not already included:

```yaml
dependencies:
  flutter:
    sdk: flutter
  sqflite: ^2.0.0+4
  path: ^1.8.0
  shared_preferences: ^2.0.8
  # Add other dependencies as needed
```

### 3. Database Setup

The app uses SQLite for local data storage. The database is initialized automatically when the app runs for the first time. The structure is defined in `book_model.dart` and includes:

- `users` table - Stores user authentication information
- `books` table - Stores book details with foreign key to users

No additional setup is required for the database since it's handled within the app.

### 4. Starting the Development Environment

```bash
# Run the app in debug mode
flutter run
```

This will launch the app on your connected device or emulator.

### 5. Running on Devices/Emulators

#### Android Emulator

1. Open Android Studio
2. Open AVD Manager (Tools > AVD Manager)
3. Create a virtual device if you don't have one
4. Start the emulator
5. Run `flutter run` from the terminal

#### iOS Simulator (Mac only)

1. Open Xcode
2. Open Simulator (Xcode > Open Developer Tool > Simulator)
3. Select a device (File > Open Simulator)
4. Run `flutter run` from the terminal

#### Physical Devices

1. Connect your device via USB
2. Enable USB debugging (Android) or trust the computer (iOS)
3. Run `flutter devices` to verify the device is detected
4. Run `flutter run` to install and launch the app

## Development Workflow

### Project Structure

Readily Reads follows a simple structure with individual Dart files for each main screen:

- `main.dart` - Application entry point and home screen
- `splash_screen.dart` - Initial loading screen
- `login_page.dart` - User authentication
- `add_book_page.dart` - Form to add new books
- `book_list_page.dart` - Simple list view of books
- `book_management_page.dart` - Advanced book management with filtering
- `currently_reading_page.dart` - Books marked as currently reading
- `edit_book_page.dart` - Form to edit existing books
- `book_model.dart` - Book data model and database operations
- `user_model.dart` - User data model and authentication
- `user_session.dart` - Session management with shared preferences

### Code Quality

1. **Linting**:

   ```bash
   # Run Flutter linting
   flutter analyze
   ```

2. **Formatting**:

   ```bash
   # Format Dart code
   flutter format lib/
   ```

3. **Testing**:

   ```bash
   # Run Flutter tests
   flutter test
   ```

### Git Workflow

1. Create a new branch for your feature or bugfix:

   ```bash
   git checkout -b feature/your-feature-name  # or bugfix/your-bugfix-name
   ```

2. Make your changes and commit them with meaningful messages:

   ```bash
   git add .
   git commit -m "Description of the changes"
   ```

3. Push your branch to the remote repository:

   ```bash
   git push origin feature/your-feature-name
   ```

4. Create a Pull Request on GitHub (or your Git platform)

## Building for Release

### Android

1. Create a keystore:

   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. Create `android/key.properties` file:

   ```plaintext
   storePassword=<password from previous step>
   keyPassword=<password from previous step>
   keyAlias=upload
   storeFile=<location of the key store file, such as ~/upload-keystore.jks>
   ```

3. Update `android/app/build.gradle` to use the keystore for signing (refer to Flutter documentation for specifics)

4. Build the APK or App Bundle:

   ```bash
   # For APK
   flutter build apk

   # For App Bundle (Google Play)
   flutter build appbundle
   ```

### iOS (Mac only)

1. Open the project in Xcode:

   ```bash
   cd ios
   open Runner.xcworkspace
   ```

2. Configure signing in Xcode:
   - Select the Runner project in the navigator
   - Select the Runner target
   - Select the Signing & Capabilities tab
   - Choose your team and manage certificates

3. Build the app:

   ```bash
   flutter build ios
   ```

4. Archive the app in Xcode for distribution

## Troubleshooting

If you encounter issues during setup, please refer to the [Troubleshooting Guide](./troubleshooting.md) or open an issue on GitHub.

## Next Steps

- Review the code to understand the application structure
- Try adding a new feature or fixing a bug
- Refer to the [Contributing Guidelines](./contributing.md) to learn how to contribute to the project
