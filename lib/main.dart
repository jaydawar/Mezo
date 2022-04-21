import 'package:app/push_notifications/push_notifications_handler.dart';
import 'package:app/ui/intro/splash_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'models/allusers_repo.dart';

void main() async {
  await WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}
class _MyAppState extends State<MyApp> {

  @override
  void dispose() {
    AllUserRepo.getInstance().dismiss();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.orange,
        cursorColor: Colors.black54,
        fontFamily: AppConstants.Poppins_Font,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: SplashScreen(),
//AuthObserver(),
      navigatorObservers: [PushNotificationsHandler()],
    );
  }
}
