import 'package:app/ui/chat/user_chat_list_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class TripToolBar extends StatelessWidget {
  String title;
  double padding;
  bool showSearch;
  VoidCallback onSearchClick;

  TripToolBar({this.title, this.padding, this.showSearch, this.onSearchClick});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        messageText(),
        showSearch == null
            ? InkWell(
                onTap: () {
                  onSearchClick();
                },
                child: searchIcon())
            : Container()
      ],
    );
  }

  messageText() {
    return Padding(
      padding:
          EdgeInsets.symmetric(horizontal: padding == null ? 24.0 : padding),
      child: Text(
        '$title',
        style: TextStyle(
          fontFamily: AppConstants.Poppins_Font,
          fontSize: 40,
          color: const Color(0xff2f2e41),
          fontWeight: FontWeight.w600,
          height: 1.1,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
