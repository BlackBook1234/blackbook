import 'package:black_book/models/default/message.dart';
import 'package:black_book/models/user_data/user_data.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_data_response.g.dart';

@JsonSerializable()
class UserDataResponseModel {
  UserDataModel? data;
  String status;
  MessageDefaultModel message;

  UserDataResponseModel(
      {required this.status, required this.message, this.data});
  factory UserDataResponseModel.fromJson(Map<String, dynamic> json) =>
      _$UserDataResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserDataResponseModelToJson(this);
}
