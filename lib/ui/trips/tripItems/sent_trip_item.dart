import 'package:app/common_widget/common_other_user_item.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:app/utils/app_constants.dart';
class SentTripItem extends StatelessWidget {
  SentTripItem({this.position,this.tripModelData,this.firebaseDbService});
  TripModelData tripModelData;
  int position;
  FirebaseDbService firebaseDbService;
  @override
  Widget build(BuildContext context) {
    return tripModelData==null?emptyState(context):tripModelData.isEmpty!=null&&tripModelData.isEmpty?noItemState(context,text: 'No Sent Trip'):Container(
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
        padding: EdgeInsets.only(top: 14, left: 15, bottom: 13),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
        Expanded(
        child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[

                  tripPartyNameTitle(
                      title: 'Trip Name:\t',
                      subTitle: tripModelData.tripTitle,
                      paddingTop: 10.0),
                  tripSubMainTitle(
                      title: 'Date:',
                      subTitle: Utils.getDateFrom(tripModelData.tripDate),
                      paddingTop: 2.0),
                  tripSubMainTitle(
                      title: 'Time:', subTitle:Utils.getTimeFrom(tripModelData.tripDate), paddingTop: 2.0),
                  tripSubMainTitle(
                      title: 'Location:', subTitle: tripModelData.address, paddingTop: 2.0),
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

  tripMainTitle() {
    return Padding(
      padding: EdgeInsets.only(

          left: 10
      ),
      child: Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Fredrick Runderson',
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
            text: title==null?"":'$title',
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