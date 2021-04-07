import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/ui/addtrip/bloc/add_trip_bloc.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:app/utils/app_constants.dart';
import 'package:flutter_svg/svg.dart';

class SelectAttendees extends StatefulWidget {
  List<UserModel> selectedAttendeeList;
  List<UserModel> processedListOfUsers;

  SelectAttendees(this.selectedAttendeeList, {this.processedListOfUsers});

  @override
  State<StatefulWidget> createState() {
    return _SelectAttendeeState();
  }
}

class _SelectAttendeeState extends State<SelectAttendees> {
  Stream<List<UserModel>> attentdeelistStream;
  List<UserModel> selectedAttendee = [];
  UserModel currentUser;
  StreamSubscription<List<UserModel>> chatUserSubscription;
  AddTripBloc _addTripBloc = AddTripBloc();

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResources.app_screen_bgColor,
      body: WillPopScope(
        onWillPop: () {
          _onBackPress();
        },
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 45.0,
            ),
            toolBar(),
            SizedBox(
              height: 8.0,
            ),
            Expanded(child: _attendeeList())
          ],
        ),
      ),
    );
  }

  toolBar() {
    return Row(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1),
          child: IconButton(
            icon: SvgPicture.string(
              '<svg viewBox="183.0 53.2 16.0 13.5" ><path transform="translate(-1408.3, 70.92)" d="M 1597.54052734375 -4.398300170898438 L 1591.66162109375 -10.27815341949463 C 1591.44482421875 -10.40956783294678 1591.299926757812 -10.64773464202881 1591.299926757812 -10.91970062255859 C 1591.299926757812 -11.0578145980835 1591.337158203125 -11.18709850311279 1591.402099609375 -11.29819774627686 C 1591.435546875 -11.3597240447998 1591.478271484375 -11.41757774353027 1591.530395507812 -11.46960067749023 C 1591.55517578125 -11.49447441101074 1591.581298828125 -11.51720523834229 1591.608520507812 -11.53786087036133 L 1597.54052734375 -17.46990013122559 C 1597.833984375 -17.76239967346191 1598.308227539062 -17.76239967346191 1598.601684570312 -17.46990013122559 C 1598.894165039062 -17.17650032043457 1598.894165039062 -16.70219993591309 1598.601684570312 -16.40880012512207 L 1593.862426757812 -11.67030048370361 L 1606.550415039062 -11.67030048370361 C 1606.964477539062 -11.67030048370361 1607.300170898438 -11.3346004486084 1607.300170898438 -10.91970062255859 C 1607.300170898438 -10.50570011138916 1606.964477539062 -10.17000007629395 1606.550415039062 -10.17000007629395 L 1593.890380859375 -10.17000007629395 L 1598.601684570312 -5.459400177001953 C 1598.894165039062 -5.165999889373779 1598.894165039062 -4.691699981689453 1598.601684570312 -4.398300170898438 C 1598.454956054688 -4.252049922943115 1598.263061523438 -4.178925037384033 1598.071044921875 -4.178925037384033 C 1597.879150390625 -4.178925037384033 1597.687255859375 -4.252049922943115 1597.54052734375 -4.398300170898438 Z" fill="#454f63" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
              allowDrawingOutsideViewBox: true,
              fit: BoxFit.fill,
            ),
            iconSize: 16.0,
            onPressed: () {
              _onBackPress();
            },
          ),
        ),
        searchBar(),
        SizedBox(
          width: 16,
        ),
      ],
    );
  }

  searchBar() {
    return Container(
      height: 40,
      alignment: Alignment.centerLeft,
      width: MediaQuery.of(context).size.width - 72,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.0),
        color: const Color(0xffffffff),
        boxShadow: [
          BoxShadow(
            color: const Color(0x14455b63),
            offset: Offset(0, 12),
            blurRadius: 16,
          ),
        ],
      ),
      child: TextFormField(
        maxLines: 1,
        minLines: 1,
        onChanged: (value){
          List<UserModel> processedListOfUsers=[];
          if(value!='') {
            widget.processedListOfUsers.forEach((element) {
              if (element.fullName.toLowerCase().contains(value..toLowerCase())) {
                processedListOfUsers.add(element);
              }
            });
            _addTripBloc.updateAttendeeList(processedListOfUsers);
          }else{
            _addTripBloc.updateAttendeeList(widget.processedListOfUsers);
          }

        },
        style: TextStyle(
          fontFamily: AppConstants.Poppins_Font,
          fontSize: 15,
          color: const Color(0xff455b63),
        ),
        cursorColor: Color(0xff455b63),
        textAlign: TextAlign.start,
        textInputAction: TextInputAction.send,
        decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: InputBorder.none,
            hintText: 'Search',
            hintStyle: TextStyle(
              fontFamily: AppConstants.Poppins_Font,
              fontSize: 15,
              color: const Color(0xff455b63),
            ),
            contentPadding: EdgeInsets.only(left: 15, top: 4)),
      ),
    );
  }

  _attendeeList() {
    return StreamBuilder<List<UserModel>>(
        stream: _addTripBloc.selectAttendeeStream,
        initialData: [],
        builder: (context, selectAttendeeSnapShot) {
          return ListView.builder(
              padding: EdgeInsets.only(left: 30, right: 5),
              itemCount: selectAttendeeSnapShot.data.length,
              itemBuilder: (BuildContext context, int position) {
                return InkWell(
                  onTap: () {
                    if (selectAttendeeSnapShot.data[position].isSelected) {
                      selectAttendeeSnapShot.data[position].isSelected = false;
                      selectedAttendee
                          .remove(selectAttendeeSnapShot.data[position]);
                    } else {
                      selectAttendeeSnapShot.data[position].isSelected = true;
                      selectedAttendee
                          .add(selectAttendeeSnapShot.data[position]);
                    }

                    _addTripBloc
                        .updateAttendeeList(selectAttendeeSnapShot.data);

                    log("selectedAttendee${jsonEncode(selectedAttendee)}");
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Stack(
                      children: <Widget>[
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            attentdeeName(
                                selectAttendeeSnapShot.data[position].fullName),
                            attentdeeAddress(selectAttendeeSnapShot
                                .data[position].address
                                .toString()),
                            SizedBox(
                              height: 12,
                            ),
                            Divider(
                              height: 1,
                              color: Colors.grey,
                            )
                          ],
                        ),
                        Positioned(
                            right: 0,
                            top: 0,
                            bottom: 0,
                            child: selectAttendeeSnapShot
                                            .data[position].isSelected !=
                                        null &&
                                    selectAttendeeSnapShot
                                        .data[position].isSelected
                                ? Icon(
                                    Icons.clear,
                                    size: 19,
                                    color: Colors.grey,
                                  )
                                : Icon(
                                    Icons.radio_button_unchecked,
                                    size: 19,
                                    color: Colors.grey,
                                  )),
                      ],
                    ),
                  ),
                );
                /*AttendeeItem(position);*/
              });
        });
  }

  attentdeeName(name) {
    return Padding(
      padding: EdgeInsets.only(
        top: 12,

      ),
      child: Padding(
        padding: const EdgeInsets.only(right: 50),
        child: Text(
          name,
          style: TextStyle(
            fontFamily: 'Gibson',
            fontSize: 16,
            color: const Color(0xff454f63),
            fontWeight: FontWeight.w400,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  attentdeeAddress(location) {
    return Padding(
      padding: EdgeInsets.only(
        top: 2,
      ),
      child: Text(
        location,
        style: TextStyle(
          fontFamily: 'Gibson',
          fontSize: 12,
          color: const Color(0xff959dad),
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  void _initialize() async {
    currentUser = await UserRepo.getInstance().getCurrentUser();
    _addTripBloc.updateAttendeeList(widget.processedListOfUsers);
  }

  void _onBackPress() {
    Navigator.pop(context, widget.processedListOfUsers);
  }
}
