// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NotificationDetail _$NotificationDetailFromJson(Map<String, dynamic> json) =>
    NotificationDetail(
      id: json['id'] as int?,
      sourceType: json['source_type'] as String?,
      sourceId: json['source_id'] as String?,
      type: json['type'] as String?,
      userId: json['user_id'] as int?,
      title: json['title'] as String?,
      body: json['body'] as String?,
      isSeen: json['is_seen'] as int?,
      seenAt: json['seen_at'] as String?,
      isTrashed: json['is_trashed'] as bool?,
      trashedAt: json['trashed_at'] as String?,
      createdAt: json['created_at'] as String?,
    );

Map<String, dynamic> _$NotificationDetailToJson(NotificationDetail instance) =>
    <String, dynamic>{
      'id': instance.id,
      'source_type': instance.sourceType,
      'source_id': instance.sourceId,
      'type': instance.type,
      'user_id': instance.userId,
      'title': instance.title,
      'body': instance.body,
      'is_seen': instance.isSeen,
      'seen_at': instance.seenAt,
      'is_trashed': instance.isTrashed,
      'trashed_at': instance.trashedAt,
      'created_at': instance.createdAt,
    };
