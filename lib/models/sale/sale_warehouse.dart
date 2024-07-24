// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'sale_warehouse.g.dart';

@JsonSerializable()
class SaleListWarehouseModel {
  int? total_cost, total_price;
  String? name;

  SaleListWarehouseModel({this.total_cost, this.total_price});
  factory SaleListWarehouseModel.fromJson(Map<String, dynamic> json) =>
      _$SaleListWarehouseModelFromJson(json);
  Map<String, dynamic> toJson() => _$SaleListWarehouseModelToJson(this);
}
