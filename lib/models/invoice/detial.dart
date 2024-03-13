import 'package:json_annotation/json_annotation.dart';
import 'manual.dart';
import 'qpay.dart';

part 'detial.g.dart';

@JsonSerializable()
class InvoiceDetial {
  int? amount, period, orderId;
  String? description, title;
  Qpay? qpay;
  List<Manual>? manual;

  InvoiceDetial(
      {this.amount,
      this.period,
      this.qpay,
      this.description,
      this.title,
      this.orderId,
      this.manual});
  factory InvoiceDetial.fromJson(Map<String, dynamic> json) =>
      _$InvoiceDetialFromJson(json);
  Map<String, dynamic> toJson() => _$InvoiceDetialToJson(this);
}
