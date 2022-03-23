import 'dart:convert';

import 'package:app/common_widget/common_decoration.dart';
import 'package:app/common_widget/custom_button.dart';
import 'package:app/common_widget/custom_progress_indicator.dart';
import 'package:app/common_widget/header_toolbar.dart';
import 'package:app/common_widget/pin_entery_text_field.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/models/allusers_repo.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/ui/auth/profile_setup_screen.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:app/utils/string_resource.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app/utils/app_constants.dart';
import 'package:flutter/services.dart';
import '../dashboard/dashboard.dart';

class OtpScreen extends StatefulWidget {
  String verificationId;
  String phoneNumber;

  OtpScreen({this.verificationId, this.phoneNumber});

  @override
  State<StatefulWidget> createState() {
    return _OtpState(verificationId: verificationId);
  }
}

class _OtpState extends State<OtpScreen> {
  String smssent = "", verificationId;
  var isLoading = false;
  FirebaseDbService firebaseUserAuth = FirebaseDbService();

  //https://firebase.flutter.dev/docs/auth/phone/
  _OtpState({this.verificationId});

  Future<void> signIn(String smsCode) async {
    print("verificationId$verificationId");
    if (smsCode != null && smsCode != '') {
      final AuthCredential credential = PhoneAuthProvider.credential(
        verificationId: widget.verificationId,
        smsCode: smsCode,
      );
      FirebaseAuth auth = FirebaseAuth.instance;

      // Wait for the user to complete the reCAPTCHA & for a SMS code to be sent.
      //  ConfirmationResult confirmationResult = await auth.signInWithPhoneNumber(widget.phoneNumber);
      // UserCredential userCredential = await confirmationResult.confirm('123456');
      await FirebaseAuth.instance.signInWithCredential(credential).then((user) {
        print("userRegisteruid${user.user.uid}");
        isLoading = false;
        notify();
        checkUserExistedOrNot(user.user.uid);

      }).catchError((signUpError) {
        print("Exceptiom ${signUpError}");

        if (signUpError is FirebaseAuthException) {
          print("CheckErrorCode${signUpError.code}");
          if (signUpError.code.trim() == 'invalid-verification-code'.trim()) {
            Utils.showSnackBar(
                'The entered OTP is incorrect. Please try again.', context);
          } else if (signUpError.code.trim() == 'session-expired'.trim()) {
            Utils.showSnackBar(
                'The SMS code has expired. Please re-send the verification code to try again.',
                context);
          } else {
            Utils.showSnackBar(signUpError.toString(), context);
          }
          //Utils.showSnackBar(signUpError.toString(), context);
        }
        isLoading = false;
        notify();
      });
    } else {
      Utils.showSnackBar('Please enter otp.', context);
    }
  }

  Future<void> resendVerificationCode() async {
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
            phoneNumber: widget.phoneNumber,
          ),
          context);
    };
    final PhoneVerificationCompleted verifiedSuccess = (AuthCredential auth) {
      print("verifiedSuccess");
    };
    final PhoneVerificationFailed verifyFailed = (FirebaseAuthException e) {
      print('${e.message}');
      dismissProgressDialog();
      Utils.showSnackBar('Something went wrong', context);
    };

    await FirebaseAuth.instance
        .verifyPhoneNumber(
          phoneNumber: widget.phoneNumber,
          timeout: const Duration(seconds: 60),
          verificationCompleted: verifiedSuccess,
          verificationFailed: verifyFailed,
          codeSent: smsCodeSent,
          codeAutoRetrievalTimeout: autoRetrieve,
        )
        .then((value) {})
        .catchError((onError) {
      dismissProgressDialog();
      Utils.showSnackBar('Something went wrong', context);
    });
  }

  @override
  Widget build(BuildContext context) {
    var bottomCardHeight = MediaQuery.of(context).size.height - 170;
    return Scaffold(
      backgroundColor: ColorResources.app_primary_color,
      resizeToAvoidBottomInset: false,
    //  resizeToAvoidBottomPadding: false,
      body: Stack(
        children: <Widget>[
          HeaderToolBar(
            titleText: StringResource.enter_otp,
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
    );
  }

  bottomCard(double bottomCardHeight) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: SingleChildScrollView(
        controller: ScrollController(),
        padding: EdgeInsets.zero,
        child: Container(
          height: bottomCardHeight,
          decoration: bottomCardDecoration(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(top: 75, left: 25, right: 25, bottom: 6),
                child: otpText(),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 25, left: 25, right: 25, bottom: 25),
                child: PinEntryTextField(
                  showFieldAsBox: true,
                  fieldWidth: 40.0,
                  fontSize: 12.0,
                  fields: 6,
                  onSubmit: (String pin) {
                    smssent = pin;
                    isLoading = true;
                    notify();
                    signIn(smssent);
                    //end showDialog()
                  }, // end onSubmit
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                      left: 25,
                      right: 25,
                    ),
                    child: CustomButton(
                      buttonClickCallback: () {
                        if (smssent != null && smssent.length == 6) {
                          isLoading = true;
                          notify();
                          signIn(smssent);
                        } else {
                          Utils.showSnackBar('Please enter otp.', context);
                        }
                      },
                      buttonTitle: 'Submit',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        didNotReceive(),
                        SizedBox(
                          height: 8,
                        ),
                        resendCode(),
                        SizedBox(
                          height: 8,
                        ),
                      ],
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

  otpText() {
    return Text(
      StringResource.otp_text,
      textAlign: TextAlign.center,
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 14,
        color: const Color(0xff1d2029),
        fontWeight: FontWeight.w400,
      ),
    );
  }

  resendCode() {
    return // Adobe XD layer: 'Google' (text)
        InkWell(
      onTap: () {
        isLoading = true;
        notify();
        resendVerificationCode();
        // FirebaseAuth.instance.r
      },
      child: Text(
        'Resend Code',
        style: TextStyle(
            fontFamily: 'Poppins-Regular',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: const Color(0xfffca25d),
            decoration: TextDecoration.underline),
        textAlign: TextAlign.left,
      ),
    );
  }

  didNotReceive() {
    return Text(
      'Didn\'t receive the OTP?',
      style: TextStyle(
        fontFamily: 'Circe',
        fontSize: 12,
        color: const Color(0xff1d2029),
        fontWeight: FontWeight.w500,
      ),
      textAlign: TextAlign.left,
    );
  }

  void notify() {
    setState(() {});
  }

  void dismissProgressDialog() {
    isLoading = false;
    setState(() {});
  }

  void goToDashBoardScreen(String uid) async {

    //
  }

  void checkUserExistedOrNot(String uid)async {

    firebaseUserAuth.doesUserIdAlreadyExist(uid).then((userModel) {
      print("userModel${jsonEncode(userModel)}");
      if (userModel != null && userModel.uid != null) {
        // UserModel userModel=   await  firebaseUserAuth.getUserInfoWhere(uid:uid);

        //   currentUserIdValue=uid;
        //  print("uiduiduid$uid");
        //  print("CurrentUserId$currentUserIdValue");

        updateLocalStorageCurrentUser(userModel);
        // jsonEncode('jsonEncodeuserModel${jsonEncode(user)}');

      } else {
        Utils.nextScreen(
            ProfileSetUpScreen(
              userId: uid,
              phoneNumber: widget.phoneNumber,
            ),
            context);
      }
    });
  }

  void updateLocalStorageCurrentUser(UserModel userModel) async{
    print("userModel${jsonEncode(userModel)}");
    //goToDashBoardScreen(user.user.uid);
    await UserRepo.getInstance().setCurrentUser(userModel);
    await  print("CurrentUserId$currentUserIdValue");
   var user=await UserRepo.getInstance().getCurrentUser();
    print("getCurrentUser${jsonEncode(user)}");
    if(user!=null&&user.uid!=null) {
      Utils.finishAll(DashboardPage(), context);
    }
  }

// Adobe XD layer: 'Facebook' (text)
}
