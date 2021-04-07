import 'package:app/common_widget/custom_button.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/ui/chat/chat_message_screen.dart';
import 'package:app/ui/chatModule/const.dart';
import 'package:app/ui/listitems/home_trip_item.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/color_resources.dart';
import 'package:app/utils/image_resource.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatAllUserList extends StatefulWidget {
  @override
  _ChatAllUserListState createState() => _ChatAllUserListState();
}

class _ChatAllUserListState extends State<ChatAllUserList> {
  List<QueryDocumentSnapshot> userlist = new List.from([]);
  UserModel currentUser;
  String userID;
  SharedPreferences prefs;
  bool isSearchActive = false;
  final _searchTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  void _initialize() async {
    currentUser = await UserRepo.getInstance().getCurrentUser();
    print("USERID ${currentUser.uid}");
    userlist = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.app_screen_bgColor,
      body: Column(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: 40.0,
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[backButton(context), _searchBar()],
          ),
          _title(),
          Expanded(
            child: StreamBuilder(
                stream: _searchTextController.text.length>0?FirebaseFirestore.instance
                    .collection(FirestorePaths.USERS_COLLECTION).where("caseSearch", arrayContains : _searchTextController.text.toLowerCase())
                    .snapshots():FirebaseFirestore.instance
                    .collection(FirestorePaths.USERS_COLLECTION)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                        child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(themeColor)));
                  } else {
                    userlist=[];
                    userlist.addAll(snapshot.data.documents);
                    userlist.removeWhere((element) =>
                        element.data()['uid'] == currentUserIdValue);
                    print("userLength${userlist.length}");
                    return ListView.builder(
                        itemCount: userlist.length,
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemBuilder: (BuildContext context, int position) {
                          UserModel userModel =
                              UserModel.fromJson(userlist[position].data());
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (BuildContext context) =>
                                          ChatMessageScreen(
                                              otherUserId: userModel.uid,
                                              myUserId: currentUserIdValue,
                                              otherUserName: userModel.fullName,
                                              otherUserProfilePic:
                                                  userModel.profileUrl)));
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width - 62,
                              margin:
                                  EdgeInsets.only(left: 24, right: 24, top: 21),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),
                                  color: const Color(0xffffffff),
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        offset: Offset(0, 4),
                                        blurRadius: 16)
                                  ]),
                              child: Padding(
                                padding: EdgeInsets.only(
                                    top: 12, bottom: 12, left: 12, right: 12),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    _profileImage(userModel.profileUrl),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    userName(userModel.fullName),
                                    chatIcon()
                                  ],
                                ),
                              ),
                            ),
                          );
                        });
                  }
                }),
          ),
        ],
      ),
    );
  }

  _title() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 0, top: 0),
      child: Text(
        'All User',
        style: TextStyle(
          fontFamily: AppConstants.Poppins_Font,
          fontSize: 25,
          color: const Color(0xff454f63),
          fontWeight: FontWeight.w600,
          height: 1.76,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  chatIcon() {
    return Expanded(
      child: Align(
          alignment: Alignment.centerRight,
          child: SvgPicture.asset('assets/images/chat_unselect.svg')),
    );
  }

  userName(username) {
    return Text(
      username,
      style: TextStyle(
        fontFamily: AppConstants.Poppins_Font,
        fontSize: 18,
        color: const Color(0xff131621),
      ),
      textAlign: TextAlign.left,
    );
  }

  _profileImage(profileUrl) {
    return SizedBox(
        height: 35,
        width: 35,
        child: Center(
            child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(35)),
          child: CachedNetworkImage(
            imageUrl: profileUrl,
            height: 35,
            width: 35,
            fit: BoxFit.cover,
            errorWidget: (a, b, c) {
              return placeHolderImage(
                  imagePath: ImageResource.profile, height: 35, width: 35);
            },
            placeholder: (BuildContext context, String url) {
              return placeHolderImage(
                  imagePath: ImageResource.placeHolderImage,
                  height: 35,
                  width: 35);
            },
          ),
        )));
  }

  _searchBar() {
    return Expanded(
      child: Container(
        height: 45,
        margin: EdgeInsets.only(left: 0, right: 26, top: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color: const Color(0xffffffff),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  offset: Offset(0, 4),
                  blurRadius: 16)
            ]),
        child: TextFormField(
          controller: _searchTextController,
          textInputAction: TextInputAction.search,
          onFieldSubmitted: (value) {

          },
          onChanged: (value){
            setState(() {

            });
          },
          decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 14, top: 8),
              border: InputBorder.none,
              hintText: "Search",
              suffixIcon: Icon(
                Icons.search,
              )),
        ),
      ),
    );
  }

  Future<void> getUsers(searchValue) {
    FirebaseFirestore.instance
        .collection(FirestorePaths.USERS_COLLECTION)
        .get()
        .then((snapshot) {
      userlist.clear();
      userlist = snapshot.docs;
    });
  }
}
