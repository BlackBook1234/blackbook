// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

InvitationResponse _$InvitationResponseFromJson(Map<String, dynamic> json) =>
    InvitationResponse(
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => InvitationDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$InvitationResponseToJson(InvitationResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
    };

InvitationDetail _$InvitationDetailFromJson(Map<String, dynamic> json) =>
    InvitationDetail(
      countryCode: json['countryCode'] as String,
      phoneNumber: json['phoneNumber'] as String,
      text: json['text'] as String,
      date: json['date'] as String,
      id: (json['id'] as num).toInt(),
    );

Map<String, dynamic> _$InvitationDetailToJson(InvitationDetail instance) =>
    <String, dynamic>{
      'countryCode': instance.countryCode,
      'phoneNumber': instance.phoneNumber,
      'text': instance.text,
      'date': instance.date,
      'id': instance.id,
    };
