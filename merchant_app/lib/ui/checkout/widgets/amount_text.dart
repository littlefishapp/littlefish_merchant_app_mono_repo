import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class AmountText extends StatelessWidget {
  final String textValue;
  const AmountText({super.key, required this.textValue});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.max,
      children: [
        context.labelXSmall('AMOUNT'),
        context.headingLarge(
          TextFormatter.toStringCurrency(
            double.tryParse(textValue),
            currencyCode: '',
          ),
          isBold: true,
        ),
      ],
    );
  }
}
