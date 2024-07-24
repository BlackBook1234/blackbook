// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferProduct _$TransferProductFromJson(Map<String, dynamic> json) =>
    TransferProduct(
      name: json['name'] as String?,
      code: json['code'] as String?,
      photo: json['photo'] as String?,
      good_id: json['good_id'] as String?,
      count: json['count'] as int?,
      sizes: (json['sizes'] as List<dynamic>?)
          ?.map((e) => TransferProductSize.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransferProductToJson(TransferProduct instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'photo': instance.photo,
      'good_id': instance.good_id,
      'count': instance.count,
      'sizes': instance.sizes,
    };
