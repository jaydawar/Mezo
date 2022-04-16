import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserRepo {
  static UserRepo _instance;
  UserRepo._internal();

  factory UserRepo.getInstance() {
    if (_instance == null) {
      _instance = UserRepo._internal();
    }
    return _instance;
  }

  Future<UserModel> getCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String userId = prefs.getString(StorageKeys.USER_ID_KEY);
    AppConstants.USERID = userId;
    String userDisplayName = prefs.getString(StorageKeys.USER_DISPLAY_NAME_KEY);
    String userUniqueName = prefs.getString(StorageKeys.USER_UNIQUNAE);
    String userPhotoUrl = prefs.getString(StorageKeys.USER_PHOTO_URL_KEY);
    String fcmToken = prefs.getString(StorageKeys.FCM_TOKEN);
    String userphone = prefs.getString(StorageKeys.USER_PHONE_NUMBER);
    int createdAt = prefs.getInt(StorageKeys.USER_CREATEDAT);
    if (userId != null && userDisplayName != null && userPhotoUrl != null) {
      currentUserIdValue=userId;
      return UserModel(
          uid: userId,
          deviceToken: fcmToken,
          userName: userUniqueName,
          fullName: userDisplayName,
          createdAt: createdAt,
          phoneNumber: userphone,
          lng: 0.0,
          lat: 0.0,
          address: "",
          profileUrl: userPhotoUrl);
    }
    return null;
  }

  void setCurrentUser(UserModel user) async {
    var userData=jsonEncode(user);
    print("JsonDataUserData${jsonEncode(userData)}");
    currentUserIdValue=user.uid;
    print("JsonDataUserData${jsonEncode(currentUserIdValue)}");
    SharedPreferences prefs = await SharedPreferences.getInstance();



    await prefs
        .setString(StorageKeys.USER_ID_KEY, user.uid)
        .then((value) =>
            prefs.setString(StorageKeys.USER_DISPLAY_NAME_KEY, user.fullName))
        .then((value) =>
            prefs.setString(StorageKeys.USER_PHOTO_URL_KEY, user.profileUrl))
        .then((value) =>
            prefs.setString(StorageKeys.USER_PHONE_NUMBER, user.phoneNumber))
        .then((value) =>
            prefs.setString(StorageKeys.USER_UNIQUNAE, user.userName))
        .then(
            (value) => prefs.setString(StorageKeys.USER_ADDRESS, user.address))
        .then(
            (value) => prefs.setInt(StorageKeys.USER_CREATEDAT, user.createdAt))
        .then((value) => prefs.setString(StorageKeys.FCM_TOKEN, user.deviceToken??""));
  }

  void clearCurrentUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

  Future<String> getFCMToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(StorageKeys.FCM_TOKEN);
  }

  void setFCMToken(String token) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.FCM_TOKEN, token);
  }
}
