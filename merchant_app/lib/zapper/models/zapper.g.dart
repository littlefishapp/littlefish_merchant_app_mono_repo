// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'zapper.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ZapperPayment _$ZapperPaymentFromJson(Map<String, dynamic> json) =>
    ZapperPayment(
        siteId: (json['siteId'] as num?)?.toInt(),
        reference: json['reference'] as String?,
        currencyIsoCode: json['currencyIsoCode'] as String?,
        invoicedAmount: (json['invoicedAmount'] as num?)?.toDouble(),
        paidAmount: (json['paidAmount'] as num?)?.toDouble(),
        status: (json['status'] as num?)?.toInt(),
        totalVoucherAmount: (json['totalVoucherAmount'] as num?)?.toDouble(),
        zapperId: json['zapperId'] as String?,
      )
      ..totalVouchersRedeemedAmount =
          (json['totalVouchersRedeemedAmount'] as num?)?.toInt()
      ..paymentUtcDate = json['paymentUtcDate'] as String?
      ..tipAmount = (json['tipAmount'] as num?)?.toInt();

Map<String, dynamic> _$ZapperPaymentToJson(ZapperPayment instance) =>
    <String, dynamic>{
      'paidAmount': instance.paidAmount,
      'invoicedAmount': instance.invoicedAmount,
      'totalVoucherAmount': instance.totalVoucherAmount,
      'reference': instance.reference,
      'status': instance.status,
      'zapperId': instance.zapperId,
      'siteId': instance.siteId,
      'totalVouchersRedeemedAmount': instance.totalVouchersRedeemedAmount,
      'currencyIsoCode': instance.currencyIsoCode,
      'paymentUtcDate': instance.paymentUtcDate,
      'tipAmount': instance.tipAmount,
    };

ZapperInvoice _$ZapperInvoiceFromJson(Map<String, dynamic> json) =>
    ZapperInvoice(
      origin: json['origin'] as String?,
      siteReference: json['siteReference'] as String?,
      externalReference: json['externalReference'] as String?,
      amount: (json['amount'] as num?)?.toInt(),
      currencyISOCode: json['currencyISOCode'] as String?,
      createdUTCDate: json['createdUTCDate'] as String?,
      lineItems: (json['lineItems'] as List<dynamic>?)
          ?.map((e) => LineItem.fromJson(e as Map<String, dynamic>))
          .toList(),
      originReference: json['originReference'] as String?,
    );

Map<String, dynamic> _$ZapperInvoiceToJson(ZapperInvoice instance) =>
    <String, dynamic>{
      'externalReference': instance.externalReference,
      'siteReference': instance.siteReference,
      'currencyISOCode': instance.currencyISOCode,
      'amount': instance.amount,
      'lineItems': instance.lineItems,
      'origin': instance.origin,
      'createdUTCDate': instance.createdUTCDate,
      'originReference': instance.originReference,
    };

LineItem _$LineItemFromJson(Map<String, dynamic> json) => LineItem(
  name: json['name'] as String?,
  unitPrice: (json['unitPrice'] as num?)?.toDouble(),
  quantity: (json['quantity'] as num?)?.toDouble(),
  productCode: json['productCode'] as String?,
  sKU: json['SKU'] as String?,
  categories: (json['categories'] as List<dynamic>?)
      ?.map((e) => e as String)
      .toList(),
);

Map<String, dynamic> _$LineItemToJson(LineItem instance) => <String, dynamic>{
  'name': instance.name,
  'productCode': instance.productCode,
  'SKU': instance.sKU,
  'unitPrice': instance.unitPrice,
  'categories': instance.categories,
  'quantity': instance.quantity,
};
