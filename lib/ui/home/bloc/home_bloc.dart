import 'package:app/push_notifications/notifiaction_model.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:rxdart/rxdart.dart';

class HomeBloc {



  PublishSubject<List<NotificationModel>> notificationListSink = PublishSubject<List<NotificationModel>>();
  PublishSubject<List<TripModelData>> tripListSink = PublishSubject<List<TripModelData>>();
  Stream<List<TripModelData>> get tripListSinkListStream => tripListSink.stream;
  Stream<List<NotificationModel>> get notificationListStream => notificationListSink.stream;



  void updateNotificationList(List<NotificationModel> notificationList ){
    notificationListSink.sink.add(notificationList);

  }

  void updateTripList(List<TripModelData> tripList ){
    tripListSink.sink.add(tripList);

  }

  disposeBloc(){
    notificationListSink.close();
    tripListSink.close();
  }
}
