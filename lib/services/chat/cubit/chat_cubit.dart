//import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hire_harmony/models/message_model.dart';
import 'package:hire_harmony/services/chat/chat_services.dart';
import 'package:hire_harmony/services/user_services.dart';

part 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  ChatCubit() : super(ChatInitial());
  final chatServices = ChatServices();
  final userServices = UserServices();

  //send message function
  Future<void> sendMessage(String text) async {
    emit(ChatMessageSending());
    try {
      final sender = await userServices.getUser();
      final message = MessageModel(
        id: DateTime.now().toIso8601String(),
        senderId: sender.id,
        senderName: sender.name,
  senderPhotoUrl: sender.photoUrl.isNotEmpty ? sender.photoUrl : 'https://images.ctfassets.net/vztl6s0hp3ro/7zFqhZ00n4x5vnEpySo6QF/5af169fdf542ff9486e9380ec40cae9f/a-detailed-guide-on-creating-a-production-worker-job-description.webp', // Provide a fallback
        message: text,
        dateTime: DateTime.now(),
      );

      await chatServices.sendMessage(message);
      emit(ChatMessageSent());
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }
  
  

/*  Future<void> getMessages() async {
    emit(ChatLoading());
    try {
      final messagesStream = chatServices.getMessages();
      messagesStream.listen((messages) {
        
        emit(ChatSuccess(messages));
      });
    } catch (e) {
      emit(ChatFailure(e.toString()));
    }
  }*/
  Future<void> getMessages() async {
  emit(ChatLoading());
  try {
    final messagesStream = chatServices.getMessages();
    messagesStream.listen(
      (messages) {
        emit(ChatSuccess(messages));
      },
      onError: (error) {
        emit(ChatFailure(error.toString()));

      },
    );
  } catch (e) {
    emit(ChatFailure(e.toString()));
  }
}

  
  
}
