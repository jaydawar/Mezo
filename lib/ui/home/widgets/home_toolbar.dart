import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/helper/AppConstantHelper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_constants.dart';
import '../../../common_widget/comon_back_button.dart';
import '../../../utils/image_resource.dart';
import '../../../utils/image_resource.dart';

class HomeToolBar extends StatelessWidget {
  String titleText;

  HomeToolBar({this.titleText});

  @override
  Widget build(BuildContext context) {
    return topView();
  }

  welcomeUser() {
    return Text.rich(
      TextSpan(
        style: TextStyle(
          fontFamily: AppConstants.Poppins_Font,
          fontSize: 26,
          color: const Color(0xffffffff),
          height: 1.2307692307692308,
        ),
        children: [
          TextSpan(
            text: 'Welcome back,\n',
          ),
          TextSpan(
            text: '$titleText!',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
      textAlign: TextAlign.left,
    );
  }

  topView() {
    return Positioned(
      left: 25,
      right: 25,
      top: 105,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          welcomeUser(),
          SizedBox(
            height: 6,
          ),
        ],
      ),
    );
  }
}

profileBgImage() {
  return Positioned(right: 0, top: -12, child: profileBg());
}

profileBg() {
  return SvgPicture.asset(ImageResource.profile_bg_img);
}

profile({UserModel currentUser, AppConstantHelper appConstantHelper}) {
  return Positioned(
      right: 21.5,
      top: 96,
      child: // Adobe XD layer: 'Screen Shot 2020-04…' (shape)
          Container(
        height: 70,
        width: 70,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(98)),
          child: currentUser != null &&
              currentUser.profileUrl != null &&
              currentUser.profileUrl != ''
              ? appConstantHelper.loadNetworkImage(
              width: 70.0, height: 70.0, imageUrl: currentUser.profileUrl)
              : appConstantHelper.placeHolderImage(
              imagePath: ImageResource.dummy,
              height: 70.0,
              width: 70.0),
        ),
      ));
}
