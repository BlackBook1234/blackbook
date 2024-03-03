import 'package:black_book/models/default/message.dart';
import 'package:json_annotation/json_annotation.dart';
import 'product_detial.dart';
part 'product_response.g.dart';

@JsonSerializable()
class SaleProductResponseModel {
  MessageDefaultModel message;
  String status;
  SaleProductDetialModel? data;

  SaleProductResponseModel(
      {required this.status, required this.message, this.data});
  factory SaleProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$SaleProductResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaleProductResponseModelToJson(this);
}
