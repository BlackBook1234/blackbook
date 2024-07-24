import 'package:json_annotation/json_annotation.dart';

part 'manual.g.dart';

@JsonSerializable()
class Manual {
  int? amount;
  String? account, accountName, comment, description, iconUrl, name;

  Manual({this.amount, this.account, this.accountName, this.description, this.iconUrl,this.comment,this.name});
  factory Manual.fromJson(Map<String, dynamic> json) => _$ManualFromJson(json);
  Map<String, dynamic> toJson() => _$ManualToJson(this);
}
