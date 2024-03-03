// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'category_detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoryDetialModel _$CategoryDetialModelFromJson(Map<String, dynamic> json) =>
    CategoryDetialModel(
      name: json['name'] as String?,
      sort_order: json['sort_order'] as String?,
      id: json['id'] as int?,
      created_at: json['created_at'] as String?,
      parent: json['parent'] as String?,
      parent_name: json['parent_name'] as String?,
    );

Map<String, dynamic> _$CategoryDetialModelToJson(
        CategoryDetialModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'sort_order': instance.sort_order,
      'parent': instance.parent,
      'created_at': instance.created_at,
      'parent_name': instance.parent_name,
      'id': instance.id,
    };
