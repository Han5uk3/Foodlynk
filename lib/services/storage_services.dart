import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageService {
  static FirebaseStorage storage = FirebaseStorage.instance;
  static Future<String> uploadFile({
    String? mainPath = 'uploads',
    String? filePath,
    String? fileName,
  }) async {
    File file = File(filePath ?? "");
    try {
      await storage.ref('$mainPath/$fileName').putFile(file);
      String downloadURL =
          await storage.ref('$mainPath/$fileName').getDownloadURL();
      return downloadURL;
    } catch (e) {
      if (kDebugMode) {
        print('Failed to upload file: $e');
      }
      return '';
    }
  }
}
