import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';

class StorageMethod {
  final _storage = FirebaseStorage.instance;
  final _firebaseAuth = FirebaseAuth.instance;

  Future<String> uploadImageToStorage(
      {required String childName,
      required Uint8List file,
      isPost = false}) async {
    if (isPost) {
      final ref = _storage
          .ref()
          .child(childName)
          .child(_firebaseAuth.currentUser!.uid)
          .child(DateTime.now().toString());
      final uploadTask = await ref.putData(file);
      return uploadTask.ref.getDownloadURL();
    } else {
      final ref =
          _storage.ref().child(childName).child(_firebaseAuth.currentUser!.uid);
      final uploadTask = await ref.putData(file);
      return uploadTask.ref.getDownloadURL();
    }
  }
}
