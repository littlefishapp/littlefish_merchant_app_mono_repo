// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';

class CommonDivider extends StatelessWidget {
  final double height;
  final double width;
  final Color? color;
  final double? thickness;

  const CommonDivider({
    Key? key,
    this.height = 1.0,
    this.width = 1.0,
    this.color,
    this.thickness = 0.2,
  }) : assert(width <= 1.0),
       super(key: key);

  @override
  Widget build(BuildContext context) {
    var themeColor = Theme.of(
      context,
    ).extension<AppliedTextIcon>()?.deEmphasized;
    return SizedBox(
      width: MediaQuery.of(context).size.width * width,
      child: Divider(height: height, thickness: thickness, color: themeColor),
    );
  }
}
