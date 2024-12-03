import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart' as path;

class FirebaseStorageService {
  final FirebaseStorage _storage;

  FirebaseStorageService({FirebaseStorage? storage}) 
    : _storage = storage ?? FirebaseStorage.instance;

  // Upload a file to Firebase Storage
  Future<String> uploadFile(File file, String folder) async {
  try {
    final fileName = path.basename(file.path);
    final destination = '$folder/$fileName';
    final ref = _storage.ref(destination);
    final uploadTask = ref.putFile(file);
    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  } catch (e) {
    print('Error uploading file: $e');
    return '';
  }
}

  // Retrieve the download URL of a file
  Future<String> getFileUrl(String filePath) async {
    try {
      final ref = _storage.ref(filePath);
      return await ref.getDownloadURL();
    } catch (e) {
      print('Error getting file URL: $e');
      return '';
    }
  }

  // Delete a file from Firebase Storage
  Future<bool> deleteFile(String filePath) async {
    try {
      final ref = _storage.ref(filePath);
      await ref.delete();
      return true;
    } catch (e) {
      print('Error deleting file: $e');
      return false;
    }
  }

  // List all files in a specific folder
  Future<List<String>> listFiles(String folder) async {
    try {
      final ListResult result = await _storage.ref(folder).listAll();
      return result.items.map((item) => item.fullPath).toList();
    } catch (e) {
      print('Error listing files: $e');
      return [];
    }
  }

  // Upload a video file (potentially with different handling)
  Future<String> uploadVideo(File videoFile, String folder) async {
    // You might want to add additional logic here, like compressing the video
    return await uploadFile(videoFile, folder);
  }

  // Get the size of a file in bytes
  Future<int> getFileSize(String filePath) async {
    try {
      final ref = _storage.ref(filePath);
      final metadata = await ref.getMetadata();
      return metadata.size ?? 0;
    } catch (e) {
      print('Error getting file size: $e');
      return 0;
    }
  }

  // Update metadata of a file
  Future<bool> updateMetadata(String filePath, Map<String, String> customMetadata) async {
    try {
      final ref = _storage.ref(filePath);
      final newMetadata = SettableMetadata(customMetadata: customMetadata);
      await ref.updateMetadata(newMetadata);
      return true;
    } catch (e) {
      print('Error updating metadata: $e');
      return false;
    }
  }

  // Copy a file to a new location
  Future<String> copyFile(String sourcePath, String destinationPath) async {
    try {
      final sourceRef = _storage.ref(sourcePath);
      final destRef = _storage.ref(destinationPath);
      await destRef.putString(await sourceRef.getDownloadURL(), format: PutStringFormat.dataUrl);
      return await destRef.getDownloadURL();
    } catch (e) {
      print('Error copying file: $e');
      return '';
    }
  }
}