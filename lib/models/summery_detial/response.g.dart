// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SummeryResponse _$SummeryResponseFromJson(Map<String, dynamic> json) =>
    SummeryResponse(
      data: json['data'] == null
          ? null
          : SummeryDetial.fromJson(json['data'] as Map<String, dynamic>),
      message:
          MessageDefaultModel.fromJson(json['message'] as Map<String, dynamic>),
      status: json['status'] as String,
    );

Map<String, dynamic> _$SummeryResponseToJson(SummeryResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'message': instance.message,
      'status': instance.status,
    };

Store _$StoreFromJson(Map<String, dynamic> json) => Store(
      id: (json['id'] as num).toInt(),
      name: json['name'] as String,
      phone_number: json['phone_number'] as String,
      total_balance: (json['total_balance'] as num).toInt(),
      total_cost: (json['total_cost'] as num).toInt(),
      total_price: (json['total_price'] as num).toInt(),
    );

Map<String, dynamic> _$StoreToJson(Store instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'phone_number': instance.phone_number,
      'total_balance': instance.total_balance,
      'total_cost': instance.total_cost,
      'total_price': instance.total_price,
    };

Total _$TotalFromJson(Map<String, dynamic> json) => Total(
      text: json['text'] as String,
      total_balance: (json['total_balance'] as num).toInt(),
      total_cost: (json['total_cost'] as num).toInt(),
      total_price: (json['total_price'] as num).toInt(),
    );

Map<String, dynamic> _$TotalToJson(Total instance) => <String, dynamic>{
      'text': instance.text,
      'total_balance': instance.total_balance,
      'total_cost': instance.total_cost,
      'total_price': instance.total_price,
    };

SummeryDetial _$SummeryDetialFromJson(Map<String, dynamic> json) =>
    SummeryDetial(
      stores: (json['stores'] as List<dynamic>?)
          ?.map((e) => Store.fromJson(e as Map<String, dynamic>))
          .toList(),
      store_total: Total.fromJson(json['store_total'] as Map<String, dynamic>),
      warehouse_total:
          Total.fromJson(json['warehouse_total'] as Map<String, dynamic>),
      all_total: Total.fromJson(json['all_total'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SummeryDetialToJson(SummeryDetial instance) =>
    <String, dynamic>{
      'stores': instance.stores,
      'store_total': instance.store_total,
      'warehouse_total': instance.warehouse_total,
      'all_total': instance.all_total,
    };
