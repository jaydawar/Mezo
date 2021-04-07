import 'package:app/common_widget/custom_intro_button.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:app/utils/string_resource.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:rxdart/rxdart.dart';

class EditTripDetailDialog extends StatefulWidget {
  Function(int) onUpdateClick;
  VoidCallback onCancelClick;
  int previousTime;

  EditTripDetailDialog(
      {this.onUpdateClick, this.previousTime, this.onCancelClick});

  @override
  State<StatefulWidget> createState() {
    return _EditTripDialogState();
  }
}

class _EditTripDialogState extends State<EditTripDetailDialog> {
  BehaviorSubject<String> timeText = BehaviorSubject<String>();

  Stream<String> get timeTextStream => timeText.stream;
  var timeChanges ;

  @override
  void initState() {
    timeText.sink.add(Utils.getTimeFrom(widget.previousTime));
    timeChanges = widget.previousTime;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Center(
        child: Card(
          elevation: 5,
          color: ColorResources.app_primary_color,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: Wrap(
            children: <Widget>[
              editTripTitle(),
              Container(
                height: 45,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.all(Radius.circular(12.0))),
                alignment: Alignment.centerLeft,
                width: MediaQuery.of(context).size.width - 20,
                child: InkWell(
                  onTap: () {
                    DatePicker.showTime12hPicker(
                      context,
                      locale: LocaleType.en,
                      currentTime: DateTime.fromMillisecondsSinceEpoch(timeChanges),
                      onChanged: (timeChange) {
                       var  time = Utils.getTimeFrom(
                            timeChange.millisecondsSinceEpoch);
                        timeText.sink.add(time);
                        this.timeChanges=timeChange.millisecondsSinceEpoch;
                      },
                      onConfirm: (timeChange) {
                        var  time = Utils.getTimeFrom(
                            timeChange.millisecondsSinceEpoch);
                        timeText.sink.add(time);
                        this.timeChanges=timeChange.millisecondsSinceEpoch;
                      },
                      theme: DatePickerTheme(
                          containerHeight: 200.0,
                          itemHeight: 50,
                          cancelStyle: TextStyle(
                            fontFamily: AppConstants.Poppins_Font,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey,
                          ),
                          doneStyle: TextStyle(
                            fontFamily: AppConstants.Poppins_Font,
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: ColorResources.app_primary_color,
                          )),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: StreamBuilder<String>(
                        stream: timeTextStream,
                        initialData: "",
                        builder: (context, snapshot) {
                          return Text(snapshot.data,
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontFamily: AppConstants.Poppins_Font,
                                fontSize: 15,
                                color: const Color(0xffffffff),
                                fontWeight: FontWeight.w600,
                              ));
                        }),
                  ),
                ),
              ),
              cencelTrip(),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.max,
                  children: <Widget>[
                    CustomIntroWithBorderButton(
                      text: StringResource.back,
                      bttonWidth: 127,
                      textColor: Color(0xffffffff),
                      bgColor: Colors.transparent,
                      callback: () {
                        Navigator.pop(context);
                      },
                    ),

                    CustomIntroButton(
                      text: StringResource.update,
                      bttonWidth: 127,
                      bgColor: Color(0xfff5f7f9),
                      textColor: Color(0xfffca25d),
                      callback: () {
                       print("updateTripTime$timeChanges");
                        widget.onUpdateClick(timeChanges);
                        Navigator.pop(context);
                      },
                    ), // Adobe XD layer: 'bg' (shape)

                    // Adobe XD layer: 'bg' (shape)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  editTripTitle() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(top: 18, bottom: 18),
        child: Text(
          'Edit Trip ',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 22,
            color: const Color(0xffffffff),
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }

  cencelTrip() {
    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          top: 18,
        ),
        child: InkWell(
          onTap: () {
            widget.onCancelClick();
            Navigator.pop(context);
          },
          child: Text(
            'Cancel Trip ',
            style: TextStyle(
              fontFamily: AppConstants.Poppins_Font,
              fontSize: 16,
              decoration: TextDecoration.underline,
              color: const Color(0xffffffff),
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }

  bool checkValidTimeOrNot(String time) {
    if (time != null && time != "") {
    } else {
      Utils.showSnackBar("Please enter valid time.", context);
    }
  }
}
