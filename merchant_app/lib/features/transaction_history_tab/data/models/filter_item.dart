import 'package:littlefish_merchant/models/enums.dart';

class TransactionHistoryFilterItem {
  TransactionHistoryFilterItem({
    required this.type,
    required this.label,
    required this.groupLabel,
    // required this.onSelected,
    required this.enabled,
    this.date,
  });

  OrderTransactionHistoryFilter type;
  DateTime? date;
  bool enabled;
  String label;
  String groupLabel;
  // Function(bool) onSelected;
}
