// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

part 'product_in_detial.g.dart';

@JsonSerializable()
class SaleProductInDetialModel {
  String? product_name, product_code, good_id, type, store_name, store_color, money_type, product_photo, created_at;
  int? sale_id, product_id, cost, price, price_sell, stock, total_balance, warehouse_balance, store_id, is_from_warehouse;

  SaleProductInDetialModel(
      {this.cost,
      this.sale_id,
      this.is_from_warehouse,
      this.money_type,
      this.price_sell,
      this.created_at,
      this.price,
      this.product_photo,
      this.product_code,
      this.good_id,
      this.product_id,
      this.product_name,
      this.stock,
      this.store_color,
      this.store_id,
      this.store_name,
      this.total_balance,
      this.type,
      this.warehouse_balance});
  factory SaleProductInDetialModel.fromJson(Map<String, dynamic> json) => _$SaleProductInDetialModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaleProductInDetialModelToJson(this);
}
