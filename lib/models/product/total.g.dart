// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalProductModel _$TotalProductModelFromJson(Map<String, dynamic> json) =>
    TotalProductModel(
      count: (json['count'] as num).toInt(),
      balance: (json['balance'] as num).toInt(),
      cost: (json['cost'] as num).toInt(),
      price: (json['price'] as num).toInt(),
    );

Map<String, dynamic> _$TotalProductModelToJson(TotalProductModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'balance': instance.balance,
      'cost': instance.cost,
      'price': instance.price,
    };
