import 'package:app/common_widget/common_other_user_item.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CurrentTripItem extends StatelessWidget {
  TripModelData tripModelData;

  CurrentTripItem({this.tripModelData});

  @override
  Widget build(BuildContext context) {
    return tripModelData == null
        ? emptyState(context)
        : tripModelData.isEmpty != null && tripModelData.isEmpty
            ? noItemState(context, text: 'No Current Trip')
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12.0),
                    color: const Color(0xffffffff),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.08),
                          offset: Offset(0, 4),
                          blurRadius: 16)
                    ]),
                child: Row(
                  children: <Widget>[
                    verticalDots(),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 17,
                          ),
                          tripName('Trip Name'),
                          SizedBox(
                            height: 6,
                          ),
                          tripSubName(tripModelData.tripTitle),
                          SizedBox(
                            height: 15,
                          ),
                          dividerLine(context),
                          SizedBox(
                            height: 17,
                          ),
                          tripName('Destination Location'),
                          SizedBox(
                            height: 6,
                          ),
                          tripSubName(tripModelData.address),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
  }

  verticalDots() {
    return Padding(
      padding: EdgeInsets.only(left: 20, right: 19.5),
      child: SvgPicture.asset('assets/images/dotted_left.svg'),
    );
  }

  tripName(String s) {
    return Text(
      '$s',
      style: TextStyle(
        fontFamily: 'Gibson',
        fontSize: 12,
        color: const Color(0xff959dad),
      ),
      textAlign: TextAlign.left,
    );
  }

  dividerLine(BuildContext context) {
    return Container(
      height: 1.0,
      alignment: Alignment.center,
      width: MediaQuery.of(context).size.width - 123,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(1.0),
        color: const Color(0xfdf4f4f6),
      ),
    );
  }

  tripSubName(String subTitle) {
    return Text(
      '$subTitle',
      style: TextStyle(
        fontFamily: 'Gibson',
        fontSize: 16,
        color: const Color(0xff454f63),
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.left,
    ); // Adobe XD layer: 'text' (group)
  }
}
