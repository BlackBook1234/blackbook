// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleListModel _$SaleListModelFromJson(Map<String, dynamic> json) =>
    SaleListModel(
      store_id: (json['store_id'] as num?)?.toInt(),
      phone_number: json['phone_number'] as String?,
      store_name: json['store_name'] as String?,
      total_cost: (json['total_cost'] as num?)?.toInt(),
      total_price_sell: (json['total_price_sell'] as num?)?.toInt(),
      total_price: (json['total_price'] as num?)?.toInt(),
    );

Map<String, dynamic> _$SaleListModelToJson(SaleListModel instance) =>
    <String, dynamic>{
      'store_id': instance.store_id,
      'total_cost': instance.total_cost,
      'total_price': instance.total_price,
      'total_price_sell': instance.total_price_sell,
      'store_name': instance.store_name,
      'phone_number': instance.phone_number,
    };
