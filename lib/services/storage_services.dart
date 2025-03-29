import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  static FirebaseStorage storage = FirebaseStorage.instance;

  static Future<String> uploadFile({
    String mainPath = 'uploads',
    String? filePath,
    String? fileName,
    bool isDeleted = false,
  }) async {
    if (filePath == null || fileName == null) {
      if (kDebugMode) print('Invalid file path or name');
      return '';
    }

    File file = File(filePath);
    try {
      await storage.ref('$mainPath/$fileName').putFile(file);
      String downloadURL =
          await storage.ref('$mainPath/$fileName').getDownloadURL();
      print('File uploaded: $downloadURL');

      if (isDeleted) {
        Future.delayed(const Duration(minutes: 5), () async {
          await deleteFile(mainPath, fileName);
        });
      }

      return downloadURL;
    } catch (e) {
      if (kDebugMode) print('Failed to upload file: $e');
      return '';
    }
  }

  static Future<void> deleteFile(String mainPath, String fileName) async {
    try {
      await storage.ref('$mainPath/$fileName').delete();
      print('File deleted after 5 minutes: $mainPath/$fileName');
    } catch (e) {
      if (kDebugMode) print('Failed to delete file: $e');
    }
  }
}
