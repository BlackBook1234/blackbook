// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'authentication.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthenticationResponseModel _$AuthenticationResponseModelFromJson(
        Map<String, dynamic> json) =>
    AuthenticationResponseModel(
      status: json['status'] as String,
      message:
          MessageDefaultModel.fromJson(json['message'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AuthenticationResponseModelToJson(
        AuthenticationResponseModel instance) =>
    <String, dynamic>{
      'status': instance.status,
      'message': instance.message,
    };
