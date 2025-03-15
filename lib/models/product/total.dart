import 'package:json_annotation/json_annotation.dart';
part 'total.g.dart';

@JsonSerializable()
class TotalProductModel {
  int count, balance, cost, price; //TODO

  TotalProductModel(
      {required this.count,
      required this.balance,
      required this.cost,
      required this.price});
  factory TotalProductModel.fromJson(Map<String, dynamic> json) =>
      _$TotalProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$TotalProductModelToJson(this);
}
