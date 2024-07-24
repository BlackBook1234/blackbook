import 'package:black_book/models/transfer/product_detial.dart';
import 'package:json_annotation/json_annotation.dart';

part 'product.g.dart';

@JsonSerializable()
class TransferProduct {
  String? name;
  String? code;
  String? photo;
  String? good_id;
  int? count;
  List<TransferProductSize>? sizes;

  TransferProduct({
    this.name,
    this.code,
    this.photo,
    this.good_id,
    this.count,
    this.sizes,
  });

  factory TransferProduct.fromJson(Map<String, dynamic> json) =>
      _$TransferProductFromJson(json);

  Map<String, dynamic> toJson() => _$TransferProductToJson(this);
}
