// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Ticket _$TicketFromJson(Map<String, dynamic> json) =>
    Ticket(
        completed: json['completed'] as bool? ?? false,
        customerEmail: json['customerEmail'] as String?,
        customerId: json['customerId'] as String?,
        customerMobile: json['customerMobile'] as String?,
        customerName: json['customerName'] as String?,
        items: (json['items'] as List<dynamic>?)
            ?.map((e) => CheckoutCartItem.fromJson(e as Map<String, dynamic>))
            .toList(),
        ticketNumber: (json['ticketNumber'] as num?)?.toDouble(),
        notes: json['notes'] as String?,
        totalCost: (json['totalCost'] as num?)?.toDouble(),
        reference: json['reference'] as String?,
        totalValue: (json['totalValue'] as num?)?.toDouble(),
        transactionDate: json['transactionDate'] == null
            ? null
            : DateTime.parse(json['transactionDate'] as String),
        transactionId: json['transactionId'] as String?,
      )
      ..id = json['id'] as String?
      ..name = json['name'] as String?
      ..description = json['description'] as String?
      ..status = json['status'] as String?
      ..businessId = json['businessId'] as String?
      ..displayName = json['displayName'] as String?
      ..deviceName = json['deviceName'] as String?
      ..dateCreated = json['dateCreated'] == null
          ? null
          : DateTime.parse(json['dateCreated'] as String)
      ..dateUpdated = json['dateUpdated'] == null
          ? null
          : DateTime.parse(json['dateUpdated'] as String)
      ..createdBy = json['createdBy'] as String?
      ..updatedBy = json['updatedBy'] as String?
      ..indexNo = (json['indexNo'] as num?)?.toInt()
      ..deleted = json['deleted'] as bool?
      ..enabled = json['enabled'] as bool?
      ..pendingSync = json['pendingSync'] as bool? ?? false;

Map<String, dynamic> _$TicketToJson(Ticket instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'status': instance.status,
  'businessId': instance.businessId,
  'displayName': instance.displayName,
  'deviceName': instance.deviceName,
  'dateCreated': instance.dateCreated?.toIso8601String(),
  'dateUpdated': instance.dateUpdated?.toIso8601String(),
  'createdBy': instance.createdBy,
  'updatedBy': instance.updatedBy,
  'indexNo': instance.indexNo,
  'deleted': instance.deleted,
  'enabled': instance.enabled,
  'customerId': instance.customerId,
  'customerName': instance.customerName,
  'customerEmail': instance.customerEmail,
  'customerMobile': instance.customerMobile,
  'transactionId': instance.transactionId,
  'reference': instance.reference,
  'notes': instance.notes,
  'items': instance.items?.map((e) => e.toJson()).toList(),
  'ticketNumber': instance.ticketNumber,
  'totalValue': instance.totalValue,
  'totalCost': instance.totalCost,
  'transactionDate': instance.transactionDate?.toIso8601String(),
  'completed': instance.completed,
  'pendingSync': instance.pendingSync,
};
