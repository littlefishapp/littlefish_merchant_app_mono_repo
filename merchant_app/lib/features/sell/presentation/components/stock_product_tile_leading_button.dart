// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_image_with_badge.dart';

class StockProductTileLeadingButton extends StatelessWidget {
  const StockProductTileLeadingButton({
    super.key,
    required this.showQuantityField,
    required this.isSelected,
    required this.leading,
  });

  final bool showQuantityField;
  final bool isSelected;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final showSelected = showQuantityField ? isSelected : false;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ButtonImageWithBadge(leading: leading!, isSelected: showSelected),
    );
  }
}
