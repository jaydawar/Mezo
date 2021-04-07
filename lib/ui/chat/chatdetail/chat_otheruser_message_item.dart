import 'package:app/common_widget/common_other_user_item.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/ui/chat/model/chat_message_model.dart';
import 'package:app/ui/chatModule/const.dart';
import 'package:app/ui/chatModule/widget/full_photo.dart';
import 'package:app/utils/color_resources.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/app_constants.dart';

class ChatMessageOtherUser extends StatelessWidget {
  int position;
  ChatMessageModel messageModel;
  String otherUserId;
  bool isLast;
  FirebaseDbService firebaseDbService;

  ChatMessageOtherUser(
      {this.position,
      this.messageModel,
      this.otherUserId,
      this.isLast,
      this.firebaseDbService});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorResources.app_screen_bgColor,
      padding:
          EdgeInsets.only(top: 20, left: 20, bottom:isLast ? 50 : 0),
      child: otherMessageItem(context: context),
    );
  }

  message() {
    return // Adobe XD layer: 'bg' (shape)
        Text(
      messageModel.message,
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 14,
        color: const Color(0xffffffff),
        height: 1.4285714285714286,
      ),
      textAlign: TextAlign.left,
    );
  }

  userImg() {
    return // Adobe XD layer: 'avatar' (shape)
        Positioned(
            left: 0,
            top: 0,
            child: StreamBuilder<UserModel>(
                stream:
                    firebaseDbService.getUserInfoInfoStream(uid: otherUserId),
                initialData: null,
                builder: (context, snapshot) {
                  return snapshot.data == null
                      ?Container(
                    height: 32,
                    width: 32,
                    padding: EdgeInsets.only(bottom: 6, right: 6),
                    alignment: Alignment.centerLeft,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: Image.asset(
                        'assets/images/profile.png',
                        height: 32,
                        width: 32,
                        fit: BoxFit.fill,
                      ),
                    ),
                  )
                      : Container(
                          height: 32,
                          width: 32,
                          padding: EdgeInsets.only(bottom: 6, right: 6),
                          alignment: Alignment.centerLeft,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(5)),
                            child: loadNetworkUserPic(snapshot.data.profileUrl),
                          ),
                        );
                }));
  }

  otherMessageItem({BuildContext context}) {
    return // Adobe XD layer: 'message' (group)
        Align(
      alignment: Alignment.centerLeft,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 25, top: 10),
            child: messageModel.messageType=='text'?Container(
              margin: EdgeInsets.only(bottom: 8, left: 7),
              decoration: BoxDecoration(
                  color: Color(
                    0xffFCA25D,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(12.0))),
              child: Padding(
                padding:
                    EdgeInsets.only(right: 25, top: 25, bottom: 12, left: 12),
                child: Text(
                  messageModel.message,
                  style: TextStyle(
                    fontFamily: AppConstants.Poppins_Font,
                    fontSize: 14,
                    color: const Color(0xffffffff),
                    height: 1.4285714285714286,
                  ),
                  textAlign: TextAlign.left,
                ),
              ),
            ):Container(
              child: FlatButton(

                child: Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        valueColor:
                        AlwaysStoppedAnimation<Color>(ColorResources.app_primary_color),
                      ),
                      width: 200.0,
                      height: 200.0,
                      padding: EdgeInsets.all(70.0),
                      decoration: BoxDecoration(
                        color: greyColor2,
                        borderRadius: BorderRadius.all(
                          Radius.circular(8.0),
                        ),
                      ),
                    ),
                    errorWidget: (context, url, error) => Material(
                      child: Image.asset(
                        'images/img_not_available.jpeg',
                        width: 200.0,
                        height: 200.0,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.all(
                        Radius.circular(8.0),
                      ),
                      clipBehavior: Clip.hardEdge,
                    ),
                    imageUrl: messageModel.fileUrl,
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  clipBehavior: Clip.hardEdge,
                ),
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => FullPhoto(
                              url: messageModel.fileUrl)));
                },
                padding: EdgeInsets.all(0),
              ),
              margin: EdgeInsets.only(
                  bottom:  10.0,
                  left: 10.0),
            ),
          ),
          userImg(),
        ],
      ),
    );
  }
}
