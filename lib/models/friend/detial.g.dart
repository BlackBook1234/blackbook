// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneNumber _$PhoneNumberFromJson(Map<String, dynamic> json) => PhoneNumber(
      statusNames: json['statusNames'] == null
          ? null
          : StatusNames.fromJson(json['statusNames'] as Map<String, dynamic>),
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => PhoneNumberList.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$PhoneNumberToJson(PhoneNumber instance) =>
    <String, dynamic>{
      'list': instance.list,
      'statusNames': instance.statusNames,
    };
