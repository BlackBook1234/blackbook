// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
import 'price_money_types.dart';
part 'total.g.dart';

@JsonSerializable()
class TotalSaleModel {
  int? cost, price, income, count;
  List<TotalDetialSaleModel>? price_money_types;

  TotalSaleModel(
      {this.cost, this.price, this.price_money_types, this.income, this.count});
  factory TotalSaleModel.fromJson(Map<String, dynamic> json) =>
      _$TotalSaleModelFromJson(json);
  Map<String, dynamic> toJson() => _$TotalSaleModelToJson(this);
}
