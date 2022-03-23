import 'dart:io';

import 'package:app/common_widget/common_decoration.dart';
import 'package:app/common_widget/custom_button.dart';
import 'package:app/common_widget/custom_progress_indicator.dart';
import 'package:app/common_widget/header_toolbar.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/ui/auth/profile_setup_screen.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:app/utils/image_resource.dart';
import 'package:app/utils/string_resource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_country_picker/flutter_country_picker.dart';
import 'package:flutter_svg/svg.dart';

import 'package:app/utils/app_constants.dart';
import 'otp_screen.dart';

class EnterPhoneScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _EnterPhoneState();
  }
}

class _EnterPhoneState extends State<EnterPhoneScreen> {
  final _phoneController = TextEditingController();

  String phoneNo = "", verificationId;

  get verifiedSuccess => null;

  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    var bottomCardHeight = MediaQuery.of(context).size.height - 170;
    return Scaffold(
      backgroundColor: ColorResources.app_primary_color,
      resizeToAvoidBottomInset: false,
      //resizeToAvoidBottomPadding: false,
      body: SingleChildScrollView(
        controller: ScrollController(),
        padding: EdgeInsets.zero,
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              HeaderToolBar(
                titleText: StringResource.mobile_verification,
                context: context,
              ),
              cupImage(),
              bottomCard(bottomCardHeight),
              Align(
                alignment: Alignment.center,
                child: CommmonProgressIndicator(isLoading),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> verfiyPhone() async {
    isLoading = true;
    setState(() {});
    print("phoneNo$phoneNo");
    final PhoneCodeAutoRetrievalTimeout autoRetrieve = (String verId) {
      this.verificationId = verId;
    };
    final PhoneCodeSent smsCodeSent = (String verId, [int forceCodeResent]) {
      this.verificationId = verId;
      print("verificationId$verificationId");
      dismissProgressDialog();
      Utils.nextScreen(
          OtpScreen(
            verificationId: this.verificationId,
            phoneNumber: phoneNo,
          ),
          context);
    };
    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {
      print("verifiedSuccess");
    };
    final PhoneVerificationFailed verifyFailed = (FirebaseAuthException e) {
      print('${e.message}');
      dismissProgressDialog();
      if (e.code == 'invalid-phone-number') {
        Utils.showSnackBar('The provided phone number is not valid.', context);
        print('The provided phone number is not valid.');
      } else {
        Utils.showSnackBar(e.message, context);
      }
    };

    await FirebaseAuth.instance
        .verifyPhoneNumber(
          phoneNumber: phoneNo,
          timeout: const Duration(seconds: 120),
          verificationCompleted: verifiedSuccess,
          verificationFailed: verifyFailed,
          codeSent: smsCodeSent,
          codeAutoRetrievalTimeout: autoRetrieve,
        )
        .then((value) {})
        .catchError((onError) {
      isLoading = false;
      setState(() {});
      Utils.showSnackBar(onError.toString(), context);
    });
  }

  signinRecaptch() async {
    ConfirmationResult confirmationResult =
        await FirebaseAuth.instance.signInWithPhoneNumber('+44 7123 123 456');
    UserCredential userCredential = await confirmationResult.confirm('123456');
    ConfirmationResult confirmationResult2 =
        await FirebaseAuth.instance.signInWithPhoneNumber(
            '+44 7123 123 456',
            RecaptchaVerifier(
              container: 'recaptcha',
              size: RecaptchaVerifierSize.compact,
              theme: RecaptchaVerifierTheme.dark,
              onSuccess: () => print('reCAPTCHA Completed!'),
              onError: (FirebaseAuthException error) => print(error),
              onExpired: () => print('reCAPTCHA Expired!'),
            ));
  }

  Country _selected=Country.US;

  bottomCard(double bottomCardHeight) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: bottomCardHeight,
        decoration: bottomCardDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 75, left: 25, right: 25, bottom: 6),
              child: phoneNumberText(),
            ),
            Padding(
              padding: EdgeInsets.only(left: 25, right: 25),
              child: Stack(
                children: <Widget>[
                  //textFieldPhoneNumberBg(),
                  enterPhoNumber(),
                  Row(
                    children: <Widget>[
                      CountryPicker(
                        dense: false,
                        showFlag: false,
                        //displays flag, true by default
                        showDialingCode: true,
                        //displays dialing code, false by default
                        showName: false,
                        //displays country name, true by default
                        showCurrency: false,
                        //eg. 'British pound'
                        showCurrencyISO: false,
                        //eg. 'GBP'
                        dialingCodeTextStyle: TextStyle(
                          fontFamily: AppConstants.Poppins_Font,
                          fontSize: 14,
                          color: const Color(0x80131621),
                          fontWeight: FontWeight.w300,
                        ),
                        onChanged: (Country country) {
                          setState(() {
                            _selected = country;
                          });
                          print("_selected${_selected.dialingCode}");
                        },
                        selectedCountry: _selected,
                      ),
                      Container(
                        height: 50,
                        width: 1,
                        padding: EdgeInsets.all(1),
                        color: Color(0xff4a4d54).withOpacity(0.5),
                      )
                    ],
                  )
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.topCenter,
                child: Padding(
                  padding: EdgeInsets.only(left: 25, right: 25, top:100,bottom: 24),
                  child: CustomButton(
                    buttonClickCallback: () {
                      //  Utils.nextScreen(ProfileSetUpScreen(), context);
                      submitClick();
                    },
                    buttonTitle: 'Submit',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  phoneNumberText() {
    return Text(
      StringResource.phone_number,
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 16,
        color: const Color(0xff131621),
      ),
      textAlign: TextAlign.left,
    );
  }

  textFieldPhoneNumberBg() {
    return SvgPicture.string(
      '<svg viewBox="0.0 29.0 325.0 48.0" ><path transform="translate(0.0, 29.0)" d="M 6 0 L 319 0 C 322.313720703125 0 325 2.686291217803955 325 6 L 325 42 C 325 45.3137092590332 322.313720703125 48 319 48 L 6 48 C 2.686291217803955 48 0 45.3137092590332 0 42 L 0 6 C 0 2.686291217803955 2.686291217803955 0 6 0 Z" fill="#ffffff" stroke="#4a4d54" stroke-width="1" stroke-opacity="0.2" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
      allowDrawingOutsideViewBox: true,
      fit: BoxFit.fill,
      width: MediaQuery.of(context).size.width - 50,
    );
  }

  enterPhoNumber() {
    return Container(
      height: 48.0,
      padding: EdgeInsets.only(left: 25, right: 25),
      decoration: textFieldDecoration(),
      child: TextField(
        expands: false,
        textInputAction: TextInputAction.done,
        keyboardType: Platform.isIOS?TextInputType.numberWithOptions(
            decimal: true,
            signed: true):TextInputType.number,

        controller: _phoneController,
        inputFormatters: [
          LengthLimitingTextInputFormatter(10),
          //WhitelistingTextInputFormatter(RegExp("[0-9]"))
        ],
        onSubmitted: (phone) {
          phoneNo = phone;
          Utils.hideKeyboard();
          submitClick();
        },
        onChanged: (phone) {
          phoneNo = phone;
        },
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 45),
          hintText: StringResource.please_enter_phone,
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

  enterPhoneNumber() {
    return TextField(
      expands: false,
      keyboardType: TextInputType.phone,
      controller: _phoneController,
      inputFormatters: [
        LengthLimitingTextInputFormatter(10),
       // WhitelistingTextInputFormatter(RegExp("[0-9]"))
      ],
      onChanged: (value) {
        phoneNo = value;
      },
      decoration: InputDecoration(
        border: InputBorder.none,
        contentPadding: EdgeInsets.only(left: 100),
        hintText: StringResource.please_enter_phone,
        hintStyle: TextStyle(
          fontFamily: AppConstants.Poppins_Font,
          fontSize: 14,
          color: const Color(0x80131621),
          fontWeight: FontWeight.w300,
        ),
        hintMaxLines: 1,
      ),
    );
  }

  void dismissProgressDialog() {
    isLoading = false;
    setState(() {});
  }

  void submitClick() async {
    if (_phoneController.text != null &&
        _phoneController.text != '' &&
        _phoneController.text.length == 10) {
      phoneNo = "+${_selected.dialingCode}${_phoneController.text}";
      await FirebaseAuth.instance.signOut();
      verfiyPhone();
    } else {
      Utils.showSnackBar('Please enter valid phone number.', context);
    }
  }
}
