import 'package:black_book/models/default/message.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:json_annotation/json_annotation.dart';
import 'product_detial.dart';
import 'store_amount.dart';
part 'response.g.dart';

@JsonSerializable()
class ProductResponseModel {
  MessageDefaultModel message;
  String status;
  List<ProductDetialModel>? data;
  List<ProductStoreModel>? stores;
  StoreAmountModel? amount;

  ProductResponseModel(
      {required this.status, required this.message, this.data, this.stores,this.amount});
  factory ProductResponseModel.fromJson(Map<String, dynamic> json) =>
      _$ProductResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductResponseModelToJson(this);
}
