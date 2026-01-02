// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/providers/environment_provider.dart';

import '../../../../common/presentaion/components/cards/card_neutral.dart';

class PercentageCard extends StatelessWidget {
  final BuildContext context;
  final String value;
  final String title;

  const PercentageCard(
    this.context, {
    Key? key,
    required this.value,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      width: EnvironmentProvider.instance.isLargeDisplay!
          ? MediaQuery.of(context).size.width / 4.1
          : MediaQuery.of(context).size.width / 1.8,
      height: EnvironmentProvider.instance.isLargeDisplay! ? null : 96,
      child: CardNeutral(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '$value%',
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
                fontSize: 28.0,
              ),
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
