// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PackagesResponse _$PackagesResponseFromJson(Map<String, dynamic> json) =>
    PackagesResponse(
      status: json['status'] as String,
      message:
          MessageDefaultModel.fromJson(json['message'] as Map<String, dynamic>),
      data: json['data'] == null
          ? null
          : PhoneNumber.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$PackagesResponseToJson(PackagesResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'data': instance.data,
    };
