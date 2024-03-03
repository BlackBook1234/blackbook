import 'package:json_annotation/json_annotation.dart';
part 'message.g.dart';

@JsonSerializable()
class MessageDefaultModel {
  bool show;
  String? text;
  String? reason;

  MessageDefaultModel({required this.show, required this.text,this.reason});
  factory MessageDefaultModel.fromJson(Map<String, dynamic> json) =>
      _$MessageDefaultModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageDefaultModelToJson(this);
}
