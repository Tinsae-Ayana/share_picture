import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:share_picture/authentication/providers/auth_provider.dart';
import 'package:share_picture/post/models/post.dart';
import 'package:share_picture/post/providers/post_provider.dart';
import 'package:share_picture/widgets/like_animation.dart';
import '../common/screens/user_screen.dart';
import '../post/screens/comment_screen.dart';
import '../utils/constants.dart';

class FeedCard extends StatelessWidget {
  final Post post;
  const FeedCard({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AuthProvider>(context, listen: false).user;
    final height = MediaQuery.of(context).size.height;
    return Container(
      color: mobileBackgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _header(context, user),
          GestureDetector(
            onDoubleTap: (() {
              if (!post.likes.contains(user.uid)) {
                Provider.of<PostProvider>(context, listen: false)
                    .likeDislikePost(post: post, isAdding: true, uid: user.uid);
              }
            }),
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  height: height * 0.55,
                  width: double.infinity,
                  child: Image.network(
                    post.photoPostUrl,
                    fit: BoxFit.cover,
                  ),
                ),
                LikeAnimationWidget(
                    smallLike: false,
                    isAnimationg: post.likes.contains(user!.uid),
                    child: const Icon(
                      Icons.favorite,
                      color: Colors.white,
                      size: 100,
                    ))
              ],
            ),
          ),
          _likeComment(context, user),
          _descripViewCom(context),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              post.publishedDate.difference(DateTime.now()).inDays >= 30
                  ? post.publishedDate.toString().substring(1, 10)
                  : DateTime.now().difference(post.publishedDate).inHours >= 24
                      ? "${DateTime.now().difference(post.publishedDate).inDays.toString()} days ago"
                      : "${DateTime.now().difference(post.publishedDate).inHours} hours ago",
              style: const TextStyle(fontSize: 15, color: secondaryColor),
            ),
          ),
        ],
      ),
    );
  }

  Widget _descripViewCom(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${post.likes.length} likes',
              style: Theme.of(context).textTheme.bodyText2),
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, CommentScreen.commentScreen,
                  arguments: post);
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 2),
              child: RichText(
                text: TextSpan(
                    style: const TextStyle(color: primaryColor),
                    children: [
                      TextSpan(
                          text: post.username,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      TextSpan(
                        text: "   ${post.caption}",
                      )
                    ]),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _likeComment(context, user) {
    return Row(
      children: [
        LikeAnimationWidget(
            isAnimationg: !post.likes.contains(user.uid),
            smallLike: true,
            child: post.likes.contains(user.uid)
                ? IconButton(
                    onPressed: () {
                      Provider.of<PostProvider>(context, listen: false)
                          .likeDislikePost(
                              post: post, isAdding: false, uid: user!.uid);
                    },
                    icon: const Icon(
                      Icons.favorite,
                      color: Colors.red,
                    ))
                : IconButton(
                    onPressed: () {
                      Provider.of<PostProvider>(context, listen: false)
                          .likeDislikePost(
                              post: post, isAdding: true, uid: user.uid);
                    },
                    icon: const Icon(
                      Icons.favorite_border,
                      color: primaryColor,
                    ))),
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, CommentScreen.commentScreen,
                  arguments: post);
            },
            icon: const Icon(
              Icons.comment_outlined,
              color: primaryColor,
            )),
      ],
    );
  }

  Widget _header(BuildContext context, user) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      child: Row(children: [
        CircleAvatar(
          radius: 16,
          backgroundImage: NetworkImage(post.photoPoster),
        ),
        Expanded(
            child: GestureDetector(
          onTap: (() {
            Navigator.pushNamed(context, ProfileScreen.profileScreen,
                arguments: post.uid);
          }),
          child: Padding(
              padding: const EdgeInsets.only(left: 8),
              child: Text(
                post.username,
                style: const TextStyle(fontWeight: FontWeight.bold),
              )),
        )),
        IconButton(
          icon: const Icon(Icons.more_vert),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  if (user.uid == post.uid) {
                    return SimpleDialog(
                      children: [
                        ListTile(
                          title: const Text('Delete'),
                          onTap: () {
                            Provider.of<PostProvider>(context, listen: false)
                                .deletePost(postId: post.id);
                            Navigator.pop(context);
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                    duration: Duration(seconds: 1),
                                    content: Text('Post Delete')));
                          },
                        ),
                        ListTile(
                          title: const Text('copy link'),
                          onTap: () async {
                            Navigator.pop(context);
                            await Clipboard.setData(
                                ClipboardData(text: post.photoPostUrl));
                          },
                        ),
                      ],
                    );
                  } else {
                    return SimpleDialog(children: [
                      ListTile(
                        title: const Text('copy link'),
                        onTap: () async {
                          Navigator.pop(context);
                          Clipboard.setData(
                                  ClipboardData(text: post.photoPostUrl))
                              .then((value) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(content: Text('Link copied')));
                          });
                        },
                      )
                    ]);
                  }
                });
          },
        )
      ]),
    );
  }
}
