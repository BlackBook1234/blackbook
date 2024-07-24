// ignore_for_file: non_constant_identifier_names
import 'package:json_annotation/json_annotation.dart';
part 'amount.g.dart';

@JsonSerializable()
class AmountModel {
  int? total_cost, total_income, total_price;

  AmountModel({this.total_cost, this.total_income, this.total_price});
  factory AmountModel.fromJson(Map<String, dynamic> json) =>
      _$AmountModelFromJson(json);
  Map<String, dynamic> toJson() => _$AmountModelToJson(this);
}
