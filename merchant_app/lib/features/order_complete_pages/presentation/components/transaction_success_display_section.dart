import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/transaction_status_icon.dart';

class TransactionSuccessDisplaySection extends StatelessWidget {
  final String message;

  const TransactionSuccessDisplaySection({Key? key, required this.message})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CardSquareFlat(
      child: SizedBox(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(32.0),
          child: TransactionStatusIcon(
            icon: Icons.check_rounded,
            color: Colors.white,
            message: message,
          ),
        ),
      ),
    );
  }
}
