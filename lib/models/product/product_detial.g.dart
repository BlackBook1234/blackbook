// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductDetialModel _$ProductDetialModelFromJson(Map<String, dynamic> json) =>
    ProductDetialModel(
      name: json['name'] as String?,
      code: json['code'] as String?,
      total: json['total'] == null
          ? null
          : TotalSaleModel.fromJson(json['total'] as Map<String, dynamic>),
      photo: json['photo'] as String?,
      category_id: (json['category_id'] as num?)?.toInt(),
      category_name: json['category_name'] as String?,
      created_at: json['created_at'] as String?,
      parent_category: json['parent_category'] as String?,
      parent_name: json['parent_name'] as String?,
      good_id: json['good_id'] as String?,
      sizes: (json['sizes'] as List<dynamic>?)
          ?.map((e) => ProductInDetialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProductDetialModelToJson(ProductDetialModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'code': instance.code,
      'photo': instance.photo,
      'category_name': instance.category_name,
      'category_id': instance.category_id,
      'parent_name': instance.parent_name,
      'created_at': instance.created_at,
      'good_id': instance.good_id,
      'parent_category': instance.parent_category,
      'sizes': instance.sizes,
      'total': instance.total,
    };
