import 'package:black_book/models/default/message.dart';
import 'package:json_annotation/json_annotation.dart';
import 'category_detial.dart';

part 'category_response.g.dart';

@JsonSerializable()
class CategoryResponseModel {
  MessageDefaultModel message;
  String status;
  List<CategoryDetialModel>?  data;

  CategoryResponseModel(
      {required this.status, required this.message, this.data});
  factory CategoryResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryResponseModelToJson(this);
}
