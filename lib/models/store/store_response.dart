import 'package:black_book/models/default/message.dart';
import 'package:json_annotation/json_annotation.dart';
import 'store_detial.dart';

part 'store_response.g.dart';

@JsonSerializable()
class StoreResponseModel {
  MessageDefaultModel message;
  String status;
  List<StoreDetialModel>?  data;

  StoreResponseModel(
      {required this.status, required this.message, this.data});
  factory StoreResponseModel.fromJson(Map<String, dynamic> json) =>
      _$StoreResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoreResponseModelToJson(this);
}
