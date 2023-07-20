import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:jio_task/constants/boxNames.dart';
import 'package:jio_task/models/message/message.dart';
import 'package:jio_task/models/user/user.dart';
import 'package:http/http.dart' as http;
import 'package:jio_task/viewmodel/hiveFunctions.dart';
import 'dart:convert';
import 'chatEvent.dart';
import 'chatState.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  List<Message> messages = [];
  List<int> editingMessageIndices = [];
  bool editingIsLeft = false;
  List<User> userDetails = [];

  ChatBloc() : super(ChatInitial()) {
    on<MessagesLoaded>((event, emit) {
      print("MessagesLoaded");
      emit(MessagesUpdated(messages));
    });

    on<NewMessage>((event, emit) {
      messages.add(event.message);
      final box = Hive.box<Message>(BoxNames.messageBox);
      box.add(event.message);
      emit(MessagesUpdated(List.from(messages)));
    });

    on<MessageLongPressed>((event, emit) {
      editingMessageIndices.add(event.messageIndex);
      if (editingMessageIndices.length == 1) {
        emit(ShowDeleteDialog());
      }
    });

    on<MessageLongPressedDisabled>((event, emit) {
      editingMessageIndices.remove(event.messageIndex);
      if (editingMessageIndices.isEmpty) {
        emit(DisableDeleteDialog());
      }
    });

    on<RemoveAllLongPressed>((event, emit) {
      editingMessageIndices.clear();
      emit(DisableDeleteDialog());
      emit(UnSelectAllMessages());
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

    on<DeleteMessages>((event, emit) async {
      for (int i = 0; i < editingMessageIndices.length; i++) {
        await HiveFunctions.deleteMessage(
            event.isLeft, editingMessageIndices[i]);
        messages[editingMessageIndices[i]].deleteMessage(event.isLeft);
      }
      editingMessageIndices.clear();
      emit(DeleteMessagesState());
      emit(DisableDeleteDialog());
      emit(UnSelectAllMessages());
    });
  }

  User getUserDetails(bool isLeft) {
    print("getUserDetails");
    print(userDetails.length);
    return isLeft ? userDetails[0] : userDetails[1];
  }

  Message? getLastMessage() {
    if (messages.isEmpty) {
      return null;
    }
    return messages.last;
  }

  Future<void> loadUserDetails() async {
    final url = Uri.parse('https://api.npoint.io/71d0b4ec84f4f552b056');
    final response = await http.get(url);
    if (response.statusCode == 200) {
      List<dynamic> decodedResponseBody = json.decode(response.body);
      userDetails.addAll(decodedResponseBody
          .map((userJson) => User.fromJson(userJson as Map<String, dynamic>)));
      print("Got http details");
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<void> loadMessagesFromDb() async {
    try {
      messages = HiveFunctions.getMessages();
      await loadUserDetails();
      add(MessagesLoaded());
    } catch (error) {
      print('Error loading messages from box: $error');
    }
  }

  List<Message> getMessages() {
    return messages;
  }
}
