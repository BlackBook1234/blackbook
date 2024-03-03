// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceDetial _$InvoiceDetialFromJson(Map<String, dynamic> json) =>
    InvoiceDetial(
      amount: json['amount'] as int?,
      period: json['period'] as int?,
      qpay: json['qpay'] == null
          ? null
          : Qpay.fromJson(json['qpay'] as Map<String, dynamic>),
      description: json['description'] as String?,
      title: json['title'] as String?,
      manual: (json['manual'] as List<dynamic>?)
          ?.map((e) => Manual.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InvoiceDetialToJson(InvoiceDetial instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'period': instance.period,
      'description': instance.description,
      'title': instance.title,
      'qpay': instance.qpay,
      'manual': instance.manual,
    };
