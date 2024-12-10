// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_warehouse.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleListWarehouseModel _$SaleListWarehouseModelFromJson(
        Map<String, dynamic> json) =>
    SaleListWarehouseModel(
      total_cost: (json['total_cost'] as num?)?.toInt(),
      total_price: (json['total_price'] as num?)?.toInt(),
    )..name = json['name'] as String?;

Map<String, dynamic> _$SaleListWarehouseModelToJson(
        SaleListWarehouseModel instance) =>
    <String, dynamic>{
      'total_cost': instance.total_cost,
      'total_price': instance.total_price,
      'name': instance.name,
    };
