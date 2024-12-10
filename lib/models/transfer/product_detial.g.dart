// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferProductSize _$TransferProductSizeFromJson(Map<String, dynamic> json) =>
    TransferProductSize(
      cost: (json['cost'] as num?)?.toInt(),
      product_id: (json['product_id'] as num?)?.toInt(),
      price: (json['price'] as num?)?.toInt(),
      stock: (json['stock'] as num?)?.toInt(),
      transfer_id: (json['transfer_id'] as num?)?.toInt(),
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
