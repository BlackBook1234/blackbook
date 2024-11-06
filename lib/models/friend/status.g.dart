// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'status.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StatusNames _$StatusNamesFromJson(Map<String, dynamic> json) => StatusNames(
      APPROVED: json['APPROVED'] as String?,
      DECLINED: json['DECLINED'] as String?,
      PENDING: json['PENDING'] as String?,
    );

Map<String, dynamic> _$StatusNamesToJson(StatusNames instance) =>
    <String, dynamic>{
      'APPROVED': instance.APPROVED,
      'DECLINED': instance.DECLINED,
      'PENDING': instance.PENDING,
    };
