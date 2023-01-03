import 'package:flutter/foundation.dart';
import 'package:share_picture/post/models/comment.dart';
import 'package:share_picture/repositories/firestore_method.dart';
import 'package:share_picture/repositories/storage_method.dart';
import '../models/post.dart';

class PostService {
  final _firebasemethod = FirestoreMethods();
  final _storageMethod = StorageMethod();

  uploadPost({
    required data,
    required imageFile,
  }) async {
    final downloadLink = await _storageMethod.uploadImageToStorage(
        childName: 'posts', file: imageFile, isPost: true);
    data['photoPostUrl'] = downloadLink;
    _firebasemethod.uploadDate(data: data, collectionName: 'posts');
  }

  uploadComment({
    uid,
    comment,
    postTime,
    postId,
    username,
    photoUrl,
  }) async {
    final data = {
      'photoUrl': photoUrl,
      'username': username,
      'uid': uid,
      'comment': comment,
      'postTime': postTime.toString(),
      'likes': []
    };
    _firebasemethod.upLoadDataSub(
        data: data,
        collectionName: 'posts',
        subCollectionName: 'comments',
        docName: postId);
  }

  uploadPostToFavorite({required Post post, required userId}) async {
    await _firebasemethod.upLoadDataSub(
        data: post.toJson(),
        collectionName: 'users',
        subCollectionName: 'favoritePosts',
        docName: userId);
  }

  Future<List<Post>> getPostByUser({required userId}) async {
    final jsonList = await _firebasemethod.getDataFromFireBycontent(
        collectionName: 'posts', lookingFor: userId, field: 'uid');
    return jsonList.map((e) => Post.fromJson(json: e)).toList();
  }

  Stream<List<Post>> getRealTimePost() {
    return _firebasemethod
        .getRealTimeData(collectionName: 'posts')
        .map((event) => event.map((e) => Post.fromJson(json: e)).toList());
  }

  Stream<List<Post>> getFavoritePosts({required userId}) {
    return _firebasemethod
        .getRealTimeDataSub(
            collectionName: 'users',
            subCollectionName: 'favoritePosts',
            docName: userId)
        .map((event) => event.map((e) => Post.fromJson(json: e)).toList());
  }

  Stream<List<Comment>> getRealTimeComment({required Post post}) {
    return _firebasemethod
        .getRealTimeDataSub(
            collectionName: 'posts',
            subCollectionName: 'comments',
            docName: post.id)
        .map((event) {
      debugPrint(event.toList().toString());
      return event.map((e) {
        return Comment.fromJson(json: e);
      }).toList();
    });
  }

  likeDisLikePost({required Post post, isAdding, uid}) {
    _firebasemethod.updataListValuesinFirebase(
        collectionName: 'posts',
        field: 'likes',
        uid: uid,
        docName: post.id,
        isAdding: isAdding);
  }

  likeDisLikeComment(
      {required postId, required commentId, required uid, required isAdding}) {
    _firebasemethod.updateListValueInSub(
        collectionName: 'posts',
        docName: postId,
        subCollection: 'comments',
        docId: commentId,
        field: 'likes',
        value: uid,
        isAdding: isAdding);
  }

  deletePost({required postId}) {
    _firebasemethod.deleteDataInFirebase(
        docId: postId, collectionName: 'posts');
  }
}
