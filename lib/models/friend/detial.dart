import 'package:json_annotation/json_annotation.dart';

import 'list.dart';
import 'status.dart';
part 'detial.g.dart';
@JsonSerializable()
class PhoneNumber {
  List<PhoneNumberList>? list;
  StatusNames? statusNames;

  PhoneNumber({
    this.statusNames,
    this.list,
  });

  factory PhoneNumber.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberFromJson(json);
  Map<String, dynamic> toJson() => _$PhoneNumberToJson(this);
}
