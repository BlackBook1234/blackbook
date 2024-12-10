// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PhoneNumberList _$PhoneNumberListFromJson(Map<String, dynamic> json) =>
    PhoneNumberList(
      country_code: json['country_code'] as String?,
      has_color: json['has_color'] as String?,
      has_line: (json['has_line'] as num?)?.toInt(),
      phone_number: json['phone_number'] as String?,
      created_at: json['created_at'] as String?,
      line_amount: (json['line_amount'] as num?)?.toInt(),
      line_text: json['line_text'] as String?,
      status: json['status'] as String?,
      status_text: json['status_text'] as String?,
    );

Map<String, dynamic> _$PhoneNumberListToJson(PhoneNumberList instance) =>
    <String, dynamic>{
      'country_code': instance.country_code,
      'phone_number': instance.phone_number,
      'status': instance.status,
      'created_at': instance.created_at,
      'status_text': instance.status_text,
      'line_text': instance.line_text,
      'has_color': instance.has_color,
      'has_line': instance.has_line,
      'line_amount': instance.line_amount,
    };
