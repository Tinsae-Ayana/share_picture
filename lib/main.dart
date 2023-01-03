import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:share_picture/app.dart';
import 'package:share_picture/authentication/screens/login_screen.dart';
import 'package:share_picture/common/screens/mobile_home_screen.dart';
import 'authentication/providers/auth_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(AppRoot());
}

class AppRoot extends StatelessWidget {
  final authProvider = AuthProvider();
  AppRoot({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // if (FirebaseAuth.instance.currentUser == null) {
    //   return App(
    //     initialScreen: LoginScreen.loginScreen,
    //     authProvider: authProvider,
    //   );
    // } else {
    //   return FutureBuilder(
    //       future: authProvider.getUser(),
    //       builder: (context, futuresnapshot) {
    //         if (futuresnapshot.connectionState == ConnectionState.waiting) {
    //           return const WaitingWidget();
    //         } else {
    //           return App(
    //             initialScreen: MobileHomeScreen.mobileHomeScreen,
    //             authProvider: authProvider,
    //           );
    //         }
    //       });
    // }
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, streamsnapshot) {
          if (streamsnapshot.hasData) {
            return FutureBuilder(
                future: authProvider.getUser(),
                builder: (context, futuresnapshot) {
                  if (futuresnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return const WaitingWidget();
                  } else {
                    return App(
                      initialScreen: MobileHomeScreen.mobileHomeScreen,
                      authProvider: authProvider,
                    );
                  }
                });
          } else if (streamsnapshot.connectionState ==
              ConnectionState.waiting) {
            return const WaitingWidget();
          }
          return App(
            initialScreen: LoginScreen.loginScreen,
            authProvider: authProvider,
          );
        });
  }
}

class WaitingWidget extends StatelessWidget {
  const WaitingWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Directionality(
      textDirection: TextDirection.rtl,
      child: Center(
          child: SpinKitChasingDots(
        size: 20,
        color: Colors.blueAccent,
      )),
    );
  }
}
