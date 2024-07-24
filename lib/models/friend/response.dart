import 'package:black_book/models/default/message.dart';
import 'package:json_annotation/json_annotation.dart';
import 'detial.dart';

part 'response.g.dart';

@JsonSerializable()
class PackagesResponse {
  MessageDefaultModel message;
  String status;
  PhoneNumber? data;

  PackagesResponse({required this.status, required this.message, this.data});
  factory PackagesResponse.fromJson(Map<String, dynamic> json) =>
      _$PackagesResponseFromJson(json);
  Map<String, dynamic> toJson() => _$PackagesResponseToJson(this);
}
