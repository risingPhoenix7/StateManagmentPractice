import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:jio_task/constants/boxNames.dart';
import 'package:jio_task/models/message/message.dart';
import 'package:jio_task/models/user/user.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
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
      final box = Hive.box<Message>(BoxNames.messageBox);
      box.add(event.message);
      emit(MessagesUpdated(List.from(messages)));
    });

    on<MessageLongPressed>((event, emit) {
      editingMessageIndex = event.messageIndex;
    });

    // on<EmojiSelected>((event, emit) {
    //   if (editingMessageIndex != null && editingMessageIndex! >= 0) {
    //     messages[editingMessageIndex!] =
    //         messages[editingMessageIndex!].copyWith(emoji: event.emoji);
    //     emit(MessagesUpdated(List.from(messages)));
    //     editingMessageIndex = null;
    //   }
    // });

    on<MessageReply>((event, emit) {
      emit(ReplyModeEnabled(messages[messages.length - event.messageIndex - 1],
          event.isLeft, messages.length - event.messageIndex - 1));
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
        ? const User(
            id: 1, profilePic: "assets/images/naruto.png", name: 'Naruto')
        : const User(
            id: 2, profilePic: "assets/images/sasuke.jpg", name: 'Sasuke');
  }

  Message? getLastMessage() {
    if (messages.isEmpty) {
return null;    }
    return messages.last;
  }

  Future<void> loadMessagesFromDb() async {
    try {
      final box = Hive.box<Message>(BoxNames.messageBox);
      messages = box.values.toList().cast<Message>();
      add(MessagesLoaded());
    } catch (error) {
      print('Error loading messages from box: $error');
    }
  }

  List<Message> getMessages() {
    return messages;
  }
}
