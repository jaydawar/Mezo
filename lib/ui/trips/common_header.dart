import 'package:app/common_widget/comon_back_button.dart';
import 'package:app/ui/trips/trip_tool_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomHeader extends StatelessWidget {

  VoidCallback onBackPress;
  bool showSearch;

  VoidCallback onSeachClick;
  CustomHeader({this.onBackPress,this.showSearch,this.onSeachClick});
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 45,left: 12,right: 10,bottom: 12),
          child: CustomBackButton(
            buttonColor: Colors.black,

            backCallback: (){
             onBackPress();

            },

          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: TripToolBar(
            title: 'Trips',padding: 24,
            showSearch: showSearch,
            onSearchClick: onSeachClick,


          ),
        ),

      ],
    );
  }
}
