import 'package:black_book/models/default/message.dart';
import 'package:json_annotation/json_annotation.dart';
import 'detial.dart';

part 'response.g.dart';

@JsonSerializable()
class TransferResponse {
  MessageDefaultModel message;
  String status;
  List<TransferDetial>? data;

  TransferResponse({required this.status, required this.message, this.data});
  factory TransferResponse.fromJson(Map<String, dynamic> json) =>
      _$TransferResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TransferResponseToJson(this);
}
