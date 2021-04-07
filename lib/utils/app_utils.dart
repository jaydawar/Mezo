import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

//import 'package:flushbar/flushbar.dart';
class Utils {
  static List<ListItem> attentdeelist = [
    ListItem('Stephan432', "Stephan Richard", false),
    ListItem('Stephan133', "Stephan Rick", false),
    ListItem('Stephan234', "Stephan Denny", false),
  ];

  static hideKeyboard(){
   // SystemChannels.textInput.invokeMethod('TextInput.hide');
  }

  //mezo.app.open
  static Future<String> openUberApp(MethodChannel platform) async {
    String shareApp;
    try {
      final String result = await platform.invokeMethod('openUber');
      shareApp = result.toString();
      // Navigator.pop(context);
    } on PlatformException catch (e) {
      shareApp = "Failed to getThubnail: '${e.message}'.";
    }
    return shareApp;
  }
  static Future<String> openLyftApp(MethodChannel platform) async {
    String shareApp;
    try {
      final String result = await platform.invokeMethod('openLyft');
      shareApp = result.toString();
      // Navigator.pop(context);
    } on PlatformException catch (e) {
      shareApp = "Failed to getThubnail: '${e.message}'.";
    }
    return shareApp;
  }
  static Future<bool> checkConnectivity() async {
    bool _isConnected = false;
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        print('connected');
        _isConnected = true;
      } else {
        _isConnected = false;
      }
    } on SocketException catch (_) {
      print('not connected');
      _isConnected = false;
    }

    return _isConnected;
  }
  static bool isFieldEmpty(String fieldValue) => fieldValue?.isEmpty ?? true;
  static int getCuurentTimeinMillies(){
    DateTime now = DateTime.now();
    int currentDate = now.millisecondsSinceEpoch;
    return currentDate;
  }

  static showToast(String message, BuildContext context) {

  }

  static showSnackBar(String message, BuildContext context) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      message: message,
      duration: Duration(seconds: 3),
    )
      ..show(context);
  }

  static showSnackBarBottom(String message, BuildContext context) {
    Scaffold.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  static bool checkNullOrEmpty(String value) {
    if (value == null || value.isEmpty) return true;
    return false;
  }

  static void nextScreen(Widget child, BuildContext context) {
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (BuildContext context) => child),
    );
  }
  static void replaceScreen(Widget child, BuildContext context) {
    Navigator.pushReplacement(
      context,
      CupertinoPageRoute(builder: (BuildContext context) => child),
    );
  }

  static void finishAll(Widget child, BuildContext context) {
    Navigator.pushAndRemoveUntil(
        context, MaterialPageRoute(builder: (BuildContext context) => child), (
        route) => false);
  }

  static String getDateFrom(int timeInMillis) {
    final dateformat = DateFormat('MMM dd, yyyy');
    var date = dateformat
        .format(DateTime.fromMillisecondsSinceEpoch(timeInMillis))
        .toString();



    return "\t$date";
  }

  static String getDateTime(int timeInMillis) {
    final dateformat = DateFormat('MMM dd - h:mm a');
    var date = dateformat
        .format(DateTime.fromMillisecondsSinceEpoch(timeInMillis))
        .toString();



    return "\t$date";
  }

  static String getTimeFrom(int timeInMillis) {
    final dateformat = DateFormat('h:mm a');
    var time = dateformat
        .format(DateTime.fromMillisecondsSinceEpoch(timeInMillis))
        .toString();

    return "\t$time";
  }



  static void removeFocusandMoveToNext(FocusNode focusNode1, FocusNode focusNode2, BuildContext context) {
    focusNode1.unfocus();
    focusNode2.requestFocus(FocusNode());

  }

  static int getTripDateFrom(String date) {
   // Nov 12, 2020 	12:37 PM
    //Nov 12, 2020	11:46 AM
    //Nov 12, 2020	12:00 PM
    try {
      final dateformat = DateFormat('MMM dd, yyyy h:mm a');
      return dateformat
          .parse(date)
          .millisecondsSinceEpoch;
    }catch(e){
      print(e);
    }
  }
}

class ListItem {
  var value;
  String name;
  bool isSelected;

  ListItem(this.value, this.name, this.isSelected);
}
