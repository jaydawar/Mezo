import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/ui/chat/model/chat_message_model.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rxdart/rxdart.dart';

import 'firebase_repo.dart';

class AllUserRepo {
  static AllUserRepo _instance;

  final FirebaseFirestore _firestore;

  final _chatUsersSubject = BehaviorSubject<List<UserModel>>();

  Stream<List<UserModel>> get chatMessageListStream => getChatUsers();

  List<UserModel> chatUserMessageList = [];

  AllUserRepo._internal(this._firestore);

  factory AllUserRepo.getInstance() {
    if (_instance == null) {
      _instance = AllUserRepo._internal(FirebaseRepo.getInstance().firestore);

      _instance._getChatUsersInternal();

    }
    return _instance;
  }

  void _getChatUsersInternal() {
    _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .orderBy("fullName")
        .snapshots()
        .map((data) => Deserializer.deserializeUsers(data.docs))
        .listen((users) {
      _chatUsersSubject.sink.add(users);
    });
  }

//i6FoS3ZWfZgnzIxnpagfBz3l4P72
 /* void getUserWhere(String uid) {
    print("getUserWhere$uid");
    _firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .where("uid", isEqualTo: uid)
        .limit(1)
        .snapshots()
        .map((data) => Deserializer.deserializeUsers(data.docs))
        .listen((users) {
      _chatUsersSubject.sink.add(users);
      log("jsonEncodemessage${jsonEncode(users)}");
    });
  }*/

  Stream<List<UserModel>> getChatUsers() {
    return _chatUsersSubject.stream;
  }

  Future<bool> sendMessageToChatroom(
      String chatroomId, UserModel user, String message) async {
    try {
      DocumentReference authorRef =
          _firestore.collection(FirestorePaths.USERS_COLLECTION).doc(user.uid);
      DocumentReference chatroomRef = _firestore
          .collection(FirestorePaths.CHATROOMS_COLLECTION)
          .doc(chatroomId);
      Map<String, dynamic> serializedMessage = {
        "author": authorRef,
        "timestamp": DateTime.now(),
        "value": message
      };
      chatroomRef.update({
        "messages": FieldValue.arrayUnion([serializedMessage])
      });
      return true;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }

  void dismiss() {
    _chatUsersSubject.close();
  }
}

/*

  void _getChatUsersInternal() async {
    await _firestore
        .collection(FirestorePaths.CHATMESSAGES)
        .limit(1)
        .where('toID', isEqualTo: 'i6FoS3ZWfZgnzIxnpagfBz3l4P72asdfa')
        .snapshots()
        .map((data) => Deserializer.deserializeUsers(data.docs))
        .listen((users) {
      print("userstoID${jsonEncode(users)}");
      chatUserMessageList.addAll(users);
    });
    await _firestore
        .collection(FirestorePaths.CHATMESSAGES)
        .limit(1)
        .where('fromId', isEqualTo: 'i6FoS3ZWfZgnzIxnpagfBz3l4P72asdfa')
        .snapshots()
        .map((data) => Deserializer.deserializeUsers(data.docs))
        .listen((users) {
      print("usersfromId${jsonEncode(users)}");
      chatUserMessageList.addAll(users);
    });
    _chatUsersSubject.sink.add(chatUserMessageList);
  }
  */
/*Future<QuerySnapshot> fetchChatListUsers(String loginId) async {
    CollectionReference col = _firestore
        .collection(FirestorePaths.CHATMESSAGES)
        .orderBy('createdAt', descending: true)
        .limit(1);

    Query query = col.where('fromId', isEqualTo: loginId);

    return await query.get();
  }*/
