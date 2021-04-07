
import 'package:bloc/bloc.dart';

import 'dashboard_state.dart';

enum NavbarItems { Home, Chat, AddTrip, Trips, Profile }

class NavbarBloc extends Bloc<NavbarItems, NavbarState> {
  NavbarBloc(NavbarState initialState) : super(initialState);

  @override
  NavbarState get initialState => HomeTab();

  @override
  Stream<NavbarState> mapEventToState(NavbarItems event) async* {
    switch (event) {
      case NavbarItems.Home:
        yield HomeTab();
        break;
      case NavbarItems.Chat:
        yield ChatTab();
        break;
      case NavbarItems.AddTrip:
        yield AddTripTab();
        break;

      case NavbarItems.Trips:
        yield TripTab();
        break;

      case NavbarItems.Profile:
        yield ProfileTab();
        break;
      default:
        yield HomeTab();
        break;
    }
  }
}
