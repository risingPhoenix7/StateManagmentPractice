import 'package:jio_task/models/message/message.dart';

abstract class ChatState {}

class ChatInitial extends ChatState {}

class MessagesUpdated extends ChatState {
  final List<Message> messages;

  MessagesUpdated(this.messages);
}

class ReplyModeEnabled extends ChatState {
  final Message replyMessage;
  final int replyIndex;
  final bool isLeft;

  ReplyModeEnabled(this.replyMessage, this.isLeft, this.replyIndex);
}

class ReplyModeDisabled extends ChatState {}

class ScrollToIndex extends ChatState {
  final int index;
  final bool isLeft;

  ScrollToIndex(this.index, this.isLeft);
}

class ShowDeleteDialog extends ChatState {}
class DisableDeleteDialog extends ChatState {}
class UnSelectAllMessages extends ChatState {}
class DeleteMessagesState extends ChatState {}