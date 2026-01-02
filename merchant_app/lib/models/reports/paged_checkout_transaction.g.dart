// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paged_checkout_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PagedCheckoutTransaction _$PagedCheckoutTransactionFromJson(
  Map<String, dynamic> json,
) => PagedCheckoutTransaction(
  result: (json['result'] as List<dynamic>?)
      ?.map((e) => CheckoutTransaction.fromJson(e as Map<String, dynamic>))
      .toList(),
  count: (json['count'] as num?)?.toInt(),
);

Map<String, dynamic> _$PagedCheckoutTransactionToJson(
  PagedCheckoutTransaction instance,
) => <String, dynamic>{'count': instance.count, 'result': instance.result};
