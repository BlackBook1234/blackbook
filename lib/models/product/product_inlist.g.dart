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
      price: json['price'] as int?,
      stock: json['stock'] as int?,
      warehouse_stock: json['warehouse_stock'] as int?,
      id: json['id'] as int?,
    );

Map<String, dynamic> _$ProductInDetialModelToJson(
        ProductInDetialModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'cost': instance.cost,
      'price': instance.price,
      'stock': instance.stock,
      'id': instance.id,
      'warehouse_stock': instance.warehouse_stock,
    };
