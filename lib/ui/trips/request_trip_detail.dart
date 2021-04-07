import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app/alerts/trip_confirmation_alert.dart';
import 'package:app/alerts/trip_confirmed_dialog.dart';
import 'package:app/common_widget/custom_progress_indicator.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/helper/AppConstantHelper.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/ui/dashboard/dashboard.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/ui/trips/tripItems/requested_trip_item.dart';
import 'package:app/ui/trips/trip_viewall_screen.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'commmon_widgets.dart';
import 'common_header.dart';

class RequestTripDetailScreen extends StatefulWidget {
  TripModelData tripModelData;
  bool isfromViewAll;
  int position;

  RequestTripDetailScreen({this.tripModelData, this.position,this.isfromViewAll});

  @override
  State<StatefulWidget> createState() {
    return _RequestTripState();
  }
}

class _RequestTripState extends State<RequestTripDetailScreen> {
  Completer<GoogleMapController> _controller = Completer();
  FirebaseDbService firebaseDbService = FirebaseDbService();
  AppConstantHelper appConstantHelper = AppConstantHelper();
  UserModel currentUser;
  CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );
  AsyncSnapshot<UserModel> userSnapShot;
  static CameraPosition _tripLocation = CameraPosition(
      bearing: 192.8334901395799,
      target: LatLng(37.43296265331129, -122.08832357078792),
      tilt: 59.440717697143555,
      zoom: 19.151926040649414);
  var isDecline = false;

  var status = false;
  @override
  void initState() {
    appConstantHelper.setContext(context);
    _initialize();

    super.initState();


  }

  Map<MarkerId, Marker> markers =
      <MarkerId, Marker>{}; // CLASS MEMBER, MAP OF MARKS

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
    return Scaffold(
      backgroundColor: ColorResources.app_screen_bgColor,
      body: WillPopScope(
        onWillPop: () {
          _onBackPress();
        },
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                CustomHeader(
                  onBackPress: () {
                    _onBackPress();
                  },showSearch: false,

                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25),
                  child: tripSubTitle("Requested"),
                ),
                SizedBox(
                  height: 15,
                ),
                StreamBuilder<UserModel>(
                    stream: firebaseDbService.userInfoStream,
                    initialData: null,
                    builder: (context, userSnapShot) {
                      if (userSnapShot.data != null)
                        this.userSnapShot = userSnapShot;
                      return Padding(
                        padding: EdgeInsets.only(left: 25, right: 25),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            userSnapShot.data == null
                                ? CircularProgressIndicator()
                                : appConstantHelper.loadNetworkImage(
                                    imageUrl: userSnapShot.data.profileUrl,
                                    height: 98.0,
                                    width: 98.0),
                            SizedBox(
                              width: 15,
                            ),
                            tripCreaterUserName(userSnapShot.data == null
                                ? ""
                                : userSnapShot.data.fullName)
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
                tripSubMainTitle(
                    title: 'Time:\t',
                    subTitle: Utils.getTimeFrom(widget.tripModelData.tripDate),
                    paddingTop: 2.0,
                    paddingLeft: 25.0),
                tripSubMainTitle(
                    title: 'Location:\t',
                    subTitle: widget.tripModelData.address,
                    paddingTop: 2.0,
                    paddingLeft: 25.0),
                SizedBox(
                  height: 4,
                ),
                // editTrip(),
                SizedBox(
                  height: 12,
                ), Padding(
                  padding:  EdgeInsets.only(left:10),
                  child: Align(
                    alignment: Alignment.centerLeft,
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
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(
                          width: 12,
                        ),
                        InkWell(
                            onTap: () {
                              onDecelneShowPoupandSendNotification(
                                  context);
                            },
                            child: SvgPicture.asset(
                                'assets/images/cross.svg')),
                        SizedBox(
                          width: 12,
                        ),
                        InkWell(
                            onTap: () {
                              onConfirmShowPopupandSendNotification(context);
                            },
                            child: SvgPicture.asset(
                                'assets/images/tick.svg'))
                      ],
                    ),
                  ),
                ),

                // Padding(
                //   padding: EdgeInsets.only(left: 25, right: 25),
                //   child: Row(
                //     children: <Widget>[
                //       InkWell(
                //           onTap: () {
                //             onDecelneShowPoupandSendNotification(context);
                //           },
                //           child: SvgPicture.asset('assets/images/cross.svg')),
                //       SizedBox(
                //         width: 12,
                //       ),
                //       InkWell(
                //           onTap: () {
                //             onConfirmShowPopupandSendNotification(context);
                //           },
                //           child: SvgPicture.asset('assets/images/tick.svg'))
                //     ],
                //   ),
                // ),
                SizedBox(
                  height: 12,
                ),
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, right: 25),
                    child: GoogleMap(
                      mapType: MapType.normal,
                      initialCameraPosition: _kGooglePlex,
                      onMapCreated: (GoogleMapController controller) {
                        _controller.complete(controller);
                        goToTripLocation();
                      },
                    ),
                  ),
                ),
                SizedBox(
                  height: 60,
                ),
              ],
            ),
            Align(
              alignment: Alignment.center,
              child: StreamBuilder<bool>(
                  stream: firebaseDbService.showProgressStream,
                  initialData: false,
                  builder: (context, snapshot) {
                    return CommmonProgressIndicator(snapshot.data);
                  }),
            )
          ],
        ),
      ),
    );
  }

  Future<void> goToTripLocation() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_tripLocation));
  }

  attendingText() {
    return Text(
      'Attending',
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xff131621),
      ),
      textAlign: TextAlign.left,
    );
  }

  editTrip() {
    return Text(
      'Edit Trip',
      style: TextStyle(
        color: ColorResources.app_primary_color,
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 14,
        fontStyle: FontStyle.normal,
        decoration: TextDecoration.underline,
      ),
    );
  }

  void onConfirmShowPopupandSendNotification(BuildContext mcontext) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return ConfirmTripDialogAlert(
            title: AlertDialogMessages.onConfirmTitle,
            message: AlertDialogMessages.onConfirmMessge,
            confimCallback: () {
              firebaseDbService.acceptTripRequest(
                  userId: currentUserIdValue,
                  tripModelData: widget.tripModelData,
                  mattendeeList: widget.tripModelData.attendeeList,
                  onAccept: () {
                    if (userSnapShot.data != null)
                      firebaseDbService.sendNotification(
                          receiver: userSnapShot.data.deviceToken,
                          type: FcmPushNotifications.TRIP_NOTIFICATION_TYPE,
                          id: widget.tripModelData.uid,
                          receiverUid: userSnapShot.data.uid,
                          senderUid: currentUserIdValue,
                          msg: "${currentUser.fullName}\t" +
                              FcmPushNotifications.onAcceptNotificationMessage +
                              "\t${widget.tripModelData.tripTitle}",
                          title: FcmPushNotifications.onAcceptNotificationTitle,
                          onApiCallDone: () async {
                            firebaseDbService.showProgressSink.add(false);
                            Navigator.pop(context);

                            widget.tripModelData.attendeeList
                                .forEach((element) {
                              if (element.attendeeUid == currentUserIdValue) {
                                element.status = true;
                              }
                            });

                            log("CheckUpdated${jsonEncode(widget.tripModelData)}");
                            status=true;
                            setState(() {

                            });
                            var isClosed = await showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return TripConfirmedDialog();
                                });
                          });
                  });
            },
          );
        });
  }

  void onDecelneShowPoupandSendNotification(BuildContext mcontext) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) {
          return ConfirmTripDialogAlert(
              title: AlertDialogMessages.onDeclineTitle,
              message: AlertDialogMessages.onDeclineMessge,
              confimCallback: () {
                firebaseDbService.declineTripRequest(
                    tripModelData: widget.tripModelData,
                    mattendeeList: widget.tripModelData.attendeeList,
                    userId: currentUserIdValue,
                    onDecline: () {
                      Navigator.pop(context);
                      if (userSnapShot.data != null)
                        widget.tripModelData.attendeeList
                            .forEach((element) {
                          if (element.attendeeUid == currentUserIdValue) {
                            element.status = false;
                            element.isDecline = true;
                          }
                        });
                        firebaseDbService.sendNotification(
                            receiver: userSnapShot.data.deviceToken,
                            type: FcmPushNotifications.TRIP_NOTIFICATION_TYPE,
                            id: widget.tripModelData.uid,
                            receiverUid: userSnapShot.data.uid,
                            senderUid: currentUserIdValue,
                            msg: "${currentUser.fullName}\t" +
                                FcmPushNotifications
                                    .onDeclineNotificationMessage +
                                "\t${widget.tripModelData.tripTitle}",
                            title:
                                FcmPushNotifications.onAcceptNotificationTitle,
                            onApiCallDone: () {
                              firebaseDbService.showProgressSink.add(false);
                              Utils.showSnackBar(
                                  'Trip is declined successfully.', context);
                              isDecline=true;
                              setState(() {

                              });
                             // _onBackPress();
                            });

                      // Navigator.pop(context,true);
                    });
              });
        });
  }

  void _initialize() async {
    currentUser = await UserRepo.getInstance().getCurrentUser();
    _kGooglePlex = CameraPosition(
      target: LatLng(widget.tripModelData.lat, widget.tripModelData.lng),
      zoom: 14.4746,
    );
    _tripLocation = CameraPosition(
        bearing: 192.8334901395799,
        target: LatLng(widget.tripModelData.lat, widget.tripModelData.lng),
        tilt: 59.440717697143555,
        zoom: 19.151926040649414);
    setState(() {});
    firebaseDbService.getUserInfoWhere(uid: widget.tripModelData.createrUid);
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
