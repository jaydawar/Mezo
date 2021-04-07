import 'dart:async';

import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/ui/chat/bloc/firebase_user_list_bloc.dart';
import 'package:app/ui/chat/chat_main_list_item.dart';
import 'package:app/ui/chat/model/chat_message_model.dart';
import 'package:app/ui/chatModule/const.dart';
import 'package:app/ui/trips/trip_search_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'chat_all_user_list.dart';
import 'chat_message_screen.dart';
import 'chat_user_search.dart';

class ChatUserListScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _ChatUserListState();
  }
}

class _ChatUserListState extends State<ChatUserListScreen> {
  StreamSubscription<List<ChatMessageModel>> chatUserSubscription;
  UserModel currentUser;
  ChatMessageBloc chatMessageBloc = ChatMessageBloc();
  FirebaseDbService firebaseDbService = FirebaseDbService();
  String userID;
  SharedPreferences prefs;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    currentUser = await UserRepo.getInstance().getCurrentUser();

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.app_screen_bgColor,
      body: chatUserListScreenBody(),
    );
  }

  chatUserListScreenBody() {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 66.0,
        ),
        Align(
          alignment: Alignment.centerRight,
          child: IconButton(
            padding: EdgeInsets.only(right: 16, left: 16),
            iconSize: 30,
            onPressed: () {
              Navigator.push(
                  context,
                  CupertinoPageRoute(
                      builder: (BuildContext context) => ChatUserSearch()));
            },
            icon: SizedBox(
                height: 30,
                width: 30,
                child: Center(
                    child: SvgPicture.asset('assets/images/search.svg'))),
          ),
        ),
        SizedBox(
          height: 5.0,
        ),
        Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[messageText(), plusIcon()],
        ),
        SizedBox(
          height: 15.0,
        ),
        Expanded(
          child: StreamBuilder<List<ChatMessageModel>>(
              stream: firebaseDbService.getChats(currentUser),
              // stream: chatMessageBloc.chatUserListStream,
              initialData: [],
              builder: (context, snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)));
                } else {
                  return ListView.builder(
                      itemCount: snapshot.data.length,
                      padding: EdgeInsets.zero,
                      itemBuilder: (BuildContext context, int position) {
                        ChatMessageModel chatMessageModel =
                            snapshot.data[position];
                        return Material(
                          type: MaterialType.transparency,
                          child: InkWell(
                              onTap: () {
                                var otherUserId;
                                var otherUserName;
                                if (chatMessageModel.toID == currentUser.uid) {
                                  otherUserId = chatMessageModel.fromId;
                                  otherUserName = chatMessageModel.fromUserName;
                                } else if (chatMessageModel.fromId ==
                                    currentUser.uid) {
                                  otherUserId = chatMessageModel.toID;
                                  otherUserName = chatMessageModel.toUserName;
                                }

                                Utils.nextScreen(
                                  ChatMessageScreen(
                                    otherUserId: otherUserId,
                                    myUserId: currentUser.uid,
                                    otherUserName: otherUserName,
                                    otherUserProfilePic: '',
                                    previoischatMessageModel: chatMessageModel,
                                  ),
                                  context,
                                );
                              },
                              child: ChatListItem(
                                position: position,
                                chatMessageModel: chatMessageModel,
                                firebaseDbService: firebaseDbService,
                              )),
                        );
                      });
                }
              }),
        )
      ],
    );
  }

  messageText() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        'Messages',
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

  plusIcon() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      child: IconButton(
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ChatAllUserList()));
          },
          icon: Icon(Icons.add, color: ColorResources.app_primary_color)),
    );
  }
}

Widget searchIcon() {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 22),
    child: SvgPicture.asset('assets/images/search.svg'),
  );
}
