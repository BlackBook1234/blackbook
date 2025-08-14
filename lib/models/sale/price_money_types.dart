// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'price_money_types.g.dart';

@JsonSerializable()
class TotalDetialSaleModel {
  int? amount, amount_sell;
  String? name;

  TotalDetialSaleModel({this.amount, this.name, this.amount_sell});
  factory TotalDetialSaleModel.fromJson(Map<String, dynamic> json) => _$TotalDetialSaleModelFromJson(json);
  Map<String, dynamic> toJson() => _$TotalDetialSaleModelToJson(this);
}
