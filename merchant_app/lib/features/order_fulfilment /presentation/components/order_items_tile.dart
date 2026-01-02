// flutter imports
import 'package:flutter/material.dart';

// project imports
import 'package:littlefish_merchant/app/theme/typography.dart';

class OrderItemsTile extends StatelessWidget {
  final String leadingTopText;
  final String trailTopText;
  final String leadingBottomTextOne;
  final String trailBottomTextOne;
  final Color? leadingTopTextColour;
  final Color? trailTopTextColour;
  final Color? trailBottomColour;
  final bool? isManyItems;

  const OrderItemsTile({
    super.key,
    required this.leadingTopText,
    required this.trailTopText,
    required this.leadingBottomTextOne,
    required this.trailBottomTextOne,
    this.leadingTopTextColour,
    this.trailTopTextColour,
    this.trailBottomColour,
    this.isManyItems = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: Column(
        children: [
          _topRow(context),
          const SizedBox(height: 4),
          _bottomRow(context),
        ],
      ),
    );
  }

  Widget _topRow(BuildContext context) {
    return Row(
      children: [
        context.paragraphSmall(
          leadingTopText,
          color: leadingTopTextColour,
          isSemiBold: true,
        ),
        const Spacer(),
        context.paragraphSmall(
          trailTopText,
          color: trailTopTextColour,
          isSemiBold: true,
        ),
      ],
    );
  }

  Widget _bottomRow(BuildContext context) {
    return Row(
      children: [
        context.labelXSmall(
          isManyItems == true
              ? '$leadingBottomTextOne items'
              : '$leadingBottomTextOne item',
        ),
        const Spacer(),
        context.labelXSmall(trailBottomTextOne, color: trailBottomColour),
      ],
    );
  }
}
