import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app/utils/app_constants.dart';
class EmptyListItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        emptyImage('assets/images/trip_request.svg'),
        SizedBox(
          height: 8.0,
        ),
        emptyText('No Items')
      ],
    );
  }

  emptyImage(String path) {
    return SvgPicture.asset('assets/images/trip_request.svg');
  }

  emptyText(String text) {
    return Text(
      '$text',
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: const Color(0xff131621),
      ),
      textAlign: TextAlign.left,
    );
  }
}
