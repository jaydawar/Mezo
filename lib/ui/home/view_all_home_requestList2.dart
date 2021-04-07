import 'dart:convert';
import 'dart:developer';

import 'package:app/common_widget/comon_back_button.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/helper/AppConstantHelper.dart';
import 'package:app/models/notification_repo.dart';
import 'package:app/models/trip_repo.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/push_notifications/notifiaction_model.dart';
import 'package:app/ui/listitems/home_trip_item.dart';
import 'package:app/ui/profile/notification/profile_notification_screen.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/ui/trips/tripItems/requested_trip_with_options_item.dart';
import 'package:app/ui/trips/trip_tool_bar.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/home_bloc.dart';

class AllRequestList2 extends StatefulWidget {
  // List<TripModelData> tripViewAllList;
  //
  // AllRequestList2({this.tripViewAllList});
  var addresses = []; // Some array I got from async call

  @override
  State<StatefulWidget> createState() {
    return _AllNotificationState();
  }
}

class _AllNotificationState extends State<AllRequestList2> {
  UserModel currentUser;
  AppConstantHelper _appConstantHelper = AppConstantHelper();
  FirebaseDbService firebaseDbService = FirebaseDbService();
  HomeBloc _homeBloc = HomeBloc();
  SharedPreferences prefs;
  var isLoading = false;
  List<TripModelData> requestTripList = [];
  List<TripModelData> tripViewAllList = [];
  List<NotificationModel> notificationList = [];
  bool viewAllNotification = false;
  bool viewAllTrips = false;

  @override
  void initState() {
    // TODO: implement initState
    _initialize();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies


    super.didChangeDependencies();
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
    TripRepo.getInstance().getTripsStream().listen((event) {
      requestTripList = [];
      requestTripList.clear();
      tripViewAllList.addAll(event);

      tripViewAllList.forEach((tripItem) async {
        tripItem.attendeeList.forEach((element) {
          if (element.attendeeUid == currentUserIdValue) {
            requestTripList.add(tripItem);
          }
        });
      });
      _homeBloc.updateTripList(requestTripList);
      if (requestTripList.length > 0) {
        viewAllTrips = true;
        setState(() {});
      }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.app_screen_bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 12, top: 50, bottom: 1),
            child: CustomBackButton(
              backCallback: () {
                Navigator.pop(context);
              },
              buttonColor: Colors.black,
            ),
          ),
          TripToolBar(
            title: 'Trips',
            showSearch: false,
          ),
          tripRequestStreamData()
        ],
      ),
    );
  }
  tripRequestStreamData() {
    return StreamBuilder<List<TripModelData>>(
        stream: _homeBloc.tripListSinkListStream,
        initialData: [],
        builder: (context, tripListSnapshot) {
          return tripListSnapshot.data.length > 0
              ? ProfileTabLisScreen(
                  type: 4,
                  tripViewAllList: tripListSnapshot.data,
                )
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
}
