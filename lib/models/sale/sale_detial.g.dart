// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sale_detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DetialSaleProductModel _$DetialSaleProductModelFromJson(
        Map<String, dynamic> json) =>
    DetialSaleProductModel(
      date: json['date'] as String?,
      list: (json['list'] as List<dynamic>?)
          ?.map((e) => SaleListModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      total: json['total'] == null
          ? null
          : TotalSaleModel.fromJson(json['total'] as Map<String, dynamic>),
      stores: (json['stores'] as List<dynamic>?)
          ?.map((e) => StoreDetialModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      warehouse: json['warehouse'] == null
          ? null
          : SaleListWarehouseModel.fromJson(
              json['warehouse'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$DetialSaleProductModelToJson(
        DetialSaleProductModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'list': instance.list,
      'total': instance.total,
      'stores': instance.stores,
      'warehouse': instance.warehouse,
    };
