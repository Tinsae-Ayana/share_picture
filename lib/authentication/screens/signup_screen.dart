import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:share_picture/utils/constants.dart';
import 'package:share_picture/widgets/button.dart';
import 'package:share_picture/widgets/test_field_input.dart';

import '../providers/auth_provider.dart';

class SignupScreen extends StatefulWidget {
  static const signupScreen = '/signupScreen';
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailTextEditingController = TextEditingController();
  final _passwordTextEditingController = TextEditingController();
  final _bioTextEditingController = TextEditingController();
  final _userNameTextEditingController = TextEditingController();

  @override
  void dispose() {
    _emailTextEditingController.dispose();
    _passwordTextEditingController.dispose();
    _bioTextEditingController.dispose();
    _userNameTextEditingController.dispose();
    super.dispose();
  }

  _onSigninButtonPressed(context) async {
    Provider.of<AuthProvider>(context, listen: false)
        .changePassword(_passwordTextEditingController.text);
    Provider.of<AuthProvider>(context, listen: false)
        .changeEmail(_emailTextEditingController.text);
    Provider.of<AuthProvider>(context, listen: false)
        .changeBio(_bioTextEditingController.text);
    Provider.of<AuthProvider>(context, listen: false)
        .changeUsername(_userNameTextEditingController.text);

    await Provider.of<AuthProvider>(context, listen: false).createAccount();
    // await Provider.of<AuthProvider>(context, listen: false).getUser();
    // if (Provider.of<AuthProvider>(context, listen: false).status ==
    //     Status.authenticated) {
    //   Navigator.of(context).pushNamedAndRemoveUntil(
    //       MobileHomeScreen.mobileHomeScreen, (Route<dynamic> route) => false);
    // } else {
    //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    //       content:
    //           Text(Provider.of<AuthProvider>(context, listen: false).message)));
    // }
  }

  void selectImage(context) async {
    final picker = ImagePicker();
    final xFile = await picker.pickImage(source: ImageSource.gallery);
    final imageFile = await xFile!.readAsBytes();
    Provider.of<AuthProvider>(context, listen: false)
        .changeImageFile(imageFile);
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
                const SizedBox(height: 10),
                GestureDetector(
                  onTap: () => selectImage(context),
                  child: Selector<AuthProvider, Uint8List?>(
                    selector: (p0, p1) => p1.imageFile,
                    builder: ((context, value, child) {
                      return Stack(
                        children: [
                          CircleAvatar(
                            radius: 64.0,
                            backgroundImage: value == null
                                ? const AssetImage(defaultUser) as ImageProvider
                                : MemoryImage(value),
                          ),
                          Positioned(
                              bottom: -10,
                              left: 80,
                              child: IconButton(
                                icon: const Icon(Icons.add_a_photo),
                                onPressed: (() {}),
                              ))
                        ],
                      );
                    }),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFieldInput(
                    textEditingController: _userNameTextEditingController,
                    textInputType: TextInputType.text,
                    hintText: "Enter your username"),
                const SizedBox(height: 20),
                TextFieldInput(
                    textEditingController: _emailTextEditingController,
                    textInputType: TextInputType.emailAddress,
                    hintText: "Enter your email"),
                const SizedBox(height: 20),
                TextFieldInput(
                    isPass: true,
                    textEditingController: _passwordTextEditingController,
                    textInputType: TextInputType.text,
                    hintText: "password"),
                const SizedBox(height: 20.0),
                TextFieldInput(
                    textEditingController: _bioTextEditingController,
                    textInputType: TextInputType.text,
                    hintText: "Enter your bio"),
                const SizedBox(height: 30),
                Selector<AuthProvider, Status>(
                    selector: (p0, p1) => p1.status,
                    builder: (context, status, widget) {
                      if (status == Status.inprogress) {
                        return const CircularProgressIndicator();
                      } else {
                        return Button(
                            color: blueColor,
                            label: 'Sign in',
                            onpressed: () {
                              _onSigninButtonPressed(context);
                            });
                      }
                    }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
