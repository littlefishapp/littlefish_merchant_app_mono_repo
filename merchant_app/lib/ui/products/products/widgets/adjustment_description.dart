import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_informational.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class AdjustmentDescription extends StatelessWidget {
  final double initialValue;
  final double quantity;

  const AdjustmentDescription({
    Key? key,
    required this.initialValue,
    required this.quantity,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (initialValue == quantity) {
      return const SizedBox.shrink();
    }

    final isIncrease = quantity > initialValue;
    final difference = (quantity - initialValue).abs();
    final description = _getDescription(difference, isIncrease);
    final themeData = Theme.of(context);
    final color = isIncrease
        ? themeData.extension<AppliedInformational>()?.successText
        : Theme.of(context).extension<AppliedInformational>()?.errorText;

    return context.labelMedium(description, color: color);
  }

  String _getDescription(double difference, bool isIncrease) {
    String diff = TextFormatter.toStringRemoveZeroDecimals(difference);
    String desc = isIncrease
        ? 'You are adding $diff item'
        : 'You are removing $diff item';
    return difference.abs() == 1 ? desc : '${desc}s';
  }
}
