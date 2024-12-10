// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductStoreModel _$ProductStoreModelFromJson(Map<String, dynamic> json) =>
    ProductStoreModel(
      name: json['name'] as String?,
      phone_number: json['phone_number'] as String?,
      created_at: json['created_at'] as String?,
      is_main: (json['is_main'] as num?)?.toInt(),
      id: (json['id'] as num?)?.toInt(),
    );

Map<String, dynamic> _$ProductStoreModelToJson(ProductStoreModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'phone_number': instance.phone_number,
      'created_at': instance.created_at,
      'is_main': instance.is_main,
      'id': instance.id,
    };
