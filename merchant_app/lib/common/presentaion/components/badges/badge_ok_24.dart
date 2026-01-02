import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class BadgeOk24 extends StatelessWidget {
  final double radius;

  final String value;

  const BadgeOk24({super.key, this.radius = 8, this.value = ''});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.only(
        topRight: Radius.circular(radius),
        bottomLeft: Radius.circular(radius),
      ),
      child: Container(
        alignment: Alignment.center,
        width: value.isEmpty
            ? AppVariables.appDefaultButtonRadius * 2
            : AppVariables.appDefaultButtonRadius * 5,
        height: value.isEmpty
            ? AppVariables.appDefaultButtonRadius * 2
            : AppVariables.appDefaultButtonRadius * 5,
        decoration: BoxDecoration(
          color: Theme.of(context).extension<AppliedTextIcon>()?.success,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
          ),
        ),
        child: value.isEmpty
            ? Icon(
                Icons.check,
                color: Theme.of(context).extension<AppliedSurface>()?.primary,
                size: AppVariables.appDefaultButtonRadius * 1.5,
              )
            : context.labelXSmall(
                value,
                color: Theme.of(context).extension<AppliedSurface>()?.primary,
                isBold: true,
              ),
      ),
    );
  }
}
