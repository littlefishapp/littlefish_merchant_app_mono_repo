import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class ErrorIcon extends StatelessWidget {
  final Color? color;
  final double? size;
  const ErrorIcon({super.key, this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return Icon(
      LittleFishIcons.error,
      size: size,
      color: color ?? Theme.of(context).extension<AppliedTextIcon>()?.error,
    );
  }
}
