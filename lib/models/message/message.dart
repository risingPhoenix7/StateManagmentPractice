import 'package:hive/hive.dart';

part 'message.g.dart';

@HiveType(typeId: 0)
class Message extends HiveObject {
  Message({
    required this.isLeft,
    required this.text,
    required this.dateTime,
    this.replyToIndex,
    this.emoji,
    this.deletedByLeft = false,
    this.deletedByRight = false,
  });

  @HiveField(0)
  bool isLeft;
  @HiveField(2)
  String text;
  @HiveField(3)
  DateTime dateTime;
  @HiveField(5)
  int? replyToIndex;
  @HiveField(6)
  String? emoji;
  @HiveField(7)
  bool deletedByLeft;
  @HiveField(8)
  bool deletedByRight;
}
