// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qpay.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Qpay _$QpayFromJson(Map<String, dynamic> json) => Qpay(
      invoice_id: json['invoice_id'] as String?,
      qPay_shortUrl: json['qPay_shortUrl'] as String?,
      urls: (json['urls'] as List<dynamic>?)
          ?.map((e) => Urls.fromJson(e as Map<String, dynamic>))
          .toList(),
      qr_image: json['qr_image'] as String?,
      qr_text: json['qr_text'] as String?,
    );

Map<String, dynamic> _$QpayToJson(Qpay instance) => <String, dynamic>{
      'invoice_id': instance.invoice_id,
      'qr_text': instance.qr_text,
      'qr_image': instance.qr_image,
      'qPay_shortUrl': instance.qPay_shortUrl,
      'urls': instance.urls,
    };
