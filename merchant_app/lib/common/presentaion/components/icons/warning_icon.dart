import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_informational.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class WarningIcon extends StatelessWidget {
  final Color? color;
  final double? size;
  const WarningIcon({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      LittleFishIcons.warning,
      size: size,
      color:
          color ??
          Theme.of(context).extension<AppliedInformational>()?.warningText,
    );
  }
}
