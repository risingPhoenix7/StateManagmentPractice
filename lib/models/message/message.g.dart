// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Message _$$_MessageFromJson(Map<String, dynamic> json) => _$_Message(
      isLeft: json['isLeft'] as bool,
      text: json['text'] as String,
      dateTime: DateTime.parse(json['dateTime'] as String),
      replyToIndex: json['replyToIndex'] as int?,
      emoji: json['emoji'] as String?,
    );

Map<String, dynamic> _$$_MessageToJson(_$_Message instance) =>
    <String, dynamic>{
      'isLeft': instance.isLeft,
      'text': instance.text,
      'dateTime': instance.dateTime.toIso8601String(),
      'replyToIndex': instance.replyToIndex,
      'emoji': instance.emoji,
    };
