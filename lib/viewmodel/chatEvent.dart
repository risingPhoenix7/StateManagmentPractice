import '../models/message.dart';
abstract class ChatEvent {}

class MessagesLoaded extends ChatEvent {}

class MessageLongPressed extends ChatEvent {
  final int messageIndex;

  MessageLongPressed(this.messageIndex);
}

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

  MessageReply(this.messageIndex);
}