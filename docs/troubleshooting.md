# Troubleshooting Guide for [Your Mobile App Name]

This guide provides solutions for common issues you might encounter when developing, building, or using [Your Mobile App Name].

## Table of Contents

- [Development Environment Issues](#development-environment-issues)
- [Flutter and Dart Issues](#flutter-and-dart-issues)
- [Build and Deployment Issues](#build-and-deployment-issues)
- [UI and Rendering Issues](#ui-and-rendering-issues)
- [State Management Issues](#state-management-issues)
- [API and Network Issues](#api-and-network-issues)
- [Device-Specific Issues](#device-specific-issues)
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

### Android Studio Issues

**Problem**: Android Studio not detecting Flutter plugin or SDK.

**Solutions**:

1. Verify Flutter plugin is installed:
   - Go to Preferences/Settings > Plugins
   - Search for "Flutter" and install if not present
2. Configure Flutter SDK path:
   - Go to Preferences/Settings > Languages & Frameworks > Flutter
   - Set Flutter SDK path to your Flutter installation directory
3. Invalidate caches and restart:
   - File > Invalidate Caches / Restart

### iOS Development Setup Issues

**Problem**: Xcode or iOS simulator problems.

**Solutions**:

1. Verify Xcode is installed and set up:

   ```bash
   xcode-select --print-path
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   ```

2. Install CocoaPods:

   ```bash
   sudo gem install cocoapods
   ```

3. Run pod installation:

   ```bash
   cd ios
   pod install
   ```

4. Open simulator:

   ```bash
   open -a Simulator
   ```

### Flutter Doctor Errors

**Problem**: `flutter doctor` shows errors or warnings.

**Solution**: Follow the specific recommendations from `flutter doctor`. Common fixes include:

1. Android toolchain issues:

   ```bash
   flutter doctor --android-licenses
   ```

2. Xcode issues:

   ```bash
   sudo xcode-select --switch /Applications/Xcode.app/Contents/Developer
   sudo xcodebuild -runFirstLaunch
   ```

3. Missing dependencies:

   ```bash
   flutter pub get
   ```

## Flutter and Dart Issues

### Package Get Errors

**Problem**: `flutter pub get` fails.

**Solutions**:

1. Check internet connection
2. Verify `pubspec.yaml` format is correct
3. Clear pub cache:

   ```bash
   flutter pub cache clean
   ```

4. Check for dependency conflicts in `pubspec.yaml`
5. Try running with verbose flag:

   ```bash
   flutter pub get -v
   ```

### Hot Reload Not Working

**Problem**: Changes aren't reflected when using hot reload.

**Solutions**:

1. Check if the changes are in a `build` method or stateless widget
2. Verify the app isn't paused in the debugger
3. Try hot restart instead (`Shift + r` in terminal)
4. Restart the app completely
5. Check for errors in console output

### Null Safety Migration Issues

**Problem**: Null safety related errors.

**Solutions**:

1. Make sure all dependencies support null safety
2. Properly annotate nullable types with `?`:

   ```dart
   String? nullableString;
   ```

3. Use the null-aware operators (`?.`, `??`, `!`):

   ```dart
   final value = nullableObject?.property ?? defaultValue;
   ```

4. Run migration tool:

   ```bash
   dart migrate
   ```

## Build and Deployment Issues

### Android Build Failures

**Problem**: `flutter build apk` or `flutter build appbundle` fails.

**Solutions**:

1. Check Gradle version compatibility
2. Update the Android plugin:

   ```bash
   flutter pub upgrade
   ```

3. Check for Java version issues:

   ```bash
   java -version
   ```

4. Clean build:

   ```bash
   flutter clean
   cd android
   ./gradlew clean
   cd ..
   flutter pub get
   flutter build apk
   ```

5. Check for specific error messages in build output

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
4. Clear derived data:

   ```bash
   rm -rf ~/Library/Developer/Xcode/DerivedData
   ```

5. Update iOS deployment target in Xcode

### Code Signing Issues

**Problem**: Issues with code signing for release builds.

**Solutions**:

1. **Android**:
   - Verify key.properties file is correctly set up
   - Ensure keystore file exists at the specified path
   - Check password is correct

2. **iOS**:
   - Verify Apple Developer account has a valid subscription
   - Check provisioning profiles in Xcode
   - Update certificates in Keychain Access
   - Use automatic signing for testing

## UI and Rendering Issues

### Layout Overflow

**Problem**: Yellow-black overflow warnings in UI.

**Solutions**:

1. Wrap widgets with `SingleChildScrollView` for scrollable content
2. Use `Expanded` or `Flexible` within `Row` or `Column`
3. Constrain sizes with `SizedBox` or `Container`
4. Use `FittedBox` to scale content
5. Enable `debugDumpApp()` to inspect widget tree

### Font and Image Issues

**Problem**: Custom fonts or images not displaying.

**Solutions**:

1. Verify assets are correctly declared in `pubspec.yaml`:

   ```yaml
   flutter:
     assets:
       - assets/images/
     fonts:
       - family: CustomFont
         fonts:
           - asset: assets/fonts/CustomFont-Regular.ttf
           - asset: assets/fonts/CustomFont-Bold.ttf
             weight: 700
   ```

2. Check file paths and case sensitivity
3. Run `flutter clean` and `flutter pub get`
4. Verify the files exist in the assets directory
5. Check image format compatibility

### Responsive Design Issues

**Problem**: App doesn't adapt well to different screen sizes.

**Solutions**:

1. Use `MediaQuery` to get screen dimensions:

   ```dart
   final screenWidth = MediaQuery.of(context).size.width;
   ```

2. Use `LayoutBuilder` for container-based constraints:

   ```dart
   LayoutBuilder(
     builder: (context, constraints) {
       if (constraints.maxWidth > 600) {
         return WideLayout();
       } else {
         return NarrowLayout();
       }
     },
   )
   ```

3. Use `FractionallySizedBox` for proportional sizing
4. Implement responsive font sizing
5. Use appropriate widgets like `Expanded`, `Flexible`, and `AspectRatio`

## State Management Issues

### State Not Updating UI

**Problem**: Changes to state don't reflect in the UI.

**Solutions**:

1. Verify you're calling `setState(() {})` in StatefulWidget
2. Check that you're modifying the actual state variable
3. Ensure state provider is correctly set up (Provider, Bloc, etc.)
4. Verify widgets are listening to state changes
5. Check for immutable objects that need to be copied

### Provider Specific Issues

**Problem**: Provider package not working as expected.

**Solutions**:

1. Verify `ChangeNotifierProvider` is above widgets that need the data
2. Use `Consumer` or `context.watch()` to listen to changes:

   ```dart
   Consumer<MyModel>(
     builder: (context, model, child) {
       return Text(model.data);
     },
   )
   ```

3. Ensure `notifyListeners()` is called when data changes
4. Check provider is using the correct type

### BLoC Pattern Issues

**Problem**: BLoC pattern implementation issues.

**Solutions**:

1. Verify events are being added to the BLoC:

   ```dart
   myBloc.add(MyEvent());
   ```

2. Check that state changes in response to events
3. Ensure `BlocBuilder` or `BlocListener` is used correctly:

   ```dart
   BlocBuilder<MyBloc, MyState>(
     builder: (context, state) {
       if (state is LoadingState) {
         return CircularProgressIndicator();
       } else if (state is LoadedState) {
         return Text(state.data);
       } else {
         return Text('Error');
       }
     },
   )
   ```

4. Check for proper event handling in the BLoC

## API and Network Issues

### API Connection Failures

**Problem**: App fails to connect to backend API.

**Solutions**:

1. Verify internet connection on device
2. Check API URL is correct:

   ```dart
   final apiUrl = 'https://api.example.com/endpoint';
   ```

3. Verify HTTP client setup:

   ```dart
   final response = await http.get(
     Uri.parse(apiUrl),
     headers: {'Authorization': 'Bearer $token'},
   );
   ```

4. Add proper error handling:

   ```dart
   try {
     final response = await http.get(Uri.parse(apiUrl));
     if (response.statusCode == 200) {
       // Process data
     } else {
       // Handle API error
     }
   } catch (e) {
     // Handle connection error
   }
   ```

5. Check server logs for backend issues

### JSON Parsing Errors

**Problem**: Error when parsing JSON response.

**Solutions**:

1. Verify JSON format from API response
2. Use try-catch for JSON parsing:

   ```dart
   try {
     final data = jsonDecode(response.body);
     // Process data
   } catch (e) {
     print('JSON error: $e');
     // Handle parsing error
   }
   ```

3. Check model classes match the API response structure
4. Use a tool like QuickType or JsonToDart to generate model classes
5. Print raw response to debug:

   ```dart
   print('Raw response: ${response.body}');
   ```

### Authentication Issues

**Problem**: API authentication failures.

**Solutions**:

1. Check if token is expired
2. Verify token is being sent correctly in headers
3. Implement token refresh logic
4. Check server-side auth logs
5. Test API endpoints with tools like Postman

## Device-Specific Issues

### Android-Specific Problems

**Problem**: Issues only on Android devices.

**Solutions**:

1. Check Android build.gradle for configuration issues
2. Verify permissions in AndroidManifest.xml
3. Test on different Android versions
4. Check for platform-specific code:

   ```dart
   if (Platform.isAndroid) {
     // Android-specific code
   }
   ```

5. Use native debugging with Android Studio

### iOS-Specific Problems

**Problem**: Issues only on iOS devices.

**Solutions**:

1. Check Info.plist for required entries
2. Verify permissions usage descriptions
3. Test on different iOS versions
4. Check for platform-specific code:

   ```dart
   if (Platform.isIOS) {
     // iOS-specific code
   }
   ```

5. Use native debugging with Xcode

### Different Behaviors Across Devices

**Problem**: App behaves differently on various devices.

**Solutions**:

1. Use device preview package to test different screen sizes
2. Implement adaptive layouts
3. Test on physical devices when possible
4. Check for device-specific bugs in Flutter
5. Use feature detection instead of platform detection where possible

## Performance Issues

### Slow UI Rendering

**Problem**: UI feels sluggish or animations aren't smooth.

**Solutions**:

1. Use the Performance Overlay:

   ```dart
   MaterialApp(
     showPerformanceOverlay: true,
     // ...
   )
   ```

2. Reduce widget rebuilds:
   - Use `const` constructors where possible
   - Extract widgets to minimize rebuild scope
   - Use `RepaintBoundary` for complex animations
3. Optimize image assets (size and format)
4. Run in profile mode to identify issues:

   ```bash
   flutter run --profile
   ```

5. Use the Flutter DevTools performance tab

### Memory Leaks

**Problem**: App memory usage grows over time.

**Solutions**:

1. Properly dispose controllers and streams:

   ```dart
   @override
   void dispose() {
     _controller.dispose();
     _subscription.cancel();
     super.dispose();
   }
   ```

2. Avoid unnecessary rebuilds
3. Use the Flutter Memory tab in DevTools
4. Minimize large objects in memory
5. Clear caches when appropriate

### Battery Drain

**Problem**: App consumes excessive battery.

**Solutions**:

1. Minimize background operations
2. Optimize network requests (batching, caching)
3. Reduce location service usage
4. Use efficient image loading and caching
5. Avoid unnecessary animations

## Common Error Messages

### "Unhandled Exception"

**Problem**: App crashes with "Unhandled Exception".

**Solutions**:

1. Implement proper try-catch blocks
2. Add global error handling:

   ```dart
   void main() {
     FlutterError.onError = (FlutterErrorDetails details) {
       // Log error
       print('Flutter error: ${details.exception}');
     };
     
     runApp(MyApp());
   }
   ```

3. Use a crash reporting service like Firebase Crashlytics
4. Check stack trace for error source
5. Reproduce in debug mode to get more information

### "No Material widget found"

**Problem**: Error about missing Material ancestor.

**Solution**: Wrap your widget with `Material` or ensure it's inside a `MaterialApp`:

```dart
Material(
  child: YourWidget(),
)
```

### "RenderFlex overflowed by X pixels"

**Problem**: Layout overflow error in Row or Column.

**Solutions**:

1. Wrap content with `Expanded` or `Flexible`:

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

2. Make the content scrollable:

   ```dart
   SingleChildScrollView(
     scrollDirection: Axis.horizontal,
     child: Row(
       children: [...],
     ),
   )
   ```

3. Constrain text with `SizedBox` or use `FittedBox`
4. Use `Flexible` with `FlexFit.loose`

## Getting Additional Help

If you're still experiencing issues after trying the solutions in this guide:

1. Check the [Flutter GitHub issues](https://github.com/flutter/flutter/issues) for similar problems
2. Search on [Stack Overflow](https://stackoverflow.com/questions/tagged/flutter) with the Flutter tag
3. Join the [Flutter Community on Discord](https://discord.gg/flutter)
4. Create a clear, minimal example that reproduces the issue
5. File an issue on our GitHub repository with:
   - Detailed description of the problem
   - Steps to reproduce
   - Environment details (Flutter version, device, OS)
   - Error messages and stack traces
   - Screenshots or videos if applicable
