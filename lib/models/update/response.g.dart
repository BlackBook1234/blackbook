// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UpdateStatusResponse _$UpdateStatusResponseFromJson(
        Map<String, dynamic> json) =>
    UpdateStatusResponse(
      status: json['status'] as String,
      message:
          MessageDefaultModel.fromJson(json['message'] as Map<String, dynamic>),
      data: UpdateStatusDetial.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UpdateStatusResponseToJson(
        UpdateStatusResponse instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
      'data': instance.data,
    };

UpdateStatusDetial _$UpdateStatusDetialFromJson(Map<String, dynamic> json) =>
    UpdateStatusDetial(
      mustUpdate: json['mustUpdate'] as bool,
      updateVersion: json['updateVersion'] as String,
    );

Map<String, dynamic> _$UpdateStatusDetialToJson(UpdateStatusDetial instance) =>
    <String, dynamic>{
      'mustUpdate': instance.mustUpdate,
      'updateVersion': instance.updateVersion,
    };
