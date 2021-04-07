import 'dart:io';

import 'package:app/bottomsheet/file_picker_bottomsheet.dart';
import 'package:app/common_widget/common_decoration.dart';
import 'package:app/common_widget/custom_button.dart';
import 'package:app/common_widget/custom_progress_indicator.dart';
import 'package:app/common_widget/header_toolbar.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/helper/AppConstantHelper.dart';
import 'package:app/models/login_repo.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/ui/dashboard/dashboard.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:app/utils/image_resource.dart';
import 'package:app/utils/string_resource.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ProfileSetUpScreen extends StatefulWidget {
  var userId;
  var phoneNumber;

  ProfileSetUpScreen({this.userId, this.phoneNumber});

  @override
  State<StatefulWidget> createState() {
    return _ProfileSetUpState();
  }
}

class _ProfileSetUpState extends State<ProfileSetUpScreen> {
  var focusNodeName = FocusNode();
  var focusNodeUserName = FocusNode();
  var filePath = "";
  var userName = "";
  var fullName = "";
  var deviceToken = "";
  var isLoading = false;
  String _uploadedFileURL = "";
  AppConstantHelper appConstantHelper = AppConstantHelper();
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  FirebaseDbService firebaseUserAuth = FirebaseDbService();

  @override
  void initState() {
    appConstantHelper.setContext(context);
    firebaseMessaging.getToken().then((value) {
      deviceToken = value;
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var bottomCardHeight = MediaQuery.of(context).size.height - 170;
    return Scaffold(
      backgroundColor: ColorResources.app_primary_color,
      body: SingleChildScrollView(
        padding: EdgeInsets.zero,
        controller: ScrollController(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          child: Stack(
            children: <Widget>[
              HeaderToolBar(
                titleText: StringResource.profile_setUp,
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
              SizedBox(
                height: 22,
              ),
              tripCreaterUsrProfilePic(''),
              Padding(
                padding:
                    EdgeInsets.only(top: 24, left: 25, right: 25, bottom: 6),
                child: myText(StringResource.name),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: enterNameName(),
              ),
              Padding(
                padding:
                    EdgeInsets.only(top: 12, left: 25, right: 25, bottom: 6),
                child: myText(StringResource.user_name),
              ),
              Padding(
                padding: EdgeInsets.only(
                  left: 25,
                  right: 25,
                ),
                child: enterUserName(),
              ),
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                    child: CustomButton(
                      buttonClickCallback: () {
                        Utils.hideKeyboard();
                        if (userName != "" && fullName != "") {
                          showProgress(true);
                          setUpProfile();
                        } else {
                          Utils.showSnackBar(
                              StringResource.please_enter_username_and_name,
                              context);
                        }
                      },
                      buttonTitle: StringResource.submit,
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

  tripCreaterUsrProfilePic(String image) {
    return Center(
      child: InkWell(
        onTap: () {
          pickFileandUploadToServer();
        },
        child: Container(
          height: 98,
          width: 98,
          alignment: Alignment.center,
          decoration: BoxDecoration(
              shape: BoxShape.circle, color: Colors.black.withOpacity(0.8)),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(98)),
            child: Stack(
              children: <Widget>[
                filePath == ''
                    ? Positioned(
                        top: 20,
                        left: 20,
                        right: 20,
                        bottom: 20,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SvgPicture.asset(
                              ImageResource.camera,
                            ),
                            SizedBox(
                              height: 4,
                            ),
                            Text(
                              StringResource.upload_image,
                              style: TextStyle(
                                fontFamily: AppConstants.Poppins_Font,
                                fontSize: 8,
                                color: Colors.white,
                              ),
                            )
                          ],
                        ),
                      )
                    : Image.file(File(filePath)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  enterNameName() {
    return Container(
      height: 48.0,
      decoration: textFieldDecoration(),
      child: TextField(
        expands: false,
        focusNode: focusNodeName,
        textInputAction: TextInputAction.next,
        onSubmitted: (name) {
          Utils.removeFocusandMoveToNext(
              focusNodeName, focusNodeUserName, context);
        },
        onChanged: (name) {
          fullName = name;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 12),
          hintText: StringResource.please_enter_name,
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

  enterUserName() {
    return Container(
      height: 48.0,
      decoration: textFieldDecoration(),
      child: TextField(
        expands: false,
        focusNode: focusNodeUserName,
        textInputAction: TextInputAction.done,
        onChanged: (username) {
          userName = username;
        },
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(left: 12),
          hintText: StringResource.please_enter_username,
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

  void setUpProfile() {
    // Utils.nextScreen(DashboardPage(), context);

    // if(firebaseUserAuth.checkUserName(userName))
    print("deviceToken $deviceToken");
    print("name $fullName");
    print("userName $userName");
    print("userUid ${widget.userId}");

    var userModel = UserModel(
        address: "",
        createdAt: Utils.getCuurentTimeinMillies(),
        deviceToken: deviceToken,
        fullName: fullName,
        lat: 0.0,
        lng: 0.0,

        profileUrl: _uploadedFileURL,
        phoneNumber: widget.phoneNumber,
        uid: widget.userId,
        userName: userName);

    firebaseUserAuth.doesNameAlreadyExist(userName).then((isExist) {
      if (isExist) {
        Utils.showSnackBar("$userName username is already exists.", context);
        showProgress(false);
      } else {
        LoginRepo.getInstance().addUser(widget.userId, userModel);
        userModel.uid = widget.userId;
        showProgress(false);
        UserRepo.getInstance().setCurrentUser(userModel);
        Utils.finishAll(DashboardPage(), context);
      }
    });
  }


  void pickFileandUploadToServer() {
    filePickerBottomSheet(context, appConstantHelper, (filePicked) {
      filePath = filePicked.path;
      print("filePath$filePath");
      showProgress(true);
      firebaseUserAuth
          .uploadFile(
              bucketName: AppConstants.USER_IMAGE_FOLDER,
              filePath: filePath,
              fileUploaded: (fileUploadedUrl) {
                _uploadedFileURL = fileUploadedUrl;

                print("_uploadedFileURL$_uploadedFileURL");
                showProgress(false);
                isLoading = false;
                setState(() {});
              },
              callBackCode: (callBackCode) {
                isLoading = false;
                setState(() {});
              })
          .catchError((onError) {
        showProgress(false);
      });
    });
  }

  void showProgress(bool value) {
    isLoading = value;
    setState(() {});
  }
}
