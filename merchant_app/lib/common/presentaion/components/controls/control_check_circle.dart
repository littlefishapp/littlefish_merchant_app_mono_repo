import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import '../../../../app/theme/applied_system/applied_button.dart';

class ControlCheckCircle extends StatefulWidget {
  final bool isSelected;
  final bool partial;
  final Function(bool)? onChanged;
  final double width;
  final double height;
  final double lineWidth;
  final Color checkBoxColor;

  const ControlCheckCircle({
    Key? key,
    required this.isSelected,
    this.onChanged,
    this.partial = false,
    this.height = 24,
    this.width = 24,
    this.lineWidth = 2,
    this.checkBoxColor = Colors.white,
  }) : super(key: key);

  @override
  State<ControlCheckCircle> createState() => _ControlCheckBoxState();
}

class _ControlCheckBoxState extends State<ControlCheckCircle> {
  @override
  Widget build(BuildContext context) {
    // TODO(lampian): should be using informational success, already defined as brand related
    final checkedColor =
        Theme.of(context).extension<AppliedTextIcon>()?.positive ?? Colors.red;
    final unSelectedBorderColor =
        Theme.of(context).extension<AppliedButton>()?.neutralDefault ??
        Colors.red;
    return InkWell(
      onTap: () {
        widget.onChanged!(_onChangeSelection(widget.isSelected));
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
          borderRadius: const BorderRadius.all(Radius.circular(50)),
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
