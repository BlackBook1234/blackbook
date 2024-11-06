// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'categories.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CategoriesModel _$CategoriesModelFromJson(Map<String, dynamic> json) =>
    CategoriesModel(
      id: json['id'] as int,
      sort_order: json['sort_order'] as int,
      name: json['name'] as String,
      parent: json['parent'] as String,
      created_at: json['created_at'] as String,
    );

Map<String, dynamic> _$CategoriesModelToJson(CategoriesModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'sort_order': instance.sort_order,
      'name': instance.name,
      'parent': instance.parent,
      'created_at': instance.created_at,
    };
