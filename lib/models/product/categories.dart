import 'package:json_annotation/json_annotation.dart';
part 'categories.g.dart';

@JsonSerializable()
class CategoriesModel {
  int id, sort_order;
  String name, parent, created_at;

  CategoriesModel(
      {required this.id,
      required this.sort_order,
      required this.name,
      required this.parent,
      required this.created_at});
  factory CategoriesModel.fromJson(Map<String, dynamic> json) =>
      _$CategoriesModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoriesModelToJson(this);
}
