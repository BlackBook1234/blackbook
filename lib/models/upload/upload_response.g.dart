// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'upload_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UploadResponseModel _$UploadResponseModelFromJson(Map<String, dynamic> json) =>
    UploadResponseModel(
      status: json['status'] as String,
      message:
          MessageDefaultModel.fromJson(json['message'] as Map<String, dynamic>),
      data: json['data'] == null
          ? null
          : UploadDetialModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UploadResponseModelToJson(
        UploadResponseModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'data': instance.data,
    };
