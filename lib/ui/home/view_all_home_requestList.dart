import 'package:app/common_widget/comon_back_button.dart';
import 'package:app/ui/profile/notification/profile_notification_screen.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/ui/trips/trip_tool_bar.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllRequestList extends StatefulWidget {
  List<TripModelData> tripViewAllList;

  AllRequestList({this.tripViewAllList});
  var  addresses = []; // Some array I got from async call


  @override
  State<StatefulWidget> createState() {
    return _AllNotificationState();
  }
}

class _AllNotificationState extends State<AllRequestList> {
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
          ProfileTabLisScreen(
            type: 4,
            tripViewAllList: widget.tripViewAllList.toSet().toList(),
          )
        ],
      ),
    );


  }



}
