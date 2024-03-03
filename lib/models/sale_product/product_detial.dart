// ignore_for_file: non_constant_identifier_names

import 'package:black_book/models/sale/total.dart';
import 'package:black_book/models/sale_product/product_in_detial.dart';
import 'package:black_book/models/store/store_detial.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product_detial.g.dart';

@JsonSerializable()
class SaleProductDetialModel {
  List<SaleProductInDetialModel>? list;
  List<StoreDetialModel>? stores;
  TotalSaleModel? total;

  SaleProductDetialModel({this.list, this.stores, this.total});
  factory SaleProductDetialModel.fromJson(Map<String, dynamic> json) =>
      _$SaleProductDetialModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaleProductDetialModelToJson(this);
}
