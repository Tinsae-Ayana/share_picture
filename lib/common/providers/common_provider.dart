import 'package:flutter/cupertino.dart';
import 'package:share_picture/common/models/user.dart';
import 'package:share_picture/common/services/common_services.dart';

class CommonProvider with ChangeNotifier {
  final commonServices = Commonservices();

  search({searchKey}) {
    commonServices.search(searchKey: searchKey);
  }

  Stream<List<User>> searchStream() {
    return commonServices.searchStream();
  }

  Stream<User> getUserInrealTime({required userId}) {
    return commonServices.getOtherUserInfoinRealTime(userId: userId);
  }

  Future<User> getOtherUserData({required userId}) {
    return commonServices.getOtherUserInfo(userId: userId);
  }

  followUnfollow({userId, myuId, isAdding}) async {
    await commonServices.followUnfollow(
        userId: userId, myuId: myuId, isAdding: isAdding);

    notifyListeners();
  }
}
