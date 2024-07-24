import 'package:black_book/models/default/message.dart';
import 'package:black_book/models/product/product_store.dart';
import 'package:json_annotation/json_annotation.dart';

import 'detial.dart';

part 'response.g.dart';

@JsonSerializable()
class TransferDataResponse {
  List<TransferItem>? data;
  MessageDefaultModel message;
  String status;
  List<ProductStoreModel>? stores;

  TransferDataResponse(
      {this.data, required this.message, required this.status, this.stores});

  factory TransferDataResponse.fromJson(Map<String, dynamic> json) =>
      _$TransferDataResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TransferDataResponseToJson(this);
}
