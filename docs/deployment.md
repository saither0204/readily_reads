# Deployment Guide for [Your Mobile App Name]

This guide provides instructions for deploying [Your Mobile App Name] to app stores and backend services (if applicable).

## Table of Contents

- [Prerequisites](#prerequisites)
- [Environment Configuration](#environment-configuration)
- [Mobile App Deployment](#mobile-app-deployment)
  - [Android Deployment](#android-deployment)
  - [iOS Deployment](#ios-deployment)
- [Backend Deployment](#backend-deployment) (if applicable)
- [Continuous Integration/Deployment](#continuous-integrationdeployment)
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
- Backend hosting account (if applicable)
- CI/CD platform access (if using)

## Environment Configuration

### Production Configuration

Ensure your app is configured for production:

1. Update API endpoints to production URLs
2. Disable debug features and logging
3. Update environment variables for production

### Configuring Environment Variables

For a Flutter app using environment variables:

1. Create a `.env.prod` file:

   ```plaintext
   API_URL=https://api.yourdomain.com
   SENTRY_DSN=your-sentry-dsn
   [Other production variables]
   ```

2. Ensure your loading mechanism reads from the correct file based on build type

## Mobile App Deployment

### Android Deployment

#### Preparing for Google Play Store

1. **Configure app signing**:

   Create a keystore for signing your app:

   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

   Create `mobile/android/key.properties`:

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

2. **Update app version**:

   In `pubspec.yaml`:

   ```yaml
   version: 1.0.0+1  # version_name+version_code
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

   - App title and description
   - Feature graphic (1024 x 500 px)
   - Promo graphic (180 x 120 px)
   - App icon (512 x 512 px)
   - Screenshots (various sizes)
   - Privacy policy URL
   - Contact information

5. **Upload to Google Play Console**:

   - Navigate to [Google Play Console](https://play.google.com/console)
   - Create a new app or select existing app
   - Complete the store listing
   - Upload the APK or App Bundle
   - Set up pricing and distribution
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
     - Set a unique Bundle Identifier

2. **Update app version**:

   In `pubspec.yaml`:

   ```yaml
   version: 1.0.0+1  # version_name+build_number
   ```

   Also update in Xcode (Info.plist):
   - CFBundleShortVersionString (1.0.0)
   - CFBundleVersion (1)

3. **Create App Store Connect record**:

   - Go to [App Store Connect](https://appstoreconnect.apple.com/)
   - Create a new app
   - Provide bundle ID, name, etc.

4. **Build archive for iOS**:

   ```bash
   flutter build ios --release
   ```

   Then in Xcode:
   - Select Product > Archive
   - Wait for archiving to complete
   - Click "Distribute App"
   - Select "App Store Connect"
   - Follow the wizard steps

5. **Prepare store listing**:

   - App title and description
   - App icon (1024 x 1024 px)
   - Screenshots (various sizes)
   - App preview videos (optional)
   - Keywords for search
   - Support URL
   - Privacy policy URL
   - Contact information

6. **Submit for review**:

   - In App Store Connect, complete all required information
   - Submit for review
   - Respond to any reviewer questions

#### App Store Release Types

- **TestFlight Internal Testing**: For users in your team
- **TestFlight External Testing**: For up to 10,000 external testers
- **App Store**: Full public release

## Backend Deployment (if applicable)

If your app uses a custom backend, follow these steps for deployment:

### Server Preparation

1. Update environment variables for production
2. Configure database for production use
3. Set up proper security measures:
   - Secure HTTPS connections
   - Proper authentication
   - Rate limiting
   - Input validation

### Deployment Options

#### Option 1: Traditional Server Deployment

1. SSH into your server:

   ```bash
   ssh user@your-server-ip
   ```

2. Clone repository and install dependencies:

   ```bash
   git clone [repository URL]
   cd [project-name]/server
   npm install --production
   ```

3. Set up process manager (PM2):

   ```bash
   npm install -g pm2
   pm2 start app.js --name "[your-app]-api"
   pm2 startup
   pm2 save
   ```

4. Configure reverse proxy (Nginx):

   ```nginx
   server {
       listen 443 ssl;
       server_name api.yourdomain.com;

       ssl_certificate /path/to/cert.pem;
       ssl_certificate_key /path/to/key.pem;

       location / {
           proxy_pass http://localhost:8000;
           proxy_http_version 1.1;
           proxy_set_header Upgrade $http_upgrade;
           proxy_set_header Connection 'upgrade';
           proxy_set_header Host $host;
           proxy_cache_bypass $http_upgrade;
       }
   }
   ```

#### Option 2: Cloud Deployment (Heroku, AWS, GCP, etc.)

1. Configure for your cloud provider
2. Set up environment variables in cloud console
3. Deploy using provider-specific commands

Example for Heroku:

```bash
heroku create [your-app]-api
git subtree push --prefix server heroku main
```

## Continuous Integration/Deployment

### Setting up CI/CD with GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy

on:
  push:
    branches: [ main ]
    tags: [ 'v*' ]

jobs:
  build_android:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v2
      - uses: actions/setup-java@v2
        with:
          distribution: 'zulu'
          java-version: '11'
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.0.0'
          channel: 'stable'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - name: Setup signing
        run: |
          echo "${{ secrets.KEYSTORE_BASE64 }}" | base64 --decode > android/app/upload-keystore.jks
          echo "storePassword=${{ secrets.KEYSTORE_PASSWORD }}" > android/key.properties
          echo "keyPassword=${{ secrets.KEY_PASSWORD }}" >> android/key.properties
          echo "keyAlias=upload" >> android/key.properties
          echo "storeFile=upload-keystore.jks" >> android/key.properties
      - name: Build AppBundle
        run: flutter build appbundle
      - uses: actions/upload-artifact@v2
        with:
          name: app-bundle
          path: build/app/outputs/bundle/release/app-release.aab

  build_ios:
    runs-on: macos-latest
    steps:
      - uses: actions/checkout@v2
      - uses: subosito/flutter-action@v2
        with:
          flutter-version: '3.0.0'
          channel: 'stable'
      - run: flutter pub get
      - run: flutter analyze
      - run: flutter test
      - name: Build iOS
        run: flutter build ios --release --no-codesign
      # Further steps for iOS signing and deployment
```

## App Store Optimization

### Google Play Store Optimization

- **Title**: Clear, concise app name (max 50 characters)
- **Description**: Engaging first paragraph, feature list, call to action
- **Short Description**: Concise value proposition (max 80 characters)
- **Keywords**: Include in description naturally
- **Screenshots**: Show key features, add captions
- **Feature Graphic**: Eye-catching, represents app function
- **Video**: Create a short demo (30-60 seconds)
- **Ratings & Reviews**: Encourage satisfied users to rate

### Apple App Store Optimization

- **Title**: Clear app name (max 30 characters)
- **Subtitle**: Brief value proposition (max 30 characters)
- **Keywords**: Add keywords field (max 100 characters)
- **Description**: Detailed features and benefits
- **Screenshots**: Show key features with captions
- **Preview Video**: Create app previews (15-30 seconds)
- **Ratings & Reviews**: Implement in-app review requests

## Post-Deployment Verification

After deployment, verify:

1. App installs and launches successfully
2. All features work as expected
3. Authentication flows work properly
4. API connections function correctly
5. Push notifications deliver (if applicable)
6. Analytics are tracking properly
7. Crash reporting is configured
8. Performance is acceptable

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

2. Create detailed release notes
3. Test thoroughly on all supported devices
4. Implement backward compatibility where possible
5. Consider phased rollouts for major changes

## Rollback Procedures

### Mobile App Rollback

If serious issues are found after release:

1. **Google Play**:
   - Halt staged rollout
   - Revert to previous version in Play Console

2. **App Store**:
   - Submit an expedited review with previous version
   - Request removal if critical security issue

### Backend Rollback (if applicable)

1. **Traditional Server**:

   ```bash
   git checkout [previous-version-tag]
   npm install
   pm2 restart [your-app]-api
   ```

2. **Heroku**:

   ```bash
   heroku rollback
   ```

3. **Database**:
   - Restore from backup if database changes are involved
