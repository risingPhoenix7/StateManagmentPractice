import 'package:hive/hive.dart';

import '../constants/boxNames.dart';
import '../models/message/message.dart';

class HiveFunctions {
  static List<Message> getMessages() {
    final box = Hive.box<Message>(BoxNames.messageBox);
    List<Message> messages = box.values.toList().cast<Message>();
    return messages;
  }

  static Future<void> deleteMessage(bool isLeft, int index) async{
    final box = Hive.box<Message>(BoxNames.messageBox);
    Message? message = box.getAt(index);
    if (message != null) {
      isLeft ? message.deletedByLeft = true : message.deletedByRight = true;
      await box.putAt(index, message);
    }
  }
}
