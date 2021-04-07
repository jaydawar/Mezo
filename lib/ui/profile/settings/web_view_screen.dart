import 'dart:async';
import 'dart:io';

import 'package:app/common_widget/custom_button.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app/utils/app_constants.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewProblem extends StatefulWidget {
  var text;

  WebViewProblem({this.text});
  @override
  State<StatefulWidget> createState() => _WebViewState();
}

class _WebViewState extends State<WebViewProblem> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();
  String selectedUrl = '';


  @override
  void initState() {
    super.initState();
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.app_screen_bgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 55.0,
          ),
          backButton(context),
          Padding(
            padding: const EdgeInsets.only(left: 25, top: 18),
            child: Text(
              '${widget.text}',
              style: TextStyle(
                fontFamily: AppConstants.Poppins_Font,
                fontSize: 25,
                fontWeight: FontWeight.bold,
                color: const Color(0xff131621),
              ),
              textAlign: TextAlign.left,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Expanded(
              child: WebviewScaffold(
            url: widget.text == 'Privacy Policy'
                ? 'https://www.getmezo.com/pp'
                : 'https://www.getmezo.com/tc',
            mediaPlaybackRequiresUserGesture: false,
            withZoom: true,
            withLocalStorage: true,
            hidden: true,
            initialChild: Container(
              color: ColorResources.app_screen_bgColor,
              child:  Center(
                child: Text('Loading .....',style: TextStyle(
                  fontFamily: AppConstants.Poppins_Font,
                  fontSize: 16,
                  fontWeight: FontWeight.normal,
                  color: const Color(0xff131621),
                ),),
              ),
            ),
          ))

        ],
      ),
    );
  }

  dummyTextView() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, right: 24),
      child: Text(
        "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum",
        style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: const Color(0xff131621),
            letterSpacing: 0.7,
            wordSpacing: 0.7,
            height: 1.4),
        textAlign: TextAlign.justify,
      ),
    );
  }
}
