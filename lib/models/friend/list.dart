// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';
part 'list.g.dart';

@JsonSerializable()
class PhoneNumberList {
  String? country_code,
      phone_number,
      status,
      created_at,
      status_text,
      line_text,
      has_color;
  int? has_line,line_amount;

  PhoneNumberList(
      {this.country_code,
      this.has_color,
      this.has_line,
      this.phone_number,
      this.created_at,
      this.line_amount,
      this.line_text,
      this.status,
      this.status_text});

  factory PhoneNumberList.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberListFromJson(json);
  Map<String, dynamic> toJson() => _$PhoneNumberListToJson(this);
}
