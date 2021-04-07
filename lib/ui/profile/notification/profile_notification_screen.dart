import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/push_notifications/notifiaction_model.dart';
import 'package:app/ui/chat/chat_main_list_item.dart';
import 'package:app/ui/chat/model/chat_message_model.dart';
import 'package:app/ui/listitems/home_trip_item.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/ui/trips/tripItems/requested_trip_item.dart';
import 'package:app/ui/trips/tripItems/requested_trip_with_options_item.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/image_resource.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

// ignore: must_be_immutable
class ProfileTabLisScreen extends StatelessWidget {
  var type;
  List<TripModelData> tripViewAllList;
  List<NotificationModel> notificationList;
  FirebaseDbService firebaseDbService = FirebaseDbService();

  List<ChatMessageModel> chatList;
  UserModel currentUser;

  ProfileTabLisScreen(
      {this.type, this.tripViewAllList,this.currentUser, this.chatList, this.notificationList});

  NotificationModel notificationModelItem;

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: ListView.builder(
          itemCount: type == 1
              ? chatList.length
              : type == 0
                  ? notificationList.length
                  : type == 4
                      ? tripViewAllList.length
                      : 0,
          padding: EdgeInsets.zero,
          itemBuilder: (BuildContext context, int position) {
            if (type == 0) {
              notificationModelItem = notificationList[position];
            }
            return type == 4
                ? Padding(
                    padding: EdgeInsets.only(
                        top: 25,
                        left: 24,
                        right: 24,
                        bottom: position == 9 ? 30 : 0),
                    child: RequestedTripWithOptionItem(
                      firebaseDbService: firebaseDbService,
                      tripModelData: tripViewAllList[position],
                      position: position,
                      currentUser: currentUser,
                    ),
                  )
                : type == 0
                    ? notificationItem(context, notificationModelItem)
                    : type == 1
                        ? ChatListItem(
                            position: position,
                            chatMessageModel: chatList[position],
                            firebaseDbService: firebaseDbService,
                          )
                        : Padding(
                            padding: EdgeInsets.only(
                                left: 25,
                                right: 25,
                                bottom: position == 9 ? 50 : 0),
                            child: RequestedTripItem(
                              position: position,
                            ),
                          );
          }),
    );
  }

  notificationItem(BuildContext context, NotificationModel notificationModel) {
    return Container(
      width: MediaQuery.of(context).size.width - 62,
      margin: EdgeInsets.only(left: 24, right: 24, top: 25),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: const Color(0xffffffff),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.08),
                offset: Offset(0, 4),
                blurRadius: 16)
          ]),
      child: Padding(
        padding: EdgeInsets.only(top: 17, bottom: 17, left: 12, right: 12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            StreamBuilder<UserModel>(
              stream: firebaseDbService.getUserInfoInfoStream(uid:notificationModel.senderUid ),
              initialData: null,
              builder: (context, snapshot) {
                return snapshot.data==null? SizedBox(
                    height: 35,
                    width: 35,
                    child: Center(child: Image.asset('assets/images/profile.png'))): SizedBox(
                    height: 35,
                    width: 35,
                    child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(35)),
                          child: CachedNetworkImage(
                            imageUrl: snapshot.data.profileUrl,
                            height: 35,
                            width: 35,
                            fit: BoxFit.cover,
                            errorWidget: (a, b, c) {
                              return placeHolderImage(
                                  imagePath: ImageResource.profile, height: 35, width: 35);
                            },
                            placeholder: (BuildContext context, String url) {
                              return placeHolderImage(
                                  imagePath: ImageResource.placeHolderImage,
                                  height: 35,
                                  width: 35);
                            },
                          ),
                        )));
              }
            ),
            SizedBox(
              width: 15,
            ),
            notificationTextItem(
                notificationModelItem.title, notificationModelItem.body),
          ],
        ),
      ),
    );
  }

  notificationTextItem(String title, String content) {
    return Expanded(
      child: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text: '$title \t',
            style: TextStyle(
              fontFamily: AppConstants.Poppins_Font,
              fontSize: 13,
              color: const Color(0xff131621),
              fontWeight: FontWeight.w500,
            ),
          ),
          TextSpan(
            text: content,
            style: TextStyle(
              fontFamily: AppConstants.Poppins_Font,
              fontSize: 13,
              color: const Color(0xff131621),
              fontWeight: FontWeight.w300,
            ),
          ),
        ]),
      ),
    );
  }
}

userChatItem(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width - 62,
    margin: EdgeInsets.only(left: 24, right: 24, top: 21),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: Offset(0, 4),
              blurRadius: 16)
        ]),
    child: Padding(
      padding: EdgeInsets.only(top: 12, bottom: 12, left: 12, right: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
              height: 35,
              width: 35,
              child: Center(child: Image.asset('assets/images/profile.png'))),
          SizedBox(
            width: 15,
          ),
          userName(),
          chatIcon()
        ],
      ),
    ),
  );
}

chatIcon() {
  return Expanded(
    child: Align(
        alignment: Alignment.centerRight,
        child: SvgPicture.asset('assets/images/chat_unselect.svg')),
  );
}

userName() {
  return Text(
    'Ashley Neagle',
    style: TextStyle(
      fontFamily: AppConstants.Poppins_Font,
      fontSize: 18,
      color: const Color(0xff131621),
    ),
    textAlign: TextAlign.left,
  );
}
