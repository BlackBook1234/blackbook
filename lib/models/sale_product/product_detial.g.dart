// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleProductDetialModel _$SaleProductDetialModelFromJson(
        Map<String, dynamic> json) =>
    SaleProductDetialModel(
      list: (json['list'] as List<dynamic>?)
          ?.map((e) =>
              SaleProductInDetialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      stores: (json['stores'] as List<dynamic>?)
          ?.map((e) => StoreDetialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] == null
          ? null
          : TotalSaleModel.fromJson(json['total'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SaleProductDetialModelToJson(
        SaleProductDetialModel instance) =>
    <String, dynamic>{
      'list': instance.list,
      'stores': instance.stores,
      'total': instance.total,
    };
