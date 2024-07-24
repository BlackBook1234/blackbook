// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProductResponseModel _$ProductResponseModelFromJson(
        Map<String, dynamic> json) =>
    ProductResponseModel(
      status: json['status'] as String,
      message:
          MessageDefaultModel.fromJson(json['message'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ProductDetialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      stores: (json['stores'] as List<dynamic>?)
          ?.map((e) => ProductStoreModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      amount: json['amount'] == null
          ? null
          : StoreAmountModel.fromJson(json['amount'] as Map<String, dynamic>),
    )..total =
        TotalProductModel.fromJson(json['total'] as Map<String, dynamic>);

Map<String, dynamic> _$ProductResponseModelToJson(
        ProductResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'data': instance.data,
      'stores': instance.stores,
      'amount': instance.amount,
      'total': instance.total,
    };
