import 'package:app/models/user_repo.dart';
import 'package:app/ui/auth/login_screen.dart';
import 'package:app/ui/intro/intro_screens.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:app/utils/image_resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_transition/page_transition.dart';

import '../dashboard/dashboard.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashState();
  }
}

class _SplashState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    if (mounted) {
      Future.delayed(Duration(seconds: 1)).then((value) {
        UserRepo.getInstance().getCurrentUser().then((value){
          if(value!=null&&value.uid!=null&&value.uid!=""){
           Utils.finishAll(DashboardPage(), context);
          }else{
            Utils.finishAll(IntroScreen(), context);
          }
        });

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.app_primary_color,
      body: Center(child:  mezzoIcon()),
    );
  }

  mezzoText() {
    return Text(
      'Mezzo',
      style: TextStyle(
          color: Colors.white,
          fontSize: 55.0,
          fontFamily: AppConstants.Poppins_Font,
          fontWeight: FontWeight.w600),
    );
  }

  mezzoIcon() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 70.0),
      child: Center(
        child: Image.asset(
          ImageResource.mezzo_splash,

        ),
      ),
    );
  }
}
