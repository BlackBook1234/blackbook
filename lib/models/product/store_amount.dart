// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'store_amount.g.dart';

@JsonSerializable()
class StoreAmountModel {
  int? total_cost, total_price;

  StoreAmountModel({this.total_cost, this.total_price});
  factory StoreAmountModel.fromJson(Map<String, dynamic> json) =>
      _$StoreAmountModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoreAmountModelToJson(this);
}
