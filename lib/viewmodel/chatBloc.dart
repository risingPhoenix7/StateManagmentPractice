import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jio_task/models/message.dart';
import 'package:jio_task/models/user.dart';

import 'chatEvent.dart';
import 'chatState.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<Message> messages = [];
  int? editingMessageIndex;

  ChatBloc() : super(ChatInitial()) {
    on<MessagesLoaded>((event, emit) {
      emit(MessagesUpdated(messages));
    });

    on<NewMessage>((event, emit) {
      messages.add(event.message);
      emit(MessagesUpdated(List.from(messages)));
    });

    on<MessageLongPressed>((event, emit) {
      editingMessageIndex = event.messageIndex;
    });

    on<EmojiSelected>((event, emit) {
      if (editingMessageIndex != null && editingMessageIndex! >= 0) {
        messages[editingMessageIndex!].emoji = event.emoji;
        emit(MessagesUpdated(List.from(messages)));
        editingMessageIndex = null;
      }
    });

    on<MessageReply>((event, emit) {
      emit(ReplyModeEnabled(messages[event.messageIndex]));
    });
  }

  User getUserDetails(bool isLeft) {
    return isLeft
        ? User(id: 1, profilePic: 'images/naruto.png', name: 'Naruto')
        : User(id: 2, profilePic: 'images/sasuke.jpg', name: 'Sasuke');
  }

  Message getLastMessage() {
    return messages.last;
  }

  Future<void> loadMessagesFromJson() async {
    try {
      String jsonData = await rootBundle.loadString('/json/chats.json');
      List<dynamic> jsonResult = jsonDecode(jsonData);
      messages = jsonResult.map((item) => Message.fromJson(item)).toList();
      add(MessagesLoaded());
    } catch (error) {
      print('Error loading messages from JSON: $error');
    }
  }
}
