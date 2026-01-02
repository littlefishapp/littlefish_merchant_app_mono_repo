// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_button.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

import '../../../app/theme/applied_system/applied_surface.dart';

class SelectableTextBox extends StatefulWidget {
  final String text;
  final Function() onTap;
  final bool isSelected;
  final Color? boxColour, borderColour;
  final Color? selectedBoxColour, selectedBorderColour;
  final Color? textColour, selectedTextColour;
  final double borderWidth, selectedBorderWidth;

  const SelectableTextBox({
    required this.text,
    required this.onTap,
    this.isSelected = false,
    this.borderColour,
    this.boxColour,
    this.selectedBorderColour,
    this.selectedBoxColour,
    this.textColour,
    this.selectedTextColour,
    this.borderWidth = 1,
    this.selectedBorderWidth = 1,
    Key? key,
  }) : super(key: key);

  @override
  State<SelectableTextBox> createState() => _SelectableTextBoxState();
}

class _SelectableTextBoxState extends State<SelectableTextBox> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.transparent,
      onTap: () => widget.onTap(),
      child: Container(
        height: 54,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        decoration: BoxDecoration(
          color: getBoxColour(),
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
            color: getBorderColour(),
            width: widget.isSelected
                ? widget.selectedBorderWidth
                : widget.borderWidth,
          ),
        ),
        child: Center(
          child: Text(
            widget.text,
            style: context.appThemeTitleMedium!.copyWith(
              color: getTextColour(),
            ),
          ),
        ),
      ),
    );
  }

  Color getBorderColour() {
    if (widget.isSelected) {
      return Theme.of(context).extension<AppliedButton>()?.primaryDefault ??
          Colors.red;
    }

    return Theme.of(context).extension<AppliedButton>()?.neutralDefault ??
        Colors.red;
  }

  Color getBoxColour() {
    if (widget.isSelected) {
      return Theme.of(context).extension<AppliedSurface>()?.brandSubTitle ??
          Colors.red;
    }

    return Theme.of(context).extension<AppliedSurface>()?.brandSubTitle ??
        Colors.red;
  }

  Color getTextColour() {
    if (widget.isSelected) {
      return Theme.of(context).extension<AppliedButton>()?.primaryDefault ??
          Colors.red;
    }

    return Theme.of(context).extension<AppliedButton>()?.neutralDefault ??
        Colors.red;
  }
}
