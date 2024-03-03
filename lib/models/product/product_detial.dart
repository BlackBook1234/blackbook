// ignore_for_file: non_constant_identifier_names
import 'package:black_book/models/sale/total.dart';
import 'package:json_annotation/json_annotation.dart';

import 'product_inlist.dart';
part 'product_detial.g.dart';

@JsonSerializable()
class ProductDetialModel {
  String? name,
      code,
      photo,
      category_name,
      parent_category,
      parent_name,
      created_at,
      good_id;
  int? category_id;
  List<ProductInDetialModel>? sizes;
  TotalSaleModel? total;

  ProductDetialModel(
      {this.name,
      this.code,
      this.total,
      this.photo,
      this.category_id,
      this.category_name,
      this.created_at,
      this.parent_category,
      this.parent_name,
      this.good_id,
      this.sizes});
  factory ProductDetialModel.fromJson(Map<String, dynamic> json) =>
      _$ProductDetialModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductDetialModelToJson(this);
}
