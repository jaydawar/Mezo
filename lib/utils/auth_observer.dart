import 'dart:async';

import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/models/user_repo.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'navigation_helper.dart';



class AuthObserver extends NavigatorObserver {
  AuthObserver() {
    _setup();
  }

  StreamSubscription<firebase.User> _authStateListener;

  Future<void> _setup() async {
    await Firebase.initializeApp();
    if (_authStateListener == null) {
      _authStateListener = firebase.FirebaseAuth.instance.authStateChanges().listen((user) {
        if (user != null) {
          final loginProvider = user.providerData.first.providerId;
          // UserRepo.getInstance().setCurrentUser(UserModel(
          //
          // ));
          if (loginProvider.contains("phone") ) {
            // TODO analytics call for phone
          } else {

          }
         // NavigationHelper.navigateToMain(navigator.context, removeUntil: (_) => false);
        } else {
        // NavigationHelper.navigateToLogin(navigator.context, removeUntil: (_) => false);
        }
      }, onError: (error) {
        NavigationHelper.navigateToLogin(navigator.context, removeUntil: (_) => false);
      });
    }
  }

  void close() {
    _authStateListener?.cancel();
  }
}
