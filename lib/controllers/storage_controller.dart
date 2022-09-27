import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class StorageController {
  StorageController._privateConstructor();
  static final StorageController _instance = StorageController._privateConstructor();
  factory StorageController() => _instance;

  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;

  firebase_storage.UploadTask initiateUploading(String storagePath, File file) {
    firebase_storage.UploadTask task = storage.ref(storagePath).putFile(file);
    return task;
  }

  Future<bool> uploadFile(String storagePath, File file) async {
    firebase_storage.UploadTask task = initiateUploading(storagePath, file);
    try {
      await task;
      return true;
    } on FirebaseException catch (e) {
      if (e.code == 'permission-denied') {
      }
      return false;
    }
  }

  Future<String?> getDownloadURL(String storagePath) async {
    try {
      final String downloadURL = await storage.ref(storagePath).getDownloadURL();
      return downloadURL;
    } catch (e) {
      return null;
    }
  }

  Future<String?> uploadAndGetUrl(String userId, File file) async {
    final String storagePath = "files/$userId/${DateTime.now().toString()}.mp3";
    final bool successUpload = await uploadFile(storagePath, file);
    if (!successUpload) {
      return null;
    }
    final String? downloadURL = await getDownloadURL(storagePath);
    if (downloadURL == null) {
      return null;
    }
    return downloadURL;
  }
}
