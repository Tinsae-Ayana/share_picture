import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:provider/provider.dart';
import 'package:share_picture/authentication/providers/auth_provider.dart';
import 'package:share_picture/authentication/screens/signup_screen.dart';
import 'package:share_picture/utils/constants.dart';
import 'package:share_picture/widgets/button.dart';
import 'package:share_picture/widgets/test_field_input.dart';

class LoginScreen extends StatefulWidget {
  static const loginScreen = '/LoginScreen';
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    super.dispose();
  }

  _onLoginButtonPressed(context) async {
    Provider.of<AuthProvider>(context, listen: false)
        .changePassword(_passwordTextEditingController.text);
    Provider.of<AuthProvider>(context, listen: false)
        .changeEmail(_emailTextEditingController.text);
    await Provider.of<AuthProvider>(context, listen: false)
        .loginWithEmailandPassword();

    // if (Provider.of<AuthProvider>(context, listen: false).status ==
    //     Status.authenticated) {
    //   Navigator.of(context)
    //       .pushReplacementNamed(MobileHomeScreen.mobileHomeScreen);
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content:
    //           Text(Provider.of<AuthProvider>(context, listen: false).message)));
    // }

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text(Provider.of<AuthProvider>(context, listen: false).message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  log,
                  color: primaryColor,
                  height: 64.0,
                ),
                const SizedBox(height: 50),
                TextFieldInput(
                    textEditingController: _emailTextEditingController,
                    textInputType: TextInputType.emailAddress,
                    hintText: "email"),
                const SizedBox(height: 50),
                TextFieldInput(
                    isPass: true,
                    textEditingController: _passwordTextEditingController,
                    textInputType: TextInputType.text,
                    hintText: "password"),
                const SizedBox(height: 30.0),
                Selector<AuthProvider, Status>(
                    selector: (p0, p1) => p1.status,
                    builder: (context, status, widget) {
                      if (status == Status.inprogress) {
                        return const CircularProgressIndicator();
                      } else {
                        return Button(
                            color: blueColor,
                            label: 'Log in',
                            onpressed: () => _onLoginButtonPressed(context));
                      }
                    }),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: const Text("Don't Have Account?"),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: TextButton(
                        onPressed: () => Navigator.of(context)
                            .pushNamed(SignupScreen.signupScreen),
                        child: const Text(
                          "Sign up",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
