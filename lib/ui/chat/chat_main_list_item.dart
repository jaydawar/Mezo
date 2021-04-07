import 'package:app/common_widget/custom_progress_indicator.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/ui/listitems/home_trip_item.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'chat_message_screen.dart';
import 'model/chat_message_model.dart';

class ChatListItem extends StatelessWidget {
  int position;
  ChatMessageModel chatMessageModel;
  FirebaseDbService firebaseDbService;
  String otherUserId;

  ChatListItem({this.position, this.chatMessageModel, this.firebaseDbService});

  @override
  Widget build(BuildContext context) {
    if (chatMessageModel != null) {
      if (chatMessageModel.toID == currentUserIdValue) {
        otherUserId = chatMessageModel.fromId;
      } else if (chatMessageModel.fromId == currentUserIdValue) {
        otherUserId = chatMessageModel.toID;
      }
      print("*******otherUserId${otherUserId}");
    }
    return chatListItemBody(chatMessageModel);
  }

  chatListItemBody(ChatMessageModel chatMessageModel) {
    return Padding(
      padding: EdgeInsets.only(
          /*left: 24, right: 24.0, bottom: position == 9 ? 50 : 0, top: 15.0),*/
          left: 24,
          right: 24.0,
          bottom: 0,
          top: 15.0),
      child: StreamBuilder<UserModel>(
          stream: firebaseDbService.getUserInfoInfoStream(uid: otherUserId),
          initialData: null,
          builder: (context, snapshot) {
            return InkWell(
              onTap: () {
                var otherUserId;
                var otherUserName;
                if (chatMessageModel.toID == currentUserIdValue) {
                  otherUserId = chatMessageModel.fromId;
                  otherUserName = chatMessageModel.fromUserName;
                } else if (chatMessageModel.fromId ==
                    currentUserIdValue) {
                  otherUserId = chatMessageModel.toID;
                  otherUserName = chatMessageModel.toUserName;
                }

                Utils.nextScreen(
                  ChatMessageScreen(
                    otherUserId: otherUserId,
                    myUserId: currentUserIdValue,
                    otherUserName: otherUserName,
                    otherUserProfilePic: '',
                    previoischatMessageModel: chatMessageModel,
                  ),
                  context,
                );
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  userImg(snapshot.data),
                  SizedBox(
                    width: 16.0,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            userName(snapshot.data == null
                                ? ""
                                : snapshot.data.fullName),
                            chatMessageModel.fromId != currentUserIdValue &&
                                    chatMessageModel.status != null &&
                                    chatMessageModel.status == "unread"
                                ? dotImg()
                                : Container()
                          ],
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        messageContent(chatMessageModel.message),
                        SizedBox(
                          height: 16.0,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
    );
  }

  messageContent(msg) {
    return SingleChildScrollView(
        child: Text(
      msg,
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 14,
        color: const Color(0xff78849e),
        height: 1.5714285714285714,
      ),
      textAlign: TextAlign.left,
    ));
  }

  userName(String username) {
    return // Adobe XD layer: 'Marie Winter' (text)
        Text(
      username,
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 16,
        color: const Color(0xff454f63),
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.left,
    );
  }

  userImg(UserModel data) {
    return // Adobe XD layer: 'avatar' (shape)

        Container(
      height: 62,
      width: 62,
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
      ),
      child: data == null
          ? CircularProgressIndicator()
          : Container(
              height: 62,
              width: 62,
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  child: data.profileUrl != null
                      ? CachedNetworkImage(
                          imageUrl: data.profileUrl,
                          height: 62.0,
                          width: 62.0,
                          fit: BoxFit.cover,
                          placeholder: (BuildContext context, String image) {
                            return CommmonProgressIndicator(true);
                          },
                          errorWidget: (a, b, c) {
                            return placeHolderImage(
                              imagePath: 'assets/images/profile.png',
                              height: 62,
                              width: 62,
                            );
                          },
                        )
                      : placeHolderImage(
                          imagePath: 'assets/images/profile.png',
                          height: 62,
                          width: 62,
                        )),
            ),
    );
  }
}

dotImg() {
  return // Adobe XD layer: 'badge' (shape)
      Container(
    height: 8,
    width: 8,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(4.0),
      color: const Color(0xfffca25d),
    ),
  );
}
