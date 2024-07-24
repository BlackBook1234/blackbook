// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferDataResponse _$TransferDataResponseFromJson(
        Map<String, dynamic> json) =>
    TransferDataResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TransferItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      message:
          MessageDefaultModel.fromJson(json['message'] as Map<String, dynamic>),
      status: json['status'] as String,
      stores: (json['stores'] as List<dynamic>?)
          ?.map((e) => ProductStoreModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransferDataResponseToJson(
        TransferDataResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'status': instance.status,
      'stores': instance.stores,
    };
