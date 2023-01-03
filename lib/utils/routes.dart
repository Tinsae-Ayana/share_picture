import 'package:flutter/material.dart';
import 'package:share_picture/authentication/screens/login_screen.dart';
import 'package:share_picture/authentication/screens/signup_screen.dart';
import 'package:share_picture/common/screens/mobile_home_screen.dart';
import 'package:share_picture/common/screens/user_screen.dart';

import '../post/screens/comment_screen.dart';

class RouteMobileScreen {
  static Route? ongenerateRoute(settings) {
    switch (settings.name) {
      case SignupScreen.signupScreen:
        return MaterialPageRoute(builder: ((context) => const SignupScreen()));
      case LoginScreen.loginScreen:
        return MaterialPageRoute(builder: ((context) => const LoginScreen()));
      case MobileHomeScreen.mobileHomeScreen:
        return MaterialPageRoute(
            builder: ((context) => const MobileHomeScreen()));
      case CommentScreen.commentScreen:
        return MaterialPageRoute(
            builder: ((context) => CommentScreen(post: settings.arguments)));
      case ProfileScreen.profileScreen:
        return MaterialPageRoute(
            builder: ((context) => ProfileScreen(
                  userId: settings.arguments,
                )));
      default:
        return null;
    }
  }
}
