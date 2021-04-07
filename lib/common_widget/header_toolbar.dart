import 'package:app/common_widget/common_decoration.dart';
import 'package:app/utils/image_resource.dart';
import 'package:app/utils/string_resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:app/utils/app_constants.dart';
import 'comon_back_button.dart';

class HeaderToolBar extends StatelessWidget {
  String titleText;
BuildContext context;
  HeaderToolBar({this.titleText,this.context});

  @override
  Widget build(BuildContext context) {
    return topView();
  }

  topView() {
    return Positioned(
      left: 12,
      right: 25,
      top: 56,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          CustomBackButton(
            backCallback: () {
              Navigator.pop(context);
            },
            buttonColor: Colors.white,
          ),

          mobileVerificationText(),
          SizedBox(
            height: 12,
          ),
        ],
      ),
    );
  }

  mobileVerificationText() {
    return Padding(
      padding: EdgeInsets.only(left: 13),
      child: Text(
        titleText,
        style: TextStyle(
          fontFamily: AppConstants.Poppins_Font,
          fontSize: 26,
          color: const Color(0xffffffff),
          fontWeight: FontWeight.w700,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }



}
cupImage() {
  return Positioned(
    right: 0,
    top: 25,
    child: SvgPicture.asset(ImageResource.cup_img),
  );
}