// ignore_for_file: non_constant_identifier_names

import 'package:black_book/models/default/message.dart';
import 'package:json_annotation/json_annotation.dart';

part "response.g.dart";

@JsonSerializable()
class SummeryResponse {
  SummeryDetial? data;
  MessageDefaultModel message;
  String status;

  SummeryResponse({this.data, required this.message, required this.status});

  factory SummeryResponse.fromJson(Map<String, dynamic> json) =>
      _$SummeryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$SummeryResponseToJson(this);
}

@JsonSerializable()
class Store {
  final int id;
  final String name;
  final String phone_number;
  final int total_balance;
  final int total_cost;
  final int total_price;

  Store({
    required this.id,
    required this.name,
    required this.phone_number,
    required this.total_balance,
    required this.total_cost,
    required this.total_price,
  });

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
  Map<String, dynamic> toJson() => _$StoreToJson(this);
}

@JsonSerializable()
class Total {
  final String text;
  final int total_balance;
  final int total_cost;
  final int total_price;

  Total({
    required this.text,
    required this.total_balance,
    required this.total_cost,
    required this.total_price,
  });

  factory Total.fromJson(Map<String, dynamic> json) => _$TotalFromJson(json);
  Map<String, dynamic> toJson() => _$TotalToJson(this);
}

@JsonSerializable()
class SummeryDetial {
  final List<Store>? stores;
  final Total store_total;
  final Total warehouse_total;
  final Total all_total;

  SummeryDetial(
      {this.stores,
      required this.store_total,
      required this.warehouse_total,
      required this.all_total});

  factory SummeryDetial.fromJson(Map<String, dynamic> json) =>
      _$SummeryDetialFromJson(json);
  Map<String, dynamic> toJson() => _$SummeryDetialToJson(this);
}
