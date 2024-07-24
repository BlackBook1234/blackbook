import 'package:json_annotation/json_annotation.dart';
part 'list.g.dart';

@JsonSerializable()
class PhoneNumberList {
  String? country_code, phone_number, status, created_at, status_text;

  PhoneNumberList(
      {this.country_code,
      this.phone_number,
      this.created_at,
      this.status,
      this.status_text});

  factory PhoneNumberList.fromJson(Map<String, dynamic> json) =>
      _$PhoneNumberListFromJson(json);
  Map<String, dynamic> toJson() => _$PhoneNumberListToJson(this);
}
