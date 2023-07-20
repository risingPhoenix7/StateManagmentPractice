import '../models/message/message.dart';

abstract class ChatEvent {}

class MessagesLoaded extends ChatEvent {}

class MessageLongPressed extends ChatEvent {
  final int messageIndex;
  final bool isLeft;

  MessageLongPressed({required this.messageIndex, required this.isLeft});
}

class MessageLongPressedDisabled extends ChatEvent {
  final int messageIndex;

  MessageLongPressedDisabled({required this.messageIndex});
}

class RemoveAllLongPressed extends ChatEvent {}

class NewMessage extends ChatEvent {
  final Message message;

  NewMessage({required this.message});
}

class EmojiSelected extends ChatEvent {
  final String emoji;

  EmojiSelected(this.emoji);
}

class MessageReply extends ChatEvent {
  final int messageIndex;
  bool isLeft;

  MessageReply({required this.messageIndex, required this.isLeft});
}

class MessageReplyDisabled extends ChatEvent {}

class GoToIndex extends ChatEvent {
  final int index;
  final bool isLeft;

  GoToIndex({required this.index, required this.isLeft});
}

class DeleteMessages extends ChatEvent {
  final bool isLeft;
  DeleteMessages({required this.isLeft});
}
