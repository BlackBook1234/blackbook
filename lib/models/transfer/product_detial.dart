
import 'package:json_annotation/json_annotation.dart';
part "product_detial.g.dart";
@JsonSerializable()
class TransferProductSize {
  int? cost;
  int? product_id;
  int? price;
  int? stock;
  int? transfer_id;
  String? type;

  TransferProductSize({
    this.cost,
    this.product_id,
    this.price,
    this.stock,
    this.transfer_id,
    this.type,
  });

  factory TransferProductSize.fromJson(Map<String, dynamic> json) =>
      _$TransferProductSizeFromJson(json);

  Map<String, dynamic> toJson() => _$TransferProductSizeToJson(this);
}
