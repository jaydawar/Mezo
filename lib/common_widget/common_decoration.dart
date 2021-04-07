import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BoxDecoration bottomCardDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.only(
      topLeft: Radius.circular(20.0),
      topRight: Radius.circular(20.0),
    ),
    color: const Color(0xfff5f7f9),
    boxShadow: [
      BoxShadow(
        color: const Color(0x0d000000),
        offset: Offset(0, -5),
        blurRadius: 20,
      ),
    ],
  );
}

BoxDecoration textFieldDecoration() {
  return BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.all(Radius.circular(8.0)),
    border: Border.all(color: Color(0xff4A4D54).withOpacity(0.2), width: 1),
  );
}
