class NotificationModel {
  NotificationModel(
      {this.type,
      this.id,
      this.createdAt,
      this.title,
      this.body,
      this.receiverUid,
      this.senderUid});

  String body;
  String type;
  String title;
  String id;
  String receiverUid;
  String senderUid;
  int createdAt;

  NotificationModel.fromJson(Map<String, dynamic> json) {
    this.body = json['body'];
    this.type = json['type'];
    this.receiverUid = json['receiverUid'];
    this.senderUid = json['senderUid'];
    this.title = json['title'];
    this.createdAt = json['createdAt'];
    this.id = json['id'];
  }

  Map<String, dynamic> get map {
    return {
      'body': body,
      'title': title,
      'type': type,
      'receiverUid': receiverUid,
      'senderUid': senderUid,
      'id': id,
      'createdAt': createdAt,
    };
  }

  Map toJson() => {
        'body': body,
        'title': title,
        'type': type,
        'receiverUid': receiverUid,
        'senderUid': senderUid,
        'id': id,
        'createdAt': createdAt,
      };
}
