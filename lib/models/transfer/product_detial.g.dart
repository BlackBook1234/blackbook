// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferProductSize _$TransferProductSizeFromJson(Map<String, dynamic> json) =>
    TransferProductSize(
      cost: json['cost'] as int?,
      product_id: json['product_id'] as int?,
      price: json['price'] as int?,
      stock: json['stock'] as int?,
      transfer_id: json['transfer_id'] as int?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$TransferProductSizeToJson(
        TransferProductSize instance) =>
    <String, dynamic>{
      'cost': instance.cost,
      'product_id': instance.product_id,
      'price': instance.price,
      'stock': instance.stock,
      'transfer_id': instance.transfer_id,
      'type': instance.type,
    };
