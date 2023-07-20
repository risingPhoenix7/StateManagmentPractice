// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class MessageAdapter extends TypeAdapter<Message> {
  @override
  final int typeId = 0;

  @override
  Message read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Message(
      isLeft: fields[0] as bool,
      text: fields[2] as String,
      dateTime: fields[3] as DateTime,
      replyToIndex: fields[5] as int?,
      emoji: fields[6] as String?,
      deletedByLeft: fields[7] as bool,
      deletedByRight: fields[8] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Message obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.isLeft)
      ..writeByte(2)
      ..write(obj.text)
      ..writeByte(3)
      ..write(obj.dateTime)
      ..writeByte(5)
      ..write(obj.replyToIndex)
      ..writeByte(6)
      ..write(obj.emoji)
      ..writeByte(7)
      ..write(obj.deletedByLeft)
      ..writeByte(8)
      ..write(obj.deletedByRight);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MessageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
