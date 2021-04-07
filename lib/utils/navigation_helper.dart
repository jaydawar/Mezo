
import 'package:app/ui/auth/login_screen.dart';
import 'package:app/ui/chat/chat_message_screen.dart';
import 'package:app/ui/chat/user_chat_list_screen.dart';
import 'package:app/ui/chatModule/home.dart';
import 'package:app/ui/dashboard/dashboard.dart';
import 'package:flutter/material.dart';


bool Function(Route<dynamic>) _defaultRule = (_) => true;

class NavigationHelper {

  static void navigateToLogin(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => LoginScreen()));
    }
  }

  static void navigateToMain(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => DashboardPage()),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => DashboardPage()));
    }
  }

  static void navigateToAddChat(
    BuildContext context, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => ChatUserListScreen()),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ChatUserListScreen()));
    }
  }

  static void navigateToInstantMessaging(
    BuildContext context,
    String displayName,
    String chatroomId, {
    bool addToBackStack: false,
    bool Function(Route<dynamic>) removeUntil,
  }) {
    if (addToBackStack) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (context) => ChatMessageScreen(

          ),
        ),
        removeUntil ?? _defaultRule,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ChatMessageScreen(

          ),
        ),
      );
    }
  }
}
