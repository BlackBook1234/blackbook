// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_in_detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleProductInDetialModel _$SaleProductInDetialModelFromJson(
        Map<String, dynamic> json) =>
    SaleProductInDetialModel(
      cost: json['cost'] as int?,
      sale_id: json['sale_id'] as int?,
      is_from_warehouse: json['is_from_warehouse'] as int?,
      money_type: json['money_type'] as String?,
      created_at: json['created_at'] as String?,
      price: json['price'] as int?,
      product_code: json['product_code'] as String?,
      good_id: json['good_id'] as String?,
      product_id: json['product_id'] as int?,
      product_name: json['product_name'] as String?,
      stock: json['stock'] as int?,
      store_color: json['store_color'] as String?,
      store_id: json['store_id'] as int?,
      store_name: json['store_name'] as String?,
      total_balance: json['total_balance'] as int?,
      type: json['type'] as String?,
      warehouse_balance: json['warehouse_balance'] as int?,
    );

Map<String, dynamic> _$SaleProductInDetialModelToJson(
        SaleProductInDetialModel instance) =>
    <String, dynamic>{
      'product_name': instance.product_name,
      'product_code': instance.product_code,
      'good_id': instance.good_id,
      'type': instance.type,
      'store_name': instance.store_name,
      'store_color': instance.store_color,
      'money_type': instance.money_type,
      'created_at': instance.created_at,
      'sale_id': instance.sale_id,
      'product_id': instance.product_id,
      'cost': instance.cost,
      'price': instance.price,
      'stock': instance.stock,
      'total_balance': instance.total_balance,
      'warehouse_balance': instance.warehouse_balance,
      'store_id': instance.store_id,
      'is_from_warehouse': instance.is_from_warehouse,
    };
