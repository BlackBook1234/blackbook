import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class InvitationResponse {
  List<InvitationDetail>? data;

  InvitationResponse({this.data});
  factory InvitationResponse.fromJson(Map<String, dynamic> json) =>
      _$InvitationResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InvitationResponseToJson(this);
}

@JsonSerializable()
class InvitationDetail {
  String countryCode, phoneNumber, text, date;
  int id;

  InvitationDetail(
      {required this.countryCode,
      required this.phoneNumber,
      required this.text,
      required this.date,
      required this.id});
  factory InvitationDetail.fromJson(Map<String, dynamic> json) =>
      _$InvitationDetailFromJson(json);
  Map<String, dynamic> toJson() => _$InvitationDetailToJson(this);
}
