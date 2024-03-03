// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'product_store.g.dart';

@JsonSerializable()
class ProductStoreModel {
  String? name, phone_number, created_at;
  int? is_main, id;

  ProductStoreModel(
      {this.name, this.phone_number, this.created_at, this.is_main, this.id});
  factory ProductStoreModel.fromJson(Map<String, dynamic> json) =>
      _$ProductStoreModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProductStoreModelToJson(this);
}
