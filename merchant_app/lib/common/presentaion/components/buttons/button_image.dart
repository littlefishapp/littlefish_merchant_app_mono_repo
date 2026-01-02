import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';

import '../../../../app/theme/applied_system/applied_border.dart';
import '../../../../app/theme/applied_system/applied_surface.dart';

class ButtonImage extends StatelessWidget {
  final double width;
  final double height;
  final bool isSelected;
  final Widget? image;
  final void Function()? onTap;

  const ButtonImage({
    super.key,
    this.image,
    this.width = 56,
    this.height = 56,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).extension<AppliedTextIcon>();
    final surfaceTheme = Theme.of(context).extension<AppliedSurface>();
    final borderTheme = Theme.of(context).extension<AppliedBorder>();

    final fill = surfaceTheme?.brandSubTitle ?? Colors.red;
    final iconColor = textTheme?.brand ?? Colors.red;
    final borderSelected =
        Theme.of(context).extension<AppliedTextIcon>()?.success ?? Colors.red;
    const borderUnselected = Colors.transparent;

    return InkWell(
      onTap: onTap,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? borderSelected : borderUnselected,
            width: 2,
          ),
          color: fill,
          borderRadius: BorderRadius.circular(
            AppVariables.appDefaultButtonRadius,
          ),
        ),
        child: image ?? Icon(Icons.inventory_2_outlined, color: iconColor),
      ),
    );
  }
}
