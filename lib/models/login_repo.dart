import 'dart:async';

import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:cloud_firestore/cloud_firestore.dart';

import 'firebase_repo.dart';

class LoginRepo {
  static LoginRepo _instance;
  final firebase.FirebaseAuth _auth = firebase.FirebaseAuth.instance;
  final FirebaseFirestore _firestore;

  LoginRepo._internal(this._firestore);

  factory LoginRepo.getInstance() {
    if (_instance == null) {
      _instance = LoginRepo._internal(FirebaseRepo.getInstance().firestore);
    }
    return _instance;
  }

  Future<UserModel> signIn(firebase.AuthCredential credentials) async {
    final authResult = await _auth.signInWithCredential(credentials);
    if (authResult != null && authResult.user != null) {
      final user = authResult.user;
      final token = await UserRepo.getInstance().getFCMToken();
      UserModel serializedUser = UserModel(
          address: "",
          createdAt: Utils.getCuurentTimeinMillies(),
          deviceToken: token,
          fullName: user.displayName,
          lat: 0.0,
          lng: 0.0,
          profileUrl: "",
          phoneNumber: user.phoneNumber,
          uid: user.uid,
          chatOnline: false,
          userName: "");
      await _firestore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(user.uid)
          .set(serializedUser.map, SetOptions(merge: true));
      return serializedUser;
    } else {
      return null;
    }
  }

  Future addUser(String uid, UserModel userModel) async {
    await _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(uid).set({
      'fullName': userModel.fullName,
      'userName': userModel.userName,
      'uid': userModel.uid,
      'lat': userModel.lat,
      'lng': userModel.lng,
      'profileUrl': userModel.profileUrl,
      'phoneNumber': userModel.phoneNumber,
      'createdAt': userModel.createdAt,
      "caseSearch": setSearchParam(userModel.fullName),
      'address': userModel.address,
      'deviceToken': userModel.deviceToken,
    }, SetOptions(merge: true));
  }
  setSearchParam(String caseNumber) {
    List<String> caseSearchList = List();
    String temp = "";
    for (int i = 0; i < caseNumber.length; i++) {
      temp = temp + caseNumber[i].toLowerCase();
      caseSearchList.add(temp);
    }
    return caseSearchList;
  }
  Future<bool> _signOut() async {
    return _auth.signOut().catchError((error) {
      print("LoginRepo::logOut() encountered an error:\n${error.error}");
      return false;
    }).then((value) {
      return true;
    });
  }

  Future<bool> signOut() async {
    return _signOut();
  }
}
