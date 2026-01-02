// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_expense.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BusinessExpense _$BusinessExpenseFromJson(Map<String, dynamic> json) =>
    BusinessExpense(
        amount: (json['amount'] as num?)?.toDouble(),
        beneficiary: json['beneficiary'] as String?,
        beneficiaryId: json['beneficiaryId'] as String?,
        creditorName: json['creditorName'] as String?,
        expenseType: $enumDecodeNullable(
          _$ExpenseTypeEnumMap,
          json['expenseType'],
        ),
        invoiceId: json['invoiceId'] as String?,
        sourceOfFunds: $enumDecodeNullable(
          _$SourceOfFundsEnumMap,
          json['sourceOfFunds'],
        ),
        reference: json['reference'] as String?,
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
      ..enabled = json['enabled'] as bool?;

Map<String, dynamic> _$BusinessExpenseToJson(BusinessExpense instance) =>
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
      'amount': instance.amount,
      'beneficiary': instance.beneficiary,
      'beneficiaryId': instance.beneficiaryId,
      'invoiceId': instance.invoiceId,
      'reference': instance.reference,
      'expenseType': _$ExpenseTypeEnumMap[instance.expenseType],
      'sourceOfFunds': _$SourceOfFundsEnumMap[instance.sourceOfFunds],
      'creditorName': instance.creditorName,
    };

const _$ExpenseTypeEnumMap = {
  ExpenseType.invoice: 0,
  ExpenseType.wages: 1,
  ExpenseType.bill: 2,
  ExpenseType.general: 3,
  ExpenseType.refund: 4,
};

const _$SourceOfFundsEnumMap = {
  SourceOfFunds.cash: 0,
  SourceOfFunds.eft: 1,
  SourceOfFunds.credit: 2,
  SourceOfFunds.mobileMoney: 3,
  SourceOfFunds.card: 4,
  SourceOfFunds.other: 5,
};
