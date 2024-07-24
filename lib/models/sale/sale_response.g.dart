// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MainSaleProductResponseModel _$MainSaleProductResponseModelFromJson(
        Map<String, dynamic> json) =>
    MainSaleProductResponseModel(
      status: json['status'] as String,
      message:
          MessageDefaultModel.fromJson(json['message'] as Map<String, dynamic>),
      data: json['data'] == null
          ? null
          : DetialSaleProductModel.fromJson(
              json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$MainSaleProductResponseModelToJson(
        MainSaleProductResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'data': instance.data,
    };
