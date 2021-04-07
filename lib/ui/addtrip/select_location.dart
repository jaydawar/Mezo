import 'dart:async';

import 'package:app/utils/app_constants.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SelectLocation extends StatefulWidget{
  String selectedLocation="";
  SelectLocation({this.selectedLocation});
  @override
  State<StatefulWidget> createState() {

  return _SelectLocationState();
  }

}
class _SelectLocationState extends State<SelectLocation>{
  Completer<GoogleMapController> _controller = Completer();
  static const LatLng _center = const LatLng(45.521563, -122.677433);
  final Set<Marker> _markers = {};
  LatLng _lastMapPosition = _center;

  TextEditingController enterLocationCOntroller;

  @override
  void initState() {
    if(widget.selectedLocation=="Location"){
      widget.selectedLocation="";
    }
    enterLocationCOntroller=TextEditingController(text: widget.selectedLocation);
    setState(() {

    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: WillPopScope(
        onWillPop: (){
          _onBackPress();
        },
        child: Stack(children: [



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
          toolBar(),

        ],),
      ),

    );
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller.complete(controller);
  }
  void _onAddMarkerButtonPressed() {
    setState(() {
      _markers.add(Marker(
        // This marker id can be anything that uniquely identifies each marker.
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
        style: TextStyle(
          fontFamily: AppConstants.Poppins_Font,
          fontSize: 15,
          color: const Color(0xff455b63),
        ),
        cursorColor: Color(0xff455b63),
        textAlign: TextAlign.start,
         onFieldSubmitted: (value){
          _onBackPress();
         },
         controller: enterLocationCOntroller,
        onChanged: (value){widget.selectedLocation=value;},
        decoration: InputDecoration(

            border: InputBorder.none,
            hintText: 'Enter location name',
            hintStyle: TextStyle(
              fontFamily: AppConstants.Poppins_Font,
              fontSize: 15,
              color: const Color(0xff455b63),
            ),
            contentPadding: EdgeInsets.only(left: 15, bottom: 5)),
      ),
    );
  }
  toolBar() {
    return Positioned(
      left: 0,
      right: 0,
      top: 45,
      child: Row(
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
            width: 12,
          ),
        ],
      ),
    );
  }

  void _onBackPress() {
    if(widget.selectedLocation==""){
      widget.selectedLocation="Location";
    }
    Navigator.pop(context,widget.selectedLocation);
  }
}