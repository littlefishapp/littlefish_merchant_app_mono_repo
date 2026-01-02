import 'package:equatable/equatable.dart';
import 'package:littlefish_merchant/models/expenses/business_expense.dart';

class ExpensesPaymentTypeEntity extends Equatable {
  final int displayIndex;
  final bool enabled;
  final String id;
  final String displayName;
  final String description;

  const ExpensesPaymentTypeEntity({
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

  ExpensesPaymentTypeEntity copyWith({
    int? displayIndex,
    bool? enabled,
    String? id,
    String? displayName,
    String? description,
  }) {
    return ExpensesPaymentTypeEntity(
      displayIndex: displayIndex ?? this.displayIndex,
      enabled: enabled ?? this.enabled,
      id: id ?? this.id,
      displayName: displayName ?? this.displayName,
      description: description ?? this.description,
    );
  }

  SourceOfFunds get sourceOfFunds {
    final normalizedName = displayName.toLowerCase().trim();
    switch (normalizedName) {
      case 'cash':
        return SourceOfFunds.cash;
      case 'eft':
        return SourceOfFunds.eft;
      case 'credit':
        return SourceOfFunds.credit;
      case 'mobile money':
      case 'mobilemoney':
        return SourceOfFunds.mobileMoney;
      case 'card':
        return SourceOfFunds.card;
      case 'other':
        return SourceOfFunds.other;
      default:
        return SourceOfFunds.other;
    }
  }
}
