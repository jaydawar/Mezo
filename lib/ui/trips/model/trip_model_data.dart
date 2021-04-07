import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';

class TripModelData {
  String tripTitle;
  String location;
  String createrUid;
  String address;
  int tripDate;
  int createdAt;
  double lat;
  double lng;
  bool isEmpty;
  List<Attendee> attendeeList;
  String uid;

  TripModelData(
      {this.tripTitle,
      this.tripDate,
      this.isEmpty,
      this.location,
      this.attendeeList,
      this.createrUid,
      this.address,
      this.createdAt,
      this.lat,
      this.lng,
      this.uid});

  TripModelData.map(dynamic obj) {
    this.tripTitle = obj['tripTitle'];
    this.uid = obj['uid'];
    this.tripDate = obj['tripDate'];
    this.attendeeList = obj['attendeeList'];
    this.lat = obj['lat'];
    this.lng = obj['lng'];
    this.createdAt = obj['createdAt'];
    this.address = obj['address'];
    this.createrUid = obj['createrUid'];
    this.location = obj['location'];
  }

  TripModelData.fromJson(Map<String, dynamic> json) {
    this.tripTitle = json['tripTitle'];
    this.lat = json['lat'];
    if (json['attendeeList'] != null) {
      print("json['attendeeList'] ${json['attendeeList']}");
      attendeeList = List<Attendee>();
      json['attendeeList'].forEach((v) {
        attendeeList.add(Attendee.fromJson(v));
      });
    }
    this.tripDate = json['tripDate'];
    this.lng = json['lng'];
    this.createrUid = json['createrUid'];
    this.address = json['address'];
    this.createdAt = json['createdAt'];
    this.uid = json['uid'];
    this.location = json['location'];
  }

  Map toJson() => {
        'tripTitle': tripTitle,
        'attendeeList': attendeeList,
        'tripDate': tripDate,
        'createrUid': createrUid,
        'uid': uid,
        'lat': lat,
        'lng': lng,
        'address': address,
        'createdAt': createdAt,
        'location': location,
      };

  // var array=FieldValue.arrayUnion(tripModelData.attendeeList);
  // log("array${({
  // "characteristics" : FieldValue.arrayUnion(["generous","loving","loyal"])
  // })}");
  Map<String, dynamic> get map {
    List<Map> list = new List();

    if (attendeeList != null && attendeeList.isNotEmpty) {
      attendeeList.forEach((grp) {
        list.add(grp.toJson());
      });
    }

    return {
      "uid": uid,
      "attendeeList": list,
      "tripTitle": tripTitle,
      "tripDate": tripDate,
      "address": address,
      "createrUid": createrUid,
      "createdAt": createdAt,
      "location": location,
      "lat": lat,
      "lng": lng,
    };
  }
}

class Attendee {
  String attendeeUid;
  bool status;
  bool isDecline;

  Attendee({this.status, this.attendeeUid, this.isDecline});

  Attendee.fromJson(Map<String, dynamic> json) {
    attendeeUid = json['attendeeUid'];
    status = json['status'];
    isDecline = json['isDecline'];
  }

  Map toJson() => {
        'status': status,
        'attendeeUid': attendeeUid,
        'isDecline': isDecline,
      };
}
