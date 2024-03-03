// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferDetial _$TransferDetialFromJson(Map<String, dynamic> json) =>
    TransferDetial(
      transfer_id: json['transfer_id'] as int?,
      price: json['price'] as int?,
      product_code: json['product_code'] as String?,
      product_id: json['product_id'] as int?,
      product_name: json['product_name'] as String?,
      cost: json['cost'] as int?,
      created_at: json['created_at'] as String?,
      good_id: json['good_id'] as String?,
      stock: json['stock'] as int?,
      store_id: json['store_id'] as int?,
      store_name: json['store_name'] as String?,
      transfer_keyword: json['transfer_keyword'] as String?,
      transfer_type: json['transfer_type'] as String?,
      type: json['type'] as String?,
    );

Map<String, dynamic> _$TransferDetialToJson(TransferDetial instance) =>
    <String, dynamic>{
      'transfer_id': instance.transfer_id,
      'product_id': instance.product_id,
      'cost': instance.cost,
      'price': instance.price,
      'stock': instance.stock,
      'store_id': instance.store_id,
      'product_name': instance.product_name,
      'product_code': instance.product_code,
      'good_id': instance.good_id,
      'type': instance.type,
      'store_name': instance.store_name,
      'created_at': instance.created_at,
      'transfer_type': instance.transfer_type,
      'transfer_keyword': instance.transfer_keyword,
    };
