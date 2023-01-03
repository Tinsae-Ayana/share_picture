import 'package:firebase_auth/firebase_auth.dart';
import 'package:share_picture/repositories/authentication_method.dart';
import 'package:share_picture/repositories/firestore_method.dart';
import 'package:share_picture/repositories/storage_method.dart';
import 'package:share_picture/utils/constants.dart';
import 'package:share_picture/common/models/user.dart' as model;

class AuthService {
  final _authMethod = AuthenticationMethod();
  final _firestoreMethod = FirestoreMethods();
  final _storageMethod = StorageMethod();

  Future<String> login({email, password}) async {
    final message = _authMethod.loginUser(email: email, password: password);
    return message;
  }

  Future<String> signupUser({required data, required imageFile}) async {
    final message = await _authMethod.signupUser(
        email: data['email'], password: data['password']);
    if (message == loginSucess) {
      final downloadLink = await _storageMethod.uploadImageToStorage(
          childName: 'profilePictures', file: imageFile);
      data['profilePhoto'] = downloadLink;
      data['uid'] = FirebaseAuth.instance.currentUser!.uid;
      _firestoreMethod.uploadDate(
          data: data, collectionName: 'users', docName: data['uid']);
      return message;
    } else {
      return message;
    }
  }

  logoutUser() {
    _authMethod.logout();
  }

  Future<model.User> getUser() async {
    if (FirebaseAuth.instance.currentUser == null) {
      await FirebaseAuth.instance.currentUser?.reload();
    }
    final json = await _firestoreMethod.getDataFromFire(
        collectionName: 'users',
        docName: FirebaseAuth.instance.currentUser!.uid);

    return model.User.fromJson(json!);
  }
}
