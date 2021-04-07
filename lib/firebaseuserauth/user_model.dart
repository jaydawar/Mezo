class UserModel {
  String fullName;
  String userName;
  String phoneNumber;
  String deviceToken;
  String address;
  String profileUrl;
  int createdAt;
  bool chatOnline;

  // int messageID;
  bool isSelected;
  double lat;
  double lng;
  String uid;

  UserModel(
      {this.fullName,
      this.userName,
      this.profileUrl,
      this.isSelected,
      this.phoneNumber,
      this.deviceToken,
      this.address,
      this.chatOnline,
      this.createdAt,
      // this.messageID,
      this.lat,
      this.lng,
      this.uid});

  UserModel.map(dynamic obj) {
    this.fullName = obj['fullName'];
    this.userName = obj['userName'];
    this.uid = obj['uid'];
    this.chatOnline = obj['chatOnline'];
    this.profileUrl = obj['profileUrl'];
    this.lat = obj['lat'];
    this.lng = obj['lng'];
    this.createdAt = obj['createdAt'];
    // this.messageID = obj['messageID'];
    this.address = obj['address'];
    this.deviceToken = obj['deviceToken'];
    this.phoneNumber = obj['phoneNumber'];
  }

  UserModel.fromJson(Map<String, dynamic> json) {
    this.fullName = json['fullName'];
    this.userName = json['userName'];
    this.lat = json['lat'];
    this.profileUrl = json['profileUrl'];
    this.lng = json['lng'];
    this.deviceToken = json['deviceToken'];
    this.address = json['address'];
    this.createdAt = json['createdAt'];
    this.chatOnline = json['chatOnline'];
    // this.messageID = json['messageID'];
    this.uid = json['uid'];
    this.phoneNumber = json['phoneNumber'];
  }

  Map toJson() => {
        'fullName': fullName,
        'userName': userName,
        'profileUrl': profileUrl,
        'deviceToken': deviceToken,
        'uid': uid,
        'lat': lat,
        'chatOnline': chatOnline,
        // 'lng': lng,
        // 'messageID': messageID,
        'address': address,
        'createdAt': createdAt,
        'phoneNumber': phoneNumber,
      };

  Map<String, dynamic> get map {
    return {
      "uid": uid,
      "fullName": fullName,
      "profileUrl": profileUrl,
      "address": address,
      "fcmToken": deviceToken,
      "chatOnline": chatOnline,
      "createdAt": createdAt,
      // "messageID": messageID,
      "phoneNumber": phoneNumber,
      "lat": lat,
      "lng": lng,
    };
  }
}
