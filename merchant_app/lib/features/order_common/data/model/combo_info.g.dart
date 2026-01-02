// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'combo_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ComboInfo _$ComboInfoFromJson(Map<String, dynamic> json) => ComboInfo(
  id: json['id'] as String,
  name: json['name'] as String,
  productId: json['productId'] as String,
  quantity: (json['quantity'] as num).toDouble(),
);

Map<String, dynamic> _$ComboInfoToJson(ComboInfo instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'productId': instance.productId,
  'quantity': instance.quantity,
};
