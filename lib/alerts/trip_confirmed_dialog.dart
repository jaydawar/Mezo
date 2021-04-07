import 'package:app/utils/app_constants.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class TripConfirmedDialog extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
       child: Center(
        child: Card(
          elevation: 5,
          color: ColorResources.app_primary_color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Wrap(
            children: <Widget>[confirmdImg(), tripConfirmedText()],
          ),
        ),
      ),
    );
  }

  confirmdImg() {
    return // Adobe XD layer: 'undraw_confirmed_81…' (group)
        Padding(
      padding: EdgeInsets.only(top: 31.0,left: 78,right: 78),
      child: SvgPicture.asset('assets/images/trip_confirmed.svg'),
    );
  }

  tripConfirmedText() {
    return Padding(
      padding: EdgeInsets.only(bottom: 31.0),
      child: Center(
        child: Text(
          'Trip Confirmed',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 21,
            color: const Color(0xffffffff),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
