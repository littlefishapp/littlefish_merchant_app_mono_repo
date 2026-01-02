import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

// ignore: must_be_immutable
class PercentageBar extends StatelessWidget {
  BuildContext context;
  double percentage;
  double value;
  String title;

  PercentageBar({
    Key? key,
    required this.context,
    required this.percentage,
    required this.value,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: LinearPercentIndicator(
            lineHeight: 36.0,
            percent: percentage,
            animation: true,
            trailing: percentageBarTrailing(context),
            barRadius: const Radius.circular(8),
            //linearStrokeCap: LinearStrokeCap.butt,
            backgroundColor: Theme.of(
              context,
            ).colorScheme.secondary.withOpacity(0.5),
            progressColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }

  Widget percentageBarTrailing(BuildContext context) {
    return SizedBox(
      width: 76,
      child: Column(
        children: <Widget>[
          context.labelXSmall(title, maxLines: 2),
          context.labelXSmall(TextFormatter.toStringCurrency(value)),
        ],
      ),
    );
  }
}
