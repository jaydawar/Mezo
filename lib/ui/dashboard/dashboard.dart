import 'package:app/firebaseuserauth/firebase_db_service.dart';
import 'package:app/models/user_repo.dart';
import 'package:app/ui/addtrip/add_trip_screen.dart';
import 'package:app/ui/chat/user_chat_list_screen.dart';
import 'package:app/ui/dashboard/dashboard_state.dart';
import 'package:app/ui/dashboard/widgets/fab_bottom_app_bar.dart';
import 'package:app/ui/home/home_screen.dart';
import 'package:app/ui/profile/profile_screen.dart';
import 'package:app/ui/trips/trips_screen.dart';
import 'package:app/utils/color_resources.dart';
import 'package:app/utils/image_resource.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'dashboard_bloc.dart';

class DashboardPage extends StatefulWidget {
  int initialIndex;
  DashboardPage({this.initialIndex});
  @override
  State<StatefulWidget> createState() {
    return _DashboardPageState();
  }
}

class _DashboardPageState extends State<DashboardPage> {
  NavbarBloc _navbarBloc;

  @override
  void initState() {
    updateDeviceToken();
    if(widget.initialIndex==null) {
      _navbarBloc = NavbarBloc(HomeTab());
    }else{
      _navbarBloc = NavbarBloc(TripTab());
    }

    super.initState();
  }

  @override
  void dispose() {
    _navbarBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print("indexSellected:fffff");
    return Scaffold(
      bottomNavigationBar: FABBottomAppBar(
        height: 74.0,
        initialIndex: widget.initialIndex,
        color: ColorResources.bottom_tab_unselected,
        selectedColor: ColorResources.bottom_tab_selected,
        notchedShape: CircularNotchedRectangle(),

        onTabSelected: (index) {
          print("indexSellected: $index");
          widget.initialIndex=index;
          setState(() {

          });
          switch (index) {
            case 0:
              _navbarBloc.add(NavbarItems.Home);
              break;
            case 1:
              _navbarBloc.add(NavbarItems.Chat);
              break;
            case 2:
              _navbarBloc.add(NavbarItems.Trips);
              break;
            case 3:
              _navbarBloc.add(NavbarItems.Profile);
              break;
          }
        },
        items: [
          FABBottomAppBarItem(iconPath: ImageResource.tab1, text: 'Home'),
          FABBottomAppBarItem(iconPath: ImageResource.tab2, text: 'Chat'),
          FABBottomAppBarItem(iconPath: ImageResource.tab3, text: 'Trip'),
          FABBottomAppBarItem(iconPath: ImageResource.tab4, text: 'Profile'),
        ],
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFab(context),
      body: BlocBuilder(
          cubit: _navbarBloc,
          builder: (BuildContext context, NavbarState state) {
            if (state is HomeTab)
              return HomeScreen();
            if (state is ChatTab) return ChatUserListScreen();
            if (state is AddTripTab) return AddTripScreen();
            if (state is TripTab) return TripsListScreen();
            if (state is ProfileTab) return ProfileScreen();
          }),
    );
  }

  _buildFab(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        widget.initialIndex=-1;
        _navbarBloc.add(NavbarItems.AddTrip);

        setState(() {

        });
        },
      tooltip: 'Add',
      child: Stack(
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
              color: const Color(0xfffca25d),
              border: Border.all(width: 4.0, color: const Color(0xffffffff)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0x19000000),
                  offset: Offset(5, 5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.elliptical(9999.0, 9999.0)),
              color: const Color(0xfffca25d),
              border: Border.all(width: 4.0, color: const Color(0xffffffff)),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xffffffff),
                  offset: Offset(-5, -5),
                  blurRadius: 10,
                ),
              ],
            ),
          ),
          Center(
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          )
        ],
      ),
      elevation: 2.0,
    );
  }

  void updateDeviceToken() async{
    var deviceToken=await UserRepo.getInstance().getFCMToken();
    await  FirebaseDbService().updateUserDeviceToken(deviceToken, currentUserIdValue);
  }


}
