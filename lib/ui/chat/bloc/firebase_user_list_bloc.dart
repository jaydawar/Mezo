import 'package:app/ui/chat/model/chat_message_model.dart';
import 'package:rxdart/rxdart.dart';

class ChatMessageBloc {
  PublishSubject<List<ChatMessageModel>> chatUserListSink = PublishSubject<List<ChatMessageModel>>();

  BehaviorSubject<bool> showProgressSink = BehaviorSubject<bool>();

  Stream<bool> get showProgressStream => showProgressSink.stream;

  Stream<List<ChatMessageModel>> get chatUserListStream =>
      chatUserListSink.stream;

  showProgress({bool show}) {
    showProgressSink.sink.add(show);
  }

  updateUserChatList(List<ChatMessageModel> chatUserList) {
    chatUserListSink.sink.add(chatUserList);
  }

  disposeBloc() {
    showProgressSink.close();
    chatUserListSink.close();
  }




}
