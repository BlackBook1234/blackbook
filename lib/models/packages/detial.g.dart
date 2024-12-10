// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackagesDetial _$PackagesDetialFromJson(Map<String, dynamic> json) =>
    PackagesDetial(
      amount: (json['amount'] as num?)?.toInt(),
      oldAmount: (json['oldAmount'] as num?)?.toInt(),
      description: (json['description'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      title: json['title'] as String?,
      period: (json['period'] as num?)?.toInt(),
      key: json['key'] as String?,
    );

Map<String, dynamic> _$PackagesDetialToJson(PackagesDetial instance) =>
    <String, dynamic>{
      'oldAmount': instance.oldAmount,
      'amount': instance.amount,
      'period': instance.period,
      'key': instance.key,
      'title': instance.title,
      'description': instance.description,
    };
