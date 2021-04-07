abstract class NavbarState {}

class HomeTab extends NavbarState {
  final String title = "Home";
  final int itemIndex = 0;
}

class ChatTab extends NavbarState {
  final String title = "ChatTab";
  final int itemIndex = 1;
}

class AddTripTab extends NavbarState {
  final String title = "AddTrip";
  final int itemIndex = 5;
}

class TripTab extends NavbarState {
  final String title = "TripTab";
  final int itemIndex = 2;
}

class ProfileTab extends NavbarState {
  final String title = "ProfileTab";
  final int itemIndex = 3;
}
