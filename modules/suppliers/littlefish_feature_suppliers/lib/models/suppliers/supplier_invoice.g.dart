// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'supplier_invoice.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SupplierInvoice _$SupplierInvoiceFromJson(Map<String, dynamic> json) =>
    SupplierInvoice(
        amount: (json['amount'] as num?)?.toDouble(),
        currencyCode: json['currencyCode'] as String?,
        dueDate: const IsoDateTimeConverter().fromJson(json['dueDate']),
        invoiceDate: const IsoDateTimeConverter().fromJson(json['invoiceDate']),
        reference: json['reference'] as String?,
        supplierId: json['supplierId'] as String?,
        supplierName: json['supplierName'] as String?,
        taxAmount: (json['taxAmount'] as num?)?.toDouble(),
        amountOutstanding: (json['amountOutstanding'] as num?)?.toDouble(),
        payments: (json['payments'] as List<dynamic>?)
            ?.map((e) => InvoicePayment.fromJson(e as Map<String, dynamic>))
            .toList(),
        recieved: json['recieved'] as bool?,
      )
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..status = json['status'] as String?
      ..businessId = json['businessId'] as String?
      ..displayName = json['displayName'] as String?
      ..deviceName = json['deviceName'] as String?
      ..dateCreated = const IsoDateTimeConverter().fromJson(json['dateCreated'])
      ..dateUpdated = const IsoDateTimeConverter().fromJson(json['dateUpdated'])
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..indexNo = (json['indexNo'] as num?)?.toInt()
      ..deleted = json['deleted'] as bool?
      ..enabled = json['enabled'] as bool?
      ..grvId = json['grvId'] as String?;

Map<String, dynamic> _$SupplierInvoiceToJson(SupplierInvoice instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'status': instance.status,
      'businessId': instance.businessId,
      'displayName': instance.displayName,
      'deviceName': instance.deviceName,
      'dateCreated': const IsoDateTimeConverter().toJson(instance.dateCreated),
      'dateUpdated': const IsoDateTimeConverter().toJson(instance.dateUpdated),
      'createdBy': instance.createdBy,
      'updatedBy': instance.updatedBy,
      'indexNo': instance.indexNo,
      'deleted': instance.deleted,
      'enabled': instance.enabled,
      'supplierName': instance.supplierName,
      'supplierId': instance.supplierId,
      'reference': instance.reference,
      'invoiceDate': const IsoDateTimeConverter().toJson(instance.invoiceDate),
      'dueDate': const IsoDateTimeConverter().toJson(instance.dueDate),
      'amount': instance.amount,
      'amountOutstanding': instance.amountOutstanding,
      'taxAmount': instance.taxAmount,
      'currencyCode': instance.currencyCode,
      'recieved': instance.recieved,
      'grvId': instance.grvId,
      'payments': instance.payments,
    };

InvoicePayment _$InvoicePaymentFromJson(Map<String, dynamic> json) =>
    InvoicePayment(
      paidBy: json['paidBy'] as String?,
      amount: (json['amount'] as num?)?.toDouble(),
      paymentDate: json['paymentDate'] == null
          ? null
          : DateTime.parse(json['paymentDate'] as String),
      paymentId: json['paymentId'] as String?,
    );

Map<String, dynamic> _$InvoicePaymentToJson(InvoicePayment instance) =>
    <String, dynamic>{
      'paymentId': instance.paymentId,
      'amount': instance.amount,
      'paymentDate': instance.paymentDate?.toIso8601String(),
      'paidBy': instance.paidBy,
    };
