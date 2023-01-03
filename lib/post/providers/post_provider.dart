import 'package:flutter/foundation.dart';
import 'package:share_picture/post/services/post_services.dart';
import '../../authentication/providers/auth_provider.dart';
import '../models/comment.dart';
import '../models/post.dart';

class PostProvider extends ChangeNotifier {
  PostProvider({required authProvider}) : _authProvider = authProvider;

  final _postService = PostService();
  final AuthProvider _authProvider;
  Uint8List? imageFile;
  String? caption;
  String message = '';

  changeCaption(caption) {
    this.caption = caption;
  }

  changeImageFile(imageFile) {
    debugPrint('change has been called ');
    this.imageFile = imageFile;
    notifyListeners();
  }

  Future<void> postToFirebase() async {
    if (imageFile != null) {
      await _authProvider.getUser();
      final post = Post(
          photoPoster: _authProvider.user!.profilePhoto,
          caption: caption ?? '',
          uid: _authProvider.user!.uid,
          username: _authProvider.user!.username,
          id: '',
          publishedDate: DateTime.now(),
          photoPostUrl: '',
          likes: <String>[]);
      await _postService.uploadPost(data: post.toJson(), imageFile: imageFile);
      message = 'Post uploaded succesfully';
      caption = null;
      imageFile = null;
    } else {
      message = 'Please choose a picture to upload';
    }
    notifyListeners();
  }

  Stream<List<Post>> getAllRealTimePostData() {
    return _postService.getRealTimePost();
  }

  Future<List<Post>> getPostofUser({required userId}) {
    return _postService.getPostByUser(userId: userId);
  }

  Stream<List<Post>> getFavoritePost({required userId}) {
    return _postService.getFavoritePosts(userId: userId);
  }

  deletePost({required postId}) {
    _postService.deletePost(postId: postId);
  }

  likeDislikePost({post, isAdding, uid}) {
    _postService.likeDisLikePost(post: post, isAdding: isAdding, uid: uid);
  }

  postComment({
    uid,
    comment,
    postTime,
    postId,
    username,
    photoUrl,
  }) {
    _postService.uploadComment(
        uid: uid,
        comment: comment,
        postTime: postTime,
        postId: postId,
        username: username,
        photoUrl: photoUrl);
  }

  Stream<List<Comment>> getCommentInRealtime({required post}) {
    return _postService.getRealTimeComment(post: post);
  }

  likeDislikeComment(
      {required postId, required commentId, required uid, required isAdding}) {
    _postService.likeDisLikeComment(
        postId: postId, commentId: commentId, uid: uid, isAdding: isAdding);
  }
}
