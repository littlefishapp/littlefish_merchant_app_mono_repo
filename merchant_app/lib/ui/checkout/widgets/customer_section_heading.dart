import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class CustomerSectionHeading extends StatelessWidget {
  final bool isRequired;
  const CustomerSectionHeading({super.key, required this.isRequired});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          context.labelMediumBold('Customer'),
          if (isRequired) ...[
            const SizedBox(width: 4),
            Container(
              alignment: Alignment.bottomCenter,
              child: context.labelXSmall('(Required)'),
            ),
          ],
        ],
      ),
    );
  }
}
