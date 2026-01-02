import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class InvoiceLabelRow extends StatelessWidget {
  final String label;
  final String value;

  const InvoiceLabelRow({Key? key, required this.label, required this.value})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          context.labelSmall(label, isBold: false),
          context.labelSmall(value, isBold: false),
        ],
      ),
    );
  }
}
