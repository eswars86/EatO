# Firebase Setup Quick Guide

## 🔥 Step-by-Step Firebase Configuration

### Step 1: Firebase Console Setup

1. **Go to Firebase Console**
   - Visit: https://console.firebase.google.com/
   - Sign in with your Google account

2. **Create New Project**
   - Click "Add project" button
   - Enter project name: `EatO` (or any name you prefer)
   - Accept terms and click "Continue"
   - Enable/disable Google Analytics (optional)
   - Click "Create project"
   - Wait for project creation (usually takes 30-60 seconds)

### Step 2: Add Android App

1. **Register Android App**
   - In Firebase Console, click Android icon
   - Find your package name in: `android/app/build.gradle.kts`
     - Look for: `namespace = "com.example.flutter_application_1"`
   - Enter the package name
   - App nickname (optional): `EatO Android`
   - Debug signing certificate SHA-1 (optional, needed for Google Sign-In)
   - Click "Register app"

2. **Download Config File**
   - Download `google-services.json`
   - Place it in: `android/app/google-services.json`
   - **IMPORTANT**: The file must be in the `app` folder, not `android` folder!

3. **Verify Android Configuration**
   - Check that `google-services.json` is in the correct location
   - The Firebase SDK is already added in `build.gradle.kts`

### Step 3: Enable Firebase Services

#### A. Enable Authentication

1. In Firebase Console, click "Authentication" in the left sidebar
2. Click "Get started"
3. Go to "Sign-in method" tab
4. Click on "Email/Password"
5. Toggle "Enable" switch
6. Click "Save"

#### B. Create Firestore Database

1. In Firebase Console, click "Firestore Database"
2. Click "Create database"
3. Select "Start in test mode" (for development)
4. Click "Next"
5. Choose your preferred location (e.g., us-central1)
6. Click "Enable"
7. Wait for database creation

**Security Rules (Test Mode):**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if true;
    }
  }
}
```

**Note:** Test mode allows all reads/writes. Change this before production!

#### C. Setup Firebase Storage

1. In Firebase Console, click "Storage"
2. Click "Get started"
3. Select "Start in test mode"
4. Click "Next"
5. Choose the same location as Firestore
6. Click "Done"

**Security Rules (Test Mode):**
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    match /{allPaths=**} {
      allow read, write: if true;
    }
  }
}
```

### Step 4: Run Your App

1. **Connect a device or start emulator**
   ```bash
   flutter devices
   ```

2. **Run the app**
   ```bash
   cd d:\flutter-project\Sprint-2\EatO\flutter_application_1
   flutter run
   ```

3. **Test the features**
   - Sign up with a new email/password
   - Add some tasks
   - Mark tasks as complete/incomplete
   - Sign out and sign back in
   - Verify data persists

### Step 5: Verify Firebase Connection

#### Check in Firebase Console:

1. **Authentication Tab**
   - Should see your registered users
   - Click on a user to see details

2. **Firestore Database Tab**
   - Should see `tasks` collection
   - Should see `users` collection
   - Click on documents to see data

3. **Storage Tab**
   - Will show uploaded files when you use storage features

### Step 6: Test Real-Time Sync

1. **Option A: Two Emulators**
   ```bash
   # Terminal 1
   flutter run -d emulator-5554
   
   # Terminal 2  
   flutter run -d chrome
   ```

2. **Option B: Two Physical Devices**
   ```bash
   # Check connected devices
   flutter devices
   
   # Run on device 1
   flutter run -d <device1_id>
   
   # In another terminal, run on device 2
   flutter run -d <device2_id>
   ```

3. **Test Scenario**
   - Sign in on both devices with the same account
   - Add a task on Device 1
   - Watch it appear on Device 2 instantly!
   - Mark it complete on Device 2
   - See it update on Device 1

### Troubleshooting

#### Issue: "FirebaseOptions cannot be null"

**Solution:**
```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# Run configuration
flutterfire configure
```

This will automatically create `firebase_options.dart` and configure your app.

Then update `main.dart`:
```dart
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

#### Issue: "Failed to register app"

**Solution:**
- Make sure `google-services.json` is in `android/app/` folder
- Clean and rebuild:
  ```bash
  flutter clean
  flutter pub get
  flutter run
  ```

#### Issue: "PERMISSION_DENIED" in Firestore

**Solution:**
- Check Firestore rules in Firebase Console
- Make sure you're in "test mode" for development
- Rules should allow read/write for testing

#### Issue: "Network error" or "Connection failed"

**Solution:**
- Check internet connection
- Verify Firebase project is active
- Check if emulator has internet access
- Try restarting the app

### iOS Setup (Optional)

1. **Register iOS App in Firebase Console**
   - Click iOS icon
   - Find bundle ID in: `ios/Runner.xcodeproj/project.pbxproj`
   - Download `GoogleService-Info.plist`
   - Place it in: `ios/Runner/GoogleService-Info.plist`

2. **Install Pods**
   ```bash
   cd ios
   pod install
   cd ..
   ```

3. **Run on iOS**
   ```bash
   flutter run -d ios
   ```

### Production Security Rules

Before deploying to production, update your security rules:

#### Firestore Rules (Production):
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only read/write their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Tasks - users can only access their own tasks
    match /tasks/{taskId} {
      allow read, write: if request.auth != null 
                        && request.auth.uid == resource.data.userId;
      allow create: if request.auth != null 
                   && request.auth.uid == request.resource.data.userId;
    }
  }
}
```

#### Storage Rules (Production):
```javascript
rules_version = '2';
service firebase.storage {
  match /b/{bucket}/o {
    // Profile pictures - users can only upload their own
    match /profile_pictures/{userId}/{allPaths=**} {
      allow read: if true;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Task images - only task owner can upload
    match /task_images/{userId}/{allPaths=**} {
      allow read: if request.auth != null;
      allow write: if request.auth != null && request.auth.uid == userId;
    }
  }
}
```

### Next Steps

- [ ] Complete Firebase Console setup
- [ ] Test authentication flow
- [ ] Test real-time data sync
- [ ] Add profile picture upload
- [ ] Configure security rules for production
- [ ] Add Firebase Analytics (optional)
- [ ] Add Firebase Cloud Messaging for push notifications (optional)
- [ ] Record demo video

### Useful Commands

```bash
# Check Flutter doctor
flutter doctor

# List connected devices
flutter devices

# Run with specific device
flutter run -d <device_id>

# Run in release mode
flutter run --release

# Build APK
flutter build apk

# Check dependencies
flutter pub outdated

# Clean project
flutter clean

# Get dependencies
flutter pub get

# Analyze code
flutter analyze
```

### Resources

- [Firebase Console](https://console.firebase.google.com/)
- [FlutterFire Documentation](https://firebase.flutter.dev/)
- [Firestore Documentation](https://firebase.google.com/docs/firestore)
- [Firebase Auth Documentation](https://firebase.google.com/docs/auth)
- [Firebase Storage Documentation](https://firebase.google.com/docs/storage)

---

**Created for Sprint 2 - Concept 2: Firebase Services & Real-Time Integration**
