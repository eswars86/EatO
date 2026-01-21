/// Firebase Integration Examples
/// 
/// This file contains practical examples of using Firebase services
/// in your Flutter application. Copy and adapt these examples as needed.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

// ============================================================================
// FIREBASE AUTHENTICATION EXAMPLES
// ============================================================================

class AuthExamples {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Example 1: Sign up with email and password
  Future<void> exampleSignUp() async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: 'user@example.com',
        password: 'securePassword123',
      );
      print('User created: ${userCredential.user?.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        print('The password is too weak.');
      } else if (e.code == 'email-already-in-use') {
        print('An account already exists for this email.');
      }
    }
  }

  /// Example 2: Sign in with email and password
  Future<void> exampleSignIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: 'user@example.com',
        password: 'securePassword123',
      );
      print('User signed in: ${userCredential.user?.uid}');
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for this email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided.');
      }
    }
  }

  /// Example 3: Listen to authentication state changes
  void exampleAuthStateListener() {
    _auth.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in: ${user.uid}');
        print('Email: ${user.email}');
      }
    });
  }

  /// Example 4: Get current user
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  /// Example 5: Sign out
  Future<void> exampleSignOut() async {
    await _auth.signOut();
    print('User signed out successfully');
  }

  /// Example 6: Send password reset email
  Future<void> exampleResetPassword() async {
    try {
      await _auth.sendPasswordResetEmail(email: 'user@example.com');
      print('Password reset email sent');
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 7: Update user profile
  Future<void> exampleUpdateProfile() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await user.updateDisplayName('John Doe');
      await user.updatePhotoURL('https://example.com/profile.jpg');
      await user.reload(); // Refresh user data
      print('Profile updated');
    }
  }
}

// ============================================================================
// CLOUD FIRESTORE EXAMPLES
// ============================================================================

class FirestoreExamples {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Example 1: Add a document with auto-generated ID
  Future<void> exampleAddDocument() async {
    try {
      DocumentReference docRef = await _firestore.collection('tasks').add({
        'title': 'Complete Flutter project',
        'description': 'Implement Firebase integration',
        'completed': false,
        'priority': 'high',
        'createdAt': FieldValue.serverTimestamp(),
        'tags': ['flutter', 'firebase', 'mobile'],
      });
      print('Document added with ID: ${docRef.id}');
    } catch (e) {
      print('Error adding document: $e');
    }
  }

  /// Example 2: Add a document with custom ID
  Future<void> exampleSetDocument() async {
    try {
      await _firestore.collection('users').doc('user123').set({
        'name': 'John Doe',
        'email': 'john@example.com',
        'age': 30,
        'preferences': {
          'theme': 'dark',
          'notifications': true,
        },
      });
      print('Document set successfully');
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 3: Update a document (merge)
  Future<void> exampleUpdateDocument() async {
    try {
      await _firestore.collection('tasks').doc('task123').update({
        'completed': true,
        'completedAt': FieldValue.serverTimestamp(),
      });
      print('Document updated');
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 4: Delete a document
  Future<void> exampleDeleteDocument() async {
    try {
      await _firestore.collection('tasks').doc('task123').delete();
      print('Document deleted');
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 5: Get a single document
  Future<void> exampleGetDocument() async {
    try {
      DocumentSnapshot doc = await _firestore.collection('tasks').doc('task123').get();
      
      if (doc.exists) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        print('Title: ${data['title']}');
        print('Completed: ${data['completed']}');
      } else {
        print('Document does not exist');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 6: Get all documents in a collection
  Future<void> exampleGetAllDocuments() async {
    try {
      QuerySnapshot querySnapshot = await _firestore.collection('tasks').get();
      
      for (var doc in querySnapshot.docs) {
        print('${doc.id} => ${doc.data()}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 7: Real-time listener (snapshots)
  void exampleRealtimeListener() {
    _firestore.collection('tasks').snapshots().listen((querySnapshot) {
      print('Received ${querySnapshot.docs.length} tasks');
      
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data();
        print('Task: ${data['title']} - Completed: ${data['completed']}');
      }
    });
  }

  /// Example 8: Query with filtering
  Future<void> exampleQueryWithFilter() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('tasks')
          .where('completed', isEqualTo: false)
          .where('priority', isEqualTo: 'high')
          .get();

      print('Found ${querySnapshot.docs.length} high-priority incomplete tasks');
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 9: Query with ordering
  Future<void> exampleQueryWithOrdering() async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('tasks')
          .orderBy('createdAt', descending: true)
          .limit(10)
          .get();

      print('Latest 10 tasks:');
      for (var doc in querySnapshot.docs) {
        print(doc.data());
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 10: Batch operations
  Future<void> exampleBatchOperations() async {
    try {
      WriteBatch batch = _firestore.batch();

      // Add multiple documents
      DocumentReference doc1 = _firestore.collection('tasks').doc('task1');
      batch.set(doc1, {'title': 'Task 1', 'completed': false});

      DocumentReference doc2 = _firestore.collection('tasks').doc('task2');
      batch.set(doc2, {'title': 'Task 2', 'completed': false});

      // Update a document
      DocumentReference doc3 = _firestore.collection('tasks').doc('task3');
      batch.update(doc3, {'completed': true});

      // Delete a document
      DocumentReference doc4 = _firestore.collection('tasks').doc('task4');
      batch.delete(doc4);

      // Commit all operations atomically
      await batch.commit();
      print('Batch operations completed');
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 11: Transaction (atomic read-modify-write)
  Future<void> exampleTransaction() async {
    try {
      await _firestore.runTransaction((transaction) async {
        // Read
        DocumentReference counterRef = _firestore.collection('counters').doc('taskCount');
        DocumentSnapshot snapshot = await transaction.get(counterRef);

        if (!snapshot.exists) {
          throw Exception("Counter does not exist!");
        }

        // Modify
        int newCount = (snapshot.data() as Map<String, dynamic>)['count'] + 1;

        // Write
        transaction.update(counterRef, {'count': newCount});
      });
      print('Transaction completed');
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 12: Pagination (cursor-based)
  Future<void> examplePagination() async {
    try {
      // First page
      QuerySnapshot firstPage = await _firestore
          .collection('tasks')
          .orderBy('createdAt')
          .limit(10)
          .get();

      print('First page: ${firstPage.docs.length} items');

      // Second page (start after last document from first page)
      if (firstPage.docs.isNotEmpty) {
        DocumentSnapshot lastDoc = firstPage.docs.last;

        QuerySnapshot secondPage = await _firestore
            .collection('tasks')
            .orderBy('createdAt')
            .startAfterDocument(lastDoc)
            .limit(10)
            .get();

        print('Second page: ${secondPage.docs.length} items');
      }
    } catch (e) {
      print('Error: $e');
    }
  }
}

// ============================================================================
// FIREBASE STORAGE EXAMPLES
// ============================================================================

class StorageExamples {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Example 1: Upload a file
  Future<void> exampleUploadFile(File file) async {
    try {
      String fileName = 'uploads/${DateTime.now().millisecondsSinceEpoch}.jpg';
      Reference ref = _storage.ref().child(fileName);

      UploadTask uploadTask = ref.putFile(file);

      // Wait for upload to complete
      TaskSnapshot snapshot = await uploadTask;
      print('Upload complete: ${snapshot.bytesTransferred} bytes');

      // Get download URL
      String downloadUrl = await snapshot.ref.getDownloadURL();
      print('Download URL: $downloadUrl');
    } catch (e) {
      print('Error uploading file: $e');
    }
  }

  /// Example 2: Upload with progress tracking
  Future<void> exampleUploadWithProgress(File file) async {
    try {
      Reference ref = _storage.ref().child('uploads/image.jpg');
      UploadTask uploadTask = ref.putFile(file);

      uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
        double progress = snapshot.bytesTransferred / snapshot.totalBytes;
        print('Upload progress: ${(progress * 100).toStringAsFixed(2)}%');
      });

      await uploadTask;
      print('Upload completed');
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 3: Upload with metadata
  Future<void> exampleUploadWithMetadata(File file) async {
    try {
      Reference ref = _storage.ref().child('uploads/document.pdf');

      SettableMetadata metadata = SettableMetadata(
        contentType: 'application/pdf',
        customMetadata: {
          'uploadedBy': 'user123',
          'description': 'Important document',
        },
      );

      await ref.putFile(file, metadata);
      print('File uploaded with metadata');
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 4: Download a file
  Future<void> exampleDownloadFile() async {
    try {
      Reference ref = _storage.ref().child('uploads/image.jpg');

      // Get download URL
      String downloadUrl = await ref.getDownloadURL();
      print('Download URL: $downloadUrl');

      // Or download to local file
      File localFile = File('/path/to/local/file.jpg');
      await ref.writeToFile(localFile);
      print('File downloaded to ${localFile.path}');
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 5: Delete a file
  Future<void> exampleDeleteFile() async {
    try {
      Reference ref = _storage.ref().child('uploads/image.jpg');
      await ref.delete();
      print('File deleted');
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 6: Get file metadata
  Future<void> exampleGetMetadata() async {
    try {
      Reference ref = _storage.ref().child('uploads/image.jpg');
      FullMetadata metadata = await ref.getMetadata();

      print('Name: ${metadata.name}');
      print('Size: ${metadata.size} bytes');
      print('Content Type: ${metadata.contentType}');
      print('Created: ${metadata.timeCreated}');
      print('Updated: ${metadata.updated}');
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 7: List all files in a directory
  Future<void> exampleListFiles() async {
    try {
      Reference ref = _storage.ref().child('uploads/');
      ListResult result = await ref.listAll();

      print('Found ${result.items.length} files:');
      for (Reference fileRef in result.items) {
        print('- ${fileRef.name}');
        String url = await fileRef.getDownloadURL();
        print('  URL: $url');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  /// Example 8: Upload from bytes (useful for web)
  Future<void> exampleUploadBytes(List<int> bytes) async {
    try {
      Reference ref = _storage.ref().child('uploads/data.bin');
      await ref.putData(Uint8List.fromList(bytes));
      print('Bytes uploaded');
    } catch (e) {
      print('Error: $e');
    }
  }
}

// ============================================================================
// COMBINED EXAMPLES (Auth + Firestore + Storage)
// ============================================================================

class CombinedExamples {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Example: Complete user registration flow
  Future<void> exampleUserRegistrationFlow({
    required String email,
    required String password,
    required String displayName,
    required File? profileImage,
  }) async {
    try {
      // 1. Create user account
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      String userId = userCredential.user!.uid;

      // 2. Upload profile image (if provided)
      String? profileImageUrl;
      if (profileImage != null) {
        Reference imageRef = _storage.ref().child('profile_pictures/$userId.jpg');
        await imageRef.putFile(profileImage);
        profileImageUrl = await imageRef.getDownloadURL();
      }

      // 3. Create user profile in Firestore
      await _firestore.collection('users').doc(userId).set({
        'email': email,
        'displayName': displayName,
        'profileImageUrl': profileImageUrl,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      });

      // 4. Update Firebase Auth profile
      await userCredential.user!.updateDisplayName(displayName);
      if (profileImageUrl != null) {
        await userCredential.user!.updatePhotoURL(profileImageUrl);
      }

      print('User registration completed successfully');
    } catch (e) {
      print('Error during registration: $e');
      rethrow;
    }
  }

  /// Example: Save user task with image attachment
  Future<void> exampleCreateTaskWithImage({
    required String title,
    required String description,
    required File? imageFile,
  }) async {
    try {
      String userId = _auth.currentUser!.uid;

      // Upload image if provided
      String? imageUrl;
      if (imageFile != null) {
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        Reference imageRef = _storage.ref().child('task_images/$userId/$timestamp.jpg');
        await imageRef.putFile(imageFile);
        imageUrl = await imageRef.getDownloadURL();
      }

      // Create task document
      await _firestore.collection('tasks').add({
        'userId': userId,
        'title': title,
        'description': description,
        'imageUrl': imageUrl,
        'completed': false,
        'createdAt': FieldValue.serverTimestamp(),
      });

      print('Task created successfully');
    } catch (e) {
      print('Error creating task: $e');
    }
  }

  /// Example: Get user's tasks with real-time updates
  Stream<List<Map<String, dynamic>>> exampleGetUserTasksStream() {
    String userId = _auth.currentUser!.uid;

    return _firestore
        .collection('tasks')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        return {
          'id': doc.id,
          ...doc.data(),
        };
      }).toList();
    });
  }
}

// ============================================================================
// USAGE IN FLUTTER WIDGETS
// ============================================================================

/*
// Example: Using in a StatefulWidget

class MyWidget extends StatefulWidget {
  @override
  _MyWidgetState createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  final CombinedExamples _examples = CombinedExamples();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _examples.exampleGetUserTasksStream(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }

        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }

        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No tasks found');
        }

        List<Map<String, dynamic>> tasks = snapshot.data!;

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            var task = tasks[index];
            return ListTile(
              title: Text(task['title']),
              subtitle: Text(task['description']),
              leading: task['imageUrl'] != null
                  ? Image.network(task['imageUrl'])
                  : Icon(Icons.task),
            );
          },
        );
      },
    );
  }
}
*/
