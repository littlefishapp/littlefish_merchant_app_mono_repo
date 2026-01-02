import 'package:equatable/equatable.dart';
import 'package:littlefish_merchant/models/expenses/business_expense.dart';

class ExpensesCategoryEntity extends Equatable {
  final int displayIndex;
  final bool enabled;
  final String id;
  final String displayName;
  final String description;
  const ExpensesCategoryEntity({
    required this.displayIndex,
    required this.enabled,
    required this.id,
    required this.displayName,
    required this.description,
  });
  @override
  List<Object?> get props => [
    displayIndex,
    enabled,
    id,
    displayName,
    description,
  ];
  ExpensesCategoryEntity copyWith({
    int? displayIndex,
    bool? enabled,
    String? id,
    String? displayName,
    String? description,
  }) {
    return ExpensesCategoryEntity(
      displayIndex: displayIndex ?? this.displayIndex,
      enabled: enabled ?? this.enabled,
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
    );
  }

  ExpenseType get expenseType {
    final normalizedName = displayName.toLowerCase().trim();
    switch (normalizedName) {
      case 'invoice':
        return ExpenseType.invoice;
      case 'wages':
        return ExpenseType.wages;
      case 'bill':
        return ExpenseType.bill;
      case 'general':
        return ExpenseType.general;
      case 'refund':
        return ExpenseType.refund;
      default:
        return ExpenseType.general;
    }
  }
}
