import 'package:littlefish_merchant/models/enums.dart';

class TransactionPaymentMethodHelper {
  static TransactionPaymentMethod? getPaymentMethodByName(String? name) {
    if (name == null || name.isEmpty) return null;
    switch (name.toLowerCase()) {
      case 'cash':
        return TransactionPaymentMethod.cash;
      case 'card':
        return TransactionPaymentMethod.card;
      case 'masterpass':
        return TransactionPaymentMethod.masterpass;
      case 'snapscan':
        return TransactionPaymentMethod.snapscan;
      case 'zapper':
        return TransactionPaymentMethod.zapper;
      case 'mpesa':
        return TransactionPaymentMethod.mpesa;
      case 'airtelmoney':
        return TransactionPaymentMethod.airtelMoney;
      case 'tigopesa':
        return TransactionPaymentMethod.tigoPesa;
      case 'credit':
        return TransactionPaymentMethod.credit;
      case 'other':
        return TransactionPaymentMethod.other;
      default:
        return null;
    }
  }
}
