class AppConstants {
  static var USER_IMAGE_FOLDER = "usersImages";
  static var CHAT_IMAGE_FOLDER = "chatImages";
  static var USERID = "";
  static var Poppins_Font = "Poppins";
}

class ErrorMessages {
  static const String NO_USER_FOUND =
      "Login failed because there is no user in the database";
}

class StorageKeys {
  static const String USER_ID_KEY = "user_id_key";
  static const String USER_DISPLAY_NAME_KEY = "user_display_name_key";
  static const String USER_UNIQUNAE = "user_unique_name_key";
  static const String USER_PHOTO_URL_KEY = "user_photo_url_key";
  static const String USER_ADDRESS = "user_address";
  static const String USER_PHONE_NUMBER = "user_phone";
  static const String FCM_TOKEN = "fcmToken";
  static const String USER_CREATEDAT = "userCreated";
  static const String USER_PHONENUMBER = "phoneNumber";
}

class UIConstants {
  // FONT SIZE
  static const double SMALLER_FONT_SIZE = 10.0;
  static const double STANDARD_FONT_SIZE = 14.0;
  static const double BIGGER_FONT_SIZE = 18.0;

  // PADDING
  static const double SMALLER_PADDING = 8.0;
  static const double STANDARD_PADDING = 16.0;
  static const double BIGGER_PADDING = 24.0;

  // ELEVATION
  static const double STANDARD_ELEVATION = 3.0;
}

class FirestorePaths {
  static const String ROOT_PATH = "";
  static const String USERS_COLLECTION = ROOT_PATH + "users";
  static const String TRIPS_COLLECTION = ROOT_PATH + "trips";
  static const String NOTIFICATIONS_COLLECTION = ROOT_PATH + "notifications";
  static const String CHATROOMS_COLLECTION = ROOT_PATH + "chatrooms";
  static const String CHATMESSAGES = ROOT_PATH + "chatMessages";
  static const String MyChat = ROOT_PATH + "MyChat";
  static const String USER_DOCUMENT = USERS_COLLECTION + "/{user_id}";
}

class FcmPushNotifications {
  static const String SERVR_KEY =
      "AAAAnXx0aqk:APA91bGbnehRpBSfspy9sTeRsMOOjY7VD9jBj-DWvBTHoY31vJq184L29C4RmyBYy3I7gloqsK9oA9o1zMMHJwdB6bNHAlvWEqoXyINN4wZsIWbogZnZ-QwfRffAvzm4pj8a_RavOebe";

  static var CLICK_ACTION = "FLUTTER_NOTIFICATION_CLICK";

  static var PRIORITY = "high";

  static String onAcceptNotificationMessage =
      "has accepted your trip request for";
  static String onDeclineNotificationMessage =
      "has decline your trip request for";

  static String onTripCancelled = "has cancelled the trip";
  static String onTripCreate = "has created the trip";

  static var onAcceptNotificationTitle = "Accept Trip Request";
  static var onDeclineNotificationTitle = "Decline Trip Request";
  static var tripCancelled = "Trip Cancelled";
  static var newTrip = "New Trip";

  static var TRIP_NOTIFICATION_TYPE = 'trip';
  static var CHAT_NOTIFICATION_TYPE = 'chat';
}

class AlertDialogMessages {
  static String onConfirmTitle = "Confirm Trip";
  static String onDeclineTitle = "Decline Trip";
  static String onConfirmMessge =
      "Please choose whether you would like to confirm this trip or return back to trip details.";
  static String onDeclineMessge =
      "Please choose whether you would like to decline this trip or return back.";
}
