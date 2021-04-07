import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:app/alerts/trip_confirmed_dialog.dart';
import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/models/allusers_repo.dart';
import 'package:app/models/trip_repo.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/ui/addtrip/select_attendees.dart';
import 'package:app/ui/addtrip/select_location.dart';

import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/app_constants.dart';
import 'package:app/utils/app_utils.dart';
import 'package:app/utils/color_resources.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bloc/add_trip_bloc.dart';

class AddTripScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _AddTripState();
  }
}

class _AddTripState extends State<AddTripScreen> {
  AddTripBloc _addTripBloc = AddTripBloc();
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  var isOpen = false;
  var selectedLocation = "Location";
  final Set<Marker> _markers = {};
  List<UserModel> selectedAttendeeList = [];
  LatLng _lastMapPosition = _center;
  TripModelData addTripData;
  SharedPreferences pref;
  FirebaseDbService firebaseDbService = FirebaseDbService();
  String tripDate;
  String tripTime;
  final TextEditingController tripTitleController = TextEditingController();
  String transport = 'Transportation';

  var currentUserId = "";
  Stream<List<UserModel>> attentdeelistStream;

  UserModel currentUser;
  StreamSubscription<List<UserModel>> chatUserSubscription;

  @override
  void initState() {
    _initialize();
    super.initState();
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }

  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        markerId: MarkerId(_lastMapPosition.toString()),
        position: _lastMapPosition,
        infoWindow: InfoWindow(
          title: 'Really cool place',
          snippet: '5 Star Rating',
        ),
        icon: BitmapDescriptor.defaultMarker,
      ));
    });
  }

  void _onCameraMove(CameraPosition position) {
    _lastMapPosition = position.target;
  }

  String _date = "Not set";
  String _time = "Not set";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          GoogleMap(
            onMapCreated: _onMapCreated,
            initialCameraPosition: CameraPosition(
              target: _center,
              zoom: 11.0,
            ),
            mapType: MapType.normal,
            markers: _markers,
            onCameraMove: _onCameraMove,
          ),
          // Adobe XD layer: 'bg' (shape)
          Positioned(
            left: 16,
            right: 16,
            top: 40,
            child: Container(
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
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 50,
                    child: TextField(
                      maxLines: 1,
                      minLines: 1,
                      controller: tripTitleController,
                      onTap: () {
                        isOpen = !isOpen;
                        setState(() {});
                      },
                      style: TextStyle(
                        fontFamily: AppConstants.Poppins_Font,
                        fontSize: 15,
                        color: const Color(0xff455b63),
                      ),
                      cursorColor: Color(0xff455b63),
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Create by clicking',
                          contentPadding: EdgeInsets.only(left: 64)),
                    ),
                  ),
                  isOpen
                      ? InkWell(
                          onTap: () async {
                            var processedListOfUsers2 = await Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (BuildContext context) =>
                                        SelectAttendees(
                                          selectedAttendeeList,
                                          processedListOfUsers:
                                              processedListOfUsers,
                                        )));
                            log("selectedAttendeeList${selectedAttendeeList.length}");
                            selectedAttendeeList = [];
                            processedListOfUsers.forEach((element) {
                              if (element != null && element.isSelected) {
                                selectedAttendeeList.add(element);
                              }
                            });
                            _addTripBloc.updateSelectedAttendeeList(
                                selectedAttendeeList);
                          },
                          child: typeFieldWidget(),
                        )
                      : Container(),
                  InkWell(
                      onTap: () {
                        DatePicker.showDateTimePicker(context,
                            showTitleActions: true,
                            onChanged: (dateselected) {
                              onDateSelected(dateselected);
                            },
                            theme: DatePickerTheme(
                                containerHeight: 200.0,
                                itemHeight: 50,
                                cancelStyle: TextStyle(
                                  fontFamily: AppConstants.Poppins_Font,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey,
                                ),
                                doneStyle: TextStyle(
                                  fontFamily: AppConstants.Poppins_Font,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w600,
                                  color: ColorResources.app_primary_color,
                                )),
                            minTime: DateTime.now(),
                            maxTime: DateTime(2025, 12, 31),
                            onConfirm: (
                              dateselected,
                            ) {
                              onDateSelected(dateselected);
                            },
                            currentTime: DateTime.now().add(Duration(hours: 1)),
                            locale: LocaleType.en);
                      },
                      child: StreamBuilder<String>(
                        initialData: "Date",
                        stream: _addTripBloc.tripDateStream,
                        builder: (context, dateSnapshot) {
                          return itemMenu(
                              'assets/images/date.svg',
                              dateSnapshot.data != null
                                  ? dateSnapshot.data
                                  : "Date");
                        },
                      )),

                  InkWell(
                    onTap: () async {
                      selectedLocation = await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (BuildContext context) => SelectLocation(
                                    selectedLocation: selectedLocation,
                                  )));
                      setState(() {});
                    },
                    child: itemMenu(
                        'assets/images/location_map.svg', selectedLocation),
                  ),
                  InkWell(
                    onTap: () async {
                      showModalBottomSheet(
                          context: context,
                          backgroundColor: Colors.transparent,
                          builder: (BuildContext bc) {
                            return Container(
                              height: 260,
                              decoration: BoxDecoration(
                                color: ColorResources.app_primary_color,
                                borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(8.0),
                                  topRight: Radius.circular(8.0),
                                ),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  reideSharingText(),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 24, top: 24, bottom: 24),
                                    child: Row(
                                      children: [
                                        transporaationType('Uber'),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        transporaationType2(
                                          'Lyft',
                                        ),
                                      ],
                                    ),
                                  ),
                                  Center(
                                    child: StreamBuilder<bool>(
                                        stream: isUberSelectedStream,
                                        initialData: true,
                                        builder: (context, snapshot) {
                                          return RaisedButton(
                                            padding: EdgeInsets.zero,
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(12.0),
                                              ),
                                            ),
                                            onPressed: () {
                                              // if (snapshot.data) {
                                              //   Utils.openUberApp(MethodChannel(
                                              //       'mezo.app.open'));
                                              // } else {
                                              //   Utils.openLyftApp(MethodChannel(
                                              //       'mezo.app.open'));
                                              // }
                                              isLyftSelectedSink.sink
                                                  .add(false);
                                              isUberSelectedSink.sink
                                                  .add(false);
                                              setState(() {
                                                transport =
                                                    "I will drive myself";
                                              });
                                              Navigator.pop(context);
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width -
                                                  32,
                                              height: 52.0,
                                              alignment: Alignment.center,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(12.0),
                                                ),
                                                color: const Color(0xffffffff),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0x14455b63),
                                                    offset: Offset(0, 12),
                                                    blurRadius: 16,
                                                  ),
                                                ],
                                              ),
                                              child: Text(
                                                // snapshot.data
                                                //     ? 'Schedule Uber'
                                                //     : 'Schedule Lyft',
                                                'I will drive myself',
                                                style: TextStyle(
                                                  fontFamily: 'Poppins',
                                                  fontSize: 15,
                                                  color:
                                                      const Color(0xfffca25d),
                                                  fontWeight: FontWeight.w600,
                                                ),
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                          );
                                        }),
                                  )
                                ],
                              ),
                            );
                          });
                    },
                    child:
                        itemMenu('assets/images/transportation.svg', transport),
                  ),

                  /* typeFieldWidget(),*/
                  // Adobe XD layer: 'bg' (shape)
                  isOpen ? sendRequestButton() : Container(),
                ],
              ),
            ),
          ),
          Positioned(
            left: 16,
            top: 58,
            child: menuIcon(),
          )
        ],
      ),
    );
  }

  DateTime selectedDate = DateTime.now();

  TimeOfDay selectedTime = TimeOfDay(hour: 00, minute: 00);

  Widget typeFieldWidget() {
    return StreamBuilder<List<UserModel>>(
        stream: _addTripBloc.selectedAttendeeStream,
        initialData: [],
        builder: (context, attendeeSnapshot) {
          return attendeeSnapshot.data.length == 0
              ? itemMenu('assets/images/attendies.svg', 'Attendees')
              : Container(
                  height: 48,
                  padding: EdgeInsets.only(right: 22),
                  child: FormField<UserModel>(
                    builder: (FormFieldState<UserModel> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                            prefixIcon: Container(
                              height: 20,
                              padding: EdgeInsets.only(left: 16),
                              width: 18,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: SvgPicture.asset(
                                  'assets/images/attendies.svg',
                                  height: 20,
                                  width: 18,
                                ),
                              ),
                            ),
                            border: InputBorder.none,
                            fillColor: Colors.white),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<UserModel>(
                            hint: Padding(
                              padding: EdgeInsets.only(left: 16),
                              child: Text(
                                selectedAttendeeList[0].fullName,
                                style: TextStyle(
                                  fontFamily: AppConstants.Poppins_Font,
                                  fontSize: 15,
                                  color: const Color(0xff838383),
                                ),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            /* value: currentSelectedValue,*/
                            isDense: false,
                            onChanged: (newValue) {
                              setState(() {
                                // currentSelectedValue = newValue;
                              });
                              // print(currentSelectedValue);
                            },
                            items: attendeeSnapshot.data.map((UserModel value) {
                              return DropdownMenuItem<UserModel>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 40),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text("${value.fullName}"),
                                      InkWell(
                                        onTap: () {
                                          List<UserModel>
                                              newselectedAttendeeList = [];
                                          selectedAttendeeList
                                              .forEach((element) {
                                            if (element != null &&
                                                element.isSelected &&
                                                value.uid != element.uid) {
                                              newselectedAttendeeList
                                                  .add(element);
                                            }
                                          });
                                          processedListOfUsers
                                              .forEach((element) {
                                            if (element.uid == value.uid) {
                                              element.isSelected = false;
                                            }
                                          });
                                          log("newselectedAttendeeList${jsonEncode(newselectedAttendeeList)}");
                                          _addTripBloc
                                              .updateSelectedAttendeeList(
                                                  newselectedAttendeeList);
                                          selectedAttendeeList =
                                              newselectedAttendeeList;
                                          Navigator.pop(context);
                                        },
                                        child: Icon(
                                          Icons.close,
                                          size: 18,
                                          color: Colors.grey,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                );
        });
  }

  itemMenu(String img, String text) {
    return isOpen
        ? Container(
            height: 50,
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
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 16,
                ),
                SizedBox(
                    height: 20,
                    width: 18,
                    child: Center(
                        child: SvgPicture.asset(
                      img,
                      height: 20,
                      width: 18,
                    ))),
                SizedBox(
                  width: 36,
                ),
                Text(
                  '$text',
                  style: TextStyle(
                    fontFamily: AppConstants.Poppins_Font,
                    fontSize: 15,
                    color: const Color(0xff838383),
                  ),
                  textAlign: TextAlign.left,
                )
              ],
            ))
        : Container();
  }

  menuIcon() {
    return InkWell(
      onTap: () {
        isOpen = !isOpen;
        setState(() {});
      },
      child: Padding(
        padding: const EdgeInsets.only(left: 18),
        child: SvgPicture.string(
          '<svg viewBox="2.0 5.0 20.0 13.5" ><path transform="translate(2.0, 5.0)" d="M 8.749800682067871 13.5 C 8.335800170898438 13.5 8.000100135803223 13.16429996490479 8.000100135803223 12.75030040740967 C 8.000100135803223 12.33540058135986 8.335800170898438 11.99970054626465 8.749800682067871 11.99970054626465 L 19.25010108947754 11.99970054626465 C 19.66410064697266 11.99970054626465 19.99979972839355 12.33540058135986 19.99979972839355 12.75030040740967 C 19.99979972839355 13.16429996490479 19.66410064697266 13.5 19.25010108947754 13.5 L 8.749800682067871 13.5 Z M 0.7497000098228455 7.49970006942749 C 0.3357000052928925 7.49970006942749 0 7.164000034332275 0 6.75 C 0 6.335999965667725 0.3357000052928925 6.00029993057251 0.7497000098228455 6.00029993057251 L 19.25010108947754 6.00029993057251 C 19.66410064697266 6.00029993057251 19.99979972839355 6.335999965667725 19.99979972839355 6.75 C 19.99979972839355 7.164000034332275 19.66410064697266 7.49970006942749 19.25010108947754 7.49970006942749 L 0.7497000098228455 7.49970006942749 Z M 0.7497000098228455 1.500300049781799 C 0.3357000052928925 1.500300049781799 0 1.164600014686584 0 0.7497000098228455 C 0 0.3357000052928925 0.3357000052928925 0 0.7497000098228455 0 L 11.25 0 C 11.66400051116943 0 11.99970054626465 0.3357000052928925 11.99970054626465 0.7497000098228455 C 11.99970054626465 1.164600014686584 11.66400051116943 1.500300049781799 11.25 1.500300049781799 L 0.7497000098228455 1.500300049781799 Z" fill="#455b63" stroke="none" stroke-width="1" stroke-miterlimit="4" stroke-linecap="butt" /></svg>',
          allowDrawingOutsideViewBox: true,
          fit: BoxFit.fill,
        ),
      ),
    );
  }

  sendRequestButton() {
    return RaisedButton(
      padding: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(12.0),
          bottomLeft: Radius.circular(12.0),
        ),
      ),
      onPressed: () {
        if (tripTitleController.text == "") {
          Utils.showSnackBar('Please enter trip title. ', context);
          return;
        }

        if (selectedAttendeeList != null && selectedAttendeeList.length == 0) {
          Utils.showSnackBar('Please select attendee. ', context);
          return;
        }
        if (selectedDate == null ||
            selectedDate.millisecondsSinceEpoch <=
                Utils.getCuurentTimeinMillies()) {
          Utils.showSnackBar('Please select future date for trip. ', context);
          return;
        }
        if (selectedLocation == '' || selectedLocation == "Location") {
          Utils.showSnackBar('Please enter location name.', context);
          return;
        }
        if (tripTitleController.text != null &&
            tripTitleController.text != "" &&
            selectedLocation != "") {
          List<Attendee> attendeeList = [];
          selectedAttendeeList.forEach((element) {
            attendeeList.add(Attendee(
                status: false, isDecline: false, attendeeUid: element.uid));
            firebaseDbService.sendNotificationMultiple(
              type: FcmPushNotifications.TRIP_NOTIFICATION_TYPE,
              receiver: "",
              id: "new trip",
              receiverUid: element.uid,
              senderUid: currentUserIdValue,
              msg: "${currentUser.fullName}\t" +
                  FcmPushNotifications.onTripCreate +
                  "\t${tripTitleController.text}",
              title: FcmPushNotifications.newTrip,
              onApiCallDone: () {
                firebaseDbService.showProgressSink.add(false);
              },
            );
          });
          addTripData = TripModelData(
            address: selectedLocation,
            lat: 78.99,
            lng: 35.44,
            createdAt: Utils.getCuurentTimeinMillies(),
            location: "Test Location",
            createrUid: currentUser.uid,
            tripDate: selectedDate.millisecondsSinceEpoch,
            tripTitle: tripTitleController.text,
            attendeeList: attendeeList,
          );
          TripRepo.getInstance().addNewTrip(tripModelData: addTripData);
          isOpen = false;
          selectedLocation = "Location";
          tripTitleController.text = "";
          selectedAttendeeList = [];
          setState(() {});
          showDialog(
              context: context,
              barrierDismissible: true,
              barrierColor: Colors.white.withOpacity(0.7),
              builder: (context) {
                return TripConfirmedDialog();
              });
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width - 32,
        height: 52.0,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(12.0),
            bottomLeft: Radius.circular(12.0),
          ),
          color: const Color(0xfffca25d),
          boxShadow: [
            BoxShadow(
              color: const Color(0x14455b63),
              offset: Offset(0, 12),
              blurRadius: 16,
            ),
          ],
        ),
        child: Text(
          'Send Request',
          style: TextStyle(
            fontFamily: AppConstants.Poppins_Font,
            fontSize: 15,
            color: const Color(0xffffffff),
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.left,
        ),
      ),
    );
  }

  List<UserModel> processedListOfUsers = [];

  void _initialize() async {
    currentUser = await UserRepo.getInstance().getCurrentUser();
    AllUserRepo.getInstance().getChatUsers().listen((users) {
      processedListOfUsers =
          users.where((user) => user.uid != currentUser.uid).toList();
      processedListOfUsers.forEach((element) {
        element.isSelected = false;
      });
      log("processedListOfUsers${jsonEncode(users)}");
    });
  }

  void onDateSelected(DateTime dateselected) {
    print('confirmDate ${dateselected.millisecondsSinceEpoch}');
    _date =
        '${dateselected.year} - ${dateselected.month} - ${dateselected.day}';
    selectedDate = dateselected;
    // date=DateFormat('yyyy-MMMM-dd').format(selectedDate);
    tripDate = DateFormat('MMM dd, yyyy, hh:mm a').format(selectedDate);
    _addTripBloc.changeTripDate(selectedDate: tripDate);
  }

  void showTransportationSelection(BuildContext context) {}

  BehaviorSubject<bool> isUberSelectedSink = BehaviorSubject<bool>();

  Stream<bool> get isUberSelectedStream => isUberSelectedSink.stream;

  BehaviorSubject<bool> isLyftSelectedSink = BehaviorSubject<bool>();

  Stream<bool> get isLyftSelectedStream => isUberSelectedSink.stream;

  transporaationType(
    String type,
  ) {
    return InkWell(
      onTap: () {
        isLyftSelectedSink.sink.add(false);
        isUberSelectedSink.sink.add(true);
        Utils.openUberApp(MethodChannel('mezo.app.open'));
        transport = "Uber";
        Navigator.pop(context);
        setState(() {});

      },
      child: StreamBuilder<bool>(
          stream: isUberSelectedStream,
          initialData: true,
          builder: (context, isUberSelected) {
            return Container(
              height: 76,
              width: 101,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: isUberSelected.data
                      ? Colors.white
                      : ColorResources.app_primary_color,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(color: Colors.white)),
              child: transportationName(
                type,
                isUberSelected.data
                    ? ColorResources.app_primary_color
                    : Colors.white,
              ),
            );
          }),
    );
  }

  transporaationType2(
    String type,
  ) {
    return InkWell(
      onTap: () {
        isLyftSelectedSink.sink.add(true);
        isUberSelectedSink.sink.add(false);
        Navigator.pop(context);
        Utils.openLyftApp(MethodChannel('mezo.app.open'));
        transport = "Lyft";
        setState(() {});
      },
      child: StreamBuilder<bool>(
          stream: isLyftSelectedStream,
          initialData: false,
          builder: (context, isLyftSelected) {
            return Container(
              height: 76,
              width: 101,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: isLyftSelected.data
                      ? ColorResources.app_primary_color
                      : Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  border: Border.all(color: Colors.white)),
              child: transportationName(
                type,
                isLyftSelected.data
                    ? Colors.white
                    : ColorResources.app_primary_color,
              ),
            );
          }),
    );
  }

  transportationName(String name, Color textColor) {
    return Text(
      name,
      style: TextStyle(
        fontFamily: 'Poppins',
        fontSize: 16,
        color: textColor,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );
  }

  reideSharingText() {
    return Padding(
      padding: const EdgeInsets.only(left: 24, top: 20),
      child: Text(
        'Ride sharing:',
        style: TextStyle(
          fontFamily: 'Poppins',
          fontSize: 16,
          color: const Color(0xffffffff),
          fontWeight: FontWeight.w600,
        ),
        textAlign: TextAlign.left,
      ),
    );
  }
}
