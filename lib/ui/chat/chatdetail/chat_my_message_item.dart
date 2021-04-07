import 'package:app/ui/chat/chatdetail/date_header.dart';
import 'package:app/ui/chat/model/chat_message_model.dart';
import 'package:app/ui/chatModule/const.dart';
import 'package:app/ui/chatModule/widget/full_photo.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ChatMyMessageItem extends StatelessWidget {
  int position;
  bool isLast;
  ChatMessageModel messageModel;

  ChatMyMessageItem({this.position,this.isLast, this.messageModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorResources.app_screen_bgColor,
      padding:
      EdgeInsets.only(top: 20, left: 20, bottom: isLast ? 50 : 0),
      child: myMessageItem(context: context),
    );
  }

  myMessageItem({BuildContext context}) {
    return // Adobe XD layer: 'message' (group)
        Align(
      alignment: Alignment.bottomRight,
      child: Padding(
        padding: EdgeInsets.only(right: 25),
        child: messageModel.messageType=='text'?Container(
          decoration: BoxDecoration(
              color: Color(
                0xff838383,
              ),
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          child: Padding(
            padding: EdgeInsets.only(right: 25, top: 12, bottom: 12, left: 12),
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
        ):
        Container(
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
              right: 10.0),
        ),
      ),
    );
  }
}
