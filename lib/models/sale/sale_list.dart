// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'sale_list.g.dart';

@JsonSerializable()
class SaleListModel {
  int? store_id, total_cost, total_price, total_price_sell;
  String? store_name, phone_number;

  SaleListModel({
    this.store_id,
    this.phone_number,
    this.store_name,
    this.total_cost,
    this.total_price_sell,
    this.total_price,
  });
  factory SaleListModel.fromJson(Map<String, dynamic> json) => _$SaleListModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaleListModelToJson(this);
}
