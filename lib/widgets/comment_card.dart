import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_picture/authentication/providers/auth_provider.dart';
import 'package:share_picture/post/models/comment.dart';
import 'package:share_picture/post/models/post.dart';
import 'package:share_picture/post/providers/post_provider.dart';

class CommentCard extends StatelessWidget {
  final Post post;
  final Comment comment;

  const CommentCard({super.key, required this.post, required this.comment});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
      child: Row(children: [
        Container(
          alignment: Alignment.center,
          child: CircleAvatar(
            foregroundColor: Colors.transparent,
            backgroundImage: NetworkImage(comment.photoUrl),
            radius: 24,
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(
                      text: "${comment.username} ",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  TextSpan(text: comment.comment),
                ])),
                Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateTime.now().difference(comment.postTime).inDays >=
                                  30
                              ? comment.postTime.toString().substring(1, 10)
                              : DateTime.now()
                                          .difference(comment.postTime)
                                          .inHours >=
                                      24
                                  ? "${DateTime.now().difference(comment.postTime).inDays.toString()} days ago"
                                  : "${DateTime.now().difference(comment.postTime).inHours} hours ago",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                            width: MediaQuery.of(context).size.width * 0.2),
                        Text('${comment.likes.length} likes',
                            style: Theme.of(context).textTheme.bodyText2),
                      ],
                    ))
              ],
            ),
          ),
        ),
        Container(
            alignment: Alignment.center,
            child: IconButton(
              icon: comment.likes.contains(user!.uid)
                  ? const Icon(
                      Icons.favorite,
                      color: Color.fromRGBO(244, 67, 54, 1),
                    )
                  : const Icon(
                      Icons.favorite_border,
                    ),
              onPressed: (() {
                final isAdding = comment.likes.contains(user.uid);
                Provider.of<PostProvider>(context, listen: false)
                    .likeDislikeComment(
                        postId: post.id,
                        commentId: comment.id,
                        uid: user.uid,
                        isAdding: !isAdding);
              }),
            ))
      ]),
    );
  }
}
