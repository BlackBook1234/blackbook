// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleListModel _$SaleListModelFromJson(Map<String, dynamic> json) =>
    SaleListModel(
      store_id: json['store_id'] as int?,
      phone_number: json['phone_number'] as String?,
      store_name: json['store_name'] as String?,
      total_cost: json['total_cost'] as int?,
      total_price: json['total_price'] as int?,
    );

Map<String, dynamic> _$SaleListModelToJson(SaleListModel instance) =>
    <String, dynamic>{
      'store_id': instance.store_id,
      'total_cost': instance.total_cost,
      'total_price': instance.total_price,
      'store_name': instance.store_name,
      'phone_number': instance.phone_number,
    };
