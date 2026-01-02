import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class TransactionInfoItem extends StatelessWidget {
  final String title, value;
  final Color? color;
  final bool isBold;

  const TransactionInfoItem({
    super.key,
    required this.title,
    required this.value,
    this.isBold = false,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return content(context);
  }

  Padding content(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      mainAxisSize: MainAxisSize.max,
      children: [
        Expanded(
          child: context.paragraphMedium(
            title,
            alignLeft: true,
            isBold: isBold,
          ),
        ),
        Expanded(
          child: context.paragraphMedium(
            alignRight: true,
            value,
            color: color,
            isBold: isBold,
          ),
        ),
      ],
    ),
  );
}
