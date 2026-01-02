// Flutter imports
import 'package:flutter/material.dart';

// Project imports
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/models/enums.dart';

class CheckoutActionSummary extends StatelessWidget {
  final CheckoutActionType actionType;
  final double subtotal;
  final double actionAmount;

  const CheckoutActionSummary({
    required this.actionType,
    required this.subtotal,
    required this.actionAmount,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      child: Column(children: [_buildActionRow()]),
    );
  }

  Widget _buildActionWidget() {
    switch (actionType) {
      case CheckoutActionType.withdrawal:
        return _buildRow('Cash Withdrawal Amount', actionAmount);
      case CheckoutActionType.cashback:
        return _buildRow('Cashback Amount', actionAmount);
      default:
        return const SizedBox.shrink(); // Return an empty widget for unexpected cases
    }
  }

  Widget _buildActionRow() {
    return _buildActionWidget();
  }

  Widget _buildRow(String title, double amount) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: const TextStyle(fontSize: 16.0)),
        Text(
          TextFormatter.toStringCurrency(amount, currencyCode: ''),
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
