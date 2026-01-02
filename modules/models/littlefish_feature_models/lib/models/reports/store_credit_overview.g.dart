// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store_credit_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

StoreCreditOverview _$StoreCreditOverviewFromJson(Map<String, dynamic> json) =>
    StoreCreditOverview(
      creditTrend: (json['creditTrend'] as List<dynamic>?)
          ?.map((e) => CheckoutTransaction.fromJson(e as Map<String, dynamic>))
          .toList(),
      creditCustomers: (json['creditCustomers'] as List<dynamic>?)
          ?.map((e) => Customer.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$StoreCreditOverviewToJson(
  StoreCreditOverview instance,
) => <String, dynamic>{
  'creditCustomers': instance.creditCustomers,
  'creditTrend': instance.creditTrend,
};
