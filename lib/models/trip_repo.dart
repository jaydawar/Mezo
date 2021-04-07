import 'dart:convert';
import 'dart:developer';

import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

import 'firebase_repo.dart';

class TripRepo {
  static TripRepo _instance;

  final FirebaseFirestore _firestore;

  final _tripList = BehaviorSubject<List<TripModelData>>();

  Stream<List<TripModelData>> get tripListStream => _tripList.stream;

  TripRepo._internal(this._firestore);

  factory TripRepo.getInstance() {
    if (_instance == null) {
      _instance = TripRepo._internal(FirebaseRepo.getInstance().firestore);
      _instance.getTripRepoInternal();
    }
    return _instance;
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

  Stream<List<TripModelData>> getTripsStream() {
    return _tripList.stream;
  }

  void addNewTrip({TripModelData tripModelData}) async {
    print("tripModelData.map${tripModelData.map}");

    await _firestore
        .collection(FirestorePaths.TRIPS_COLLECTION)
        .add(tripModelData.map)
        .then((snapShot) {
      var uid = snapShot.id;
      addTripUId(uid);
      //updateTripAttendee(tripModelData.attendeeList, uid);
    });
  }

  void updateTripModel({TripModelData tripModelData,String uid}) async {
    print("tripModelData.map${tripModelData.map}");

    await _firestore
        .collection(FirestorePaths.TRIPS_COLLECTION).doc(uid)
        .set(tripModelData.map)
        .then((snapShot) {

      //updateTripAttendee(tripModelData.attendeeList, uid);
    });
  }
  Future<void> updateTripAttendee(List<Attendee> attendteeData, String id) {
    List<Map> list = new List();

    if (attendteeData != null && attendteeData.isNotEmpty) {
      attendteeData.forEach((grp) {
        list.add(grp.toJson());
      });
    }
    return _firestore
        .collection(FirestorePaths.TRIPS_COLLECTION)
        .doc(id)
        .update({"attendeeList": FieldValue.arrayUnion(list)});
  }

   acceptTrip(TripModelData tripModelData,List<Attendee> attendteeData, String id,String userId) async{
    List<Map> list = new List();

    if (attendteeData != null && attendteeData.isNotEmpty) {
      attendteeData.forEach((grp) {
        if(grp.attendeeUid==userId){
          grp.status=true;
          list.add(grp.toJson());
        }else {
          list.add(grp.toJson());
        }
      });
    }
    await _firestore
        .collection(FirestorePaths.TRIPS_COLLECTION)
        .doc(id)
        .set({"attendeeList": FieldValue.arrayUnion(list),},SetOptions(
      merge: false
    ));
  }


  addTripUId(String uid) {
    _firestore
        .collection(FirestorePaths.TRIPS_COLLECTION)
        .doc(uid)
        .update({'uid': uid});
  }

  void updateTrip({String tripUid, String tripDate}) {
    _firestore
        .collection(FirestorePaths.TRIPS_COLLECTION)
        .doc(tripUid)
        .set({"tripDate": tripDate});
  }



}
