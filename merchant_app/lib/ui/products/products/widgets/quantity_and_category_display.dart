import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'dart:math' as math;

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class QuantityAndCategoryDisplay extends StatelessWidget {
  final String? category;
  final double initialValue;
  final bool showQuantityInfo;

  const QuantityAndCategoryDisplay({
    Key? key,
    this.category,
    required this.initialValue,
    required this.showQuantityInfo,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (!showQuantityInfo && category == null) {
      return const SizedBox.shrink();
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (category != null) ...[
          Icon(
            Icons.category_outlined,
            color: Theme.of(context).extension<AppliedTextIcon>()?.deEmphasized,
          ),
          const SizedBox(width: 6),
          context.paragraphSmall(
            category!,
            color: Theme.of(context).extension<AppliedTextIcon>()?.deEmphasized,
          ),
          const SizedBox(width: 16),
        ],
        if (showQuantityInfo) ...[
          Icon(
            Icons.inventory_2_outlined,
            color: Theme.of(context).extension<AppliedTextIcon>()?.deEmphasized,
          ),
          const SizedBox(width: 6),
          context.paragraphSmall(
            _getItemQuantityText(math.max(initialValue.round(), 0)),
            color: Theme.of(context).extension<AppliedTextIcon>()?.deEmphasized,
          ),
        ],
      ],
    );
  }

  String _getItemQuantityText(int quantity) {
    String quantityText = '$quantity item';
    return quantity.abs() == 1 ? quantityText : '${quantityText}s';
  }
}
