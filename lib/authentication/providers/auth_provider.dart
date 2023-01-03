import 'package:flutter/foundation.dart';
import 'package:share_picture/authentication/services/auth_services.dart';
import 'package:share_picture/common/models/user.dart';
import 'package:share_picture/utils/constants.dart';

enum Status { authenticated, notAuthenticated, inprogress }

class AuthProvider extends ChangeNotifier {
  String username = '';
  String email = '';
  String password = '';
  String bio = '';
  Uint8List? imageFile;
  User? user;
  final _authService = AuthService();
  String message = "please fill the field first!";
  Status status = Status.notAuthenticated;

  copyWith({username, email, password, bio, uid}) {
    user = User(
      bio: bio ?? this.bio,
      username: username ?? this.username,
      password: password ?? this.password,
      profilePhoto: '',
      email: email ?? this.email,
      uid: uid ?? '',
      followers: [],
      followings: [],
    );
  }

  changeUsername(String username) {
    this.username = username;
    copyWith(username: username);
    notifyListeners();
  }

  changeEmail(String email) {
    this.email = email;
    copyWith(email: email);
    notifyListeners();
  }

  changePassword(String password) {
    this.password = password;
    copyWith(password: password);
    notifyListeners();
  }

  changeBio(String bio) {
    this.bio = bio;
    copyWith(bio: bio);
    notifyListeners();
  }

  changeImageFile(imageFile) {
    this.imageFile = imageFile;
    notifyListeners();
  }

  loginWithEmailandPassword() async {
    status = Status.inprogress;
    debugPrint('before the validation');
    if (inputValidatorForLogin()) {
      debugPrint('inside validation');
      final messagePass =
          await _authService.login(email: email, password: password);
      if (messagePass == loginSucess) {
        message = 'Logged in succesfully';
        status = Status.authenticated;
        notifyListeners();
      } else {
        message = messagePass;
        status = Status.notAuthenticated;
        notifyListeners();
      }
    } else {
      message = 'Some error has occur';
      status = Status.notAuthenticated;
      notifyListeners();
    }
  }

  createAccount() async {
    status = Status.inprogress;
    notifyListeners();
    if (inputValidatorForSignup()) {
      final messagePass = await _authService.signupUser(
          data: user!.toJson(), imageFile: imageFile);
      if (messagePass == loginSucess) {
        await getUser();
        message = messagePass;
        status = Status.authenticated;
        notifyListeners();
      } else {
        message = messagePass;
      }
    } else {
      message = 'Make sure to fill the form again';
      status = Status.notAuthenticated;
      notifyListeners();
    }
  }

  logoutUser() {
    _authService.logoutUser();
    status = Status.notAuthenticated;
    notifyListeners();
  }

  Future<User?> getUser() async {
    user = await _authService.getUser();
    return user;
  }

  bool inputValidatorForLogin() {
    final bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    final bool validPassword = password != '';

    if (validPassword && emailValid) {
      return true;
    } else {
      return false;
    }
  }

  bool inputValidatorForSignup() {
    final emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    final validName = username != '';
    final validBio = bio != '';
    final validImage = imageFile != null;

    if (emailValid && validImage && validBio && validName) {
      return true;
    } else {
      return false;
    }
  }
}
