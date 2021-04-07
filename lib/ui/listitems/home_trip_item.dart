import 'package:app/common_widget/common_other_user_item.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeTripItem extends StatelessWidget {
  HomeTripItem({this.position, this.tripModelData, this.firebaseDbService});

  FirebaseDbService firebaseDbService;
  int position;
  TripModelData tripModelData;

  @override
  Widget build(BuildContext context) {
    if (tripModelData != null)
      firebaseDbService.getUserInfoWhere(uid: tripModelData.createrUid);
    return Container(
      margin: EdgeInsets.only(top: 20),
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
        padding: EdgeInsets.only(
          top: 14,
          left: 15,
          bottom: 13,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  StreamBuilder<UserModel>(
                      initialData: null,
                      stream: firebaseDbService.userInfoStream,
                      builder: (context, snapshot) {
                        return Padding(
                          padding: EdgeInsets.only(top: 20, left: 15),
                          child: snapshot.data == null
                              ? SizedBox(
                                  height: 30,
                                  width: 30,
                                  child:
                                      Center(child: CircularProgressIndicator()))
                              : Row(
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
                                            snapshot.data.profileUrl),
                                    tripMainTitle(snapshot.data.fullName),
                                  ],
                                ),
                        );
                      }),
                  tripPartyNameTitle(
                      title: tripModelData.tripTitle,
                      subTitle: tripModelData.tripTitle,
                      paddingTop: 10.0),
                  tripSubMainTitle(
                      title: 'Date:',
                      subTitle: Utils.getDateFrom(tripModelData.tripDate),
                      paddingTop: 2.0),
                  tripSubMainTitle(
                      title: 'Time:',
                      subTitle: Utils.getTimeFrom(tripModelData.tripDate),
                      paddingTop: 2.0),
                  tripSubMainTitle(
                      title: 'Location:',
                      subTitle: tripModelData.location,
                      paddingTop: 2.0),
                ],
              ),
            ),
            SizedBox(
              width: 12,
            ),
          ],
        ),
      ),
    );
  }

  tripMainTitle(String fullName) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          fullName == null ? "" : fullName,
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

  tripPartyNameTitle({String title, String subTitle, double paddingTop}) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        left: 15,
      ),
      child: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text: 'Trip Name:\t',
            style: TextStyle(
              fontFamily: AppConstants.Poppins_Font,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xff4a4d54),
            ),
          ),
          TextSpan(
            text: '$subTitle',
            style: TextStyle(
              fontFamily: AppConstants.Poppins_Font,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: const Color(0xff4a4d54),
            ),
          )
        ]),
      ),
    );
  }

  tripSubMainTitle({String title, String subTitle, double paddingTop}) {
    return Padding(
      padding: EdgeInsets.only(
        top: paddingTop,
        left: 15,
      ),
      child: RichText(
        text: TextSpan(children: <TextSpan>[
          TextSpan(
            text: '$title',
            style: TextStyle(
              fontFamily: AppConstants.Poppins_Font,
              fontSize: 14,
              color: const Color(0xb24a4d54),
            ),
          ),
          TextSpan(
            text: '$subTitle',
            style: TextStyle(
              fontFamily: AppConstants.Poppins_Font,
              fontSize: 14,
              color: const Color(0xff4a4d54),
            ),
          )
        ]),
      ),
    );
  }
}

placeHolderImage({String imagePath, double height, double width}) {
  return Image.asset(
    imagePath,
    height: 121,
    width: 121,
    fit: BoxFit.fill,
  );
}
