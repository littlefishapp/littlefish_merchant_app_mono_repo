import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

Widget buildTextComponent(
  BuildContext context,
  String text,
  Color textColor,
  String rowSize,
  bool useSemiBold,
  bool useBold,
) {
  switch (rowSize.toLowerCase()) {
    case 'xxlarge':
      return context.headingLarge(text, color: textColor, isBold: useBold);
    case 'xlarge':
      return context.headingMedium(text, color: textColor, isBold: useBold);
    case 'large':
      return context.headingXSmall(
        text,
        color: textColor,
        isBold: useBold,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    case 'medium':
      return context.paragraphLarge(
        text,
        color: textColor,
        isBold: useBold,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    case 'normal':
      return context.paragraphSmall(
        text,
        color: textColor,
        isBold: useBold,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );

    case 'small':
      return context.paragraphXSmall(
        text,
        color: textColor,
        isBold: useBold,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    case 'xsmall':
      return context.labelXXSmall(
        text,
        color: textColor,
        isSemiBold: useSemiBold,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
    default:
      return context.paragraphSmall(
        text,
        color: textColor,
        isBold: useBold,
        maxLines: 2,
        overflow: TextOverflow.ellipsis,
      );
  }
}

BoxFit getBoxFit(String configBoxFit) {
  switch (configBoxFit) {
    case 'fill':
      return BoxFit.fill;
    case 'contain':
      return BoxFit.contain;
    case 'cover':
      return BoxFit.cover;
    case 'fitWidth':
      return BoxFit.fitWidth;
    case 'fitHeight':
      return BoxFit.fitHeight;
    case 'none':
      return BoxFit.none;
    case 'scaleDown':
      return BoxFit.scaleDown;
    default:
      return BoxFit.fitWidth;
  }
}
