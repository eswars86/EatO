import 'package:cloud_firestore/cloud_firestore.dart';

/// Firebase Firestore Service
/// Handles real-time data synchronization for tasks, messages, and other data
class FirestoreService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Collection references
  CollectionReference get tasksCollection => _firestore.collection('tasks');
  CollectionReference get usersCollection => _firestore.collection('users');

  /// Add a new task
  /// Returns the document ID of the newly created task
  Future<String> addTask({
    required String title,
    String? description,
    String? userId,
  }) async {
    try {
      final DocumentReference docRef = await tasksCollection.add({
        'title': title,
        'description': description ?? '',
        'userId': userId ?? 'anonymous',
        'completed': false,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
      return docRef.id;
    } catch (e) {
      throw 'Error adding task: $e';
    }
  }

  /// Update an existing task
  Future<void> updateTask({
    required String taskId,
    String? title,
    String? description,
    bool? completed,
  }) async {
    try {
      final Map<String, dynamic> updates = {
        'updatedAt': FieldValue.serverTimestamp(),
      };

      if (title != null) updates['title'] = title;
      if (description != null) updates['description'] = description;
      if (completed != null) updates['completed'] = completed;

      await tasksCollection.doc(taskId).update(updates);
    } catch (e) {
      throw 'Error updating task: $e';
    }
  }

  /// Delete a task
  Future<void> deleteTask(String taskId) async {
    try {
      await tasksCollection.doc(taskId).delete();
    } catch (e) {
      throw 'Error deleting task: $e';
    }
  }

  /// Get all tasks as a real-time stream
  /// This enables automatic UI updates when data changes
  Stream<QuerySnapshot> getTasks({String? userId}) {
    Query query = tasksCollection.orderBy('createdAt', descending: true);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    return query.snapshots();
  }

  /// Get a single task by ID as a stream
  Stream<DocumentSnapshot> getTask(String taskId) {
    return tasksCollection.doc(taskId).snapshots();
  }

  /// Get completed tasks
  Stream<QuerySnapshot> getCompletedTasks({String? userId}) {
    Query query = tasksCollection
        .where('completed', isEqualTo: true)
        .orderBy('updatedAt', descending: true);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    return query.snapshots();
  }

  /// Get pending tasks
  Stream<QuerySnapshot> getPendingTasks({String? userId}) {
    Query query = tasksCollection
        .where('completed', isEqualTo: false)
        .orderBy('createdAt', descending: true);

    if (userId != null) {
      query = query.where('userId', isEqualTo: userId);
    }

    return query.snapshots();
  }

  /// Create or update user profile
  Future<void> saveUserProfile({
    required String userId,
    required String email,
    String? displayName,
    String? photoUrl,
  }) async {
    try {
      await usersCollection.doc(userId).set({
        'email': email,
        'displayName': displayName ?? '',
        'photoUrl': photoUrl ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'lastLogin': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw 'Error saving user profile: $e';
    }
  }

  /// Get user profile
  Future<DocumentSnapshot> getUserProfile(String userId) async {
    try {
      return await usersCollection.doc(userId).get();
    } catch (e) {
      throw 'Error getting user profile: $e';
    }
  }

  /// Listen to user profile changes
  Stream<DocumentSnapshot> getUserProfileStream(String userId) {
    return usersCollection.doc(userId).snapshots();
  }

  /// Batch operation example - Add multiple tasks at once
  Future<void> addMultipleTasks(List<Map<String, dynamic>> tasks) async {
    try {
      final WriteBatch batch = _firestore.batch();

      for (var taskData in tasks) {
        final DocumentReference docRef = tasksCollection.doc();
        batch.set(docRef, {
          ...taskData,
          'createdAt': FieldValue.serverTimestamp(),
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }

      await batch.commit();
    } catch (e) {
      throw 'Error adding multiple tasks: $e';
    }
  }
}
