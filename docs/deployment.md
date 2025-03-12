# Deployment Guide for Readily Reads

This guide provides instructions for deploying Readily Reads to app stores.

## Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Configuration](#environment-configuration)
- [Mobile App Deployment](#mobile-app-deployment)
  - [Android Deployment](#android-deployment)
  - [iOS Deployment](#ios-deployment)
- [App Store Optimization](#app-store-optimization)
- [Post-Deployment Verification](#post-deployment-verification)
- [Versioning and Updates](#versioning-and-updates)
- [Rollback Procedures](#rollback-procedures)

## Prerequisites

Before deploying, ensure you have:

- Google Play Developer account (for Android)
- Apple Developer account (for iOS)
- Properly configured app signing keys and certificates
- All app store assets (screenshots, descriptions, etc.)
- Required legal documentation (privacy policy, terms of service)

## Environment Configuration

### Production Configuration

Ensure your app is configured for production:

1. Disable debug features and logging
2. Update environment configuration
3. Ensure database setup is properly configured

### Configuration Settings

Readily Reads uses SQLite for local storage and manages configuration through Flutter build settings:

1. Update app version and build number in `pubspec.yaml`:

   ```yaml
   version: 1.0.0+1  # format is version_name+version_code
   ```

2. Ensure proper database configuration in `book_model.dart` and `user_model.dart`

## Mobile App Deployment

### Android Deployment

#### Preparing for Google Play Store

1. **Configure app signing**:

   Create a keystore for signing your app:

   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

   Create `android/key.properties`:

   ```plaintext
   storePassword=<password>
   keyPassword=<password>
   keyAlias=upload
   storeFile=<path to keystore>
   ```

   Reference this in `android/app/build.gradle`:

   ```gradle
   def keyProperties = new Properties()
   def keyPropertiesFile = rootProject.file('key.properties')
   if (keyPropertiesFile.exists()) {
       keyProperties.load(new FileInputStream(keyPropertiesFile))
   }

   android {
       // ...
       signingConfigs {
           release {
               keyAlias keyProperties['keyAlias']
               keyPassword keyProperties['keyPassword']
               storeFile keyProperties['storeFile'] ? file(keyProperties['storeFile']) : null
               storePassword keyProperties['storePassword']
           }
       }
       buildTypes {
           release {
               signingConfig signingConfigs.release
               // ...
           }
       }
   }
   ```

2. **Update app metadata in AndroidManifest.xml**:

   Make sure the application name, icons, and other metadata are correctly set:

   ```xml
   <application
       android:label="Readily Reads"
       android:icon="@mipmap/ic_launcher"
       ...>
   ```

3. **Build release APK or App Bundle**:

   ```bash
   # For APK
   flutter build apk --release

   # For App Bundle (preferred for Play Store)
   flutter build appbundle --release
   ```

   Find the outputs at:
   - APK: `build/app/outputs/flutter-apk/app-release.apk`
   - Bundle: `build/app/outputs/bundle/release/app-release.aab`

4. **Prepare store listing**:

   - App title: "Readily Reads"
   - Short description: "Your personal reading habit tracker"
   - Full description: Include details about features (book tracking, reading progress, etc.)
   - Feature graphic (1024 x 500 px)
   - App icon (512 x 512 px)
   - Screenshots:
     - Home screen
     - Book list
     - Add book form
     - Book management screen
     - Currently reading view
   - Privacy policy URL

5. **Upload to Google Play Console**:

   - Navigate to [Google Play Console](https://play.google.com/console)
   - Create a new app or select existing app
   - Complete the store listing
   - Upload the APK or App Bundle
   - Set up pricing and distribution (Readily Reads can be free)
   - Submit for review

#### Play Store Release Types

- **Internal testing**: For your team only
- **Closed testing**: For specific testers by email
- **Open testing**: For public beta testing
- **Production**: Full public release

### iOS Deployment

#### Preparing for App Store

1. **Configure app signing and capabilities**:

   - Open Xcode:

     ```bash
     cd ios
     open Runner.xcworkspace
     ```

   - Configure signing in Xcode:
     - Select Runner project
     - Select Runner target
     - Go to Signing & Capabilities tab
     - Select your team
     - Set a unique Bundle Identifier (e.g., com.yourcompany.readilyreads)

2. **Update app version and build number**:

   In `pubspec.yaml`:

   ```yaml
   version: 1.0.0+1  # version_name+build_number
   ```

   Also update in Xcode (Info.plist):
   - CFBundleShortVersionString (1.0.0)
   - CFBundleVersion (1)

3. **Configure app metadata in Info.plist**:

   Make sure to set:
   - CFBundleDisplayName (Readily Reads)
   - Privacy descriptions for any permissions (if needed)

4. **Create App Store Connect record**:

   - Go to [App Store Connect](https://appstoreconnect.apple.com/)
   - Create a new app
   - Provide bundle ID, name, etc.

5. **Build archive for iOS**:

   ```bash
   flutter build ios --release
   ```

   Then in Xcode:
   - Select Product > Archive
   - Wait for archiving to complete
   - Click "Distribute App"
   - Select "App Store Connect"
   - Follow the wizard steps

6. **Prepare store listing**:

   - App title: "Readily Reads"
   - Subtitle: "Personal Reading Tracker"
   - Description: Include details about features
   - App icon (1024 x 1024 px)
   - Screenshots for various device sizes
   - Keywords: reading, books, tracker, library, etc.
   - Support URL
   - Privacy policy URL
   - App category: Books, Productivity, or Lifestyle

7. **Submit for review**:

   - In App Store Connect, complete all required information
   - Submit for review
   - Respond to any reviewer questions

#### App Store Release Types

- **TestFlight Internal Testing**: For users in your team
- **TestFlight External Testing**: For up to 10,000 external testers
- **App Store**: Full public release

## App Store Optimization

### Google Play Store Optimization

- **Title**: "Readily Reads - Book Tracker"
- **Description**: Start with a strong first paragraph describing the app's purpose, followed by feature list in bullet points
- **Short Description**: "Track your reading habits and manage your book collection"
- **Keywords**: Include terms like "book tracker," "reading habit," "book collection," etc.
- **Screenshots**: Show key features with descriptive captions
- **Feature Graphic**: Design a clean graphic showing the app concept

### Apple App Store Optimization

- **Title**: "Readily Reads"
- **Subtitle**: "Your Personal Book Tracker"
- **Keywords**: Add relevant keywords separated by commas
- **Description**: Clear, concise description of the app's purpose and features
- **Screenshots**: Show key screens with descriptive captions
- **App Preview Video**: Consider creating a short demo video

## Post-Deployment Verification

After deployment, verify:

1. App installs and launches successfully
2. User registration and login work correctly
3. Book management features function properly:
   - Adding new books
   - Editing existing books
   - Marking books as currently reading
   - Deleting books
4. Filtering and search functionality works
5. UI displays correctly on different device sizes
6. Database operations work smoothly
7. Performance is acceptable

## Versioning and Updates

### Semantic Versioning

Follow semantic versioning for your app:

- **Major version (1.x.x)**: Incompatible API changes, major redesigns
- **Minor version (x.1.x)**: New features, backward-compatible
- **Patch version (x.x.1)**: Bug fixes, minor improvements

### Update Checklist

When releasing updates:

1. Update version numbers in:
   - `pubspec.yaml`
   - Android build.gradle (if needed)
   - iOS Info.plist (if needed)

2. Create detailed release notes highlighting new features or fixes
3. Test thoroughly on all supported devices
4. Implement database migrations if changing the data model
5. Consider phased rollouts for major changes

### Feature Planning for Future Versions

Consider these features for future updates:

1. Reading progress tracking (% completion)
2. Reading goals and statistics
3. Book recommendations
4. Barcode scanning for adding books
5. Cloud synchronization
6. Social sharing features
7. Enhanced filtering and categorization

## Rollback Procedures

### Mobile App Rollback

If serious issues are found after release:

1. **Google Play**:
   - Halt staged rollout
   - Revert to previous version in Play Console

2. **App Store**:
   - Submit an expedited review with previous version
   - Request removal if critical security issue

3. **Database Considerations**:
   - Ensure database schema changes are backward compatible
   - Add version checks in code to handle both old and new schemas
   - Consider adding database downgrade paths for critical issues
