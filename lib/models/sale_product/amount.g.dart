// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'amount.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AmountModel _$AmountModelFromJson(Map<String, dynamic> json) => AmountModel(
      total_cost: (json['total_cost'] as num?)?.toInt(),
      total_income: (json['total_income'] as num?)?.toInt(),
      total_price: (json['total_price'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AmountModelToJson(AmountModel instance) =>
    <String, dynamic>{
      'total_cost': instance.total_cost,
      'total_income': instance.total_income,
      'total_price': instance.total_price,
    };
