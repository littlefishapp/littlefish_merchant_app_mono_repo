// flutter imports
import 'package:flutter/material.dart';

// project imports
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/text_tag.dart';

class TransactionHistoryItem extends StatelessWidget {
  final IconData? leadingIcon;
  final String leadingText;
  final String leadingBottomTextOne, leadingBottomTextTwo;
  final String trailText;
  final String trailBottomTextOne, trailBottomTextTwo;
  final Color? leadingAndTrailColour;
  final Color? trailBottomTextOneColour;
  final double leadingBottomTextGap,
      trailBottomTextGap,
      leadingBottomTextAlignment;
  final bool? useTrailingBottomTags;
  final Function() onTap;

  const TransactionHistoryItem({
    super.key,
    required this.leadingIcon,
    required this.leadingText,
    required this.leadingBottomTextOne,
    required this.leadingBottomTextTwo,
    required this.trailText,
    required this.trailBottomTextOne,
    required this.trailBottomTextTwo,
    required this.onTap,
    this.leadingAndTrailColour,
    this.trailBottomTextOneColour,
    this.leadingBottomTextGap = 8,
    this.trailBottomTextGap = 8,
    this.leadingBottomTextAlignment = 2,
    this.useTrailingBottomTags = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Expanded(
              flex: 10,
              child: Column(
                children: [
                  _topRow(context),
                  const SizedBox(height: 4),
                  _bottomRow(context),
                ],
              ),
            ),
            const Expanded(
              child: Icon(Icons.arrow_forward_ios_outlined, size: 12),
            ),
          ],
        ),
      ),
    );
  }

  Widget _leadingIconAndText(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(leadingIcon, color: leadingAndTrailColour),
        const SizedBox(width: 8),
        context.paragraphSmall(
          leadingText,
          color: leadingAndTrailColour,
          isSemiBold: true,
        ),
      ],
    );
  }

  Widget _leadingBottomTexts(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const SizedBox(width: 2),
        context.labelXSmall(leadingBottomTextOne),
        SizedBox(width: leadingBottomTextGap),
        context.labelXSmall(leadingBottomTextTwo),
      ],
    );
  }

  Widget _trailingBottomItems(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 2),
        TextTag(displayText: trailBottomTextOne, color: Colors.green),
        SizedBox(width: trailBottomTextGap),
        TextTag(displayText: trailBottomTextTwo, color: Colors.green),
      ],
    );
  }

  Widget _trailingTopText(BuildContext context) {
    return context.paragraphSmall(
      trailText,
      color: leadingAndTrailColour,
      isSemiBold: true,
    );
  }

  Widget _trailingBottomTexts(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        context.labelXSmall(
          trailBottomTextOne,
          color: trailBottomTextOneColour,
        ),
        SizedBox(width: trailBottomTextGap),
        context.labelXSmall(trailBottomTextTwo),
      ],
    );
  }

  Widget _topRow(BuildContext context) {
    return Row(
      children: [
        Expanded(child: _leadingIconAndText(context)),
        const Spacer(),
        _trailingTopText(context),
      ],
    );
  }

  Widget _bottomRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Expanded(child: _leadingBottomTexts(context)),
        useTrailingBottomTags == false
            ? Expanded(child: _trailingBottomTexts(context))
            : Expanded(child: _trailingBottomItems(context)),
      ],
    );
  }
}
