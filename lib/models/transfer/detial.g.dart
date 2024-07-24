// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'detial.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TransferItem _$TransferItemFromJson(Map<String, dynamic> json) => TransferItem(
      tid: json['tid'] as String?,
      description: json['description'] as String?,
      status_text: json['status_text'] as String?,
      transfer_type: json['transfer_type'] as String?,
      store_id: json['store_id'] as int?,
      isShowConfirmation: json['isShowConfirmation'] as bool?,
      store_name: json['store_name'] as String?,
      status: json['status'] as String?,
      created_at: json['created_at'] as String?,
      transfer_keyword: json['transfer_keyword'] as String?,
      total_count: json['total_count'] as int?,
      total_cost: json['total_cost'] as int?,
      total_price: json['total_price'] as int?,
      products: (json['products'] as List<dynamic>?)
          ?.map((e) => TransferProduct.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TransferItemToJson(TransferItem instance) =>
    <String, dynamic>{
      'tid': instance.tid,
      'description': instance.description,
      'status': instance.status,
      'status_text': instance.status_text,
      'transfer_keyword': instance.transfer_keyword,
      'store_name': instance.store_name,
      'created_at': instance.created_at,
      'transfer_type': instance.transfer_type,
      'total_count': instance.total_count,
      'total_cost': instance.total_cost,
      'store_id': instance.store_id,
      'total_price': instance.total_price,
      'products': instance.products,
      'isShowConfirmation': instance.isShowConfirmation,
    };
