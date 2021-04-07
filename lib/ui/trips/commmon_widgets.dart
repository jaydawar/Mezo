import 'package:app/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

tripSubTitle(String subTitle) {
  return Text(
    '$subTitle',
    style: TextStyle(
      fontFamily: AppConstants.Poppins_Font,
      fontSize: 20,
      color: const Color(0xff131621),
      fontWeight: FontWeight.w500,
    ),
    textAlign: TextAlign.left,
  );
}

tripCreaterUsrProfilePic(String imageUrl) {
  return Container(
    height: 98,
    width: 98,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
    ),
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(98)),
      child: Image.asset(
        'assets/images/profile.png',
        height: 98,
        width: 98,
        fit: BoxFit.fill,
      ),
    ),
  );
}

tripCreaterUserName(String name) {
  return Text(
    '$name ',
    style: TextStyle(
      fontFamily: AppConstants.Poppins_Font,
      fontSize: 18,
      color: const Color(0xff131621),
    ),
    textAlign: TextAlign.left,
  );
}
