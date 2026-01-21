# Quick Start Checklist ✅

## Before You Begin

Print this page and check off items as you complete them!

---

## Part 1: Firebase Console Setup (20 minutes)

### Create Firebase Project
- [ ] Go to https://console.firebase.google.com/
- [ ] Sign in with Google account
- [ ] Click "Add project"
- [ ] Enter project name: "EatO"
- [ ] Click "Continue" through steps
- [ ] Wait for project creation

### Add Android App
- [ ] Click Android icon in Firebase Console
- [ ] Find package name in `android/app/build.gradle.kts`
- [ ] Enter package name in Firebase
- [ ] Click "Register app"
- [ ] Download `google-services.json`
- [ ] Move file to: `android/app/google-services.json`
- [ ] Verify file location is correct

### Enable Authentication
- [ ] Click "Authentication" in left sidebar
- [ ] Click "Get started"
- [ ] Click "Sign-in method" tab
- [ ] Click "Email/Password"
- [ ] Toggle "Enable"
- [ ] Click "Save"

### Create Firestore Database
- [ ] Click "Firestore Database" in left sidebar
- [ ] Click "Create database"
- [ ] Select "Start in test mode"
- [ ] Click "Next"
- [ ] Choose location (e.g., us-central1)
- [ ] Click "Enable"
- [ ] Wait for creation

### Setup Storage
- [ ] Click "Storage" in left sidebar
- [ ] Click "Get started"
- [ ] Select "Start in test mode"
- [ ] Click "Next"
- [ ] Choose same location as Firestore
- [ ] Click "Done"

---

## Part 2: Run the App (5 minutes)

### Prepare Environment
- [ ] Open Terminal/Command Prompt
- [ ] Run: `flutter doctor`
- [ ] Verify no critical issues
- [ ] Connect device or start emulator
- [ ] Run: `flutter devices` (verify device detected)

### Install and Run
```bash
# Navigate to project
cd d:\flutter-project\Sprint-2\EatO\flutter_application_1

# Install dependencies
flutter pub get

# Run the app
flutter run
```

- [ ] App builds successfully
- [ ] App launches on device
- [ ] Login screen appears

---

## Part 3: Test Features (10 minutes)

### Test Authentication
- [ ] Enter email: test@example.com
- [ ] Enter password: test123456
- [ ] Click "Create Account"
- [ ] See success message
- [ ] Arrive at tasks screen
- [ ] Click logout button
- [ ] Return to login screen
- [ ] Sign in with same credentials
- [ ] Successfully logged in

### Test Firestore
- [ ] Add task: "Test Task 1"
- [ ] See task appear in list
- [ ] Check task completion checkbox
- [ ] See task marked complete
- [ ] Uncheck task
- [ ] See task marked incomplete
- [ ] Delete task
- [ ] Task removed from list

### Verify in Firebase Console
- [ ] Open Firebase Console
- [ ] Go to Authentication → Users
- [ ] See your test user listed
- [ ] Go to Firestore Database → Data
- [ ] See "tasks" collection
- [ ] See your task documents
- [ ] Click on a task to see details

---

## Part 4: Test Real-Time Sync (15 minutes)

### Setup Two Devices

**Option A: Two Emulators**
```bash
# Terminal 1
flutter run -d emulator-5554

# Terminal 2
flutter run -d chrome
```

**Option B: Emulator + Physical Device**
```bash
# Check devices
flutter devices

# Run on each device
flutter run -d <device_id>
```

- [ ] App running on Device 1
- [ ] App running on Device 2
- [ ] Both logged in with same account

### Test Real-Time Features
- [ ] Device 1: Add task "Buy milk"
- [ ] Device 2: Task appears INSTANTLY (no refresh!)
- [ ] Device 2: Mark task complete
- [ ] Device 1: Task updates INSTANTLY to completed
- [ ] Device 1: Add task "Go shopping"
- [ ] Device 2: New task appears INSTANTLY
- [ ] Device 2: Delete task
- [ ] Device 1: Task disappears INSTANTLY
- [ ] Try adding multiple tasks quickly - all sync

### Verify in Console
- [ ] Keep Firebase Console open
- [ ] Watch Firestore Database → Data tab
- [ ] Add task from app
- [ ] See it appear in console instantly!
- [ ] Delete task from app
- [ ] See it disappear from console instantly!

---

## Part 5: Video Recording (30 minutes)

### Preparation
- [ ] Read VIDEO_WALKTHROUGH_CHECKLIST.md
- [ ] Practice demo flow
- [ ] Clean up test data
- [ ] Prepare both devices/emulators
- [ ] Test screen recording software
- [ ] Prepare script/notes

### Record Video (3-5 minutes)
- [ ] Introduction (30 sec)
- [ ] Firebase Console tour (45 sec)
- [ ] Authentication demo (45 sec)
- [ ] **Real-time sync demo** (90 sec) ← MOST IMPORTANT!
- [ ] Code explanation (45 sec)
- [ ] Conclusion (30 sec)

### Key Points to Show:
- [ ] Two devices side by side
- [ ] Add task on Device 1 → appears on Device 2
- [ ] Toggle complete on Device 2 → updates on Device 1
- [ ] Delete on Device 1 → disappears on Device 2
- [ ] Firebase Console showing live data
- [ ] Code snippets (briefly)
- [ ] Emphasize "NO REFRESH NEEDED" multiple times

### After Recording
- [ ] Review video quality
- [ ] Check audio clarity
- [ ] Verify video length (3-5 min)
- [ ] Confirm all key points covered

---

## Part 6: Submission (10 minutes)

### Upload Video
- [ ] Go to drive.google.com
- [ ] Upload video file
- [ ] Wait for upload to complete
- [ ] Right-click → Share
- [ ] Set to "Anyone with the link"
- [ ] Set permission to "Viewer" or "Editor"
- [ ] Copy link

### Update README
- [ ] Open README.md
- [ ] Find "Video Walkthrough" section
- [ ] Paste Google Drive link
- [ ] Save file
- [ ] Test link in incognito mode
- [ ] Verify video plays correctly

### Final Checks
- [ ] All code is committed (if using Git)
- [ ] README.md is complete
- [ ] Video link works
- [ ] google-services.json is in place (but NOT committed to Git!)
- [ ] App runs without errors
- [ ] Real-time sync works perfectly

---

## Troubleshooting Quick Fixes

### "FirebaseOptions cannot be null"
```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### "App not registered"
- Verify `google-services.json` is in `android/app/`
- Check package name matches in Firebase Console

### "Permission denied" errors
- Ensure Firestore is in "Test mode"
- Check rules allow read/write

### Build errors
```bash
flutter clean
flutter pub get
flutter run
```

### Real-time not working
- Check internet connection
- Verify both devices logged in with same account
- Restart both app instances
- Check Firebase Console for data

---

## Time Estimates

| Task | Estimated Time |
|------|----------------|
| Firebase Console Setup | 20 minutes |
| Run & Test App | 15 minutes |
| Test Real-Time Sync | 15 minutes |
| Record Video | 30 minutes |
| Upload & Submit | 10 minutes |
| **Total** | **~90 minutes** |

---

## Success Criteria ✨

You're ready to submit when:

✅ Firebase Console is fully configured  
✅ App runs without errors  
✅ Authentication works (sign up, login, logout)  
✅ Tasks can be added, updated, deleted  
✅ Real-time sync works between 2 devices  
✅ Video demonstrates all features clearly  
✅ Video is 3-5 minutes long  
✅ Video link is public and working  
✅ README contains video link  

---

## Emergency Contacts / Resources

- **Firebase Console:** https://console.firebase.google.com/
- **Firebase Docs:** https://firebase.google.com/docs
- **FlutterFire Docs:** https://firebase.flutter.dev/
- **Setup Guide:** See `FIREBASE_SETUP_GUIDE.md`
- **Video Guide:** See `VIDEO_WALKTHROUGH_CHECKLIST.md`

---

## Pro Tips 💡

1. **Do Firebase Console setup first** - It's the foundation
2. **Test on TWO devices** - Real-time sync is the main feature
3. **Keep Firebase Console open** - Watch data update in real-time
4. **Emphasize "no refresh"** - This is what makes Firebase special
5. **Practice video once** - You'll do better on the real recording
6. **Stay under 5 minutes** - Quality over quantity
7. **Show enthusiasm** - You built something cool!

---

## You've Got This! 🚀

This is a comprehensive implementation. Everything is set up and working. Just follow the checklist, test thoroughly, record a great demo, and submit!

**Remember:** The real-time sync is the star feature - make it shine! ✨

Good luck! 🔥

---

**Last Updated:** January 21, 2026  
**Sprint 2 - Concept 2:** Firebase Services & Real-Time Integration
