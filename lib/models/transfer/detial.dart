// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'product.dart';

part "detial.g.dart";

@JsonSerializable()
class TransferItem {
  String? tid, description;
  String? status;
  String? status_text;
  // int? status_user_id;
  String? transfer_keyword, store_name, created_at, transfer_type;
  int? total_count;
  int? total_cost, store_id;
  int? total_price;
  List<TransferProduct>? products;
  bool? isShowConfirmation;

  TransferItem(
      {this.tid,
      this.description,
      this.status_text,
      this.transfer_type,
      this.store_id,
      this.isShowConfirmation,
      this.store_name,
      this.status,
      this.created_at,
      // this.status_user_id,
      this.transfer_keyword,
      this.total_count,
      this.total_cost,
      this.total_price,
      this.products});

  factory TransferItem.fromJson(Map<String, dynamic> json) =>
      _$TransferItemFromJson(json);

  Map<String, dynamic> toJson() => _$TransferItemToJson(this);
}
