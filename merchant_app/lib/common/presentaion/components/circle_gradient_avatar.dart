// Flutter imports:
import 'package:flutter/material.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';

class CircleGradientAvatar extends StatelessWidget {
  const CircleGradientAvatar({
    Key? key,
    required this.child,
    this.radius = 20,
    this.colors,
  }) : super(key: key);

  final double radius;

  final Widget child;

  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors:
              colors ??
              [
                Theme.of(context).extension<AppliedTextIcon>()?.secondary ??
                    Colors.red,
                Theme.of(context).extension<AppliedTextIcon>()?.emphasized ??
                    Colors.red,
              ],
        ),
        borderRadius: BorderRadius.circular(30.0),
      ),
      child: CircleAvatar(
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
        radius: radius,
        child: child,
      ),
    );
  }
}

class OutlineGradientAvatar extends StatelessWidget {
  const OutlineGradientAvatar({
    Key? key,
    required this.child,
    this.radius,
    this.colors,
  }) : super(key: key);

  final double? radius;

  final Widget child;

  final List<Color>? colors;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      foregroundColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      radius: (radius ?? 20),
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors:
                colors ??
                [
                  Theme.of(context).extension<AppliedTextIcon>()?.secondary ??
                      Colors.red,
                  Theme.of(context).extension<AppliedTextIcon>()?.emphasized ??
                      Colors.red,
                ],
          ),
          borderRadius: BorderRadius.circular(_getBorderRadius()),
        ),
        child: Container(
          padding: EdgeInsets.all(_getMargin()),
          child: CircleAvatar(
            backgroundColor: Colors.white,
            foregroundColor: Theme.of(
              context,
            ).extension<AppliedTextIcon>()?.brand,
            radius: (radius ?? 20),
            child: child,
          ),
        ),
      ),
    );
  }

  double _getBorderRadius() {
    var r = (radius ?? 20);

    if (r >= 100) return r;

    return r;
  }

  double _getMargin() {
    var r = (radius ?? 20);

    double margin = 0;

    if (r >= 80) margin = 0.35;

    if (r >= 40) margin = 0.5;

    if (r < 40) margin = 1;

    return margin;
  }
}
