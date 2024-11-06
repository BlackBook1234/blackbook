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
      income: json['income'] as int?,
      count: json['count'] as int?,
    );

Map<String, dynamic> _$TotalSaleModelToJson(TotalSaleModel instance) =>
    <String, dynamic>{
      'cost': instance.cost,
      'price': instance.price,
      'income': instance.income,
      'count': instance.count,
      'price_money_types': instance.price_money_types,
    };
