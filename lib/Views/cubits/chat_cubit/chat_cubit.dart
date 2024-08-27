import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meta/meta.dart';
import 'package:yap/Models/message.dart';
import 'package:yap/helper/consts.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());

  List<Message> messagesList = [];
  CollectionReference messages =
      FirebaseFirestore.instance.collection(kMessagesCollection);

  void sendMessage({required String msg, required String email}) {
    messages.add(
      {
        kMessage: msg,
        kCreatedAt: DateTime.now(),
        'id': email,
      },
    );
  }

  void getMessage() {
    messages.orderBy(kCreatedAt, descending: true).snapshots().listen((event) {
      messagesList.clear();
      for (var doc in event.docs) {
        messagesList.add(Message.fromjson(doc));
      }
      emit(ChatSuccess());
    });
  }
}
