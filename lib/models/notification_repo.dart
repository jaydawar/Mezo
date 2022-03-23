import 'dart:html';

import 'package:app/push_notifications/notifiaction_model.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:rxdart/rxdart.dart';

import 'firebase_repo.dart';

class NotificationRepo {
  static NotificationRepo _instance;

  final FirebaseFirestore _firestore;

  NotificationRepo._internal(this._firestore);

  factory NotificationRepo.getInstance() {
    if (_instance == null) {
      _instance =
          NotificationRepo._internal(FirebaseRepo.getInstance().firestore);
      _instance.getNotificationRepoInternal();
    }
    return _instance;
  }

  // ignore: close_sinks
  final _notificationList = BehaviorSubject<List<NotificationModel>>();

  void getNotificationRepoInternal() {
    print("currentUserIdValue  $currentUserIdValue");
    _firestore
        .collection(FirestorePaths.NOTIFICATIONS_COLLECTION)
        .where('receiverUid', isEqualTo: currentUserIdValue)
        .snapshots()
        .map((data) => Deserializer.deserializeNotifications(data.docs))
        .listen((trips) {
      _notificationList.sink.add(trips);
    });
  }

  Stream<List<NotificationModel>> getNotificationStream() {
    return _notificationList.stream;
  }

  void addNewNotification({TripModelData tripModelData}) async {
    print("tripModelData.map${tripModelData.map}");

    await _firestore
        .collection(FirestorePaths.NOTIFICATIONS_COLLECTION)
        .add(tripModelData.map)
        .then((snapShot) {
      var uid = snapShot.id;
      addNotificationUId(uid);
    });
  }

  Future<void> sendNotification(
      {String receiverId,
      String msg,
      String title,
      VoidCallback onApiCallDone}) async {
    String fcmUrl = "https://fcm.googleapis.com/fcm/send";
    var token = getToken(receiverId);
    print('token : $token');

    final data = {
      "notification": {"body": msg, "title": title},
      "priority": FcmPushNotifications.PRIORITY,
      "data": {
        "click_action": FcmPushNotifications.CLICK_ACTION,
        "id": "1",
        "status": "done"
      },
      "to": "$token"
    };

    final headers = {
      'content-type': 'application/json',
      'Authorization': 'key=${FcmPushNotifications.SERVR_KEY}'
    };

    BaseOptions options = new BaseOptions(
      connectTimeout: 5000,
      receiveTimeout: 3000,
      headers: headers,
    );

    try {
      final response = await Dio(options).post(fcmUrl, data: data);

      if (response.statusCode == 200) {
        //  Fluttertoast.showToast(msg: 'Notification Sent to User');
        onApiCallDone();
      } else {
        print('notification sending failed');
        onApiCallDone();
        // on failure do sth
      }
    } catch (e) {
      print('exception $e');
      onApiCallDone();
    }
  }

  static Future<String> getToken(userId) async {
    final FirebaseFirestore _db = FirebaseFirestore.instance;

    var token;
    await _db
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(userId)
        .get()
        .then((snapshot) {
      token = snapshot.data()['deviceToken'];
    });

    return token;
  }

  addNotificationUId(String uid) {
    _firestore
        .collection(FirestorePaths.NOTIFICATIONS_COLLECTION)
        .doc(uid)
        .update({'uid': uid});
  }

  void updateNotification({String tripUid, String tripDate}) {
    _firestore
        .collection(FirestorePaths.NOTIFICATIONS_COLLECTION)
        .doc(tripUid)
        .set({"tripDate": tripDate});
  }
}
