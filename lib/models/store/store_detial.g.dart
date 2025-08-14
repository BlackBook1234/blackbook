// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreDetialModel _$StoreDetialModelFromJson(Map<String, dynamic> json) =>
    StoreDetialModel(
      name: json['name'] as String?,
      payment_end_date: json['payment_end_date'] as String?,
      id: (json['id'] as num?)?.toInt(),
      phone_number: json['phone_number'] as String?,
      created_at: json['created_at'] as String?,
      is_main: (json['is_main'] as num?)?.toInt(),
    );

Map<String, dynamic> _$StoreDetialModelToJson(StoreDetialModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone_number': instance.phone_number,
      'created_at': instance.created_at,
      'payment_end_date': instance.payment_end_date,
      'is_main': instance.is_main,
      'id': instance.id,
    };
