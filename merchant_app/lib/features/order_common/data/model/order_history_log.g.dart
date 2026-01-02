// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_history_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderHistoryLog _$OrderHistoryLogFromJson(Map<String, dynamic> json) =>
    OrderHistoryLog(
      changeId: json['changeId'] as String? ?? '',
      orderId: json['orderId'] as String? ?? '',
      previousState: json['previousState'] as String? ?? '',
      changeDate: json['changeDate'] as String? ?? '',
      changedBy: json['changedBy'] as String? ?? '',
      newState: json['newState'] as String? ?? '',
      notes: json['notes'] as String? ?? '',
      reason: json['reason'] as String? ?? '',
    );

Map<String, dynamic> _$OrderHistoryLogToJson(OrderHistoryLog instance) =>
    <String, dynamic>{
      'orderId': instance.orderId,
      'changeId': instance.changeId,
      'previousState': instance.previousState,
      'newState': instance.newState,
      'changedBy': instance.changedBy,
      'changeDate': instance.changeDate,
      'reason': instance.reason,
      'notes': instance.notes,
    };
