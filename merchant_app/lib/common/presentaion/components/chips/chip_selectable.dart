import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

import '../../../../app/theme/applied_system/applied_border.dart';
import '../../../../app/theme/applied_system/applied_button.dart';

class ChipSelectable extends StatelessWidget {
  final Function(BuildContext context) onTap;
  final String text;
  final bool selected;
  final double width;
  final double height;
  const ChipSelectable({
    super.key,
    required this.text,
    required this.selected,
    this.width = 60,
    this.height = 40,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appliedBorderTheme = Theme.of(context).extension<AppliedBorder>();
    final appliedButtonTheme = Theme.of(context).extension<AppliedButton>();
    final appliedSurface = Theme.of(context).extension<AppliedSurface>();

    final selectedStroke = appliedBorderTheme?.brand ?? Colors.red;
    final selectedFill = appliedSurface?.primary ?? Colors.red;
    final selectedBorder = appliedBorderTheme?.brand ?? Colors.red;

    final unSelectedStroke = appliedButtonTheme?.neutralDefault ?? Colors.red;
    const unSelectedFill = Colors.transparent;
    final unSelected = appliedButtonTheme?.neutralDefault ?? Colors.red;

    return SizedBox(
      width: width,
      height: height,
      child: OutlinedButton(
        style: selected
            ? OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: BorderSide(color: selectedBorder, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: selectedFill,
              )
            : OutlinedButton.styleFrom(
                padding: EdgeInsets.zero,
                side: BorderSide(color: unSelected, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
                backgroundColor: unSelectedFill,
              ),
        onPressed: () {
          onTap(context);
        },
        child: Align(
          alignment: Alignment.center,
          child: selected
              ? context.labelSmall(text, isBold: true, color: selectedStroke)
              : context.labelSmall(text, color: unSelectedStroke),
        ),
      ),
    );
  }
}
