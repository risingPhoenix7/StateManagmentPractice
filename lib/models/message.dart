class Message {
  bool isLeft;
  String text;
  DateTime dateTime;
  int? replyToIndex;
  String? emoji;

  Message({
    required this.isLeft,
    required this.text,
    required this.dateTime,
    this.replyToIndex,
    this.emoji,
  });

  factory Message.fromJson(Map<String, dynamic> json) {
    return Message(
      isLeft: json['isLeft'],
      text: json['text'],
      dateTime: DateTime.parse(json['dateTime']),
      emoji: json['emoji'],
    );
  }

}
