// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'product_inlist.g.dart';

@JsonSerializable()
class ProductInDetialModel {
  String? type, created_at, store_name;
  int? cost, price, stock, id, warehouse_stock, store_id, transfer_id;
  // ignore: deprecated_member_use
  @JsonKey(ignore: true)
  int ware_stock = 0;

  ProductInDetialModel(
      {this.type,
      this.cost,
      this.transfer_id,
      this.created_at,
      this.price,
      this.store_name,
      this.store_id,
      this.stock,
      this.warehouse_stock,
      this.id});
  factory ProductInDetialModel.fromJson(Map<String, dynamic> json) =>
      _$ProductInDetialModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductInDetialModelToJson(this);
}
