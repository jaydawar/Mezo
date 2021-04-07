import 'package:app/firebaseuserauth/user_model.dart';
import 'package:app/ui/trips/model/trip_model_data.dart';
import 'package:rxdart/rxdart.dart';

class AddTripBloc {
  final BehaviorSubject<bool> showProgressSink = BehaviorSubject<bool>();



  final PublishSubject<List<UserModel>> selectAttendeeSink= PublishSubject<List<UserModel>>();

  final PublishSubject<List<UserModel>> selectedAttendeeList= PublishSubject<List<UserModel>>();

  Stream<bool> get showProgressStream => showProgressSink.stream;

  Stream<List<UserModel>> get selectAttendeeStream=>selectAttendeeSink.stream;
  Stream<List<UserModel>> get selectedAttendeeStream=>selectedAttendeeList.stream;


  BehaviorSubject<String> tripDateSink= BehaviorSubject<String>();

  Stream<String> get tripDateStream=>tripDateSink.stream;

  void showProgress(bool show) {
    showProgressSink.sink.add(show);
  }

  void updateAttendeeList(List<UserModel> attendeeList){
    selectAttendeeSink.sink.add(attendeeList);
  }
  void updateSelectedAttendeeList(List<UserModel> attendeeList){
    selectedAttendeeList.sink.add(attendeeList);
  }

  void changeTripDate({String selectedDate}){
    tripDateSink.sink.add(selectedDate);
  }
  disposeBloc(){
    showProgressSink.close();
    tripDateSink.close();
    selectAttendeeSink.close();
  }
}
