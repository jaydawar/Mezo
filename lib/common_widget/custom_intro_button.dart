import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomIntroButton extends StatelessWidget {
  double bttonWidth;
  String text;
  Color bgColor;
  Color textColor;
  VoidCallback callback;

  CustomIntroButton(
      {this.text,
      this.bgColor,
      this.textColor,
      this.bttonWidth,
      this.callback});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          callback();
        },
        child: Container(
          width: bttonWidth,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0),
            color: bgColor,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Gibson',
              fontSize: 14,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class CustomIntroWithBorderButton extends StatelessWidget {
  double bttonWidth;
  String text;
  Color bgColor;
  Color textColor;
  VoidCallback callback;

  CustomIntroWithBorderButton(
      {this.text,
      this.bgColor,
      this.textColor,
      this.bttonWidth,
      this.callback});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          callback();
        },
        child: Container(
          width: bttonWidth,
          height: 52,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.white, width: 1),
            borderRadius: BorderRadius.circular(12.0),
            color: bgColor,
          ),
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Gibson',
              fontSize: 14,
              color: textColor,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
