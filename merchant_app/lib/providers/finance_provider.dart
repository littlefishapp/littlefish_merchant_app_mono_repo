// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:provider/provider.dart';

class FinanceProvider with ChangeNotifier {
  FinanceProvider({required this.token});

  static FinanceProvider of(BuildContext context, {bool listen = true}) =>
      Provider.of<FinanceProvider>(context, listen: listen);

  String token;

  double? creditLimit;

  double? currentCredit;

  double? totalExpenses, totalRevenue, totalAssetValue;

  Future<void> initialize() async {
    creditLimit = 10000;
    currentCredit = 5000;

    totalExpenses = 7500;
    totalRevenue = 18000;
    totalAssetValue = 10500;
  }
}
