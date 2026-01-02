import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';

class CardSquareFlat extends StatelessWidget {
  final Widget child;
  final EdgeInsets? margin;
  final Clip? clipBehavior;
  final Color? color;
  final String title;

  const CardSquareFlat({
    super.key,
    required this.child,
    this.margin,
    this.clipBehavior,
    this.color,
    this.title = '',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      surfaceTintColor: Theme.of(context).scaffoldBackgroundColor,
      elevation: 1,
      // shadowColor: Colors.black12,
      margin: margin ?? const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppVariables.appDefaultRadius),
      ),
      clipBehavior: clipBehavior,
      color: color,
      child: child,
    );
  }
}
