// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDataModel _$UserDataModelFromJson(Map<String, dynamic> json) =>
    UserDataModel(
      accessToken: json['accessToken'] as String?,
      storeName: json['storeName'] as String?,
      firstName: json['firstName'] as String?,
      countryCode: json['countryCode'] as int?,
      active: json['active'] as int?,
      avatar: json['avatar'] as String?,
      email: json['email'] as String?,
      isPaid: json['isPaid'] as int?,
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
      position: json['position'] as String?,
      type: json['type'] as String?,
      userId: json['userId'] as int?,
      deviceType: json['deviceType'] as String?,
      isAdmin: json['isAdmin'] as int?,
      storeId: json['storeId'] as int?,
      refreshToken: json['refreshToken'] as String?,
      tenantId: json['tenantId'] as int?,
      tenantName: json['tenantName'] as String?,
    );

Map<String, dynamic> _$UserDataModelToJson(UserDataModel instance) =>
    <String, dynamic>{
      'accessToken': instance.accessToken,
      'storeName': instance.storeName,
      'avatar': instance.avatar,
      'deviceType': instance.deviceType,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'phone': instance.phone,
      'position': instance.position,
      'refreshToken': instance.refreshToken,
      'tenantName': instance.tenantName,
      'type': instance.type,
      'active': instance.active,
      'userId': instance.userId,
      'tenantId': instance.tenantId,
      'countryCode': instance.countryCode,
      'isAdmin': instance.isAdmin,
      'storeId': instance.storeId,
      'isPaid': instance.isPaid,
    };
