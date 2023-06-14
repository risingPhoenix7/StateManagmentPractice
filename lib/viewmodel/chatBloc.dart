import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:jio_task/models/message/message.dart';
import 'package:jio_task/models/user/user.dart';

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
        messages[editingMessageIndex!] = messages[editingMessageIndex!].copyWith(emoji: event.emoji);
        emit(MessagesUpdated(List.from(messages)));
        editingMessageIndex = null;
      }
    });

    on<MessageReply>((event, emit) {
      emit(ReplyModeEnabled(
          messages[messages.length-event.messageIndex-1], event.isLeft, messages.length-event.messageIndex-1));
    });

    on<MessageReplyDisabled>((event, emit) {
      emit(ReplyModeDisabled());
    });

    on<GoToIndex>((event, emit) {
      emit(ScrollToIndex(event.index, event.isLeft));
    });
  }

  User getUserDetails(bool isLeft) {
    return isLeft
        ? const User(id: 1, profilePic: 'images/naruto.png', name: 'Naruto')
        : const User(id: 2, profilePic: 'images/sasuke.jpg', name: 'Sasuke');
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

  List<Message> getMessages() {
    return messages;
  }
}
