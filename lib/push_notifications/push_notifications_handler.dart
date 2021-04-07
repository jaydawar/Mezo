import 'dart:io';
import 'dart:math';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/ui/chat/chat_message_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/color_resources.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';



class PushNotificationsHandler extends NavigatorObserver {
  PushNotificationsHandler() {
    _setup();
  }
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  void _setup() {

    var initializationSettingsIOS = new IOSInitializationSettings(
        onDidReceiveLocalNotification: (i, string1, string2, string3) {
          print("received notifications");
        });
    var initializationSettings = new InitializationSettings( iOS: initializationSettingsIOS);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (string) {
          print("selected notification");
        });
    if (Platform.isIOS) {
      _requestPermissionOniOS();

    } else if (Platform.isAndroid) {
      _firebaseMessaging.getToken().then((token) => UserRepo.getInstance().setFCMToken(token));
    }

    _firebaseMessaging.configure(onMessage: (Map<String, dynamic> message) {
      print("Incoming notification message:");
      print(message);
      showNotification(message);
      return Future.microtask(() => true);
    }, onResume: (Map<String, dynamic> message) {
      return _handleIncomingNotification(message);
    }, onLaunch: (Map<String, dynamic> message) {
      return _handleIncomingNotification(message);
    });
  }

  void _requestPermissionOniOS() {
    _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered.first.then((settings) {
      if (settings.alert) {
        _firebaseMessaging.getToken().then((token)            {
          print("token$token");
          UserRepo.getInstance().setFCMToken(token);
        });
      }
    });
  }


  void showNotification(Map<String, dynamic> msg) async {
    print("CustomNotification$msg");
    String title = "";
    String body = "";
    String profilePic = "";
    if (!Platform.isIOS) {
      title = msg['data']['title'];
      body = msg['data']['body'];
    } else {
      title = msg['notification']['title'];
      body = msg['notification']['body'];

      //SigmaUtils.showToast('title$title');
    }

    var iOS = new IOSNotificationDetails();
    var platform = new NotificationDetails( iOS: iOS);
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project

    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(100),
      '$title',
      '$body',
      platform,
    );
  }
  Future<bool> _handleIncomingNotification(Map<String, dynamic> payload) async {
    Map<dynamic, dynamic> data = payload["data"];
    print("dataPayLoad${data}");
    UserModel otherUser = UserModel();
    UserModel currentUser = await UserRepo.getInstance().getCurrentUser();
    if (currentUser == null) {
      return false;
    }
    /*ChatRepo.getInstance().getChatroom(data["chatroom_id"], currentUser, otherUser,)
        .then(
      (chatroom) {
        navigator.pushAndRemoveUntil(
            MaterialPageRoute(
                builder: (context) => ChatMessageScreen(

                    )),
            (Route<dynamic> route) => route.isFirst);
        return true;
      },
    );*/
    return false;
  }
}
