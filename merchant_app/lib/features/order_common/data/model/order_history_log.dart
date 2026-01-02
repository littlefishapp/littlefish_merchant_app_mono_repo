import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'order_history_log.g.dart';

@JsonSerializable()
class OrderHistoryLog extends Equatable {
  final String orderId;
  final String changeId;
  final String previousState;
  final String newState;
  final String changedBy;
  final String changeDate;
  final String reason;
  final String notes;

  const OrderHistoryLog({
    this.changeId = '',
    this.orderId = '',
    this.previousState = '',
    this.changeDate = '',
    this.changedBy = '',
    this.newState = '',
    this.notes = '',
    this.reason = '',
  });

  OrderHistoryLog copyWith({
    String? orderId,
    String? changeId,
    String? previousState,
    String? newState,
    String? changedBy,
    String? changeDate,
    String? reason,
    String? notes,
  }) {
    return OrderHistoryLog(
      orderId: orderId ?? this.orderId,
      changeId: changeId ?? this.changeId,
      previousState: previousState ?? this.previousState,
      newState: newState ?? this.newState,
      changedBy: changedBy ?? this.changedBy,
      changeDate: changeDate ?? this.changeDate,
      reason: reason ?? this.reason,
      notes: notes ?? this.notes,
    );
  }

  @override
  List<Object?> get props => [
    orderId,
    changeId,
    changedBy,
    changeDate,
    previousState,
    newState,
    reason,
    notes,
  ];

  factory OrderHistoryLog.fromJson(Map<String, dynamic> json) =>
      _$OrderHistoryLogFromJson(json);

  Map<String, dynamic> toJson() => _$OrderHistoryLogToJson(this);
}
