// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'total.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalProductModel _$TotalProductModelFromJson(Map<String, dynamic> json) =>
    TotalProductModel(
      count: json['count'] as int,
      balance: json['balance'] as int,
      cost: json['cost'] as int,
      price: json['price'] as int,
    );

Map<String, dynamic> _$TotalProductModelToJson(TotalProductModel instance) =>
    <String, dynamic>{
      'count': instance.count,
      'balance': instance.balance,
      'cost': instance.cost,
      'price': instance.price,
    };
