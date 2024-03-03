import 'package:json_annotation/json_annotation.dart';

part 'store_detial.g.dart';

@JsonSerializable()
class StoreDetialModel {
  // ignore: non_constant_identifier_names
  String? name, phone_number, created_at;
  // ignore: non_constant_identifier_names
  int? is_main, id;

  @JsonKey(ignore: true)
  bool isChecked = false;

  StoreDetialModel(
      {this.name,
      this.id,
      // ignore: non_constant_identifier_names
      this.phone_number,
      // ignore: non_constant_identifier_names
      this.created_at,
      // ignore: non_constant_identifier_names
      this.is_main});
  factory StoreDetialModel.fromJson(Map<String, dynamic> json) =>
      _$StoreDetialModelFromJson(json);
  Map<String, dynamic> toJson() => _$StoreDetialModelToJson(this);
}
