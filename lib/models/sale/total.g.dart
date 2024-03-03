// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalSaleModel _$TotalSaleModelFromJson(Map<String, dynamic> json) =>
    TotalSaleModel(
      cost: json['cost'] as int?,
      price: json['price'] as int?,
      price_money_types: (json['price_money_types'] as List<dynamic>?)
          ?.map((e) => TotalDetialSaleModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TotalSaleModelToJson(TotalSaleModel instance) =>
    <String, dynamic>{
      'cost': instance.cost,
      'price': instance.price,
      'price_money_types': instance.price_money_types,
    };
