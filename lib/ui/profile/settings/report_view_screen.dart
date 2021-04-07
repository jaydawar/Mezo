import 'package:app/common_widget/common_decoration.dart';
import 'package:app/common_widget/custom_button.dart';
import 'package:app/utils/color_resources.dart';
import 'package:app/utils/string_resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app/utils/app_constants.dart';
class ReportAProblem extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ReportState();
}

class _ReportState extends State<ReportAProblem> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.app_screen_bgColor,
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        controller: ScrollController(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 55.0,
              ),
              backButton(context),
              Padding(
                padding: const EdgeInsets.only(left: 25,top: 18),
                child: Text(
                  'Report a Problem',
                  style: TextStyle(
                    fontFamily: AppConstants.Poppins_Font,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xff131621),
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 24, left: 25, right: 25, bottom: 6),
                child: myText('Enter your email'),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: enteremail(),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 8, left: 25, right: 25, bottom: 6),
                child: myText('Summary'),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: summery(),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, bottom: 40),
                    child: CustomButton(
                      buttonClickCallback: () {
                        //open otp Screen

                        Navigator.pop(context);
                      },
                      buttonTitle: 'Submit',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  myText(String str) {
    return Text(
      str,
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 16,
        color: const Color(0xff131621),
      ),
      textAlign: TextAlign.left,
    );
  }

  enteremail() {
    return Container(
      height: 48,
      decoration: textFieldDecoration(),
      child: TextField(
        expands: false,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 12),
          hintText: StringResource.please_enter_email,
          hintStyle: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 14,
            color: const Color(0x80131621),
            fontWeight: FontWeight.w300,
          ),
          hintMaxLines: 1,
        ),
      ),
    );
  }

  summery() {
    return Container(
      decoration: textFieldDecoration(),
      child: TextField(
        expands: false,
        minLines: 10,
        maxLines: 20,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 12,top: 4),
          hintText: StringResource.please_enter_sumary_detail,
          hintStyle: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 14,
            color: const Color(0x80131621),
            fontWeight: FontWeight.w300,
          ),
          hintMaxLines: 1,
        ),
      ),
    );
  }


}
