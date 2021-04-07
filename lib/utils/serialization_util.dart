import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/models/message.dart';
import 'package:app/ui/chat/model/chat_message_model.dart';
import 'package:app/push_notifications/notifiaction_model.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Deserializer {

  static List<ChatMessageModel> deserializeUsersFromReference(List<DocumentReference> references, List<ChatMessageModel> users) {
    return users.where((item) => references.any((reference) => reference.id == item.chatRoomId)).toList();
  }

  static List<UserModel> deserializeUsers(List<DocumentSnapshot> userModelList) {
    return userModelList.map((document) => deserializeUser(document)).toList();
  }


  static List<TripModelData> deserializeTrips(List<DocumentSnapshot> tripsListData) {
    return tripsListData.map((document) => deserializeTrip(document)).toList();
  }
  static TripModelData deserializeTrip(DocumentSnapshot document) {
    return TripModelData.fromJson(document.data());
  }
 static List<NotificationModel> deserializeNotifications(List<DocumentSnapshot> tripsListData) {
    return tripsListData.map((document) => deserializeNotificatio(document)).toList();
  }

  static UserModel deserializeUser(DocumentSnapshot document) {
    return UserModel.fromJson(document.data());
  }

 static NotificationModel deserializeNotificatio(DocumentSnapshot document) {
    return NotificationModel.fromJson(document.data());
  }



  static List<Message> deserializeMessages(List<dynamic> messages) {
    return messages.map((data) {
      return deserializeMessage(Map<String, dynamic>.from(data), messages);
    }).toList();
  }

  static Message deserializeMessage(Map<String, dynamic> document, List<UserModel> users) {
    DocumentReference authorReference = document['author'];
    UserModel author = users.firstWhere((user) => user.uid == authorReference.id);
    return Message(author, document['createdAt'], document['value']);
  }



  static List<ChatMessageModel> deserializeChatMessages(List<DocumentSnapshot> tripsListData) {
    return tripsListData.map((document) => deserializeChatMessage(document)).toList();
  }
  static ChatMessageModel deserializeChatMessage(DocumentSnapshot document) {
    return ChatMessageModel.fromJson(document.data());
  }
}
