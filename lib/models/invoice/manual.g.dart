// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'manual.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Manual _$ManualFromJson(Map<String, dynamic> json) => Manual(
      amount: (json['amount'] as num?)?.toInt(),
      account: json['account'] as String?,
      accountName: json['accountName'] as String?,
      description: json['description'] as String?,
      iconUrl: json['iconUrl'] as String?,
      comment: json['comment'] as String?,
      name: json['name'] as String?,
    );

Map<String, dynamic> _$ManualToJson(Manual instance) => <String, dynamic>{
      'amount': instance.amount,
      'account': instance.account,
      'accountName': instance.accountName,
      'comment': instance.comment,
      'description': instance.description,
      'iconUrl': instance.iconUrl,
      'name': instance.name,
    };
