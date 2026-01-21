import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

/// Firebase Storage Service
/// Handles file uploads, downloads, and management in Firebase Cloud Storage
class FirebaseStorageService {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Upload a file to Firebase Storage
  /// Returns the download URL of the uploaded file
  Future<String> uploadFile({
    required File file,
    required String path,
    Function(double)? onProgress,
  }) async {
    try {
      final Reference ref = _storage.ref().child(path);
      final UploadTask uploadTask = ref.putFile(file);

      // Listen to upload progress
      if (onProgress != null) {
        uploadTask.snapshotEvents.listen((TaskSnapshot snapshot) {
          final double progress =
              snapshot.bytesTransferred / snapshot.totalBytes;
          onProgress(progress);
        });
      }

      // Wait for upload to complete
      final TaskSnapshot snapshot = await uploadTask;

      // Get download URL
      final String downloadUrl = await snapshot.ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      throw 'Error uploading file: $e';
    }
  }

  /// Upload an image file (profile picture, post image, etc.)
  Future<String> uploadImage({
    required File imageFile,
    required String userId,
    String folder = 'images',
    Function(double)? onProgress,
  }) async {
    try {
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String fileName = '${userId}_$timestamp.jpg';
      final String path = '$folder/$fileName';

      return await uploadFile(
        file: imageFile,
        path: path,
        onProgress: onProgress,
      );
    } catch (e) {
      throw 'Error uploading image: $e';
    }
  }

  /// Upload a profile picture
  Future<String> uploadProfilePicture({
    required File imageFile,
    required String userId,
    Function(double)? onProgress,
  }) async {
    try {
      final String path = 'profile_pictures/$userId.jpg';
      return await uploadFile(
        file: imageFile,
        path: path,
        onProgress: onProgress,
      );
    } catch (e) {
      throw 'Error uploading profile picture: $e';
    }
  }

  /// Upload a document or file attachment
  Future<String> uploadDocument({
    required File file,
    required String userId,
    required String fileName,
    Function(double)? onProgress,
  }) async {
    try {
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
      final String path = 'documents/$userId/${timestamp}_$fileName';

      return await uploadFile(
        file: file,
        path: path,
        onProgress: onProgress,
      );
    } catch (e) {
      throw 'Error uploading document: $e';
    }
  }

  /// Delete a file from Firebase Storage
  Future<void> deleteFile(String fileUrl) async {
    try {
      final Reference ref = _storage.refFromURL(fileUrl);
      await ref.delete();
    } catch (e) {
      throw 'Error deleting file: $e';
    }
  }

  /// Get file metadata
  Future<FullMetadata> getFileMetadata(String path) async {
    try {
      final Reference ref = _storage.ref().child(path);
      return await ref.getMetadata();
    } catch (e) {
      throw 'Error getting file metadata: $e';
    }
  }

  /// List all files in a directory
  Future<List<String>> listFiles(String path) async {
    try {
      final Reference ref = _storage.ref().child(path);
      final ListResult result = await ref.listAll();

      final List<String> urls = [];
      for (var item in result.items) {
        final String url = await item.getDownloadURL();
        urls.add(url);
      }

      return urls;
    } catch (e) {
      throw 'Error listing files: $e';
    }
  }

  /// Get download URL for a file
  Future<String> getDownloadUrl(String path) async {
    try {
      final Reference ref = _storage.ref().child(path);
      return await ref.getDownloadURL();
    } catch (e) {
      throw 'Error getting download URL: $e';
    }
  }

  /// Upload multiple files
  Future<List<String>> uploadMultipleFiles({
    required List<File> files,
    required String userId,
    String folder = 'uploads',
    Function(int current, int total)? onProgress,
  }) async {
    try {
      final List<String> urls = [];

      for (int i = 0; i < files.length; i++) {
        if (onProgress != null) {
          onProgress(i + 1, files.length);
        }

        final String timestamp =
            DateTime.now().millisecondsSinceEpoch.toString();
        final String path = '$folder/${userId}_${timestamp}_$i';

        final String url = await uploadFile(file: files[i], path: path);
        urls.add(url);
      }

      return urls;
    } catch (e) {
      throw 'Error uploading multiple files: $e';
    }
  }
}
