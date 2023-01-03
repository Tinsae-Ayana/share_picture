import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:share_picture/repositories/firestore_method.dart';
import '../models/user.dart';

class Commonservices {
  final FirestoreMethods _firestoreMethods = FirestoreMethods();
  final StreamController<List<User>> _streamController =
      StreamController<List<User>>();

  Future<User> getOtherUserInfo({required userId}) async {
    final json = await _firestoreMethods.getDataFromFire(
        collectionName: 'users', docName: userId);
    return User.fromJson(json!);
  }

  Stream<User> getOtherUserInfoinRealTime({required userId}) {
    return _firestoreMethods
        .getDataFromADocumentinStream(docName: userId, collectionName: 'users')
        .map((event) => User.fromJson(event));
  }

  search({required searchKey}) async {
    final users = await _firestoreMethods.getDataFromFireBycontent(
        collectionName: 'users', lookingFor: searchKey, field: 'username');
    debugPrint(users.toString());
    _streamController.sink.add(users.map((e) => User.fromJson(e)).toList());
  }

  Stream<List<User>> searchStream() {
    return _streamController.stream;
  }

  followUnfollow({required userId, required myuId, required isAdding}) {
    _firestoreMethods.updataListValuesinFirebase(
        collectionName: 'users',
        docName: myuId,
        uid: userId,
        field: 'followings',
        isAdding: isAdding);
    debugPrint('Inside the follow method');
    _firestoreMethods.updataListValuesinFirebase(
        collectionName: 'users',
        docName: userId,
        uid: myuId,
        field: 'followers',
        isAdding: isAdding);
  }
}
