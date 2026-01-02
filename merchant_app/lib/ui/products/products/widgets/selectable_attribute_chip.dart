import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class SelectableAttributeChip extends StatelessWidget {
  final String attribute;
  final bool isSelected;
  final VoidCallback onTap;

  const SelectableAttributeChip({
    super.key,
    required this.attribute,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color selectedColor =
        Theme.of(context).extension<AppliedTextIcon>()?.brand ??
        Colors.green.shade300;

    final Color unselectedColor =
        Theme.of(context).extension<AppliedTextIcon>()?.disabled ??
        Colors.grey.shade600;

    final Color labelColor = isSelected ? selectedColor : unselectedColor;
    final Color borderColor = isSelected ? selectedColor : unselectedColor;

    return GestureDetector(
      onTap: onTap,
      child: Chip(
        label: context.labelSmall(attribute, color: labelColor),
        backgroundColor: Colors.transparent,
        side: BorderSide(color: borderColor, width: 1.5),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      ),
    );
  }
}
