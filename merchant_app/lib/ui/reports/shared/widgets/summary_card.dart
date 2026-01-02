// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/providers/environment_provider.dart';

import '../../../../common/presentaion/components/cards/card_neutral.dart';

class SummaryCard extends StatelessWidget {
  final BuildContext context;
  final String value;
  final String title;
  final bool asDouble;
  final bool isString;
  final double? fontSize;

  const SummaryCard(
    this.context, {
    Key? key,
    required this.value,
    required this.title,
    this.asDouble = true,
    this.fontSize,
    this.isString = false,
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  value,
                  // TODO(lampian): correct implementation
                  // isString
                  //     ? value
                  //     : asDouble
                  //         ? TextFormatter.toStringCurrency(
                  //             value,
                  //             displayCurrency: false,
                  //             currencyCode: '',
                  //           )
                  //         : value,
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontSize: 28.0,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
            Text(
              title,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
