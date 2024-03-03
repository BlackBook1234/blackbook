import 'package:black_book/models/default/message.dart';
import 'package:black_book/models/upload/upload_detial.dart';
import 'package:json_annotation/json_annotation.dart';

part 'upload_response.g.dart';

@JsonSerializable()
class UploadResponseModel {
  MessageDefaultModel message;
  String status;
  UploadDetialModel?  data;

  UploadResponseModel(
      {required this.status, required this.message, this.data});
  factory UploadResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UploadResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$UploadResponseModelToJson(this);
}
