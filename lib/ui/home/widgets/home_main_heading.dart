import 'package:app/push_notifications/notifiaction_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app/utils/app_constants.dart';
class HomeMainTitleHeading extends StatelessWidget{
  String title;
  VoidCallback viewAlClick;
  bool visibility;

  HomeMainTitleHeading(this.title,this.viewAlClick,this.visibility);
  @override
  Widget build(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
      headingTitle(),
      viewAll(),


    ],);
  }
  viewAll() {
    return InkWell(
      onTap: (){
        viewAlClick();
      },
      child: Visibility(
        visible: visibility,
        child: Text(
          'View all',
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
        color: const Color(0xff000000),
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.left,
    );
  }
}