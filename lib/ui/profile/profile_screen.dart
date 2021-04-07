import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:app/bottomsheet/file_picker_bottomsheet.dart';
import 'package:app/common_widget/custom_progress_indicator.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/helper/AppConstantHelper.dart';
import 'package:app/models/notification_repo.dart';
import 'package:app/models/trip_repo.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/push_notifications/notifiaction_model.dart';
import 'package:app/ui/chat/model/chat_message_model.dart';
import 'package:app/ui/listitems/home_trip_item.dart';
import 'package:app/ui/profile/settings/settings_screen.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:app/utils/image_resource.dart';
import 'package:app/utils/string_resource.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'notification/profile_notification_screen.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ProfileState();
  }
}

class _ProfileState extends State<ProfileScreen> {
  var type = 0;
  var selectedCollor = Color(0xffFCA25D);
  var unselectedCollor = Color(0xff838383);
  var filePath = "";
  var _uploadedFileURL = "";
  UserModel currentUser;
  var isLoading = false;
  FirebaseDbService firebaseUserAuth = FirebaseDbService();
  AppConstantHelper _appConstantHelper;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  List<NotificationModel> notificationList = [];
  List<TripModelData> tripList = [];
  List<ChatMessageModel> chatList = [];

  void _initialize() async {
    _appConstantHelper = AppConstantHelper();
    _appConstantHelper.setContext(context);
    NotificationRepo.getInstance().getNotificationStream().listen((event) {
      notificationList = [];
      notificationList.addAll(event);
      log("notificationList${jsonEncode(event)}");
      setState(() {});
    });

    TripRepo.getInstance().getTripsStream().listen((event) {
      tripList = [];
      log("tripListevent${jsonEncode(event)}");
      event.forEach((tripItem) {
        tripItem.attendeeList.forEach((element) {
          if (element.attendeeUid == currentUserIdValue) {
            tripList.add(tripItem);
          }
        });
      });
      log("tripListCCCC${jsonEncode(tripList)}");

      setState(() {});
    });
    UserRepo.getInstance().getCurrentUser().then((value) {
      currentUser = value;
      firebaseUserAuth.getChats(currentUser).listen((event) {
        chatList = [];
        chatList.addAll(event);
        log("chatList${jsonEncode(chatList)}");
        setState(() {});
      });

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 64,
              ),
              Align(
                alignment: Alignment.centerRight,
                child: settingIcon(),
              ),
              Row(
                children: <Widget>[
                  profileImage(),
                  SizedBox(
                    width: 24,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 36),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          userName(),
                          SizedBox(
                            height: 1,
                          ),
                          //address(),
                        ],
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 24,
              ),
              Divider(
                height: 1,
                color: Color(0xff455B63),
              ),
              Row(
                children: <Widget>[
                  notificationIcon(),
                  usersIcon(),
                  tripsIcon()
                ],
              ),
              Divider(
                height: 1,
                color: Color(0xff455B63),
              ),
              SizedBox(
                height: 16,
              ),
              type==0&&notificationList.length==0?Expanded(child: Center(child: Text('No notifications yet'))):
              type==1&&chatList.length==0?Expanded(child: Center(child: Text('No chat users yet'))):
              type==2&&tripList.length==0?Expanded(child: Center(child: Text('No trips yet')))
                  :ProfileTabLisScreen(
                type: type == 2 ? 4 : type,
                notificationList: notificationList,
                tripViewAllList: tripList,
                chatList: chatList,
                currentUser: currentUser,
              ),
            ],
          ),
          Align(
            alignment: Alignment.center,
            child: CommmonProgressIndicator(isLoading),
          )
        ],
      ),
    );
  }

  notificationIcon() {
    return Expanded(
      child: InkWell(
        onTap: () {
          type = 0;
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 19),
          child: SvgPicture.string(
            '<svg viewBox="43.0 274.0 20.0 23.3" ><path transform="translate(40.0, 272.0)" d="M 10.77598476409912 23.08723068237305 C 10.77598476409912 24.30742835998535 11.7632360458374 25.294677734375 12.98343276977539 25.294677734375 C 14.20362949371338 25.294677734375 15.19088077545166 24.30742835998535 15.19088077545166 23.08723068237305 L 10.77598476409912 23.08723068237305 Z M 20.61521530151367 18.43938636779785 L 20.61521530151367 11.98343276977539 C 20.61521530151367 8.378303527832031 18.11935615539551 5.36108922958374 14.74717426300049 4.562414646148682 L 14.74717426300049 3.763739824295044 C 14.74717235565186 2.787581920623779 13.95959091186523 1.99999988079071 12.98343276977539 1.99999988079071 C 12.00727462768555 1.99999988079071 11.21969318389893 2.787581920623779 11.21969318389893 3.763740062713623 L 11.21969318389893 4.56241512298584 C 7.847511291503906 5.36108922958374 5.3516526222229 8.378303527832031 5.3516526222229 11.98343276977539 L 5.3516526222229 18.43938636779785 L 3 20.79104042053223 L 3 21.96686553955078 L 22.96686744689941 21.96686553955078 L 22.96686744689941 20.79104042053223 L 20.61521530151367 18.43938636779785 Z M 17.4205150604248 14.21306610107422 L 18.017578125 9.70947265625 L 10.169921875 9.70947265625 L 7.82421875 16.494140625 L 18.017578125 16.494140625 L 9.626953125 10.67236328125 L 8.546351432800293 11.98343276977539 L 11.8741626739502 11.98343276977539 L 11.8741626739502 8.655621528625488 L 14.09270286560059 8.655621528625488 L 9 8.655621528625488 L 17.4205150604248 11.98343276977539 L 17.4205150604248 14.21306610107422 Z" fill="#fca25d" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
            allowDrawingOutsideViewBox: true,
            color: type == 0 ? selectedCollor : unselectedCollor,
          ),
        ),
      ),
    );
  }

  usersIcon() {
    return Expanded(
      child: InkWell(
        onTap: () {
          type = 1;
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 19),
          child: SvgPicture.string(
            '<svg viewBox="172.0 274.0 31.4 20.0" ><path transform="translate(171.0, 269.0)" d="M 22.4285717010498 13.5714282989502 C 24.79999923706055 13.5714282989502 26.70000076293945 11.65714263916016 26.70000076293945 9.285715103149414 C 26.70000076293945 6.914286136627197 24.79999923706055 5.000000476837158 22.4285717010498 5.000000476837158 C 20.05714416503906 5.000000476837158 18.14285659790039 6.914286136627197 18.14285659790039 9.285715103149414 C 18.14285659790039 11.65714263916016 20.05714416503906 13.5714282989502 22.4285717010498 13.5714282989502 Z M 11 13.5714282989502 C 13.37142848968506 13.5714282989502 15.27142810821533 11.65714263916016 15.27142810821533 9.285715103149414 C 15.27142810821533 6.914286136627197 13.37142848968506 5.000000476837158 11 5.000000476837158 C 8.628571510314941 5.000000476837158 6.714286327362061 6.914286136627197 6.714286327362061 9.285715103149414 C 6.714286327362061 11.65714263916016 8.628571510314941 13.5714282989502 11 13.5714282989502 Z M 11 16.4285717010498 C 7.67142915725708 16.4285717010498 1 18.10000038146973 1 21.4285717010498 L 1 25.00000190734863 L 21 25.00000190734863 L 21 21.4285717010498 C 21 18.10000038146973 14.32857131958008 16.4285717010498 11 16.4285717010498 Z M 22.4285717010498 16.4285717010498 C 22.01428604125977 16.4285717010498 21.5428581237793 16.45714378356934 21.04285621643066 16.50000190734863 C 22.70000076293945 17.70000076293945 23.85714340209961 19.31428718566895 23.85714340209961 21.4285717010498 L 23.85714340209961 25.00000190734863 L 32.42857360839844 25.00000190734863 L 32.42857360839844 21.4285717010498 C 32.42857360839844 18.10000038146973 25.75714302062988 16.4285717010498 22.4285717010498 16.4285717010498 Z" fill="#838383" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
            allowDrawingOutsideViewBox: true,
            color: type == 1 ? selectedCollor : unselectedCollor,
          ),
        ),
      ),
    );
  }

  tripsIcon() {
    return Expanded(
      child: InkWell(
        onTap: () {
          type = 2;
          setState(() {});
        },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 19),
          child: SvgPicture.string(
            '<svg viewBox="313.0 275.0 16.1 21.5" ><path transform="translate(310.11, 273.52)" d="M 13.48999977111816 5.480000019073486 C 14.59000015258789 5.480000019073486 15.48999977111816 4.579999923706055 15.48999977111816 3.480000019073486 C 15.48999977111816 2.380000114440918 14.59000015258789 1.480000019073486 13.48999977111816 1.480000019073486 C 12.38999938964844 1.480000019073486 11.48999977111816 2.380000114440918 11.48999977111816 3.480000019073486 C 11.48999977111816 4.579999923706055 12.38999938964844 5.480000019073486 13.48999977111816 5.480000019073486 Z M 9.889999389648438 19.3799991607666 L 10.88999938964844 14.97999954223633 L 12.98999977111816 16.97999954223633 L 12.98999977111816 22.97999954223633 L 14.98999977111816 22.97999954223633 L 14.98999977111816 15.47999954223633 L 12.88999938964844 13.47999954223633 L 13.48999977111816 10.47999954223633 C 14.78999996185303 11.97999954223633 16.78999900817871 12.97999954223633 18.98999977111816 12.97999954223633 L 18.98999977111816 10.97999954223633 C 17.09000015258789 10.97999954223633 15.48999977111816 9.979999542236328 14.6899995803833 8.579999923706055 L 13.6899995803833 6.980000019073486 C 13.28999996185303 6.380000114440918 12.6899995803833 5.980000019073486 11.98999977111816 5.980000019073486 C 11.6899995803833 5.980000019073486 11.48999977111816 6.079999923706055 11.1899995803833 6.079999923706055 L 5.989999771118164 8.279999732971191 L 5.989999771118164 12.97999954223633 L 7.989999771118164 12.97999954223633 L 7.989999771118164 9.579999923706055 L 9.789999961853027 8.880000114440918 L 8.189999580383301 16.97999954223633 L 3.289999485015869 15.97999954223633 L 2.889999389648438 17.97999954223633 L 9.889999389648438 19.3799991607666 Z" fill="#838383" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
            allowDrawingOutsideViewBox: true,
            color: type == 2 ? selectedCollor : unselectedCollor,
          ),
        ),
      ),
    );
  }

  settingIcon() {
    return Padding(
      padding: const EdgeInsets.only(right: 24),
      child: InkWell(
        onTap: () {
          Utils.nextScreen(SettingsScreen(), context);
        },
        child: SvgPicture.string(
          '<svg viewBox="0.0 0.0 26.2 27.0" ><path transform="translate(-260.0, 0.0)" d="M 272.9276733398438 16.875 C 274.8236999511719 16.875 276.375 15.35624980926514 276.375 13.5 C 276.375 11.64374923706055 274.8236999511719 10.125 272.9276733398438 10.125 C 271.0315551757812 10.125 269.4802551269531 11.64374923706055 269.4802551269531 13.5 C 269.4802551269531 15.35624980926514 271.0315551757812 16.875 272.9276733398438 16.875 Z M 265.8604736328125 6.074999332427979 C 267.0671081542969 5.0625 268.4460144042969 4.21875 269.997314453125 3.881249666213989 L 271.3763122558594 0 L 274.8236389160156 0 L 276.2025451660156 3.881249666213989 C 277.75390625 4.387499809265137 279.1328430175781 5.0625 280.3393859863281 6.074999332427979 L 284.4762878417969 5.231249332427979 L 286.199951171875 8.268749237060547 L 283.4420166015625 11.30624866485596 C 283.6144104003906 11.98124980926514 283.6144104003906 12.82499980926514 283.6144104003906 13.5 C 283.6144104003906 14.17499923706055 283.4420166015625 15.01874923706055 283.4420166015625 15.69375038146973 L 286.199951171875 18.73124885559082 L 284.4762878417969 21.76874923706055 L 280.3393859863281 20.92499923706055 C 279.1328430175781 21.93750190734863 277.75390625 22.78125190734863 276.2025451660156 23.11874961853027 L 274.8236389160156 27 L 271.3763122558594 27 L 269.997314453125 23.11874961853027 C 268.4460144042969 22.61249732971191 267.0670166015625 21.9375 265.8604736328125 20.92499732971191 L 261.7236633300781 21.76874732971191 L 260 18.73124885559082 L 262.7579040527344 15.69374752044678 C 262.5855102539062 15.01874923706055 262.5855102539062 14.17499923706055 262.5855102539062 13.49999809265137 C 262.5855102539062 12.82499599456787 262.7579040527344 11.9812479019165 262.7579040527344 11.30624771118164 L 260 8.268750190734863 L 261.7236633300781 5.231249809265137 L 265.8604736328125 6.074999332427979 Z" fill="none" stroke="#95989a" stroke-width="1.5" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
          allowDrawingOutsideViewBox: true,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  userName() {
    return Text(
      currentUser != null ? currentUser.fullName+"" : "",
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 21,
        color: const Color(0xff272727),
        fontWeight: FontWeight.w700,
        height: 1.2857142857142858,
      ),
      textAlign: TextAlign.left,
    );
  }

  address() {
    return Text(
      'Allentown, PA',
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 14.5,
        color: const Color(0xff7a8fa6),
        height: 1.8620689655172413,
      ),
      textAlign: TextAlign.left,
    );
  }

  profileImage() {
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: InkWell(
        onTap: () {
          pickFileandUploadToServer();
        },
        child: Container(
          height: 121.0,
          width: 121.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(121)),
            child: currentUser != null
                ? Stack(children: [

              _appConstantHelper.loadNetworkImageProfile(
                  width: 121.0,
                  height: 121.0,
                  filePath: filePath,
                  imageUrl: currentUser.profileUrl),



            ],) : Center(
                    child: Container(
                      height: 121,
                      width: 121,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.black.withOpacity(0.8)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(98)),
                        child: placeHolderImage(
                            imagePath: ImageResource.placeHolderImage,
                            height: 121,
                            width: 121),
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  void pickFileandUploadToServer() {
    filePickerBottomSheet(context, _appConstantHelper, (filePicked) {
      filePath = filePicked.path;
      print("filePath$filePath");
      showProgress(true);
      firebaseUserAuth
          .uploadFile(
              bucketName: AppConstants.USER_IMAGE_FOLDER,
              filePath: filePath,
              fileUploaded: (fileUploadedUrl) {
                _uploadedFileURL = fileUploadedUrl;
                currentUser.profileUrl = _uploadedFileURL;
                UserRepo.getInstance().setCurrentUser(currentUser);
                firebaseUserAuth.updateUserProfilePic(
                    _uploadedFileURL, currentUser.uid);
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

  void showProgress(bool bool) {
    isLoading = bool;
    setState(() {});
  }
}
