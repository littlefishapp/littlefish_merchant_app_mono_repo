import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';

class CardNeutral extends StatelessWidget {
  final Widget child;
  final double elevation;
  final EdgeInsets? margin;
  final ShapeBorder? shape;
  final Clip? clipBehavior;
  final Color? color;

  const CardNeutral({
    super.key,
    required this.child,
    this.elevation = 1,
    this.margin,
    this.shape,
    this.clipBehavior,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final radius = AppVariables.appDefaultRadius;
    return Card(
      surfaceTintColor: Colors.transparent,
      elevation: elevation,
      margin: margin,
      shape:
          shape ??
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
      clipBehavior: clipBehavior,
      color: color,
      child: child,
    );
  }
}
