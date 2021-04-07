import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/ui/listitems/home_trip_item.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/image_resource.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'custom_progress_indicator.dart';

loadTripCreaterUserData(FirebaseDbService firebaseDbService,String uid){
  return StreamBuilder<UserModel>(
      initialData: null,
      stream: firebaseDbService.getUserInfoInfoStream(uid: uid),
      builder: (context, snapshot) {
        return Padding(
          padding: EdgeInsets.only(top: 2, left: 15),
          child: snapshot.data==null?SizedBox(
              height: 30,
              width: 30,
              child: Center(child: CircularProgressIndicator())):Row(
            children: <Widget>[
              snapshot == null || snapshot.data == null
                  ? SizedBox(
                  height: 30,
                  width: 30,
                  child: Center(
                      child: Image.asset(
                        'assets/images/profile.png',
                        height: 30,
                        width: 30,
                      )))
                  : loadNetworkUserPic(
                  snapshot.data.profileUrl==null?"": snapshot.data.profileUrl),
              tripMainTitle(snapshot.data.fullName),
            ],
          ),
        );
      });
}

tripMainTitle(String name) {
  return Padding(
    padding: EdgeInsets.only(left: 10),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        name==null?"":name,
        style: TextStyle(
          fontFamily: AppConstants.Poppins_Font,
          fontSize: 18,
          color: const Color(0xff131621),
        ),
        textAlign: TextAlign.left,
      ),
    ),
  );
}
loadNetworkUserPic(String profileUrl) {
  return Container(
    height: 30,
    width: 30,
    child: ClipRRect(
      borderRadius: BorderRadius.all(Radius.circular(30.0)),
      child: CachedNetworkImage(
        imageUrl: profileUrl,
        height: 30,
        width: 30,
        fit: BoxFit.cover,
        errorWidget: (a, b, c) {
          return placeHolderImage(
              imagePath: ImageResource.dummy,
              height: 30.0,
              width: 30.0);
        },
        placeholder: (BuildContext context, String url) {
          return placeHolderImage(
              imagePath: ImageResource.placeHolderImage,
              height: 30.0,
              width: 30.0);
        },
      ),
    ),
  );
}
emptyState(BuildContext context){
  return Container(
    height: 130,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: Offset(0, 4),
              blurRadius: 16)
        ]),
    child: Center(
      child: CommmonProgressIndicator(true),
    ),
  );
}


noItemState(BuildContext context,{String text}){
  return Container(
    height: 130,
    width: MediaQuery.of(context).size.width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.08),
              offset: Offset(0, 4),
              blurRadius: 16)
        ]),
    child: Center(
      child: Text('No trips yet'),
    ),
  );
}