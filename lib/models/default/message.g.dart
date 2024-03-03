// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageDefaultModel _$MessageDefaultModelFromJson(Map<String, dynamic> json) =>
    MessageDefaultModel(
      show: json['show'] as bool,
      text: json['text'] as String?,
      reason: json['reason'] as String?,
    );

Map<String, dynamic> _$MessageDefaultModelToJson(
        MessageDefaultModel instance) =>
    <String, dynamic>{
      'show': instance.show,
      'text': instance.text,
      'reason': instance.reason,
    };
