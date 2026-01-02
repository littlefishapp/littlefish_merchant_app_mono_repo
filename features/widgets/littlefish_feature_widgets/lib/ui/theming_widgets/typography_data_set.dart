import 'package:flutter/material.dart';

import 'typography_data.dart';

const boldWeight = FontWeight.w700;
const semiBoldWeight = FontWeight.w600;
const regularWeight = FontWeight.w400;
const lightweight = FontWeight.w300;

class TypographyDataSet {
  // TODO(lampian): should we be able to override the global text theme?
  String? headingLargeFontFamily;

  var displayLarge = const TypographyData(fontSize: 96.0);
  var displayMedium = const TypographyData(fontSize: 52.0);
  var displaySmall = const TypographyData(fontSize: 44.0);
  var displayXSmall = const TypographyData(fontSize: 36.0);

  // heading
  var headinXXLarge = const TypographyData(fontSize: 40.0);
  var headingXLarge = const TypographyData(fontSize: 36.0);
  var headingLarge = const TypographyData(fontSize: 32.0);
  var headingMedium = const TypographyData(fontSize: 28.0);
  var headingSmall = const TypographyData(fontSize: 24.0);
  var headingXSmall = const TypographyData(fontSize: 20.0);

  // Label
  var labelLarge = const TypographyData(fontSize: 18.0);
  var labelMedium = const TypographyData(fontSize: 16.0);
  var labelSmall = const TypographyData(fontSize: 14.0);
  var labelXSmall = const TypographyData(fontSize: 12.0);
  var labelXXSmall = const TypographyData(fontSize: 8.0);

  // Paragraph
  var paragraphLarge = const TypographyData(fontSize: 18.0);
  var paragraphMedium = const TypographyData(fontSize: 16.0);
  var paragraphSmall = const TypographyData(fontSize: 14.0);
  var paragraphXSmall = const TypographyData(fontSize: 12.0);

  // button
  var button01Bold = boldWeight;
  var button01SemiBold = boldWeight;
  var button01Regular = regularWeight;
  var button01ExtraBold = lightweight;
  var button01FontSize = 16.0;

  var button02Bold = boldWeight;
  var button02SemiBold = boldWeight;
  var button02Regular = regularWeight;
  var button02ExtraBold = lightweight;
  var button02FontSize = 14.0;

  var appBarUseGradient = false;
  var appBarGradientStart = Colors.white;
  var appBarGradientEnd = Colors.white;
  var appBarBackground = Colors.white;
  var appBarEnableSurfaceTint = false;
}
