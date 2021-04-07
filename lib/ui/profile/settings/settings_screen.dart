import 'package:app/alerts/edit_trip_detail.dart';
import 'package:app/alerts/logout_alert.dart';
import 'package:app/alerts/trip_confirmed_dialog.dart';
import 'package:app/common_widget/custom_button.dart';
import 'package:app/models/login_repo.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/ui/auth/login_screen.dart';
import 'package:app/ui/profile/settings/report_view_screen.dart';
import 'package:app/ui/profile/settings/web_view_screen.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:app/utils/ease_in_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:app/utils/app_constants.dart';

class SettingsScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SettingScreenState();
  }
}

class _SettingScreenState extends State<SettingsScreen> {
  List<SettingItem> _list;

  @override
  void initState() {
    _list = [];
    _list.add(SettingItem(
      text: 'Report a problem',
      iconPath: 'assets/images/report.svg',
    ));
    _list.add(SettingItem(
      text: 'Privacy Policy',
      iconPath: 'assets/images/privacy.svg',
    ));
    _list.add(SettingItem(
      text: 'Terms of service',
      iconPath: 'assets/images/terms_of_service.svg',
    ));
    _list.add(SettingItem(
      text: 'Logout',
      iconPath: 'assets/images/logout.svg',
    ));
    super.initState();
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
          SizedBox(
            height: 18.0,
          ),
          settinsTitle(),
          SizedBox(
            height: 12.5,
          ),
          Expanded(
            child: ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: _list.length,
                itemBuilder: (BuildContext context, int position) {
                  return Material(
                    type: MaterialType.transparency,
                    child: InkWell(
                        onTap: () {
                          if (position == 0) {
                            Utils.nextScreen(ReportAProblem(), context);
                          } else if (position == 1) {
                            Utils.nextScreen(
                                WebViewProblem(text: 'Privacy Policy'),
                                context);
                          } else if (position == 2) {
                            Utils.nextScreen(
                                WebViewProblem(text: 'Terms of service'),
                                context);
                          } else {
                            showDialog(
                                context: context,
                                barrierDismissible: true,
                                builder: (context) {
                                  return LogoutDialogAlert(
                                    confirmClick: () {
                                      UserRepo.getInstance().clearCurrentUser();
                                      LoginRepo.getInstance().signOut();
                                      Utils.finishAll(
                                        LoginScreen(),
                                        context,
                                      );
                                    },
                                  );
                                });
                          }
                        },
                        child: SettingItem(
                          iconPath: _list[position].iconPath,
                          text: _list[position].text,
                        )),
                  );
                }),
          )
        ],
      ),
    );
  }

  settinsTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Settings',
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

class SettingItem extends StatelessWidget {
  var iconPath;
  var text;

  SettingItem({this.text, this.iconPath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 14, bottom: 6.5, left: 24, right: 24),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 6.5),
            child: SvgPicture.asset(iconPath),
          ),
          SizedBox(
            width: 11.5,
          ),
          // Adobe XD layer: 'Label' (text)
          settingtitleText(text),
          Expanded(
            child: Align(
              child: forwardIcon(),
              alignment: Alignment.centerRight,
            ),
          )
        ],
      ),
    );
  }

  settingtitleText(String text) {
    return Text('$text',
        textAlign: TextAlign.left,
        style: TextStyle(
          fontFamily: AppConstants.Poppins_Font,
          fontSize: 15,
          color: const Color(0xff000000),
          letterSpacing: -0.21176469326019287,
          height: 1.4666666666666666,
        ));
  }

  forwardIcon() {
    return // Adobe XD layer: 'ic_next_screen' (group)
        SvgPicture.string(
      '<svg viewBox="0.0 0.0 8.1 13.7" ><path  d="M 5.513439655303955 6.82611083984375 L 0 1.312723755836487 L 1.312723755836487 0 L 8.141785621643066 6.82611083984375 L 1.312723755836487 13.6523265838623 L 0 12.33960342407227 L 5.513439655303955 6.82611083984375 L 5.513439655303955 6.82611083984375 Z" fill="#c7c7cc" stroke="none" stroke-width="1" stroke-miterlimit="10" stroke-linecap="butt" /></svg>',
      allowDrawingOutsideViewBox: true,
      fit: BoxFit.fill,
    );
  }
}
