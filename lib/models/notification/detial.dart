import 'package:json_annotation/json_annotation.dart';

part 'detial.g.dart';

@JsonSerializable()
class NotificationDetail {
  int? id;
  @JsonKey(name: 'source_type')
  String? sourceType;
  @JsonKey(name: 'source_id')
  String? sourceId;
  String? type;
  @JsonKey(name: 'user_id')
  int? userId;
  String? title;
  String? body;
  @JsonKey(name: 'is_seen')
  int? isSeen;
  @JsonKey(name: 'seen_at')
  String? seenAt;
  @JsonKey(name: 'is_trashed')
  bool? isTrashed;
  @JsonKey(name: 'trashed_at')
  String? trashedAt;
  @JsonKey(name: 'created_at')
  String? createdAt;

  NotificationDetail({
     this.id,
     this.sourceType,
     this.sourceId,
     this.type,
     this.userId,
     this.title,
     this.body,
    this.isSeen,
    this.seenAt,
    this.isTrashed,
    this.trashedAt,
     this.createdAt,
  });

  factory NotificationDetail.fromJson(Map<String, dynamic> json) =>
      _$NotificationDetailFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDetailToJson(this);
}
