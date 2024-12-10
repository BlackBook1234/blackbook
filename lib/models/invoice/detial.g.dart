// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvoiceDetial _$InvoiceDetialFromJson(Map<String, dynamic> json) =>
    InvoiceDetial(
      amount: (json['amount'] as num?)?.toInt(),
      period: (json['period'] as num?)?.toInt(),
      qpay: json['qpay'] == null
          ? null
          : Qpay.fromJson(json['qpay'] as Map<String, dynamic>),
      description: json['description'] as String?,
      title: json['title'] as String?,
      orderId: (json['orderId'] as num?)?.toInt(),
      manual: (json['manual'] as List<dynamic>?)
          ?.map((e) => Manual.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InvoiceDetialToJson(InvoiceDetial instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'period': instance.period,
      'orderId': instance.orderId,
      'title': instance.title,
      'description': instance.description,
      'qpay': instance.qpay,
      'manual': instance.manual,
    };
