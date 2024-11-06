// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'status.g.dart';
@JsonSerializable()
class StatusNames {
  String? APPROVED, DECLINED, PENDING;

  StatusNames({this.APPROVED, this.DECLINED, this.PENDING});

  factory StatusNames.fromJson(Map<String, dynamic> json) =>
      _$StatusNamesFromJson(json);
  Map<String, dynamic> toJson() => _$StatusNamesToJson(this);
}
