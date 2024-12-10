// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_money_types.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TotalDetialSaleModel _$TotalDetialSaleModelFromJson(
        Map<String, dynamic> json) =>
    TotalDetialSaleModel(
      amount: (json['amount'] as num?)?.toInt(),
      name: json['name'] as String?,
    );

Map<String, dynamic> _$TotalDetialSaleModelToJson(
        TotalDetialSaleModel instance) =>
    <String, dynamic>{
      'amount': instance.amount,
      'name': instance.name,
    };
