import 'package:app/common_widget/custom_button.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/ui/trips/request_trip_detail.dart';
import 'package:app/ui/trips/tripItems/current_trip_item.dart';
import 'package:app/ui/trips/tripItems/requested_trip_with_options_item.dart';
import 'package:app/ui/trips/tripItems/sent_trip_item.dart';
import 'package:app/ui/trips/trip_detaill_screen.dart';
import 'package:app/ui/trips/trip_viewall_screen.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TripSearch extends StatefulWidget {
  List<TripModelData> tripList;
  String title;
  int type;

  TripSearch({this.tripList, this.title, this.type});

  @override
  State<StatefulWidget> createState() {
    return _TripSearchState();
  }
}

class _TripSearchState extends State<TripSearch> {
  List<TripModelData> tripList = [];
  final _searchTextController = TextEditingController();
  UserModel currentUser;
  FirebaseDbService firebaseDbService = FirebaseDbService();

  @override
  void initState() {
    _init();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.app_screen_bgColor,
      body: Column(
        children: [
          SizedBox(
            height: 40.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              backButton(context, callback: () {
                Navigator.pop(context, true);
              }),
              _searchBar()
            ],
          ),
          _title(widget.title),
          Expanded(
              child: tripList.length == 0
                  ? Center(child: Text('No Trip Found'))
                  : ListView.builder(
                      padding: EdgeInsets.zero,
                      itemCount: tripList.length,
                      itemBuilder: (BuildContext context, int position) {
                        TripModelData item = tripList[position];
                        return tripList.length == 0
                            ? Center(
                                child: Text('Search with trip title'),
                              )
                            : InkWell(
                                onTap: () {
                                  _onTripClick(item, position);
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 16, right: 16, top: 12),
                                  child: widget.type == 1
                                      ? CurrentTripItem(
                                          tripModelData: item,
                                        )
                                      : widget.type == 2
                                          ? RequestedTripWithOptionItem(
                                              tripModelData: item,
                                              firebaseDbService:
                                                  firebaseDbService,
                                              position: position,
                                              currentUser: currentUser,
                                            )
                                          : SentTripItem(
                                              position: position,
                                              tripModelData: item,
                                              firebaseDbService:
                                                  FirebaseDbService(),
                                            ),
                                ),
                              );
                      })),
        ],
      ),
    );
  }

  _title(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 24, bottom: 0, top: 0),
        child: Text(
          '$title',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 25,
            color: const Color(0xff454f63),
            fontWeight: FontWeight.w600,
            height: 1.76,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  _searchBar() {
    return Expanded(
      child: Container(
        height: 45,
        margin: EdgeInsets.only(left: 0, right: 26, top: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: const Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: Offset(0, 4),
                  blurRadius: 16)
            ]),
        child: TextFormField(
          controller: _searchTextController,
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (value) {
            //log("widget.tripList${jsonEncode(widget.tripList)}");
            tripList = [];
            widget.tripList.forEach((element) {
              if (value
                  .toLowerCase()
                  .contains(element.tripTitle.toLowerCase())) {
                tripList.add(element);
              }
            });
            setState(() {});
          },
          onChanged: (value) {
            tripList = [];
            widget.tripList.forEach((element) {
              if (element.tripTitle
                  .trim()
                  .toLowerCase()
                  .contains(value.trim().toLowerCase())) {
                tripList.add(element);
                //log("OnChangetripList${jsonEncode(tripList)}");

              }
              setState(() {});
            });
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 14, top: 8),
              border: InputBorder.none,
              hintText: "Search",
              suffixIcon: Icon(
                Icons.search,
              )),
        ),
      ),
    );
  }

  void _init() async {
    currentUser = await UserRepo.getInstance().getCurrentUser();
    setState(() {});
  }

  void _onTripClick(TripModelData item, int position) async {
    var idEditable = false;
    var isSendtrip = false;

    if (item.createrUid == currentUserIdValue) {
      idEditable = true;
      isSendtrip = true;
    }
    if (Utils.getDateFrom(item.createdAt) ==
        Utils.getDateFrom(Utils.getCuurentTimeinMillies())) {
      isSendtrip = true;
    }
    item.attendeeList.forEach((element) {
      if (element.attendeeUid == currentUserIdValue) {
        idEditable = false;
      }
    });
    if (isSendtrip) {
      NeedUpdateModel isNeedModel = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => TripDetailScreen(
                    position: position,
                    tripModelData: item,
                    isfromViewAll: true,
                    isEditable: idEditable,
                  )));

      updateListView(isNeedModel);
    } else {
      NeedUpdateModel isNeedModel = await Navigator.push(
          context,
          CupertinoPageRoute(
              builder: (BuildContext context) => RequestTripDetailScreen(
                    position: position,
                    tripModelData: item,
                    isfromViewAll: true,
                  )));
      updateListView(isNeedModel);
    }
  }

  void updateListView(NeedUpdateModel isNeedModel) {
    if (isNeedModel != null && isNeedModel.isNeed) {
      widget.tripList
          .removeWhere((element) => element.uid == isNeedModel.model.uid);
      widget.tripList.insert(isNeedModel.position, isNeedModel.model);
      setState(() {});
    }
  }
}
