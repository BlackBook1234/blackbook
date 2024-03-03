import 'package:json_annotation/json_annotation.dart';

part 'detial.g.dart';

@JsonSerializable()
class TransferDetial {
  int? transfer_id, product_id, cost, price, stock, store_id;
  String? product_name,
      product_code,
      good_id,
      type,
      store_name,
      created_at,
      transfer_type,
      transfer_keyword;

  TransferDetial(
      {this.transfer_id,
      this.price,
      this.product_code,
      this.product_id,
      this.product_name,
      this.cost,
      this.created_at,
      this.good_id,
      this.stock,
      this.store_id,
      this.store_name,
      this.transfer_keyword,
      this.transfer_type,
      this.type});
  factory TransferDetial.fromJson(Map<String, dynamic> json) =>
      _$TransferDetialFromJson(json);
  Map<String, dynamic> toJson() => _$TransferDetialToJson(this);
}
