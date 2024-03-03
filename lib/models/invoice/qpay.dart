// ignore_for_file: non_constant_identifier_names

import 'package:json_annotation/json_annotation.dart';

import 'urls.dart';

part 'qpay.g.dart';

@JsonSerializable()
class Qpay {
  String? invoice_id, qr_text, qr_image, qPay_shortUrl;
  List<Urls>? urls;

  Qpay(
      {this.invoice_id,
      this.qPay_shortUrl,
      this.urls,
      this.qr_image,
      this.qr_text});
  factory Qpay.fromJson(Map<String, dynamic> json) => _$QpayFromJson(json);
  Map<String, dynamic> toJson() => _$QpayToJson(this);
}
