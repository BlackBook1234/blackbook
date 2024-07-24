import 'package:black_book/models/store/store_detial.dart';
import 'package:json_annotation/json_annotation.dart';
import 'sale_list.dart';
import 'sale_warehouse.dart';
import 'total.dart';
part 'sale_detial.g.dart';

@JsonSerializable()
class DetialSaleProductModel {
  String? date;
  List<SaleListModel>? list;
  TotalSaleModel? total;
  List<StoreDetialModel>? stores;
  SaleListWarehouseModel? warehouse;

  DetialSaleProductModel({this.date, this.list, this.total, this.stores,this.warehouse});
  factory DetialSaleProductModel.fromJson(Map<String, dynamic> json) =>
      _$DetialSaleProductModelFromJson(json);
  Map<String, dynamic> toJson() => _$DetialSaleProductModelToJson(this);
}
