import 'package:flutter/material.dart';
import 'package:share_picture/authentication/providers/auth_provider.dart';
import 'package:share_picture/utils/constants.dart';
import 'package:share_picture/widgets/comment_card.dart';
import '../../common/models/user.dart';
import '../models/post.dart';
import '../providers/post_provider.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatelessWidget {
  static const String commentScreen = '/commentString';
  final Post post;
  final commentEditingController = TextEditingController();
  CommentScreen({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context).user;
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: mobileBackgroundColor,
        title: const Text('comments'),
        centerTitle: false,
      ),
      body: Center(
          child: StreamBuilder(
              stream:
                  context.read<PostProvider>().getCommentInRealtime(post: post),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const CircularProgressIndicator();
                } else {
                  if (snapshot.hasData) {
                    return ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          return CommentCard(
                              post: post, comment: snapshot.data![index]);
                        });
                  } else if (snapshot.hasError) {
                    return const Center(
                        child: Text('Some error has occured loading comments'));
                  } else {
                    return const Center(child: Text('No comments yet'));
                  }
                }
              })),
      bottomNavigationBar: _inputComment(context, user),
    );
  }

  Widget _inputComment(BuildContext context, User? user) {
    return SafeArea(
        child: Container(
      height: kToolbarHeight,
      margin: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      padding: const EdgeInsets.only(left: 16, right: 8),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(user!.profilePhoto),
            radius: 18,
          ),
          Expanded(
            child: Padding(
                padding: const EdgeInsets.only(left: 16, right: 8),
                child: TextField(
                  autofocus: true,
                  controller: commentEditingController,
                  decoration: const InputDecoration(
                      border: InputBorder.none, hintText: 'comment'),
                )),
          ),
          IconButton(
              onPressed: () {
                if (commentEditingController.text != '') {
                  Provider.of<PostProvider>(context, listen: false).postComment(
                      uid: post.uid,
                      username: user.username,
                      photoUrl: user.profilePhoto,
                      postTime: DateTime.now(),
                      comment: commentEditingController.text,
                      postId: post.id);
                  commentEditingController.clear();
                }
              },
              icon: const Icon(
                Icons.send,
                color: primaryColor,
              )),
        ],
      ),
    ));
  }
}
