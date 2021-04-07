import 'package:app/common_widget/comon_back_button.dart';
import 'package:app/push_notifications/notifiaction_model.dart';
import 'package:app/ui/profile/notification/profile_notification_screen.dart';
import 'package:app/ui/trips/trip_tool_bar.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AllNotificationList extends StatefulWidget {
  List<NotificationModel> notificationList;
  AllNotificationList({this.notificationList});
  @override
  State<StatefulWidget> createState() {
    return _AllNotificationState()    ;
  }
}

class  _AllNotificationState extends State<AllNotificationList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.app_screen_bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 50,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 12),
            child: CustomBackButton(
              backCallback: () {
                Navigator.pop(context);
              },
              buttonColor: Colors.black,
            ),
          ),
          SizedBox(
            height: 15,
          ),
          TripToolBar(
            title: 'Notifications',
            showSearch: false,
          ),
          SizedBox(
            height: 15,
          ),
          ProfileTabLisScreen(type: 0,notificationList: widget.notificationList,)
        ],
      ),
    );
  }
}
