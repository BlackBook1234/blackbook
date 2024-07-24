import 'package:black_book/models/default/message.dart';
import 'package:black_book/models/sale/sale_detial.dart';
import 'package:json_annotation/json_annotation.dart';
part 'sale_response.g.dart';

@JsonSerializable()
class MainSaleProductResponseModel {
  MessageDefaultModel message;
  String status;
  DetialSaleProductModel? data;

  MainSaleProductResponseModel(
      {required this.status, required this.message, this.data});
  factory MainSaleProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$MainSaleProductResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$MainSaleProductResponseModelToJson(this);
}
