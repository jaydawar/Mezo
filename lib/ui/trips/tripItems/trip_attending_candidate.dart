import 'package:app/common_widget/common_other_user_item.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/utils/image_resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:app/utils/app_constants.dart';

class TripCandidateItem extends StatelessWidget {
  FirebaseDbService firebaseDbService;
  String userId;

  TripCandidateItem({this.firebaseDbService, this.userId});

  @override
  Widget build(BuildContext context) {

    return userChatItem(context);
  }

  userChatItem(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 62,
      margin: EdgeInsets.only(top: 21),
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
        padding: EdgeInsets.only(top: 15, bottom: 15, left: 12, right: 12),
        child:  StreamBuilder<UserModel>(
            stream: firebaseDbService.getUserInfoInfoStream(uid: userId),
            initialData: null,
          builder: (context, snapshot) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                snapshot.data!=null&&snapshot.data.profileUrl!=null?loadNetworkUserPic(
                    snapshot.data.profileUrl

                ):SizedBox(
                    height: 30,
                    width: 30,
                    child: Center(child: Image.asset(ImageResource.dummy))),
                SizedBox(
                  width: 15,
                ),

                Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          snapshot.data == null
                              ? CircularProgressIndicator()
                              : userName(snapshot.data.fullName),
                          address()
                        ],

                    )
              ],
            );
          }
        ),
      ),
    );
  }

  userName(String name) {
    return Text(
      name,
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 18,
        color: const Color(0xff131621),
      ),
      textAlign: TextAlign.left,
    );
  }

  address() {
    return Text(
      'address not found',
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 14.5,
        color: const Color(0xff7a8fa6),
        height: 1.8620689655172413,
      ),
      textAlign: TextAlign.left,
    );
  }
}
