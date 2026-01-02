// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:percent_indicator/percent_indicator.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';

class ScoreView extends StatelessWidget {
  final double? firstValue, secondValue;
  final Color? color, textColor;
  final double? fontSize;
  final double? lineWidth, radius;
  final FontWeight? fontWeight;
  final Color? backgroundColor;

  double get percent => firstValue! / secondValue!;

  const ScoreView({
    Key? key,
    required this.firstValue,
    required this.secondValue,
    this.color,
    this.fontSize,
    this.fontWeight,
    this.textColor,
    this.lineWidth,
    this.radius,
    this.backgroundColor,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      child: CircularPercentIndicator(
        radius: radius ?? 128.0,
        animation: true,
        lineWidth: lineWidth ?? 8,
        circularStrokeCap: CircularStrokeCap.round,
        backgroundColor: backgroundColor ?? Colors.grey.shade200,
        progressColor: color ?? Theme.of(context).colorScheme.primary,
        center: Container(
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              DecoratedText(
                (radius ?? 128.0) >= 89
                    ? '${firstValue!.toStringAsFixed(0)} / ${secondValue!.toStringAsFixed(0)}'
                    : firstValue!.toStringAsFixed(0),
                fontSize: fontSize ?? 24,
                fontWeight: fontWeight ?? FontWeight.bold,
                alignment: Alignment.center,
                textColor: textColor ?? Theme.of(context).colorScheme.secondary,
                maxLines: 2,
              ),
            ],
          ),
        ),
        percent: firstValue! / secondValue! == 0
            ? .01
            : firstValue! / secondValue!,
      ),
    );
  }
}
