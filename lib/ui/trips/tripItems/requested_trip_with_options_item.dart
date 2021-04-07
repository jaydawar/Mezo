import 'dart:convert';
import 'dart:developer';

import 'package:app/alerts/trip_confirmation_alert.dart';
import 'package:app/alerts/trip_confirmed_dialog.dart';
import 'package:app/common_widget/common_other_user_item.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/helper/AppConstantHelper.dart';
import 'package:app/models/notification_repo.dart';
import 'package:app/models/trip_repo.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/push_notifications/notifiaction_model.dart';
import 'package:app/ui/home/bloc/home_bloc.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../trips_screen.dart';

class RequestedTripWithOptionItem extends StatefulWidget {
  RequestedTripWithOptionItem(
      {this.tripModelData,
      this.position,
      this.currentUser,
      this.firebaseDbService});

  TripModelData tripModelData;
  UserModel currentUser;
  FirebaseDbService firebaseDbService;
  int position;

  @override
  _RequestedTripWithOptionItemState createState() => _RequestedTripWithOptionItemState();
}

class _RequestedTripWithOptionItemState extends State<RequestedTripWithOptionItem> {
  var isDecline = false;

  var status = false;

  AppConstantHelper _appConstantHelper = AppConstantHelper();

  HomeBloc _homeBloc = HomeBloc();

  SharedPreferences prefs;

  var isLoading = false;

  List<TripModelData> tripViewAllList = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // _initialize();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.tripModelData != null) {
      widget.tripModelData.attendeeList.forEach((element) {
        if (element.attendeeUid == currentUserIdValue) {
          isDecline = element.isDecline;
          status = element.status;
        }
      });
    }
    return Container(
      margin: EdgeInsets.only(
          top: widget.position == null
              ? 0
              : widget.position == 0
                  ? 0
                  : 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: const Color(0xffffffff),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: Offset(0, 4),
                blurRadius: 16)
          ]),
      child: Padding(
        padding: EdgeInsets.only(top: 14, left: 15, bottom: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  loadTripCreaterUserData(
                      widget.firebaseDbService, widget.tripModelData.createrUid),
                  tripPartyName(
                      title: 'Trip Name:',
                      subTitle: widget.tripModelData.tripTitle,
                      paddingTop: 10.0),
                  tripSubMainTitle(
                      title: 'Date:',
                      subTitle: Utils.getDateFrom(widget.tripModelData.tripDate),
                      paddingTop: 2.0),
                  tripSubMainTitle(
                      title: 'Time:',
                      subTitle: Utils.getTimeFrom(widget.tripModelData.tripDate),
                      paddingTop: 2.0),
                  Container(
                    width: MediaQuery.of(context).size.width - 80,
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        tripSubMainTitle(
                            title: 'Location:',
                            subTitle: widget.tripModelData.location,
                            paddingTop: 2.0),
                        Align(
                          alignment: Alignment.centerRight,
                          child: isDecline
                              ? tripPartyNameTitle(
                                  title: '',
                                  subTitle: "Declined",
                                  paddingTop: 0.0)
                              : status
                                  ? tripPartyNameTitle(
                                      title: '',
                                      subTitle: "Accepted",
                                      paddingTop: 0.0)
                                  : Row(
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: <Widget>[
                                        InkWell(
                                            onTap: () {
                                              onDecelneShowPoupandSendNotification(
                                                  context,
                                                  widget.tripModelData,
                                                  widget.currentUser);
                                            },
                                            child: SvgPicture.asset(
                                                'assets/images/cross.svg')),
                                        SizedBox(
                                          width: 12,
                                        ),
                                        InkWell(
                                            onTap: () {
                                              onConfirmShowPopupandSendNotification(
                                                  context,
                                                  widget.tripModelData,
                                                  widget.currentUser);
                                            },
                                            child: SvgPicture.asset(
                                                'assets/images/tick.svg'))
                                      ],
                                    ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }

  void onConfirmShowPopupandSendNotification(BuildContext mcontext,
      TripModelData tripModelData, UserModel userSnapShot) {
    showDialog(
        context: mcontext,
        barrierDismissible: true,
        builder: (context) {
          return ConfirmTripDialogAlert(
            title: AlertDialogMessages.onConfirmTitle,
            message: AlertDialogMessages.onConfirmMessge,
            confimCallback: () {
              Navigator.pop(context);
              widget.firebaseDbService.acceptTripRequest(
                  userId: currentUserIdValue,
                  tripModelData: tripModelData,
                  mattendeeList: tripModelData.attendeeList,
                  onAccept: () {
                    if (userSnapShot != null)
                      widget.firebaseDbService.sendNotification(
                          receiver: userSnapShot.deviceToken,
                          type: FcmPushNotifications.TRIP_NOTIFICATION_TYPE,
                          id: tripModelData.uid,
                          receiverUid: userSnapShot.uid,
                          senderUid: currentUserIdValue,
                          msg: "${widget.currentUser.fullName}\t" +
                              FcmPushNotifications.onAcceptNotificationMessage +
                              "\t${tripModelData.tripTitle}",
                          title: FcmPushNotifications.onAcceptNotificationTitle,
                          onApiCallDone: () {
                            widget.firebaseDbService.showProgressSink.add(false);
                            Navigator.pop(context);
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return TripConfirmedDialog();
                                });
                          });
                    _initialize();
                  });
            },
          );
        });
  }

  List<TripModelData> requestTripList = [];

  List<NotificationModel> notificationList = [];

  bool viewAllNotification = false;

  bool viewAllTrips = false;

  void _initialize() async {
    requestTripList = [];

    prefs = await SharedPreferences.getInstance();
    currentUserIdValue = await prefs.getString('user_id_key') ?? '';

    NotificationRepo.getInstance().getNotificationStream().listen((event) {
      notificationList = [];
      notificationList.addAll(event);
      log('HomeallTripLog${jsonEncode(notificationList)}');
      _homeBloc.updateNotificationList(notificationList);
    });
    TripRepo.getInstance().getTripsStream().listen((event) {
      requestTripList = [];
      tripViewAllList.addAll(event.toSet().toList());

      tripViewAllList.forEach((tripItem) async {
        tripItem.attendeeList.forEach((element) {
          if (element.attendeeUid == currentUserIdValue) {
            requestTripList.add(tripItem);
          }
        });
      });
      _homeBloc.updateTripList(requestTripList.toSet().toList());
      if (requestTripList.length > 0) {
        viewAllTrips = true;
        setState(() {});
      }
      if (notificationList.length > 0) {
        viewAllNotification = true;
        setState(() {});
      }
      UserRepo.getInstance().getCurrentUser().then((value) {
        widget.currentUser = value;
        setState(() {});
      });
    });
  }

  void onDecelneShowPoupandSendNotification(BuildContext mcontext,
      TripModelData tripModelData, UserModel userSnapShot) {
    showDialog(
        context: mcontext,
        barrierDismissible: true,
        builder: (context) {
          return ConfirmTripDialogAlert(
              title: AlertDialogMessages.onDeclineTitle,
              message: AlertDialogMessages.onDeclineMessge,
              confimCallback: () {
                widget.firebaseDbService.declineTripRequest(
                    tripModelData: tripModelData,
                    mattendeeList: tripModelData.attendeeList,
                    userId: currentUserIdValue,
                    onDecline: () {
                      Navigator.pop(context);
                      if (userSnapShot != null)
                        widget.firebaseDbService.sendNotification(
                            receiver: userSnapShot.deviceToken,
                            type: FcmPushNotifications.TRIP_NOTIFICATION_TYPE,
                            id: tripModelData.uid,
                            receiverUid: userSnapShot.uid,
                            senderUid: currentUserIdValue,
                            msg: "${widget.currentUser.fullName}\t" +
                                FcmPushNotifications
                                    .onDeclineNotificationMessage +
                                "\t${tripModelData.tripTitle}",
                            title:
                                FcmPushNotifications.onAcceptNotificationTitle,
                            onApiCallDone: () {
                              widget.firebaseDbService.showProgressSink.add(false);
                              Utils.showSnackBar(
                                  'Trip is declined successfully.', context);
                              Navigator.pop(mcontext);
                            });
                      _initialize();

                      // Navigator.pop(context,true);
                    });
              });
        });
  }
}

tripMainTitle(String name) {
  return Padding(
    padding: EdgeInsets.only(left: 10),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        name == null ? "" : name,
        style: TextStyle(
          fontFamily: AppConstants.Poppins_Font,
          fontSize: 18,
          color: const Color(0xff131621),
        ),
        textAlign: TextAlign.left,
      ),
    ),
  );
}

tripPartyNameTitle(
    {String title, String subTitle, double paddingTop, double paddingLeft}) {
  return Padding(
    padding: EdgeInsets.only(
      top: paddingTop,
      left: paddingLeft == null ? 15 : 0.0,
    ),
    child: RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
          text: '$title',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xff4a4d54),
          ),
        ),
        TextSpan(
          text: '$subTitle',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xff4a4d54),
          ),
        )
      ]),
    ),
  );
}

tripPartyName(
    {String title, String subTitle, double paddingTop, double paddingLeft}) {
  return Padding(
    padding: EdgeInsets.only(
      top: paddingTop,
      left: paddingLeft == null ? 15 : 0.0,
    ),
    child: RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
          text: '$title',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xff4a4d54),
          ),
        ),
        TextSpan(
          text: '$subTitle',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xff4a4d54),
          ),
        )
      ]),
    ),
  );
}

tripSubMainTitle(
    {String title, String subTitle, double paddingTop, double paddingLeft}) {
  return Padding(
    padding: EdgeInsets.only(
      top: paddingTop,
      left: paddingLeft == null ? 15 : paddingLeft,
    ),
    child: RichText(
      text: TextSpan(children: <TextSpan>[
        TextSpan(
          text: '$title',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 14,
            color: const Color(0xb24a4d54),
          ),
        ),
        TextSpan(
          text: '$subTitle',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 14,
            color: const Color(0xff4a4d54),
          ),
        )
      ]),
    ),
  );
}
