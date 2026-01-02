import 'package:littlefish_merchant/models/enums.dart';

class TransactionHistorySortItem {
  TransactionHistorySortItem({
    required this.type,
    required this.label,
    required this.groupLabel,
    required this.enabled,
  });

  OrderTransactionHistorySort type;
  bool enabled;
  String label;
  String groupLabel;
}
