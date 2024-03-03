import 'package:json_annotation/json_annotation.dart';

part 'detial.g.dart';

@JsonSerializable()
class BannerDetial {
  String? action, path, title, url;

  BannerDetial({this.action, this.path, this.title, this.url});
  factory BannerDetial.fromJson(Map<String, dynamic> json) =>
      _$BannerDetialFromJson(json);
  Map<String, dynamic> toJson() => _$BannerDetialToJson(this);
}
