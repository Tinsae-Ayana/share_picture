import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_picture/utils/constants.dart';

class AuthenticationMethod {
  final _firebaseAuth = FirebaseAuth.instance;

  Future<String> signupUser({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return loginSucess;
    } catch (excp) {
      return loginFailed;
    }
  }

  Future<String> loginUser(
      {required String email, required String password}) async {
    try {
      _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return loginSucess;
    } catch (excp) {
      return loginFailed;
    }
  }

  logout() async {
    await _firebaseAuth.signOut();
  }
}
