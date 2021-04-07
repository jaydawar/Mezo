import 'dart:convert';
import 'dart:developer';

import 'package:app/common_widget/custom_progress_indicator.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/helper/AppConstantHelper.dart';
import 'package:app/models/notification_repo.dart';
import 'package:app/models/trip_repo.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/push_notifications/notifiaction_model.dart';
import 'package:app/ui/home/bloc/home_bloc.dart';
import 'package:app/ui/home/view_all_home_requestList.dart';
import 'package:app/ui/home/view_all_notifications.dart';
import 'package:app/ui/home/widgets/home_main_heading.dart';
import 'package:app/ui/home/widgets/home_toolbar.dart';
import 'package:app/ui/listitems/home_trip_item.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/ui/trips/request_trip_detail.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../common_widget/common_decoration.dart';
import '../../utils/color_resources.dart';
import '../listitems/notification_item.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _HomeScreenState();
  }
}

class _HomeScreenState extends State<HomeScreen> {
  UserModel currentUser;
  AppConstantHelper _appConstantHelper = AppConstantHelper();
  FirebaseDbService firebaseDbService = FirebaseDbService();
  HomeBloc _homeBloc = HomeBloc();
  SharedPreferences prefs;
  var isLoading = false;
  List<TripModelData> tripViewAllList = [];
  List<TripModelData> requestTripList = [];
  List<NotificationModel> notificationList = [];
  bool viewAllNotification = false;
  bool viewAllTrips = false;
  bool isRequestedAdded = false;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bottomCardHeight = MediaQuery.of(context).size.height - 240;
    return Scaffold(
      backgroundColor: ColorResources.app_primary_color,
      body: Stack(
        children: <Widget>[
          HomeToolBar(
            titleText: currentUser != null ? currentUser.fullName : '',
          ),
          profileBgImage(),
          profile(
              currentUser: currentUser, appConstantHelper: _appConstantHelper),
          Positioned(
            top: 201,
            left: 0,
            right: 0,
            child: Container(
              height: bottomCardHeight,
              decoration: bottomCardDecoration(),
              padding: EdgeInsets.symmetric(horizontal: 25.0),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 26.0,
                  ),
                  HomeMainTitleHeading('Notifications', () {
                    Utils.nextScreen(
                      AllNotificationList(
                        notificationList: notificationList,
                      ),
                      context,
                    );
                  }, viewAllNotification),
                  SizedBox(
                    height: 13.0,
                  ),
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: 90.0),
                    child: notificationListStreamData(),
                  ),
                  SizedBox(
                    height: 31.0,
                  ),
                  HomeMainTitleHeading('Trip Requests', () async {
                    // Utils.nextScreen(
                    //     AllRequestList(
                    //       tripViewAllList: requestTripList,
                    //     ),
                    //     context);

                    var isneeded = await Navigator.push(
                            context,
                            CupertinoPageRoute(
                                builder: (context) => AllRequestList(
                                    tripViewAllList: requestTripList)))
                        .then((value) {
                      // requestTripList.clear();

                      print('Length***************${requestTripList.length}');
                      // _initialize();
                    });
                    if (isneeded != null && isneeded) {
                      isRequestedAdded = false;
                      updateList();
                    }
                  }, viewAllTrips),
                  SizedBox(
                    height: 13.0,
                  ),
                  Expanded(
                    child: tripRequestStreamData(),
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.center,
            child: CommmonProgressIndicator(isLoading),
          )
        ],
      ),
    );
  }

  notificationListStreamData() {
    return StreamBuilder<List<NotificationModel>>(
        stream: _homeBloc.notificationListStream,
        initialData: [],
        builder: (context, notificationSnapshot) {
          return notificationSnapshot.data.length > 0
              ? ListView.builder(
                  itemCount: notificationSnapshot.data.length,
                  padding: EdgeInsets.zero,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext context, int position) {
                    return NotificationItem(
                      content: notificationSnapshot.data[position].body,
                      title: notificationSnapshot.data[position].title,
                      position: position,
                    );
                  })
              : emptyNotificationWidget();
        });
  }

  tripRequestStreamData() {
    return StreamBuilder<List<TripModelData>>(
        stream: _homeBloc.tripListSinkListStream,
        initialData: [],
        builder: (context, tripListSnapshot) {
          return tripListSnapshot.data.length > 0
              ? ListView.builder(
                  padding: EdgeInsets.zero,
                  itemCount: tripListSnapshot.data.length,
                  scrollDirection: Axis.vertical,
                  itemBuilder: (BuildContext context, int position) {
                    return InkWell(
                      onTap: () async {
                        var isneeded = await Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (BuildContext context) =>
                                RequestTripDetailScreen(
                              tripModelData: tripListSnapshot.data[position],
                              position: position,
                              isfromViewAll: false,
                            ),
                          ),
                        );
                      },
                      child: HomeTripItem(
                        position: position,
                        tripModelData: tripListSnapshot.data[position],
                        firebaseDbService: firebaseDbService,
                      ),
                    );
                  })
              : emptyTripWidget();
        });
  }

  emptyTripWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: 50,
              width: 50,
              child: Center(
                  child: SvgPicture.asset(
                'assets/images/request.svg',
                height: 50,
                width: 50,
                fit: BoxFit.fill,
              ))),
          SizedBox(
            height: 8,
          ),
          Text(
            'No Requests yet!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppConstants.Poppins_Font,
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

//
  emptyNotificationWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
              height: 50,
              width: 50,
              child: Center(
                  child: SvgPicture.asset(
                'assets/images/alarm.svg',
                height: 50,
                width: 50,
                fit: BoxFit.fill,
              ))),
          SizedBox(
            height: 8,
          ),
          Text(
            '\t\t\t\tNo notifications yet!',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: AppConstants.Poppins_Font,
              fontSize: 12,
              color: Colors.black,
              fontWeight: FontWeight.w500,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    requestTripList.clear();
    tripViewAllList.clear();
  }

  void _initialize() async {
    requestTripList = [];
    requestTripList.clear();
    _appConstantHelper.setContext(context);
    prefs = await SharedPreferences.getInstance();
    currentUserIdValue = await prefs.getString('user_id_key') ?? '';
    NotificationRepo.getInstance().getNotificationStream().listen((event) {
      notificationList = [];
      notificationList.addAll(event);
      log('HomeallTripLog${jsonEncode(notificationList)}');
      _homeBloc.updateNotificationList(notificationList);
    });

    updateList();
  }

  void updateList() {
    TripRepo.getInstance().getTripsStream().listen((event) {
      requestTripList = [];
      requestTripList.clear();
      tripViewAllList.addAll(event);
      tripViewAllList.forEach((tripItem) async {
        tripItem.attendeeList.forEach((element) {
          if (element.attendeeUid == currentUserIdValue) {
            if (!isRequestedAdded) {
              isRequestedAdded = true;
              viewAllTrips = true;
              // _homeBloc.updateTripList(tripItem);
              _homeBloc.updateTripList(requestTripList);
              requestTripList.insert(0, tripItem);
              print("updateRequestDataModel");
            } else {
              requestTripList.add(tripItem);
            }
            // requestTripList.add(tripItem);
            setState(() {});
          }
        });
      });
      // _homeBloc.updateTripList(requestTripList);
      // if (requestTripList.length > 0) {
      //   viewAllTrips = true;
      //   setState(() {});
      // }

      if (notificationList.length > 0) {
        viewAllNotification = true;
        setState(() {});
      }

      UserRepo.getInstance().getCurrentUser().then((value) {
        currentUser = value;
        setState(() {});
      });
    });
  }
}
