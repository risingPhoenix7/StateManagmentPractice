import 'package:jio_task/models/message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class MessagesUpdated extends ChatState {
  final List<Message> messages;

  MessagesUpdated(this.messages);
}
class ReplyModeEnabled extends ChatState {
  final Message replyMessage;

  ReplyModeEnabled(this.replyMessage);
}