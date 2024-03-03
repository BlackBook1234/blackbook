import 'package:black_book/models/banner/detial.dart';
import 'package:black_book/models/default/message.dart';
import 'package:json_annotation/json_annotation.dart';

part 'response.g.dart';

@JsonSerializable()
class BannerResponse {
  MessageDefaultModel message;
  String status;
  List<BannerDetial>?  data;

  BannerResponse(
      {required this.status, required this.message, this.data});
  factory BannerResponse.fromJson(Map<String, dynamic> json) =>
      _$BannerResponseFromJson(json);
  Map<String, dynamic> toJson() => _$BannerResponseToJson(this);
}
