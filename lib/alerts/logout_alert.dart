import 'package:app/common_widget/custom_intro_button.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/color_resources.dart';
import 'package:app/utils/string_resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class LogoutDialogAlert extends StatelessWidget {
  VoidCallback confirmClick;
  LogoutDialogAlert({this.confirmClick});

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
            children: <Widget>[
              logoutTitle(),
              logoutSubTitle(),
              Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CustomIntroWithBorderButton(
                      text: StringResource.back,
                      bttonWidth: 127,
                      textColor: Color(0xffffffff),
                      bgColor: Colors.transparent,
                      callback: () {
                        Navigator.pop(context);
                      },
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    CustomIntroButton(
                      text: 'Confirm'.toUpperCase(),
                      bttonWidth: 127,
                      bgColor: Color(0xfff5f7f9),
                      textColor: Color(0xfffca25d),
                      callback: () {confirmClick();},
                    ), // Adobe XD layer: 'bg' (shape)

                    // Adobe XD layer: 'bg' (shape)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  logoutTitle() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 18, bottom: 0),
        child: Text(
          'Are you sure?',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 22,
            color: const Color(0xffffffff),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  logoutSubTitle() {
    return Center(
      child:
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
            'Are you sure you want to Logout?',
            style: TextStyle(
              fontFamily: 'Gibson',
              fontSize: 13,
              color: const Color(0xedffffff),
              height: 1.4615384615384615,
            ),
            textAlign: TextAlign.center,
          ),
      )

    );
  }
}