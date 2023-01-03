import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_picture/common/providers/common_provider.dart';
import 'package:share_picture/post/providers/post_provider.dart';
import 'package:share_picture/utils/constants.dart';
import 'package:share_picture/widgets/follow_button.dart';

import '../../post/models/post.dart';

class ProfileScreen extends StatefulWidget {
  static const String profileScreen = '/profileScreen';
  final String userId;
  const ProfileScreen({super.key, required this.userId});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool same = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: Provider.of<CommonProvider>(context, listen: false)
            .getUserInrealTime(userId: widget.userId),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
                child: Container(
              color: Colors.transparent,
              child: const CircularProgressIndicator(
                color: Colors.blueGrey,
                value: 20,
              ),
            ));
          } else {
            if (snapshot.hasData) {
              return _buildUserProfile(snapshot, context);
            } else {
              return const Center(
                child: Text("couldn't get user profile data"),
              );
            }
          }
        }));
  }

  Widget _buildUserProfile(snapshot, BuildContext context) {
    return Scaffold(
      backgroundColor: mobileBackgroundColor,
      appBar: AppBar(
        backgroundColor: mobileBackgroundColor,
        title: Text(snapshot.data!.username),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Column(
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: Colors.grey,
                    backgroundImage: NetworkImage(snapshot.data!.profilePhoto),
                    radius: 40,
                  ),
                  Expanded(
                    child: _buildFollowerFolliwing(context, snapshot.data),
                  )
                ],
              ),
              _buildButtons(context, snapshot.data),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 15),
                child: Text(
                  snapshot.data!.username,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(top: 5),
                child: Text(
                  snapshot.data!.bio,
                  style: const TextStyle(),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
              ),
              _postSection(context, snapshot.data)
            ],
          )
        ],
      ),
    );
  }

  Widget _postSection(BuildContext context, user) {
    return FutureBuilder(
        future: Provider.of<PostProvider>(context, listen: false)
            .getPostofUser(userId: user.uid),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (snapshot.hasData) {
              return GridView.builder(
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 1.5,
                      childAspectRatio: 1),
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) {
                    return Image(
                        fit: BoxFit.cover,
                        image:
                            NetworkImage(snapshot.data![index].photoPostUrl));
                  }));
            } else {
              return const Center(
                child: Text('No posts Yet'),
              );
            }
          }
        });
  }

  Widget _buildButtons(BuildContext context, user) {
    return Consumer<CommonProvider>(builder: (context, provider, widet) {
      return FirebaseAuth.instance.currentUser!.uid == user.uid
          ? const SizedBox()
          : user.followers.contains(FirebaseAuth.instance.currentUser!.uid)
              ? FollowButton(
                  backgroundColor: mobileBackgroundColor,
                  borderColor: Colors.grey,
                  label: 'unfollow',
                  textColor: primaryColor,
                  onPressed: () {
                    provider.followUnfollow(
                        userId: user.uid,
                        myuId: FirebaseAuth.instance.currentUser!.uid,
                        isAdding: false);
                  },
                )
              : FollowButton(
                  backgroundColor: Colors.blue,
                  borderColor: Colors.grey,
                  label: 'Follow',
                  textColor: primaryColor,
                  onPressed: () {
                    provider.followUnfollow(
                        userId: user.uid,
                        myuId: FirebaseAuth.instance.currentUser!.uid,
                        isAdding: true);
                  },
                );
    });
  }

  Widget _buildFollowerFolliwing(BuildContext context, user) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FutureBuilder<List<Post>>(
            future: Provider.of<PostProvider>(context, listen: false)
                .getPostofUser(userId: user.uid),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return _buildStatColumn(0, 'posts');
              } else {
                if (snapshot.hasData) {
                  return _buildStatColumn(snapshot.data!.length, 'posts');
                } else {
                  return _buildStatColumn(0, 'posts');
                }
              }
            }),
        _buildStatColumn(user.followers.length, 'followers'),
        _buildStatColumn(user.followings.length, 'followings')
      ],
    );
  }

  Widget _buildStatColumn(int num, String label) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          num.toString(),
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        Container(
          margin: const EdgeInsets.only(top: 4),
          child: Text(
            label,
            style: const TextStyle(
                fontSize: 15, fontWeight: FontWeight.w400, color: Colors.grey),
          ),
        )
      ],
    );
  }
}
