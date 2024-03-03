import 'package:json_annotation/json_annotation.dart';

part 'detial.g.dart';

@JsonSerializable()
class PackagesDetial {
  int? amount, period;
  String? description, key, title;

  PackagesDetial(
      {this.amount, this.description, this.title, this.period, this.key});
  factory PackagesDetial.fromJson(Map<String, dynamic> json) =>
      _$PackagesDetialFromJson(json);
  Map<String, dynamic> toJson() => _$PackagesDetialToJson(this);
}
