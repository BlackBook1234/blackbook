// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferResponse _$TransferResponseFromJson(Map<String, dynamic> json) =>
    TransferResponse(
      status: json['status'] as String,
      message:
          MessageDefaultModel.fromJson(json['message'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TransferDetial.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransferResponseToJson(TransferResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'data': instance.data,
    };
