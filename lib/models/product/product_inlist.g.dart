// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_inlist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductInDetialModel _$ProductInDetialModelFromJson(
        Map<String, dynamic> json) =>
    ProductInDetialModel(
      type: json['type'] as String?,
      cost: json['cost'] as int?,
      transfer_id: json['transfer_id'] as int?,
      created_at: json['created_at'] as String?,
      price: json['price'] as int?,
      store_name: json['store_name'] as String?,
      store_id: json['store_id'] as int?,
      stock: json['stock'] as int?,
      warehouse_stock: json['warehouse_stock'] as int?,
      id: json['id'] as int?,
    );

Map<String, dynamic> _$ProductInDetialModelToJson(
        ProductInDetialModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'created_at': instance.created_at,
      'store_name': instance.store_name,
      'cost': instance.cost,
      'price': instance.price,
      'stock': instance.stock,
      'id': instance.id,
      'warehouse_stock': instance.warehouse_stock,
      'store_id': instance.store_id,
      'transfer_id': instance.transfer_id,
    };
