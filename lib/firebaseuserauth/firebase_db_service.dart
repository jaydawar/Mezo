import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/push_notifications/notifiaction_model.dart';
import 'package:app/ui/chat/model/chat_message_model.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:path/path.dart' as Path;
import 'package:rxdart/rxdart.dart';

String CHATS = "chats", RECENT = "recentChats", MESSAGES = "messages";

class FirebaseDbService {
  final BehaviorSubject showProgressControler = BehaviorSubject<bool>();

  StreamSink get showProgressSink => showProgressControler.sink;

  Stream get showProgressStream => showProgressControler.stream;

  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<bool> doesNameAlreadyExist(String name) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('userName', isEqualTo: name)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    return documents.length == 1;
  }

  Future<UserModel> doesUserIdAlreadyExist(String uid) async {
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();
    if(result!=null&&result.docs!=null&&result.docs.length>0) {
      final List<DocumentSnapshot> documents = result.docs;
      return UserModel.fromJson(documents[0].data());
    }else{
      return null;
    }
  }

  PublishSubject<UserModel> userInfoSink = PublishSubject<UserModel>();

  Stream<UserModel> get userInfoStream => userInfoSink.stream;

  Stream<UserModel> getUserInfoInfoStream({String uid}) async* {
    try {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .limit(1)
          .get();
      final List<DocumentSnapshot> documents = result.docs;

      yield UserModel.fromJson(documents[0].data());
    } catch (e) {
      print(e);
    }
  }

  Future<UserModel> getUserInfoWhere({String uid}) async {
    showProgressSink.add(true);
    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get();
    final List<DocumentSnapshot> documents = result.docs;
    showProgressSink.add(false);
    userInfoSink.sink.add(UserModel.fromJson(documents[0].data()));
    print("documents[0].data()${documents[0].data()}");
    return UserModel.fromJson(documents[0].data());
  }

  Stream<List<ChatMessageModel>> getChats(UserModel currentUser) async* {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    UserModel user = currentUser;
    await for (QuerySnapshot snap in firestore
        .collection(RECENT)
        .doc(user.uid)
        .collection("history")
        .snapshots()) {
      try {
        List<ChatMessageModel> chats = snap.docs
            .map((doc) => ChatMessageModel.fromJson(doc.data()))
            .toList();

        yield chats;
      } catch (e) {
        print(e);
      }
    }
  }

  final _tripList = BehaviorSubject<List<TripModelData>>();

  Stream<List<TripModelData>> get tripListStream => _tripList.stream;

  Stream<List<TripModelData>> getTripsStream() {
    return _tripList.stream;
  }

  void getTripRepoInternal() {
    _firestore
        .collection(FirestorePaths.TRIPS_COLLECTION)
        .orderBy("createdAt", descending: true)
        .snapshots()
        .map((data) => Deserializer.deserializeTrips(data.docs))
        .listen((trips) {
      _tripList.sink.add(trips);
    });
  }

  Future<void> sendNotification(
      {String receiver,
      String msg,
      String type,
      String id,
      String title,
      String senderUid,
      String receiverUid,
      VoidCallback onApiCallDone}) async {
    showProgressSink.add(true);
    String fcmUrl = "https://fcm.googleapis.com/fcm/send";
    var token = receiver;
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
        //Fluttertoast.showToast(msg: 'Notification Sent to User');
        NotificationModel notificationModel = NotificationModel(
            title: title,
            createdAt: Utils.getCuurentTimeinMillies(),
            type: type,
            body: msg,
            id: id,
            receiverUid: receiverUid,
            senderUid: senderUid);
        FirebaseFirestore.instance
            .collection(FirestorePaths.NOTIFICATIONS_COLLECTION)
            .add(notificationModel.map);
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

  Future<void> sendNotificationMultiple(
      {String receiver,
      String msg,
      String type,
      String id,
      String title,
      String senderUid,
      String receiverUid,
      VoidCallback onApiCallDone}) async {
    showProgressSink.add(true);
    String fcmUrl = "https://fcm.googleapis.com/fcm/send";
    var token = await getToken(receiverUid);
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
        // Fluttertoast.showToast(msg: 'Notification Sent to User');
        NotificationModel notificationModel = NotificationModel(
            title: title,
            createdAt: Utils.getCuurentTimeinMillies(),
            type: type,
            body: msg,
            id: id,
            receiverUid: receiverUid,
            senderUid: senderUid);
        FirebaseFirestore.instance
            .collection(FirestorePaths.NOTIFICATIONS_COLLECTION)
            .add(notificationModel.map);
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

  Future<void> sendChatNotification(
      {String receiver,
      String msg,
      String type,
      String id,
      String title,
      String senderUid,
      String receiverUid,
      VoidCallback onApiCallDone}) async {
    String fcmUrl = "https://fcm.googleapis.com/fcm/send";
    var token = receiver;
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
        // Fluttertoast.showToast(msg: 'Notification Sent to User');
        NotificationModel notificationModel = NotificationModel(
            title: title,
            createdAt: Utils.getCuurentTimeinMillies(),
            type: type,
            body: msg,
            id: id,
            receiverUid: receiverUid,
            senderUid: senderUid);
        FirebaseFirestore.instance
            .collection(FirestorePaths.NOTIFICATIONS_COLLECTION)
            .add(notificationModel.map);
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

  Future uploadFile(
      {String bucketName,
      String filePath,
      Function(int) callBackCode,
      Function(String) fileUploaded}) async {
    Reference storageReference = FirebaseStorage.instance
        .ref()
        .child('$bucketName/${Path.basename(filePath)}}');
    UploadTask uploadTask = storageReference.putFile(File(filePath));
    await uploadTask.whenComplete(() {});
    print('File Uploaded');
    storageReference.getDownloadURL().then((fileURL) {
      print('fileURLFile Uploaded$fileURL');
      fileUploaded(fileURL);
    }).catchError((onError) {
      callBackCode(400);
    });
  }

  Future<List<Attendee>> getAttendeeList(String uid) async {
    List<Attendee> attendeeList = List();

    await FirebaseFirestore.instance
        .collection(FirestorePaths.TRIPS_COLLECTION)
        .doc(uid)
        .get()
        .then((document) {
      if (document.exists) {
        // Get the List of Maps
        List values = document.get('attendeeList');
        print('List received: $values');

        // For each map (each message card) in the list, add a MessageCard to the MessageCard list (using the fromJson method)
        for (Map<String, dynamic> map in values) {
          print('Map received in List: $map');

          /// Create the MessageCard from the map
          Attendee messageCard = Attendee.fromJson(map);
          print(
              'Retrieved Message Card: ${messageCard.attendeeUid} | ${messageCard.status}');

          /// Add the MessageCard to the list
          attendeeList.add(messageCard);
          print('Added MessageCard to list: ${attendeeList.last}');
        }
      }
    });

    return attendeeList;
  }

  void sendNewMessage(chatRoomId, ChatMessageModel chatMessageModel) async {
    var timeInMillies = DateTime.now().millisecondsSinceEpoch;
    var documentReference = await FirebaseFirestore.instance
        .collection(FirestorePaths.CHATMESSAGES)
        .doc(chatRoomId)
        .collection(FirestorePaths.MyChat)
        .doc(timeInMillies.toString());
    FirebaseFirestore.instance.runTransaction((transaction) async {
      transaction.set(
        documentReference,
        {
          'fromId': chatMessageModel.fromId,
          'toID': chatMessageModel.toID,
          'message': chatMessageModel.message,
          'createdAt': timeInMillies,
          "chatRoomId": chatRoomId,
          'status': chatMessageModel.status,
          'fromUserName': chatMessageModel.fromUserName,
          'fileUrl': chatMessageModel.fileUrl,
          'toUserName': chatMessageModel.toUserName,
          'messageType': chatMessageModel.messageType,
          'messageUid': timeInMillies,
        },
      );
    });
  }

  void updateTripModel({TripModelData tripModelData, String uid}) async {
    print("tripModelData.map${tripModelData.map}");

    await _firestore
        .collection(FirestorePaths.TRIPS_COLLECTION)
        .doc(uid)
        .set(tripModelData.map)
        .then((snapShot) {
      //updateTripAttendee(tripModelData.attendeeList, uid);
    });
  }

  void declineTripRequest(
      {List<Attendee> mattendeeList,
      String userId,
      TripModelData tripModelData,
      VoidCallback onDecline}) async {
    List<Attendee> attendeeList = [];
    mattendeeList.forEach((element) {
      if (element.attendeeUid == userId) {
        attendeeList.add(Attendee(
            attendeeUid: element.attendeeUid, status: false, isDecline: true));
      } else {
        attendeeList.add(element);
      }
    });
    tripModelData.attendeeList = attendeeList;
    log("attendeeListUpdate${jsonEncode(attendeeList)}");
    updateTripModel(
      uid: tripModelData.uid,
      tripModelData: tripModelData,
    );
    await onDecline();
  }

  void acceptTripRequest(
      {List<Attendee> mattendeeList,
      String userId,
      TripModelData tripModelData,
      VoidCallback onAccept}) async {
    List<Attendee> attendeeList = [];
    tripModelData.attendeeList.forEach((element) {
      if (element.attendeeUid == userId) {
        attendeeList.add(Attendee(
            attendeeUid: element.attendeeUid, isDecline: false, status: true));
      } else {
        attendeeList.add(element);
      }
    });
    tripModelData.attendeeList = attendeeList;
    log("attendeeListUpdate${jsonEncode(attendeeList)}");
    updateTripModel(
      uid: tripModelData.uid,
      tripModelData: tripModelData,
    );
    await onAccept();
  }

  void cancelTrip(String uid) async {
    await _firestore
        .collection(FirestorePaths.TRIPS_COLLECTION)
        .doc(uid)
        .delete();
  }

  void updateTripTime(String uid, int tripDate) async {
    print("updateTripTime$tripDate");
    await _firestore
        .collection(FirestorePaths.TRIPS_COLLECTION)
        .doc(uid)
        .update({'tripDate': tripDate});
  }

  void updateUserProfilePic(String uploadedFileURL, String uid) async {
    await _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(uid)
        .update({'profileUrl': uploadedFileURL});
  }
  void updateUserDeviceToken(String deviceToken, String uid) async {
    await _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(uid)
        .update({'deviceToken': deviceToken});
  }

  void getUsers(searchValue) async {
    await _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .where('fullName', isEqualTo: searchValue.substring(0, 1).toUpperCase())
        .get()
        .then((snapshot) {

    });
  }
}
