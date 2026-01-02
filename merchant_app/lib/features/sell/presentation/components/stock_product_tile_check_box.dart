// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/controls/control_check_box.dart';

class StockProductTileCheckBox extends StatelessWidget {
  const StockProductTileCheckBox({
    super.key,
    required this.isEstoreItem,
    required this.onChanged,
  });

  final bool isEstoreItem;
  final void Function(bool p1) onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: ControlCheckBox(
        isSelected: isEstoreItem,
        onChanged: onChanged,
        height: 18,
        width: 18,
        lineWidth: 1.0,
      ),
    );
  }
}
