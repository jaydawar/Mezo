import 'package:app/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TripTitleHeading extends StatelessWidget {
  String title;
VoidCallback viewAllClickType;
bool visibility;
  TripTitleHeading({this.title,this.visibility,this.viewAllClickType});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          headingTitle(),
          viewAll(),
        ],
      ),
    );
  }

  viewAll() {
    return  InkWell(
      onTap: (){
        viewAllClickType();
      },
      child: Visibility(
        visible: visibility,
        child: Text(
          'View All',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 14,
            color: const Color(0xfffca25d),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  headingTitle() {
    return Text(
      '$title',
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 20,
        color: const Color(0xff131621),
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.left,
    );
  }
}
