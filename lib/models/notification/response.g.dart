// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotficationResponse _$NotficationResponseFromJson(Map<String, dynamic> json) =>
    NotficationResponse(
      status: json['status'] as String,
      message:
          MessageDefaultModel.fromJson(json['message'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => NotificationDetail.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] as int?,
      unseen: json['unseen'] as int?,
    );

Map<String, dynamic> _$NotficationResponseToJson(
        NotficationResponse instance) =>
    <String, dynamic>{
      'message': instance.message,
      'status': instance.status,
      'total': instance.total,
      'unseen': instance.unseen,
      'data': instance.data,
    };
