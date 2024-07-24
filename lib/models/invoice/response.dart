import 'package:black_book/models/default/message.dart';
import 'package:json_annotation/json_annotation.dart';
import 'detial.dart';

part 'response.g.dart';

@JsonSerializable()
class InvoiceResponse {
  MessageDefaultModel message;
  String status;
  InvoiceDetial? data;

  InvoiceResponse({required this.status, required this.message, this.data});
  factory InvoiceResponse.fromJson(Map<String, dynamic> json) =>
      _$InvoiceResponseFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceResponseToJson(this);
}
