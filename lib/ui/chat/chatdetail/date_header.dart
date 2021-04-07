import 'package:flutter/cupertino.dart';

import 'package:app/utils/app_constants.dart';
class DateHeader extends StatelessWidget{
  String date;
  DateHeader({this.date});
  @override
  Widget build(BuildContext context) {

    return dateText();

  }

  dateText(){
    return Text(
      date,
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 12,
        color: const Color(0x8f78849e),
        fontWeight: FontWeight.w600,
        height: 1.1666666666666667,
      ),
      textAlign: TextAlign.center,
    );
  }
}