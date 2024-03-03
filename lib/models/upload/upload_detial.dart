import 'package:json_annotation/json_annotation.dart';

part 'upload_detial.g.dart';

@JsonSerializable()
class UploadDetialModel {
  String? url;

  UploadDetialModel({this.url});
  factory UploadDetialModel.fromJson(Map<String, dynamic> json) =>
      _$UploadDetialModelFromJson(json);
  Map<String, dynamic> toJson() => _$UploadDetialModelToJson(this);
}
