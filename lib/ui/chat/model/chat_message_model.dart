class ChatMessageModel {
  String fromId;
  String toID;
  String message;
  String profilePicUrl;
  String messageType;
  String toUserName;
  String fromUserName;
  String fileUrl;
  int createdAt;
  String chatRoomId;
  String status;

  ChatMessageModel({
    this.fromId,
    this.toID,
    this.message,
    this.profilePicUrl,
    this.messageType,
    this.chatRoomId,
    this.status,
    this.createdAt,
    this.fileUrl,
    this.toUserName,
    this.fromUserName,
  });

  ChatMessageModel.map(dynamic obj) {
    this.fromId = obj['fromId'];
    this.toID = obj['toID'];
    this.fromUserName = obj['fromUserName'];
    this.fileUrl = obj['fileUrl'];
    this.toUserName = obj['toUserName'];
    this.profilePicUrl = obj['profilePicUrl'];
    this.message = obj['message'];
    this.status = obj['status'];
    this.createdAt = obj['createdAt'];
    this.messageType = obj['messageType'];
    this.chatRoomId = obj['chatRoomId'];
  }

  ChatMessageModel.fromJson(Map<String, dynamic> obj) {
    this.fromId = obj['fromId'];
    this.toID = obj['toID'];
    this.fromUserName = obj['fromUserName'];
    this.fileUrl = obj['fileUrl'];
    this.toUserName = obj['toUserName'];
    this.profilePicUrl = obj['profilePicUrl'];
    this.message = obj['message'];
    this.status = obj['status'];
    this.createdAt = obj['createdAt'];
    this.messageType = obj['messageType'];
    this.chatRoomId = obj['chatRoomId'];
  }

  Map<String, dynamic> get map {
    return {
      'fromId': fromId,
      'toID': toID,
      'profilePicUrl': profilePicUrl,
      'fromUserName': fromUserName,
      'fileUrl': fileUrl,
      'toUserName': toUserName,
      'message': message,
      'status': status,
      'createdAt': createdAt,
      'messageType': messageType,
      'chatRoomId': chatRoomId,
    };
  }
  Map toJson() => {
    'fromId': fromId,
    'toID': toID,
    'profilePicUrl': profilePicUrl,
    'fromUserName': fromUserName,
    'fileUrl': fileUrl,
    'toUserName': toUserName,
    'message': message,
    'status': status,
    'createdAt': createdAt,
    'messageType': messageType,
  };
}
