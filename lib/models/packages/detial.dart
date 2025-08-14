import 'package:json_annotation/json_annotation.dart';

part 'detial.g.dart';

@JsonSerializable()
class PackagesDetial {
  int? oldAmount, amount, period;
  String? key, title, image;
  String? description;

  PackagesDetial({this.amount, this.oldAmount, this.image, this.description, this.title, this.period, this.key});
  factory PackagesDetial.fromJson(Map<String, dynamic> json) => _$PackagesDetialFromJson(json);
  Map<String, dynamic> toJson() => _$PackagesDetialToJson(this);
}
