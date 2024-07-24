import 'package:black_book/models/default/message.dart';
import 'package:json_annotation/json_annotation.dart';
import 'detial.dart';

part 'response.g.dart';

@JsonSerializable()
class NotficationResponse {
  MessageDefaultModel message;
  String status;
  int? total, unseen;
  List<NotificationDetail>? data;

  NotficationResponse(
      {required this.status,
      required this.message,
      this.data,
      this.total,
      this.unseen});
  factory NotficationResponse.fromJson(Map<String, dynamic> json) =>
      _$NotficationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$NotficationResponseToJson(this);
}
