// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SaleProductResponseModel _$SaleProductResponseModelFromJson(
        Map<String, dynamic> json) =>
    SaleProductResponseModel(
      status: json['status'] as String,
      message:
          MessageDefaultModel.fromJson(json['message'] as Map<String, dynamic>),
      data: json['data'] == null
          ? null
          : SaleProductDetialModel.fromJson(
              json['data'] as Map<String, dynamic>),
      total: json['total'] as int?,
    );

Map<String, dynamic> _$SaleProductResponseModelToJson(
        SaleProductResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'total': instance.total,
      'status': instance.status,
      'data': instance.data,
    };
