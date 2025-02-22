import 'package:black_book/models/default/message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class UpdateStatusResponse {
  String status;
  MessageDefaultModel message;
  UpdateStatusDetial data;

  UpdateStatusResponse({required this.status, required this.message, required this.data});
  factory UpdateStatusResponse.fromJson(Map<String, dynamic> json) => _$UpdateStatusResponseFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateStatusResponseToJson(this);
}

@JsonSerializable()
class UpdateStatusDetial {
  bool mustUpdate;
  String updateVersion;

  UpdateStatusDetial({required this.mustUpdate, required this.updateVersion});
  factory UpdateStatusDetial.fromJson(Map<String, dynamic> json) => _$UpdateStatusDetialFromJson(json);
  Map<String, dynamic> toJson() => _$UpdateStatusDetialToJson(this);
}
