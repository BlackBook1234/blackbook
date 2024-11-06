// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackagesDetial _$PackagesDetialFromJson(Map<String, dynamic> json) =>
    PackagesDetial(
      amount: json['amount'] as int?,
      description: json['description'] as String?,
      title: json['title'] as String?,
      period: json['period'] as int?,
      key: json['key'] as String?,
    );

Map<String, dynamic> _$PackagesDetialToJson(PackagesDetial instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'period': instance.period,
      'description': instance.description,
      'key': instance.key,
      'title': instance.title,
    };
