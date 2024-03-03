// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'category_detial.g.dart';

@JsonSerializable()
class CategoryDetialModel {
  String? name, sort_order, parent, created_at, parent_name;
  int? id;

  CategoryDetialModel(
      {this.name,
      this.sort_order,
      this.id,
      this.created_at,
      this.parent,
      this.parent_name});
  factory CategoryDetialModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryDetialModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryDetialModelToJson(this);
}
