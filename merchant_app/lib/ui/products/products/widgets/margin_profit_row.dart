import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_neutral.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

/// A widget that displays margin and profit per item in a card row.
///
/// [margin] and [profit] are the values to display (as strings, e.g. '12.5%' and 'R 10.00').
/// [color] is the color for the text and border. If not provided, uses theme defaults.
class MarginProfitRow extends StatelessWidget {
  final String margin;
  final String profit;
  final Color? color;

  const MarginProfitRow({
    Key? key,
    required this.margin,
    required this.profit,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color borderColor =
        color ??
        Theme.of(context).extension<AppliedTextIcon>()?.deEmphasized ??
        Colors.red;
    return SizedBox(
      height: 88,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        children: [
          Expanded(
            flex: 1,
            child: CardNeutral(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, color: borderColor),
                borderRadius: BorderRadius.circular(6.0),
              ),
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: context.labelSmall(
                      'Margin',
                      color: color,
                      isBold: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: context.labelMedium(
                      margin,
                      color: color,
                      isBold: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: CardNeutral(
              margin: EdgeInsets.zero,
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 2, color: borderColor),
                borderRadius: BorderRadius.circular(6),
              ),
              elevation: 0,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: context.labelSmall(
                      'Profit per item',
                      color: color,
                      isBold: true,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.only(left: 16),
                    child: context.labelMedium(
                      profit,
                      color: color,
                      isBold: true,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Utility function to calculate margin and profit as strings.
/// Returns a tuple: (margin, profit)
Tuple2<String, String> calculateMarginProfit({
  required double sellingPrice,
  required double costPrice,
  required String Function(double) currencyFormatter,
}) {
  String margin;
  String profit;
  if (costPrice > 0) {
    final marginValue = ((sellingPrice - costPrice) / costPrice * 100);
    margin = '${marginValue.toStringAsFixed(2)}%';
  } else {
    margin = '0.00%';
  }
  final profitValue = sellingPrice - costPrice;
  profit = currencyFormatter(profitValue);
  return Tuple2(margin, profit);
}

/// Simple tuple class for returning two values.
class Tuple2<A, B> {
  final A item1;
  final B item2;
  const Tuple2(this.item1, this.item2);
}
