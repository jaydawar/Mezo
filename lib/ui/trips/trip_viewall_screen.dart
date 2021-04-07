import 'dart:convert';
import 'dart:developer';

import 'package:app/common_widget/comon_back_button.dart';
import 'package:app/common_widget/custom_progress_indicator.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/helper/AppConstantHelper.dart';
import 'package:app/models/trip_repo.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/ui/trips/bloc/trip_bloc.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/ui/trips/request_trip_detail.dart';
import 'package:app/ui/trips/tripItems/current_trip_item.dart';
import 'package:app/ui/trips/tripItems/requested_trip_item.dart';
import 'package:app/ui/trips/tripItems/requested_trip_with_options_item.dart';
import 'package:app/ui/trips/tripItems/sent_trip_item.dart';
import 'package:app/ui/trips/trip_detaill_screen.dart';
import 'package:app/ui/trips/trip_search_screen.dart';
import 'package:app/ui/trips/trip_tool_bar.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TripViewAlllScreen extends StatefulWidget {
  int type;
  List<TripModelData> tripList;

  TripViewAlllScreen({this.type, this.tripList});

  @override
  State<StatefulWidget> createState() {
    return _TripViewAllState();
  }
}

class _TripViewAllState extends State<TripViewAlllScreen> {
  FirebaseDbService firebaseDbService = FirebaseDbService();
  List<TripModelData> requesttripList = [];
  AppConstantHelper _appConstantHelper = AppConstantHelper();
UserModel currentUser;
  @override
  void initState() {
   _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.app_screen_bgColor,
        body: Padding(
          padding: EdgeInsets.only(right: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 12, top: 50, bottom: 1),
                child: CustomBackButton(
                  backCallback: () {
                    Navigator.pop(context,true);
                  },
                  buttonColor: Colors.black,
                ),
              ),
              TripToolBar(
                title: 'Trips',
                showSearch: false,
                onSearchClick: (){

                  Utils.nextScreen(
                      TripSearch(
                    title: widget.type==1?'Current Trip List':widget.type==2?'Requested Trip List':'Sent Trip List',
                    tripList: widget.tripList,
                    type: widget.type,
                  ), context);
                },
              ),
              Expanded(
                child: ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: widget.tripList.length,
                    itemBuilder: (BuildContext context, int position) {
                      var tripItem = widget.tripList[position];
                      return Material(
                        type: MaterialType.transparency,
                        child: InkWell(
                          onTap: () async{
                            if (widget.type == 1 || widget.type == 3) {

                              NeedUpdateModel isNeedModel= await Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (BuildContext context) =>TripDetailScreen(
                                  tripModelData: widget.tripList[position],
                                  isEditable: widget.type == 1?true:false,
                                  isfromViewAll: true,
                                  position: position,
                                )),
                              );
                              updateListView(isNeedModel);
                            } else if (widget.type == 2) {
                              NeedUpdateModel isNeedModel= await Navigator.push(
                                context,
                                CupertinoPageRoute(builder: (BuildContext context) => RequestTripDetailScreen(
                                  tripModelData: widget.tripList[position],
                                  isfromViewAll: true,
                                  position: position,
                                )),
                              );
                             updateListView(isNeedModel);

                            }
                          },
                          child: Padding(
                            padding: EdgeInsets.only(
                                top: position == 0 ? 24 : 12, left: 25),
                            child: widget.type == 1
                                ? CurrentTripItem(
                                    tripModelData: widget.tripList[position],
                                  )
                                : widget.type == 2
                                    ? RequestedTripWithOptionItem(
                                        firebaseDbService: firebaseDbService,
                                        tripModelData: tripItem,
                                        position: position,
                              currentUser: currentUser,
                                      )
                                    : SentTripItem(
                                        firebaseDbService: firebaseDbService,
                                        tripModelData: tripItem,
                                        position: position,
                                      ),
                          ),
                        ),
                      );
                    }),
              )
            ],
          ),
        ));
  }

  void _initialize() async {
    _appConstantHelper.setContext(context);
    currentUser=await UserRepo.getInstance().getCurrentUser();
    log("ViewALlTtryp${widget.type} List ${jsonEncode(widget.tripList)}");
  }

  void updateListView(NeedUpdateModel isNeedModel) {
    if(isNeedModel!=null&&isNeedModel.isNeed){

      widget.tripList.removeWhere((element) => element.uid==isNeedModel.model.uid);
      widget.tripList.insert(isNeedModel.position,isNeedModel.model);
      setState(() {

      });
    }else{
      setState(() {

      });
    }
  }
}

class NeedUpdateModel{
  bool isNeed;
  int position;
  TripModelData model;
  NeedUpdateModel({this.position,this.model,this.isNeed});
}
