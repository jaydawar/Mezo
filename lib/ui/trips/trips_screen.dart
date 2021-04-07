import 'dart:convert';
import 'dart:developer';

import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/helper/AppConstantHelper.dart';
import 'package:app/models/trip_repo.dart';
import 'package:app/ui/chat/user_chat_list_screen.dart';
import 'package:app/ui/trips/bloc/trip_bloc.dart';
import 'package:app/ui/trips/request_trip_detail.dart';
import 'package:app/ui/trips/tripItems/current_trip_item.dart';
import 'package:app/ui/trips/tripItems/requested_trip_item.dart';
import 'package:app/ui/trips/tripItems/requested_trip_with_options_item.dart';
import 'package:app/ui/trips/tripItems/sent_trip_item.dart';
import 'package:app/ui/trips/trip_detaill_screen.dart';
import 'package:app/ui/trips/trip_heading.dart';
import 'package:app/ui/trips/trip_search_screen.dart';
import 'package:app/ui/trips/trip_tool_bar.dart';
import 'package:app/ui/trips/trip_viewall_screen.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/trip_model_data.dart';

String currentUserIdValue;

class TripsListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _TripsListState();
  }
}

class _TripsListState extends State<TripsListScreen> {
  AppConstantHelper _appConstantHelper = AppConstantHelper();
  TripBloc _tripBloc = TripBloc();
  var isLoading = false;
  List<TripModelData> tripViewAllList = [];
  List<TripModelData> sentTripList = [];
  List<TripModelData> requestTripList = [];
  List<TripModelData> currentTripList = [];
  bool viewAllCurrent = false;
  bool viewAllsent = false;
  bool viewAllRequest = false;
  BehaviorSubject<String> currentDateTime = BehaviorSubject<String>();
  Stream<String> get currentDateTimeStream => currentDateTime.stream;
  SharedPreferences prefs;
  FirebaseDbService firebaseDbService = FirebaseDbService();

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.app_screen_bgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 50),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 85.0,
            ),
            TripToolBar(
              title: 'Trips',
              onSearchClick: () {
                Utils.nextScreen(
                    TripSearch(
                      title: 'All Trips',
                      tripList: tripViewAllList,
                      type: 3,
                    ),
                    context);
              },
            ),
            SizedBox(
              height: 22,
            ),
            TripTitleHeading(
              title: 'Current',
              visibility: viewAllCurrent,
              viewAllClickType: () {
                Utils.nextScreen(
                    TripViewAlllScreen(
                      type: 1,
                      tripList: currentTripList,
                    ),
                    context);
              },
            ),
            dateText(),
            SizedBox(
              height: 12,
            ),
            StreamBuilder<TripModelData>(
                stream: _tripBloc.currenttTripDataStream,
                initialData: null,
                builder: (context, snapshot) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: InkWell(
                        onTap: () {
                          if (snapshot.data != null &&
                              snapshot.data.uid != null) {
                            Utils.nextScreen(
                                TripDetailScreen(
                                  isEditable: true,
                                  tripModelData: snapshot.data,
                                ),
                                context);
                          }
                        },
                        child: CurrentTripItem(
                          tripModelData: snapshot.data,
                        )),
                  );
                }),
            SizedBox(
              height: 20,
            ),
            TripTitleHeading(
              title: 'Requested',
              visibility: viewAllRequest,
              viewAllClickType: () async {
                log("requestTripListCheckkk${jsonEncode(requestTripList)}");
                var isneeded = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (BuildContext context) => TripViewAlllScreen(
                      type: 2,
                      tripList: requestTripList,
                    ),
                  ),
                );
                if (isneeded != null && isneeded) {
                  isRequestedAdded = false;
                  isSentAddeed = false;
                  isCurrentAddeed = false;
                  updateList();
                }
              },
            ),
            SizedBox(
              height: 12,
            ),
            StreamBuilder<TripModelData>(
                stream: _tripBloc.requestTripDataStream,
                initialData: null,
                builder: (context, snapshot) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: InkWell(
                        onTap: () async {
                          if (snapshot.data != null &&
                              snapshot.data.uid != null) {
                            var isneeded = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    RequestTripDetailScreen(
                                  tripModelData: snapshot.data,
                                  position: 0,
                                  isfromViewAll: false,
                                ),
                              ),
                            );
                            if (isneeded != null && isneeded) {
                              isRequestedAdded = false;
                              isSentAddeed = false;
                              isCurrentAddeed = false;

                              updateList();
                            }
                          }
                        },
                        child: RequestedTripItem(
                          position: 0,
                          tripModelData: snapshot.data,
                          firebaseDbService: firebaseDbService,
                        )),
                  );
                }),
            SizedBox(
              height: 20,
            ),
            TripTitleHeading(
              title: 'Sent',
              visibility: viewAllsent,
              viewAllClickType: () async {
                var isneeded = await Navigator.push(
                  context,
                  CupertinoPageRoute(
                    builder: (BuildContext context) => TripViewAlllScreen(
                      type: 3,
                      tripList: sentTripList,
                    ),
                  ),
                );
                if (isneeded != null && isneeded) {
                  isRequestedAdded = false;
                  isSentAddeed = false;
                  isCurrentAddeed = false;

                  updateList();
                }
              },
            ),
            SizedBox(
              height: 12,
            ),
            StreamBuilder<TripModelData>(
                stream: _tripBloc.sentTripDataStream,
                initialData: null,
                builder: (context, snapshot) {
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: 25),
                    child: InkWell(
                        onTap: () async {
                          if (snapshot.data != null &&
                              snapshot.data.uid != null) {
                            var isneeded = await Navigator.push(
                              context,
                              CupertinoPageRoute(
                                builder: (BuildContext context) =>
                                    TripDetailScreen(
                                      isEditable: false,
                                      tripModelData: snapshot.data,
                                    ),
                              ),
                            );

                            if (isneeded != null && isneeded) {
                              isRequestedAdded = false;
                              isSentAddeed = false;
                              isCurrentAddeed = false;

                              updateList();
                            }
                          }
                        },
                        child: SentTripItem(
                          position: 0,
                          tripModelData: snapshot.data,
                          firebaseDbService: firebaseDbService,
                        )),
                  );
                }),
            SizedBox(
              height: 22,
            ),
          ],
        ),
      ),
    );
  }

  dateText() {
    return Padding(
      padding: EdgeInsets.only(left: 25),
      child: StreamBuilder<String>(
          stream: currentDateTimeStream,
          initialData: null,
          builder: (context, snapshot) {
            return Text(
              snapshot.data == null ? "" : snapshot.data,
              style: TextStyle(
                fontFamily: 'Gibson',
                fontSize: 12,
                color: const Color(0x9078849e),
                fontWeight: FontWeight.w600,
                height: 1.1666666666666667,
              ),
              textAlign: TextAlign.left,
            );
          }),
    );
  }

  var isRequestedAdded = false;
  var isSentAddeed = false;
  var isCurrentAddeed = false;

  void _initialize() async {
    prefs = await SharedPreferences.getInstance();
    currentUserIdValue = await prefs.getString('user_id_key') ?? '';
    _appConstantHelper.setContext(context);
print("currentUserIdValue$currentUserIdValue");
    firebaseDbService.getTripRepoInternal();
    firebaseDbService.getTripsStream().listen((event) {
      log("TripScreenallTripLog${jsonEncode(event)}");
      tripViewAllList = [];
      sentTripList = [];
      requestTripList = [];
      currentTripList = [];
      tripViewAllList.addAll(event);

      updateList();
    });
  }

  void updateList() {
    sentTripList = [];
    requestTripList = [];
    currentTripList = [];
    tripViewAllList.forEach((tripItem) async {
      tripItem.attendeeList.forEach((element) {
        if (element.attendeeUid == currentUserIdValue) {
          if (!isRequestedAdded) {
            isRequestedAdded = true;
            viewAllRequest = true;
            _tripBloc.updateRequestDataModel(tripItem);
            requestTripList.insert(0, tripItem);
            print("updateRequestDataModel");
          } else {
            requestTripList.add(tripItem);
          }
        }
      });
      if (Utils.getDateFrom(tripItem.tripDate) ==
          Utils.getDateFrom(DateTime.now().millisecondsSinceEpoch)) {
        if (!isCurrentAddeed) {
          _tripBloc.updateCurrentList(tripItem);
          viewAllCurrent = true;
          currentDateTime.sink.add(Utils.getDateTime(tripItem.tripDate));
          currentTripList.insert(0, tripItem);

          print("updateCurrentList");
        } else {
          currentTripList.add(tripItem);
        }
      }
      if (tripItem.createrUid == currentUserIdValue) {
        if (!isSentAddeed) {
          isSentAddeed = true;
          viewAllsent = true;
          _tripBloc.updateSentDataModel(tripItem);
          sentTripList.insert(0, tripItem);
          print("updateSentDataModel${jsonEncode(tripItem)}");
        } else {
          sentTripList.add(tripItem);
        }
      }
    });

    if (requestTripList != null && requestTripList.length == 0) {
      _tripBloc.updateRequestDataModel(TripModelData(isEmpty: true));
    }
    if (currentTripList != null && currentTripList.length == 0) {
      _tripBloc.updateCurrentList(TripModelData(isEmpty: true));
    }
    if (sentTripList != null && sentTripList.length == 0) {
      _tripBloc.updateSentDataModel(TripModelData(isEmpty: true));
    }

    log("requestTripList${jsonEncode(requestTripList)}");
    log("currentTripList${jsonEncode(currentTripList)}");
    log("sentTripList${jsonEncode(sentTripList)}");
    setState(() {});
  }
}
