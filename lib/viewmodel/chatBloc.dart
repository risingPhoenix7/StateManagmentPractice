import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
      emit(MessagesUpdated(List.from(messages)));
    });

    on<MessageLongPressed>((event, emit) {
      editingMessageIndex = event.messageIndex;
    });

    on<EmojiSelected>((event, emit) {
      if (editingMessageIndex != null && editingMessageIndex! >= 0) {
        messages[editingMessageIndex!] =
            messages[editingMessageIndex!].copyWith(emoji: event.emoji);
        emit(MessagesUpdated(List.from(messages)));
        editingMessageIndex = null;
      }
    });

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
        ? const User(id: 1, profilePic: "assets/images/naruto.png", name: 'Naruto')
        : const User(id: 2, profilePic: "assets/images/sasuke.jpg", name: 'Sasuke');
  }

  Message getLastMessage() {
    return messages.last;
  }

  Future<void> loadMessagesFromJson() async {
    try {
      // Replace 'YOUR_CUSTOM_URL' with the actual URL to your JSON file
      final response = await http
          .get(Uri.parse('https://api.npoint.io/629520e626c95525593f'));

      if (response.statusCode == 200) {
        final jsonData = response.body;
        List<dynamic> jsonResult = jsonDecode(jsonData);
        messages = jsonResult.map((item) => Message.fromJson(item)).toList();
        add(MessagesLoaded());
      } else {
        print(
            'Failed to load messages from JSON. Status code: ${response.statusCode}');
      }
    } catch (error) {
      print('Error loading messages from JSON: $error');
    }
  }

  List<Message> getMessages() {
    return messages;
  }
}
