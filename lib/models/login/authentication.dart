import 'package:black_book/models/default/message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'authentication.g.dart';

@JsonSerializable()
class AuthenticationResponseModel {
  String status;
  MessageDefaultModel message;

  AuthenticationResponseModel({required this.status, required this.message});
  factory AuthenticationResponseModel.fromJson(Map<String, dynamic> json) =>
      _$AuthenticationResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$AuthenticationResponseModelToJson(this);
}
