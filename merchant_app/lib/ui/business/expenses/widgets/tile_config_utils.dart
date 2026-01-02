import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

buildTitle(BuildContext context, String title) {
  return Text(
    title.length < 30 ? title : '${title.substring(0, 26)}...',
    textAlign: TextAlign.start,
    style: TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).colorScheme.secondary,
      //fontFamily: UIStateData.primaryFontFamily,
    ),
  );
}

buildSubtitle(String subTitle) {
  return Text(
    // TODO(lampian): this type of widget should be wrapped inside a SizedBox or limited using flex in a row widget
    subTitle.length < 30 ? subTitle : '${subTitle.substring(0, 26)}...',
    textAlign: TextAlign.start,
    style: const TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      //fontFamily: UIStateData.primaryFontFamily,
    ),
  );
}

buildSubSubTitle(String subsubtitle) {
  return Text(
    subsubtitle,
    textAlign: TextAlign.start,
    style: const TextStyle(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Color(0xFC9E9C9F),
      //fontFamily: UIStateData.primaryFontFamily,
    ),
  );
}

buildTrailText(String trailText, BuildContext context) {
  return context.labelXSmall(
    trailText,
    alignRight: true,
    overflow: TextOverflow.ellipsis,
  );
}

buildSubTrailText(String subTrailText, BuildContext context) {
  return context.body02x14R(
    subTrailText,
    color: Theme.of(context).colorScheme.secondary,
  );
}

buildQuantityText({
  required String quantityText,
  required BuildContext context,
}) {
  return context.paragraphSmall(
    quantityText,
    alignLeft: true,
    isSemiBold: true,
  );
}
