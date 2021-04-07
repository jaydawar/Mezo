import 'package:app/common_widget/common_decoration.dart';
import 'package:app/common_widget/custom_button.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:app/utils/image_resource.dart';
import 'package:app/utils/string_resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:app/utils/app_constants.dart';
import 'enter_phone_number_screen.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: ColorResources.app_primary_color,
        body: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              topView(context),
              SizedBox(height: 30,),
              bottomView(context),
            ],
          ),
        ));
  }



  topView(BuildContext context){
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        SizedBox(
          height: 160.0,
          child: Center(
            child: Image.asset(
              ImageResource.mezzo_icon,
              height: 160.0,
            ),
          ),
        ),
        SizedBox(
            height: MediaQuery.of(context).size.height-(213+300),
            child: Center(child: SvgPicture.asset(ImageResource.having_fun))),
      ],
    );
  }

  bottomView(BuildContext context){
    return  Expanded(
      child: Align(
         alignment: Alignment.bottomCenter,
        child: Container(
          decoration: bottomCardDecoration(),
          width: MediaQuery.of(context).size.width,
          height: 383,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 54.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  StringResource.welcome_register_text,
                  style: TextStyle(
                    fontFamily: AppConstants.Poppins_Font,
                    fontSize: 31,
                    color: const Color(0xff2f2e41),
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Text(
                  '${StringResource.register_version_text}',
                  style: TextStyle(
                    fontFamily: AppConstants.Poppins_Font,
                    fontSize: 16,
                    color: const Color(0xff4a4d54),
                    height: 1.25,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(
                height: 40,
              ),
              registerWithPhoneNumber(context),
              SizedBox(
                height: 40,
              ),
            ],
          ),
        ),
      ),
    );
  }

  registerWithPhoneNumber(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 25,),
      child: CustomButton(
        buttonTitle: StringResource.register_with_phone_number,
        buttonClickCallback: () {

          Utils.nextScreen(EnterPhoneScreen(), context);
        },
      ),
    );
  }
}
