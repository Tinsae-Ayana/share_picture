import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:share_picture/authentication/providers/auth_provider.dart';
import 'package:share_picture/post/providers/post_provider.dart';
import 'package:share_picture/utils/constants.dart';
import 'package:share_picture/widgets/feed_card.dart';
import '../models/post.dart';

class FeedScreen extends StatelessWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: mobileBackgroundColor,
          title: SvgPicture.asset(log, color: primaryColor, height: 32),
          actions: [
            IconButton(
                onPressed: () {
                  Provider.of<AuthProvider>(context, listen: false)
                      .logoutUser();
                  // Navigator.pushReplacementNamed(
                  //     context, LoginScreen.loginScreen);
                },
                icon: const Icon(Icons.logout))
          ],
        ),
        body: StreamBuilder<List<Post>>(
            stream: context.read<PostProvider>().getAllRealTimePostData(),
            builder: ((context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: ((context, index) => FeedCard(
                        post: snapshot.data![index],
                      )));
            })));
  }
}
