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
      countryCode: (json['countryCode'] as num?)?.toInt(),
      active: (json['active'] as num?)?.toInt(),
      avatar: json['avatar'] as String?,
      paymentExpireDate: json['paymentExpireDate'] as String?,
      email: json['email'] as String?,
      mustUpdate: json['mustUpdate'] as String?,
      isPaid: (json['isPaid'] as num?)?.toInt(),
      lastName: json['lastName'] as String?,
      phone: json['phone'] as String?,
      position: json['position'] as String?,
      type: json['type'] as String?,
      userId: (json['userId'] as num?)?.toInt(),
      deviceType: json['deviceType'] as String?,
      isAdmin: (json['isAdmin'] as num?)?.toInt(),
      storeId: (json['storeId'] as num?)?.toInt(),
      refreshToken: json['refreshToken'] as String?,
      tenantId: (json['tenantId'] as num?)?.toInt(),
      isRegistration: json['isRegistration'] as bool?,
      payment_end_date: json['payment_end_date'] as String?,
      tenantName: json['tenantName'] as String?,
    )..isWarehouse = (json['isWarehouse'] as num?)?.toInt();

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
      'paymentExpireDate': instance.paymentExpireDate,
      'mustUpdate': instance.mustUpdate,
      'payment_end_date': instance.payment_end_date,
      'type': instance.type,
      'active': instance.active,
      'userId': instance.userId,
      'isWarehouse': instance.isWarehouse,
      'tenantId': instance.tenantId,
      'countryCode': instance.countryCode,
      'isAdmin': instance.isAdmin,
      'storeId': instance.storeId,
      'isPaid': instance.isPaid,
      'isRegistration': instance.isRegistration,
    };
