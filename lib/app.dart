import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_picture/authentication/providers/auth_provider.dart';
import 'package:share_picture/common/providers/common_provider.dart';
import 'package:share_picture/post/providers/post_provider.dart';
import 'package:share_picture/utils/routes.dart';
import 'utils/constants.dart';

class App extends StatelessWidget {
  final AuthProvider authProvider;
  final String initialScreen;
  const App(
      {super.key, required this.initialScreen, required this.authProvider});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(
            value: authProvider,
          ),
          ChangeNotifierProvider(
            create: (context) => PostProvider(authProvider: authProvider),
          ),
          ChangeNotifierProvider<CommonProvider>(
            create: (context) => CommonProvider(),
          )
        ],
        child: MaterialApp(
          debugShowCheckedModeBanner: false,
          initialRoute: initialScreen,
          onGenerateRoute: RouteMobileScreen.ongenerateRoute,
          theme:
              ThemeData.dark().copyWith(backgroundColor: mobileBackgroundColor),
        ));
  }
}
