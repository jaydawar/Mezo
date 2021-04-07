import 'dart:convert';
import 'dart:developer';

import 'package:app/alerts/edit_trip_detail.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/helper/AppConstantHelper.dart';
import 'package:app/ui/dashboard/dashboard.dart';
import 'package:app/ui/trips/common_header.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/ui/trips/tripItems/requested_trip_item.dart';
import 'package:app/ui/trips/tripItems/trip_attending_candidate.dart';
import 'package:app/ui/trips/trip_viewall_screen.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';

import 'commmon_widgets.dart';

class TripDetailScreen extends StatefulWidget {
  bool isEditable;
  TripModelData tripModelData;
  bool isfromViewAll;
  int position;

  TripDetailScreen({this.isEditable, this.position,this.isfromViewAll,this.tripModelData});

  @override
  State<StatefulWidget> createState() {
    return _TripDetailState();
  }
}

class _TripDetailState extends State<TripDetailScreen> {
  FirebaseDbService firebaseDbService = FirebaseDbService();
  AppConstantHelper appConstantHelper = AppConstantHelper();
  BehaviorSubject<String> timetimeSink= BehaviorSubject<String>();
  BehaviorSubject<String> get timeStream=>timetimeSink.stream;
  var time = "";
  var username = "";


  @override
  void initState() {
    firebaseDbService.getUserInfoWhere(uid: widget.tripModelData.createrUid);
    appConstantHelper.setContext(context);
    time = Utils.getTimeFrom(widget.tripModelData.tripDate);
    timetimeSink.sink.add(time);
    log("tripModelDataDetail${jsonEncode(widget.tripModelData)}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.app_screen_bgColor,
      body: WillPopScope(
        onWillPop: (){
          _onBackPress();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CustomHeader(onBackPress: (){
              _onBackPress();
            },showSearch: false,

            ),
            Padding(
              padding: const EdgeInsets.only(left: 25),
              child: tripSubTitle(widget.isEditable ? 'Current' : 'Sent'),
            ),
            SizedBox(
              height: 15,
            ),
            StreamBuilder<UserModel>(
                stream: firebaseDbService.userInfoStream,
                initialData: null,
                builder: (context, snapshot) {
                  if(snapshot.data!=null)
                  username = snapshot.data.fullName;
                  return Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        snapshot.data == null
                            ? CircularProgressIndicator()
                            : appConstantHelper.loadNetworkImage(
                                imageUrl: snapshot.data.profileUrl,
                                height: 98.0,
                                width: 98.0),
                        SizedBox(
                          width: 15,
                        ),
                        tripCreaterUserName(
                            snapshot.data == null ? "" : snapshot.data.fullName)
                      ],
                    ),
                  );
                }),
            tripPartyNameTitle(
                title: 'Trip Name:\t',
                subTitle: widget.tripModelData.tripTitle,
                paddingTop: 10.0,
                paddingLeft: 25.0),
            tripSubMainTitle(
                title: 'Date:\t',
                subTitle: Utils.getDateFrom(widget.tripModelData.tripDate),
                paddingTop: 2.0,
                paddingLeft: 25.0),
            StreamBuilder<String>(
                stream: timeStream,
                initialData: "",
                builder: (BuildContext context,
                    AsyncSnapshot<String> timeSnapShot){

                  return tripSubMainTitle(
                      title: 'Time:\t',
                      subTitle: timeSnapShot.data,
                      paddingTop: 2.0,
                      paddingLeft: 25.0);
                }),

            tripSubMainTitle(
                title: 'Location:\t',
                subTitle: widget.tripModelData.address,
                paddingTop: 2.0,
                paddingLeft: 25.0),
            SizedBox(
              height: 4,
            ),
            editTrip(),
            SizedBox(
              height: 12,
            ),
            attendingText(),
            Expanded(
              child: ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: widget.tripModelData.attendeeList.length,
                  itemBuilder: (BuildContext context, int posotion) {
                    print(
                        "widget.tripModelData.attendeeList.length${widget.tripModelData.attendeeList.length}");
                    return Padding(
                      padding: EdgeInsets.only(left: 25, right: 25),
                      child: widget.tripModelData.attendeeList[posotion].status ==
                              true
                          ? TripCandidateItem(
                              firebaseDbService: firebaseDbService,
                              userId: widget.tripModelData.attendeeList[posotion]
                                  .attendeeUid,
                            )
                          : Container(),
                    );
                  }),
            )
          ],
        ),
      ),
    );
  }

  attendingText() {
    return Padding(
      padding: const EdgeInsets.only(left: 25),
      child: Text(
        'Attending',
        style: TextStyle(
          fontFamily: AppConstants.Poppins_Font,
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: const Color(0xff131621),
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  editTrip() {
    return InkWell(
      onTap: () {
        showDialog(
            context: context,
            barrierDismissible: true,
            builder: (context) {
              return EditTripDetailDialog(
                onUpdateClick: (timeUpdated) {
                  time=Utils.getTimeFrom(timeUpdated);
                  timetimeSink.sink.add(time);
                  widget.tripModelData.tripDate=timeUpdated;
                  firebaseDbService.updateTripTime(widget.tripModelData.uid, timeUpdated);
                },
                onCancelClick: () {
                  firebaseDbService.cancelTrip(widget.tripModelData.uid);
                  widget.tripModelData.attendeeList.forEach((element) {
                    firebaseDbService.sendNotificationMultiple(
                      type: FcmPushNotifications.TRIP_NOTIFICATION_TYPE,
                      receiver: "",

                      id: widget.tripModelData.uid,
                      receiverUid: element.attendeeUid,
                      senderUid: currentUserIdValue,
                      msg: "${username}\t" +
                          FcmPushNotifications.onTripCancelled +
                          "\t${widget.tripModelData.tripTitle}",
                      title: FcmPushNotifications.tripCancelled,
                      onApiCallDone: () {
                        firebaseDbService.showProgressSink.add(false);
                      },
                    );
                  });

                },
                previousTime: widget.tripModelData.tripDate,
              );
            });
      },
      child: Padding(
        padding: EdgeInsets.only(left: 25),
        child: Text(
          'Edit Trip',
          style: TextStyle(
            color: ColorResources.app_primary_color,
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 14,
            fontStyle: FontStyle.normal,
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  void _onBackPress() {
    if (widget.isfromViewAll != null && widget.isfromViewAll) {
      Navigator.pop(
          context, NeedUpdateModel(isNeed: true, model: widget.tripModelData,position: widget.position));
    } else {

      Navigator.pop(context,true);
    }
  }
}
