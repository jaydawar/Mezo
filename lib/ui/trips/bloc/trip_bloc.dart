import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:rxdart/rxdart.dart';

class TripBloc {
  PublishSubject<List<TripModelData>> tripListSink =
      PublishSubject<List<TripModelData>>();

  Stream<List<TripModelData>> get tripListSinkListStream => tripListSink.stream;

  PublishSubject<TripModelData> requestTripDataSink =
      PublishSubject<TripModelData>();

  Stream<TripModelData> get requestTripDataStream => requestTripDataSink.stream;

  PublishSubject<TripModelData> sentTripDataSink =
      PublishSubject<TripModelData>();

  Stream<TripModelData> get sentTripDataStream => sentTripDataSink.stream;

  PublishSubject<TripModelData> currentTripDataSink =
      PublishSubject<TripModelData>();

  Stream<TripModelData> get currenttTripDataStream =>
      currentTripDataSink.stream;

  void updateTripList(List<TripModelData> tripList) {
    tripListSink.sink.add(tripList);
  }

  void updateCurrentList(TripModelData currenctTrip) {
    currentTripDataSink.sink.add(currenctTrip);
  }

  void updateRequestDataModel(TripModelData requestTrip) {
    requestTripDataSink.sink.add(requestTrip);
  }

  void updateSentDataModel(TripModelData sentTrip) {
    sentTripDataSink.sink.add(sentTrip);
  }

  disposeBloc() {
    tripListSink.close();
    requestTripDataSink.close();
    sentTripDataSink.close();
    currentTripDataSink.close();
  }
}
