// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDataResponseModel _$UserDataResponseModelFromJson(
        Map<String, dynamic> json) =>
    UserDataResponseModel(
      status: json['status'] as String,
      message:
          MessageDefaultModel.fromJson(json['message'] as Map<String, dynamic>),
      data: json['data'] == null
          ? null
          : UserDataModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$UserDataResponseModelToJson(
        UserDataResponseModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'status': instance.status,
      'message': instance.message,
    };
