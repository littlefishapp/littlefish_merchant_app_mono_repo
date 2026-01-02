import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../app/theme/applied_system/applied_button.dart';

class ControlCheckBox extends StatefulWidget {
  final bool isSelected;
  final bool partial;
  final Function(bool) onChanged;
  final double width;
  final double height;
  final double lineWidth;
  final Color checkBoxColor;

  const ControlCheckBox({
    Key? key,
    required this.isSelected,
    required this.onChanged,
    this.partial = false,
    this.height = 24,
    this.width = 24,
    this.lineWidth = 2,
    this.checkBoxColor = Colors.white,
  }) : super(key: key);

  @override
  State<ControlCheckBox> createState() => _ControlCheckBoxState();
}

class _ControlCheckBoxState extends State<ControlCheckBox> {
  @override
  Widget build(BuildContext context) {
    final checkedColor =
        Theme.of(context).extension<AppliedButton>()?.primaryDefault ??
        Colors.red;
    final unSelectedBorderColor =
        Theme.of(context).extension<AppliedButton>()?.neutralDefault ??
        Colors.red;
    return InkWell(
      onTap: () {
        widget.onChanged(_onChangeSelection(widget.isSelected));
      },
      child: Container(
        width: widget.width,
        height: widget.height,
        padding: EdgeInsets.zero,
        decoration: BoxDecoration(
          color: widget.isSelected || widget.partial
              ? checkedColor
              : Colors.transparent,
          border: Border.all(
            width: widget.lineWidth,
            color: widget.isSelected || widget.partial
                ? Colors.transparent
                : unSelectedBorderColor,
          ),
          borderRadius: const BorderRadius.all(Radius.circular(4.0)),
        ),
        child: widget.partial
            ? Icon(
                MdiIcons.minus,
                color: widget.checkBoxColor,
                size: widget.width * 0.75,
              )
            : widget.isSelected
            ? Icon(
                Icons.check,
                color: widget.checkBoxColor,
                size: widget.width * 0.75,
              )
            : const SizedBox.shrink(),
      ),
    );
  }

  bool _onChangeSelection(bool selection) {
    return selection ? false : true;
  }
}
