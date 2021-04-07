import 'dart:convert';
import 'dart:developer';
import 'dart:ffi';
import 'dart:io';
import 'package:app/bottomsheet/file_picker_bottomsheet.dart';
import 'package:app/common_widget/custom_button.dart';
import 'package:app/common_widget/custom_progress_indicator.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/helper/AppConstantHelper.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/ui/chat/chatdetail/chat_tet_field.dart';
import 'package:app/ui/chat/model/chat_message_model.dart';
import 'package:app/ui/chat/user_chat_list_screen.dart';
import 'package:app/ui/chatModule/const.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:app/utils/serialization_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'chat_message_screen_search.dart';
import 'chatdetail/chat_my_message_item.dart';
import 'chatdetail/chat_otheruser_message_item.dart';
import 'chatdetail/date_header.dart';

class ChatMessageScreen extends StatefulWidget {
  String otherUserId;
  String myUserId;
  String otherUserName;
  String otherUserProfilePic;
  ChatMessageModel previoischatMessageModel;

  ChatMessageScreen({
    @required this.otherUserId,
    @required this.myUserId,
    @required this.otherUserName,
    @required this.otherUserProfilePic,
    this.previoischatMessageModel,
  });

  @override
  State<StatefulWidget> createState() {
    return _ChatMessageState();
  }
}

class _ChatMessageState extends State<ChatMessageScreen> {
  int _limit = 20;
  final int _limitIncrement = 20;
  SharedPreferences prefs;
  File imageFile;
  bool isLoading = false;
  bool onCreate = true;
  String _uploadedFileURL;
  String senderName = "";
  String filePath;
  String message = "";
  FirebaseDbService firebaseFbservice = FirebaseDbService();
  final TextEditingController textEditingController = TextEditingController();
  final GroupedItemScrollController listScrollController =
      GroupedItemScrollController();
  final GroupedItemScrollController searchlistScrollController =
      GroupedItemScrollController();
  final FocusNode focusNode = FocusNode();
  AppConstantHelper appConstantHelper = AppConstantHelper();
  final _searchTextController = TextEditingController();
  bool isSearchInitialted = false;
  List<ChatMessageModel> searchedchatList = [];
  List<ChatMessageModel> mchatList;
  bool isSearching = false;

  void pickFileandUploadToServer() {
    filePickerBottomSheet(context, appConstantHelper, (filePicked) {
      filePath = filePicked.path;
      print("filePath$filePath");
      isLoading = true;
      setState(() {});
      firebaseFbservice.uploadFile(
          bucketName: AppConstants.CHAT_IMAGE_FOLDER,
          filePath: filePath,
          fileUploaded: (fileUploadedUrl) {
            setState(() {
              isLoading = false;
              _uploadedFileURL = fileUploadedUrl;
              print("_uploadedFileURL$_uploadedFileURL");
            });
            sendMessageToUser(type: 'image');
          },
          callBackCode: (callBackCode) {
            setState(() {
              isLoading = false;
            });
          });
    });
  }

  @override
  void initState() {
    _initialize();

    super.initState();
  }

  @override
  void dispose() {
    firestore
        .collection(FirestorePaths.USERS_COLLECTION)
        .doc(currentUserIdValue)
        .update({'chatOnline': false});
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.app_screen_bgColor,
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(
                height: 56.0,
              ),
              Visibility(
                visible: isSearchInitialted ? false : true,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    backButton(context),
                    IconButton(
                      onPressed: () {
                        _onSearchTab();
                      },
                      iconSize: 25,
                      icon: SvgPicture.asset('assets/images/search.svg'),
                    ),
                  ],
                ),
              ),
              Visibility(visible: isSearchInitialted, child: _searchBar()),
              userName(),
              Expanded(
                child: chatmessageListStream(),
              ),
              Container(
                height: 93,
                child: Align(
                    alignment: Alignment.bottomCenter,
                    child: ChatTextField(
                      textEditingController: textEditingController,
                      onTextChange: (msg) {
                        message = msg;
                      },
                      plusClickCallback: () {
                        print("messageTyped$message");
                        if (message != '') {
                          sendMessageToUser(type: 'text');
                        } else {
                          pickFileandUploadToServer();
                        }
                      },
                    )),
              )
            ],
          ),
          Align(
            child: CommmonProgressIndicator(isLoading),
            alignment: Alignment.center,
          )
        ],
      ),
    );
  }

  chatmessageListStream() {
    return StreamBuilder<List<ChatMessageModel>>(
      stream: listenChat(currentUser),
      initialData: null,
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data == null) {
          return Center(
              child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(themeColor)));
        } else {
          return isSearching
              ? Center(
                  child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(themeColor)))
              : isSearchInitialted && !isSearching
                  ? searchedstickyChatListView()
                  : stickyChatListView(chatList: snapshot.data);
        }
      },
    );
  }

  stickyChatListView({List<ChatMessageModel> chatList}) {
    mchatList = [];
    mchatList.addAll(chatList);
    return chatList != null && chatList.length > 0
        ? StickyGroupedListView<ChatMessageModel, String>(
            elements: chatList,
            order: StickyGroupedListOrder.ASC,
            reverse: true,
            initialScrollIndex: 0,
            itemScrollController: listScrollController,
            groupBy: (ChatMessageModel element) =>
                Utils.getDateFrom(element.createdAt),
            groupComparator: (String value1, String value2) =>
                value2.compareTo(value1),
            itemComparator:
                (ChatMessageModel element1, ChatMessageModel element2) =>
                    Utils.getDateFrom(element1.createdAt)
                        .compareTo(Utils.getDateFrom(element1.createdAt)),
            floatingHeader: false,
            padding: EdgeInsets.only(bottom: 12),
            indexedItemBuilder: (BuildContext context,
                ChatMessageModel chatMessageModel, int position) {
              return widget.otherUserId == chatMessageModel.fromId
                  ? ChatMessageOtherUser(
                      position: position,
                      messageModel: chatMessageModel,
                      otherUserId: widget.otherUserId,
                      isLast: chatList.length - 1 == position ? true : false,
                      firebaseDbService: firebaseFbservice,
                    )
                  : ChatMyMessageItem(
                      position: position,
                      isLast: chatList.length - 1 == position ? true : false,
                      messageModel: chatMessageModel,
                    );
            },
            groupSeparatorBuilder: (ChatMessageModel element) => Container(
              height: 50,
              color: ColorResources.app_screen_bgColor,
              child: Align(
                alignment: Alignment.center,
                child: DateHeader(
                  date: Utils.getDateFrom(element.createdAt) ==
                          Utils.getDateFrom(Utils.getCuurentTimeinMillies())
                      ? 'Today'
                      : Utils.getDateFrom(element.createdAt),
                ),
              ),
            ),
          )
        : Container();
  }

  searchedstickyChatListView() {
    return isSearching == false &&
            isSearchInitialted &&
            searchedchatList != null &&
            searchedchatList.length > 0
        ? StickyGroupedListView<ChatMessageModel, String>(
            elements: searchedchatList,
            order: StickyGroupedListOrder.ASC,
            reverse: true,
            initialScrollIndex: 0,
            itemScrollController: searchlistScrollController,
            groupBy: (ChatMessageModel element) =>
                Utils.getDateFrom(element.createdAt),
            groupComparator: (String value1, String value2) =>
                value2.compareTo(value1),
            itemComparator:
                (ChatMessageModel element1, ChatMessageModel element2) =>
                    Utils.getDateFrom(element1.createdAt)
                        .compareTo(Utils.getDateFrom(element1.createdAt)),
            floatingHeader: false,
            padding: EdgeInsets.only(bottom: 12),
            indexedItemBuilder: (BuildContext context,
                ChatMessageModel chatMessageModel, int position) {
              return widget.otherUserId == chatMessageModel.fromId
                  ? ChatMessageOtherUser(
                      position: position,
                      messageModel: chatMessageModel,
                      otherUserId: widget.otherUserId,
                      isLast: searchedchatList.length - 1 == position
                          ? true
                          : false,
                      firebaseDbService: firebaseFbservice,
                    )
                  : ChatMyMessageItem(
                      position: position,
                      isLast: searchedchatList.length - 1 == position
                          ? true
                          : false,
                      messageModel: chatMessageModel,
                    );
            },
            groupSeparatorBuilder: (ChatMessageModel element) => Container(
              height: 50,
              color: ColorResources.app_screen_bgColor,
              child: Align(
                alignment: Alignment.center,
                child: DateHeader(
                  date: Utils.getDateFrom(element.createdAt) ==
                          Utils.getDateFrom(Utils.getCuurentTimeinMillies())
                      ? 'Today'
                      : Utils.getDateFrom(element.createdAt),
                ),
              ),
            ),
          )
        : Container();
  }

  userName() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, bottom: 14, top: 21),
      child: StreamBuilder<UserModel>(
          stream:
              firebaseFbservice.getUserInfoInfoStream(uid: widget.otherUserId),
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.data != null) {
              otherUser = snapshot.data;
              if (otherUser.chatOnline != null)
                checkOtheruserOnline = otherUser.chatOnline;
              print("checkOtheruserOnline$checkOtheruserOnline");
            }
            return Text(
              snapshot.data != null ? '${snapshot.data.fullName}' : "Loading..",
              style: TextStyle(
                fontFamily: AppConstants.Poppins_Font,
                fontSize: 25,
                color: const Color(0xff454f63),
                fontWeight: FontWeight.w600,
                height: 1.76,
              ),
              textAlign: TextAlign.left,
            );
          }),
    );
  }

  UserModel currentUser;
  UserModel otherUser;
  var checkOtheruserOnline = false;

  void _initialize() async {
    currentUser = await UserRepo.getInstance().getCurrentUser();
    isLoading = false;
    appConstantHelper.setContext(context);
    senderName = currentUser.fullName;
    print('senderName${senderName}');
    print('otherUserName${widget.otherUserName}');
    widget.previoischatMessageModel.status = "read";
    await updateRecentChat();
  }

  void sendMessageToUser({String type}) {
    message = textEditingController.text;
    if (message.trim() != '' && type == 'text') {
      var chatMessage = ChatMessageModel(
          fileUrl: _uploadedFileURL,
          fromId: currentUserIdValue,
          fromUserName: senderName,
          toID: widget.otherUserId,
          message: textEditingController.text,
          messageType: type,
          status: checkOtheruserOnline ? "read" : "unread",
          toUserName: widget.otherUserName);

      sendMessage(chatMessage);

      textEditingController.clear();
      listScrollController.scrollTo(
          index: 0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut);
    } else if (type == 'image') {
      var chatMessage = ChatMessageModel(
          fileUrl: _uploadedFileURL,
          fromId: currentUserIdValue,
          fromUserName: senderName,
          toID: widget.otherUserId,
          message: 'image file',
          messageType: type,
          status: checkOtheruserOnline ? "read" : "unread",
          toUserName: widget.otherUserName);
      // firebaseFbservice.sendNewMessage(
      //     chatRoomId,chatMessage
      //     );
      sendMessage(chatMessage);
      _uploadedFileURL = "";
      filePath = "";
      textEditingController.clear();
      listScrollController.scrollTo(
          index: 0,
          duration: Duration(milliseconds: 300),
          curve: Curves.easeOut);
    } else {
      Fluttertoast.showToast(
          msg: 'Nothing to send',
          backgroundColor: Colors.black,
          textColor: Colors.red);
    }
  }

  static String getUniqueId(String i1, String i2) {
    print("i1${i1}");
    print("i2${i2}");
    if (i1.compareTo(i2) <= -1) {
      return i1 + i2;
    } else {
      return i2 + i1;
    }
  }

  FirebaseFirestore firestore;

  Stream<List<ChatMessageModel>> listenChat(UserModel from) async* {
    firestore = FirebaseFirestore.instance;
    await for (QuerySnapshot snap in firestore
        .collection("messages")
        .where("chatRoomId",
            isEqualTo: getUniqueId(
              currentUserIdValue,
              widget.otherUserId,
            ))
        .snapshots()) {
      try {
        log("snap.docs${snap.docs}");
        List<ChatMessageModel> chats =
            Deserializer.deserializeChatMessages(snap.docs);

        if (chats != null) {
          chats.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          log("chatsMessage${jsonEncode(chats)}");

          yield chats;
        }
      } catch (e) {
        print(e);
      }
    }
  }

  Future<bool> sendMessage(ChatMessageModel chatMessageModel) async {
    try {
      FirebaseFirestore fireStore = FirebaseFirestore.instance;
      String id = getUniqueId(chatMessageModel.fromId, chatMessageModel.toID);
      print("CHATROOMID $id");
      var timeInMillies = DateTime.now().millisecondsSinceEpoch;
      chatMessageModel.chatRoomId = id;
      fireStore.collection(MESSAGES).add({
        'fromId': chatMessageModel.fromId,
        'toID': chatMessageModel.toID,
        'message': chatMessageModel.message,
        'createdAt': timeInMillies,
        "chatRoomId": id,
        'status': chatMessageModel.status,
        'fromUserName': chatMessageModel.fromUserName,
        'fileUrl': chatMessageModel.fileUrl,
        'toUserName': chatMessageModel.toUserName,
        'messageType': chatMessageModel.messageType,
        'messageUid': timeInMillies,
      });
      await saveRecentChat(chatMessageModel);
      if (!checkOtheruserOnline) {
        firebaseFbservice.sendChatNotification(
          senderUid: widget.myUserId,
          receiverUid: widget.otherUserId,
          id: chatMessageModel.chatRoomId,
          type: 'chat',
          title: 'New Message receive from ${currentUser.fullName}',
          onApiCallDone: () {},
          msg: "${chatMessageModel.message}",
          receiver: otherUser.deviceToken,
        );
      }
      return true;
    } catch (e) {
      print("Exception $e");
      return false;
    }
  }

  Future updateRecentChat() async {
    List<String> ids = [currentUserIdValue, widget.otherUserId];

    for (String id in ids) {
      FirebaseFirestore fireStore = FirebaseFirestore.instance;
      fireStore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(currentUserIdValue)
          .update({'chatOnline': true});
      fireStore
          .collection(FirestorePaths.USERS_COLLECTION)
          .doc(widget.otherUserId)
          .snapshots()
          .listen((event) {
        if (event.get('chatOnline') != null) {
          checkOtheruserOnline = event.get('chatOnline');
        }
      });

      Query query = fireStore
          .collection(RECENT)
          .doc(id)
          .collection("history")
          .where("chatRoomId",
              isEqualTo: getUniqueId(currentUserIdValue, widget.otherUserId));
      QuerySnapshot documents = await query.get();

      if (documents.docs.length != 0) {
        DocumentSnapshot documentSnapshot = documents.docs[0];
        documentSnapshot.reference.update({'status': 'read'});
      }
    }
  }

  Future saveRecentChat(ChatMessageModel chat) async {
    List<String> ids = [chat.fromId, chat.toID];
    for (String id in ids) {
      FirebaseFirestore fireStore = FirebaseFirestore.instance;
      Query query = fireStore
          .collection(RECENT)
          .doc(id)
          .collection("history")
          .where("chatRoomId",
              isEqualTo: getUniqueId(chat.fromId, widget.otherUserId));
      QuerySnapshot documents = await query.get();
      if (documents.docs.length != 0) {
        DocumentSnapshot documentSnapshot = documents.docs[0];
        documentSnapshot.reference.set(chat.map);
      } else {
        fireStore
            .collection(RECENT)
            .doc(id)
            .collection("history")
            .add(chat.map);
      }
    }
  }

  Widget _searchBar() {
    return Row(
      children: [
        Container(
          height: 45,
          width: MediaQuery.of(context).size.width * 0.75,
          margin: EdgeInsets.only(left: 24, right: 12, top: 10),
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
              //searchedchatList = [];
              // searchedchatList.addAll(mchatList);
              onSearchSubmitClick();
            },
            onChanged: (value) {},
            decoration: InputDecoration(
              contentPadding: EdgeInsets.only(left: 14, top: 4, bottom: 6),
              border: InputBorder.none,
              hintText: "Search",
            ),
          ),
        ),
        InkWell(
          onTap: () {
            onseachCancelClick();
          },
          child: Text(
            "Cancel",
            textAlign: TextAlign.center,
          ),
        )
      ],
    );
  }

  void _onSearchTab() {
    // setState(() {
    //   _searchTextController.clear();
    //   searchedchatList = [];
    //   isSearching = false;
    //   searchedchatList.addAll(mchatList);
    //   isSearchInitialted = !isSearchInitialted;
    //   print("searchedchatList${searchedchatList.length}");
    //   print("isSearchInitialted${isSearchInitialted}");
    // });

    // otherUserId;
    // String myUserId;
    // String otherUserName;
    // String otherUserProfilePic;
    // ChatMessageModel previoischatMessageModel
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ChatMessageScreenSearch(
                  otherUserId: widget.otherUserId,
                  myUserId: widget.myUserId,
                  otherUserName: widget.otherUserName,
                  previoischatMessageModel: widget.previoischatMessageModel,
                )));
  }

  void onseachCancelClick() {
    _searchTextController.clear();
    searchedchatList = [];
    isSearching = false;
    isSearchInitialted = false;
    searchedchatList.addAll(mchatList);
    listenChat(currentUser);

    print("searchedchatList${searchedchatList.length}");
    setState(() {});
  }

  void onSearchSubmitClick() {
    isSearching = true;
    var count = 0;
    setState(() {});
    if (_searchTextController.text.length > 0) {
      searchedchatList = [];
      mchatList.forEach((element) {
        count = count + 1;
        if (element.message
            .trim()
            .toLowerCase()
            .contains(_searchTextController.text.trim().toLowerCase())) {
          searchedchatList.add(element);

          print("searchedchatList${searchedchatList.length}");
        }
      });

      if (count == mchatList.length) {
        isSearching = false;

        setState(() {});
      }
    } else {
      // searchedchatList=mchatList;
    }
    setState(() {});
  }
}
