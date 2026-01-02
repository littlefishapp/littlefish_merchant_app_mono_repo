import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography_data.dart';
import 'package:littlefish_merchant/app/theme/typography_data_set.dart';

import '../../../../../widgets/littlefish_feature_widgets/lib/injector.dart';
import 'applied_system/applied_border.dart';

extension BuildContextEntension on BuildContext {
  /// note that using 2021 styles, the default text style used by Text

  //=================================================================== Heading
  TextStyle? get appThemeHeadlineLarge =>
      Theme.of(this).textTheme.headlineLarge;

  Text headingLarge(
    String text, {
    Color? color,
    bool alignLeft = false,
    bool alignRight = false,
    bool isBold = false,
    bool isSemiBold = false,
    bool isLight = false,
  }) {
    assert(
      alignLeft == false || alignRight == false,
      'alignLeft and alignRight both true',
    );
    late TypographyData typographyData;

    if (AppVariables.isMobile || AppVariables.isDesktop) {
      typographyData = getIt.get<TypographyDataSet>().headingXLarge;
    } else {
      typographyData = getIt.get<TypographyDataSet>().headingLarge;
    }

    return Text(
      text,
      textAlign: alignLeft
          ? TextAlign.left
          : alignRight
          ? TextAlign.right
          : TextAlign.center,
      style: appThemeHeadlineLarge!.copyWith(
        fontWeight: typographyData.getWeight(
          isBold: isBold,
          isSemiBold: isSemiBold,
          isLight: isLight,
        ),
        fontSize: typographyData.fontSize,
        color: color ?? typographyData.color,
      ),
    );
  }

  TextStyle? get appThemeHeadlineMedium =>
      Theme.of(this).textTheme.headlineMedium;

  Text headingMedium(
    String text, {
    Color? color,
    bool alignLeft = false,
    bool alignRight = false,
    bool isBold = false,
    bool isSemiBold = false,
    bool isLight = false,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    assert(
      alignLeft == false || alignRight == false,
      'alignLeft and alignRight both true',
    );

    late TypographyData typographyData;

    if (AppVariables.isMobile || AppVariables.isDesktop) {
      typographyData = getIt.get<TypographyDataSet>().headingLarge;
    } else {
      typographyData = getIt.get<TypographyDataSet>().headingMedium;
    }

    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignLeft
          ? TextAlign.left
          : alignRight
          ? TextAlign.right
          : TextAlign.center,
      style: appThemeHeadlineLarge!.copyWith(
        fontWeight: typographyData.getWeight(
          isBold: isBold,
          isSemiBold: isSemiBold,
          isLight: isLight,
        ),
        fontSize: typographyData.fontSize,
        color: color ?? typographyData.color,
      ),
    );
  }

  /// M3 headline small => LF Heading 24
  TextStyle? get appThemeHeadlineSmall =>
      Theme.of(this).textTheme.headlineSmall;

  Text headingSmall(
    String text, {
    Color? color,
    bool alignLeft = false,
    bool alignRight = false,
    bool isBold = false,
    bool isSemiBold = false,
    bool isLight = false,
  }) {
    assert(
      alignLeft == false || alignRight == false,
      'alignLeft and alignRight both true',
    );

    late TypographyData typographyData;

    if (AppVariables.isMobile || AppVariables.isDesktop) {
      typographyData = getIt.get<TypographyDataSet>().headingMedium;
    } else {
      typographyData = getIt.get<TypographyDataSet>().headingSmall;
    }

    return Text(
      text,
      textAlign: alignLeft
          ? TextAlign.left
          : alignRight
          ? TextAlign.right
          : TextAlign.center,
      style: appThemeHeadlineSmall!.copyWith(
        fontWeight: typographyData.getWeight(
          isBold: isBold,
          isSemiBold: isSemiBold,
          isLight: isLight,
        ),
        fontSize: typographyData.fontSize,
        color: color ?? typographyData.color,
      ),
    );
  }

  Text headingXSmall(
    String text, {
    Color? color,
    bool alignLeft = false,
    bool alignRight = false,
    bool isBold = false,
    bool isSemiBold = false,
    bool isLight = false,
    TextOverflow? overflow,
    int? maxLines,
  }) {
    assert(
      alignLeft == false || alignRight == false,
      'alignLeft and alignRight both true',
    );

    late TypographyData typographyData;

    if (AppVariables.isMobile || AppVariables.isDesktop) {
      typographyData = getIt.get<TypographyDataSet>().headingSmall;
    } else {
      typographyData = getIt.get<TypographyDataSet>().headingXSmall;
    }

    return Text(
      text,
      maxLines: maxLines,
      overflow: overflow,
      textAlign: alignLeft
          ? TextAlign.left
          : alignRight
          ? TextAlign.right
          : TextAlign.center,
      style: appThemeHeadlineSmall!.copyWith(
        fontWeight: typographyData.getWeight(
          isBold: isBold,
          isSemiBold: isSemiBold,
          isLight: isLight,
        ),
        fontSize: typographyData.fontSize,
        color: color ?? typographyData.color,
      ),
    );
  }

  Text labelLarge(
    String text, {
    Color? color,
    bool alignLeft = false,
    bool alignRight = false,
    bool isBold = false,
    bool isSemiBold = false,
    bool isLight = false,
  }) {
    assert(
      alignLeft == false || alignRight == false,
      'alignLeft and alignRight both true',
    );

    late TypographyData typographyData;

    if (AppVariables.isMobile || AppVariables.isDesktop) {
      typographyData = getIt.get<TypographyDataSet>().labelLarge;
    } else {
      typographyData = getIt.get<TypographyDataSet>().labelLarge;
    }

    return Text(
      text,
      textAlign: alignLeft
          ? TextAlign.left
          : alignRight
          ? TextAlign.right
          : TextAlign.center,
      style: appThemeHeadlineSmall!.copyWith(
        fontWeight: typographyData.getWeight(
          isBold: isBold,
          isSemiBold: isSemiBold,
          isLight: isLight,
        ),
        fontSize: typographyData.fontSize,
        color: color ?? typographyData.color,
      ),
    );
  }

  Text labelMedium(
    String text, {
    Color? color,
    bool alignLeft = true,
    bool alignRight = false,
    bool isBold = false,
    bool isSemiBold = false,
    bool isLight = false,
    TextOverflow? overflow,
  }) {
    assert(
      alignLeft == false || alignRight == false,
      'alignLeft and alignRight both true',
    );

    late TypographyData typographyData;

    if (AppVariables.isPOSBuild) {
      typographyData = getIt.get<TypographyDataSet>().labelMedium;
    } else if (AppVariables.isMobile || AppVariables.isDesktop) {
      typographyData = getIt.get<TypographyDataSet>().labelLarge;
    } else {
      typographyData = getIt.get<TypographyDataSet>().labelMedium;
    }

    return Text(
      text,
      textAlign: alignLeft
          ? TextAlign.left
          : alignRight
          ? TextAlign.right
          : TextAlign.center,
      style: appThemeHeadlineSmall!.copyWith(
        fontWeight: typographyData.getWeight(
          isBold: isBold,
          isSemiBold: isSemiBold,
          isLight: isLight,
        ),
        fontSize: typographyData.fontSize,
        color: color ?? typographyData.color,
      ),
      overflow: overflow,
    );
  }

  Text labelMediumBold(String text, {TextOverflow? overflow}) {
    late TypographyData typographyData;

    if (AppVariables.isPOSBuild) {
      typographyData = getIt.get<TypographyDataSet>().labelMedium;
    } else if (AppVariables.isMobile || AppVariables.isDesktop) {
      typographyData = getIt.get<TypographyDataSet>().labelLarge;
    } else {
      typographyData = getIt.get<TypographyDataSet>().labelMedium;
    }

    return Text(
      text,
      textAlign: TextAlign.left,
      style: appThemeHeadlineSmall!.copyWith(
        fontWeight: typographyData.getWeight(isBold: true),
        fontSize: typographyData.fontSize,
        color:
            Theme.of(this).extension<AppliedTextIcon>()?.emphasized ??
            typographyData.color,
      ),
      overflow: overflow,
    );
  }

  TextStyle? get appThemeTitleMedium => Theme.of(this).textTheme.titleMedium;

  TextStyle? get appThemeTitleSmall => Theme.of(this).textTheme.titleSmall;

  Text labelSmall(
    String text, {
    Color? color,
    bool alignLeft = true,
    bool alignRight = false,
    bool isBold = false,
    bool isSemiBold = false,
    bool isLight = false,
    TextOverflow? overflow,
  }) {
    assert(
      alignLeft == false || alignRight == false,
      'alignLeft and alignRight both true',
    );

    late TypographyData typographyData;

    if (AppVariables.isPOSBuild) {
      typographyData = getIt.get<TypographyDataSet>().labelSmall;
    } else if (AppVariables.isMobile || AppVariables.isDesktop) {
      typographyData = getIt.get<TypographyDataSet>().labelMedium;
    } else {
      typographyData = getIt.get<TypographyDataSet>().labelSmall;
    }

    return Text(
      text,
      textAlign: alignLeft
          ? TextAlign.left
          : alignRight
          ? TextAlign.right
          : TextAlign.center,
      style: appThemeHeadlineSmall!.copyWith(
        fontWeight: typographyData.getWeight(
          isBold: isBold,
          isSemiBold: isSemiBold,
          isLight: isLight,
        ),
        fontSize: typographyData.fontSize,
        color: color ?? typographyData.color,
      ),
      overflow: overflow,
    );
  }

  Text labelXSmall(
    String text, {
    Color? color,
    bool alignLeft = false,
    bool alignRight = false,
    bool isBold = false,
    bool isSemiBold = false,
    bool isLight = false,
    TextOverflow? overflow,
    int maxLines = 1,
    bool autoSize = true,
  }) {
    assert(
      alignLeft == false || alignRight == false,
      'alignLeft and alignRight both true',
    );

    TypographyData? typographyData;
    bool typographyIsRegistered = getIt.isRegistered<TypographyDataSet>();

    if (typographyIsRegistered) {
      if (!autoSize || AppVariables.isPOSBuild) {
        typographyData = getIt.get<TypographyDataSet>().labelXSmall;
      } else if (AppVariables.isMobile || AppVariables.isDesktop) {
        typographyData = getIt.get<TypographyDataSet>().labelSmall;
      } else {
        typographyData = getIt.get<TypographyDataSet>().labelXSmall;
      }
    }

    return Text(
      text,
      textAlign: alignLeft
          ? TextAlign.left
          : alignRight
          ? TextAlign.right
          : TextAlign.center,
      style: typographyIsRegistered && typographyData != null
          ? appThemeHeadlineSmall!.copyWith(
              fontWeight: typographyData.getWeight(
                isBold: isBold,
                isSemiBold: isSemiBold,
                isLight: isLight,
              ),
              fontSize: typographyData.fontSize,
              color: color ?? typographyData.color,
            )
          : appThemeHeadlineSmall!.copyWith(color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  Text labelXXSmall(
    String text, {
    Color? color,
    bool alignLeft = false,
    bool alignRight = false,
    bool isBold = false,
    bool isSemiBold = false,
    bool isLight = false,
    TextOverflow? overflow,
    int maxLines = 1,
    bool autoSize = true,
  }) {
    assert(
      alignLeft == false || alignRight == false,
      'alignLeft and alignRight both true',
    );

    TypographyData? typographyData;
    bool typographyIsRegistered = getIt.isRegistered<TypographyDataSet>();

    if (typographyIsRegistered) {
      typographyData = getIt.get<TypographyDataSet>().labelXXSmall;
    }

    return Text(
      text,
      textAlign: alignLeft
          ? TextAlign.left
          : alignRight
          ? TextAlign.right
          : TextAlign.center,
      style: typographyIsRegistered && typographyData != null
          ? appThemeHeadlineSmall!.copyWith(
              fontWeight: typographyData.getWeight(
                isBold: isBold,
                isSemiBold: isSemiBold,
                isLight: isLight,
              ),
              fontSize: typographyData.fontSize,
              color: color ?? typographyData.color,
            )
          : appThemeHeadlineSmall!.copyWith(color: color),
      overflow: overflow,
      maxLines: maxLines,
    );
  }

  Text paragraphLarge(
    String text, {
    Color? color,
    bool alignLeft = false,
    bool alignRight = false,
    bool isBold = false,
    bool isSemiBold = false,
    bool isLight = false,
    TextOverflow? overflow,
    bool isUnderLined = false,
    int? maxLines,
  }) {
    assert(
      alignLeft == false || alignRight == false,
      'alignLeft and alignRight both true',
    );
    final typographyData = getIt.get<TypographyDataSet>().paragraphLarge;
    return Text(
      text,
      textAlign: alignLeft
          ? TextAlign.left
          : alignRight
          ? TextAlign.right
          : TextAlign.center,
      style: appThemeHeadlineSmall!.copyWith(
        fontWeight: typographyData.getWeight(
          isBold: isBold,
          isSemiBold: isSemiBold,
          isLight: isLight,
        ),
        fontSize: typographyData.fontSize,
        color: color ?? typographyData.color,
        decoration: isUnderLined ? TextDecoration.underline : null,
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle? get appThemeLabelLarge => Theme.of(this).textTheme.labelLarge;

  Text paragraphMedium(
    String text, {
    Color? color,
    bool alignLeft = false,
    bool alignRight = false,
    bool isBold = false,
    bool isSemiBold = false,
    bool isLight = false,
    TextOverflow? overflow,
    bool isUnderLined = false,
    int? maxLines,
    Color? decorationColor,
  }) {
    assert(
      alignLeft == false || alignRight == false,
      'alignLeft and alignRight both true',
    );
    final typographyData = getIt.get<TypographyDataSet>().paragraphMedium;
    return Text(
      text,
      textAlign: alignLeft
          ? TextAlign.left
          : alignRight
          ? TextAlign.right
          : TextAlign.center,
      style: appThemeHeadlineSmall!.copyWith(
        fontWeight: typographyData.getWeight(
          isBold: isBold,
          isSemiBold: isSemiBold,
          isLight: isLight,
        ),
        fontSize: typographyData.fontSize,
        color: color ?? typographyData.color,
        decoration: isUnderLined ? TextDecoration.underline : null,
        decorationColor: decorationColor,
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle? get styleParagraphLargeRegular => appThemeLabelLarge!.copyWith(
    fontSize: getIt.get<TypographyDataSet>().paragraphLarge.fontSize,
    fontWeight: getIt.get<TypographyDataSet>().paragraphLarge.regular,
  );

  TextStyle? get styleParagraphMediumRegular => appThemeLabelLarge!.copyWith(
    fontSize: getIt.get<TypographyDataSet>().paragraphMedium.fontSize,
    fontWeight: getIt.get<TypographyDataSet>().paragraphMedium.regular,
  );

  TextStyle? get styleParagraphMediumSemiBold => appThemeLabelLarge!.copyWith(
    fontSize: getIt.get<TypographyDataSet>().paragraphMedium.fontSize,
    fontWeight: getIt.get<TypographyDataSet>().paragraphMedium.semiBold,
  );

  TextStyle? get styleParagraphMediumBold => appThemeLabelLarge!.copyWith(
    fontSize: getIt.get<TypographyDataSet>().paragraphMedium.fontSize,
    fontWeight: getIt.get<TypographyDataSet>().paragraphMedium.bold,
  );

  TextStyle? get appThemeLabelMedium => Theme.of(this).textTheme.labelMedium;

  TextStyle? get styleParagraphSmallRegular => appThemeLabelMedium!.copyWith(
    fontSize: getIt.get<TypographyDataSet>().paragraphSmall.fontSize,
    fontWeight: getIt.get<TypographyDataSet>().paragraphSmall.regular,
  );

  TextStyle? get styleParagraphSmallSemiBold => appThemeLabelMedium!.copyWith(
    fontSize: getIt.get<TypographyDataSet>().paragraphSmall.fontSize,
    fontWeight: getIt.get<TypographyDataSet>().paragraphSmall.semiBold,
  );

  TextStyle? get styleParagraphXSmallRegular => appThemeLabelMedium!.copyWith(
    fontSize: getIt.get<TypographyDataSet>().paragraphXSmall.fontSize,
    fontWeight: getIt.get<TypographyDataSet>().paragraphXSmall.regular,
  );

  Text body02x14R(
    String text, {
    Color? color,
    bool alignLeft = false,
    bool alignRight = false,
  }) {
    assert(
      alignLeft == false || alignRight == false,
      'alignLeft and alignRight both true',
    );
    return Text(
      text,
      textAlign: alignLeft
          ? TextAlign.left
          : alignRight
          ? TextAlign.right
          : TextAlign.center,
      style: styleParagraphSmallRegular!.copyWith(color: color),
    );
  }

  Text paragraphSmall(
    String text, {
    Color? color,
    bool alignLeft = false,
    bool alignRight = false,
    bool isBold = false,
    bool isSemiBold = false,
    bool isLight = false,
    TextOverflow? overflow,
    bool isUnderLined = false,
    int? maxLines,
    Color? decorationColor,
  }) {
    assert(
      alignLeft == false || alignRight == false,
      'alignLeft and alignRight both true',
    );
    final typographyData = getIt.get<TypographyDataSet>().paragraphSmall;
    return Text(
      text,
      textAlign: alignLeft
          ? TextAlign.left
          : alignRight
          ? TextAlign.right
          : TextAlign.center,
      style: appThemeHeadlineSmall!.copyWith(
        fontWeight: typographyData.getWeight(
          isBold: isBold,
          isSemiBold: isSemiBold,
          isLight: isLight,
        ),
        fontSize: typographyData.fontSize,
        color: color ?? typographyData.color,
        decoration: isUnderLined ? TextDecoration.underline : null,
        decorationColor: decorationColor,
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle? get styleBody03x12R =>
      appThemeLabelMedium!.copyWith(fontSize: 12, fontWeight: FontWeight.w400);

  Text paragraphXSmall(
    String text, {
    Color? color,
    bool alignLeft = false,
    bool alignRight = false,
    bool isBold = false,
    bool isSemiBold = false,
    bool isLight = false,
    TextOverflow? overflow,
    bool isUnderLined = false,
    int? maxLines,
  }) {
    assert(
      alignLeft == false || alignRight == false,
      'alignLeft and alignRight both true',
    );
    final typographyData = getIt.get<TypographyDataSet>().paragraphXSmall;
    return Text(
      text,
      textAlign: alignLeft
          ? TextAlign.left
          : alignRight
          ? TextAlign.right
          : TextAlign.center,
      style: appThemeHeadlineSmall!.copyWith(
        fontWeight: typographyData.getWeight(
          isBold: isBold,
          isSemiBold: isSemiBold,
          isLight: isLight,
        ),
        fontSize: typographyData.fontSize,
        color: color ?? typographyData.color,
        decoration: isUnderLined ? TextDecoration.underline : null,
      ),
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  TextStyle? get appThemeLabelSmall => Theme.of(this).textTheme.labelSmall;

  TextStyle? get appThemeBodyLarge => Theme.of(this).textTheme.bodyLarge;

  TextStyle? get appThemeBodyMedium => Theme.of(this).textTheme.bodyMedium;

  TextStyle? get appThemeBodySmall => Theme.of(this).textTheme.bodySmall;

  TextStyle? get appThemeTextFormHint => Theme.of(this).textTheme.labelLarge;
  TextStyle? get appThemeTextFormLabel => styleBody03x12R;
  TextStyle? get appThemeTextFormText => styleParagraphSmallRegular;

  /// M3 body large => LF button 01
  Text button01x16M(String text) {
    return Text(
      text,
      style: appThemeBodyLarge!.copyWith(
        fontWeight: getIt.get<TypographyDataSet>().button01SemiBold,
        fontSize: getIt.get<TypographyDataSet>().button01FontSize,
      ),
    );
  }

  Text button01x16B(String text, {Color? color}) {
    return Text(
      text,
      style: appThemeBodyLarge!.copyWith(
        fontWeight: getIt.get<TypographyDataSet>().button01Bold,
        fontSize: getIt.get<TypographyDataSet>().button01FontSize,
        color: color,
      ),
    );
  }

  /// M3 body medium => LF button 02
  Text button02x14M(String text) {
    return Text(
      text,
      style: appThemeLabelMedium!.copyWith(
        fontWeight: getIt.get<TypographyDataSet>().button02SemiBold,
        fontSize: getIt.get<TypographyDataSet>().button02FontSize,
      ),
    );
  }

  Text button02x14B(String text) {
    return Text(
      text,
      style: appThemeLabelMedium!.copyWith(
        fontWeight: getIt.get<TypographyDataSet>().button02Bold,
        fontSize: getIt.get<TypographyDataSet>().button02FontSize,
      ),
    );
  }

  OutlineInputBorder inputBorderEnabled({bool inverse = false}) {
    final theme =
        Theme.of(this).extension<AppliedBorder>() ?? const AppliedBorder();
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: inverse ? theme.inversePrimary : theme.primary,
      ),
    );
  }

  OutlineInputBorder inputNoBorderSides() {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide.none,
    );
  }

  OutlineInputBorder inputBorderFocus({bool inverse = false}) {
    final theme =
        Theme.of(this).extension<AppliedBorder>() ?? const AppliedBorder();
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: inverse ? theme.inversePrimary : theme.primary,
      ),
    );
  }

  OutlineInputBorder inputBorderDisabled({bool inverse = false}) {
    final theme =
        Theme.of(this).extension<AppliedBorder>() ?? const AppliedBorder();
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(
        color: inverse ? theme.inverseDisabled : theme.disabled,
      ),
    );
  }

  OutlineInputBorder inputBorderError({bool inverse = false}) {
    final theme =
        Theme.of(this).extension<AppliedTextIcon>() ?? const AppliedTextIcon();
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(6),
      borderSide: BorderSide(color: theme.error),
    );
  }

  UnderlineInputBorder get inputBorderUnderlineFocus {
    final theme =
        Theme.of(this).extension<AppliedBorder>() ?? const AppliedBorder();
    return UnderlineInputBorder(borderSide: BorderSide(color: theme.primary));
  }

  UnderlineInputBorder get inputBorderUnderlineDisabled => UnderlineInputBorder(
    borderSide: BorderSide(
      color:
          (Theme.of(this).extension<AppliedBorder>() ?? const AppliedBorder())
              .disabled,
    ),
  );

  UnderlineInputBorder get inputBorderUnderlineError => UnderlineInputBorder(
    borderSide: BorderSide(
      color:
          (Theme.of(this).extension<AppliedBorder>() ?? const AppliedBorder())
              .error,
    ),
  );

  UnderlineInputBorder get inputBorderUnderlineEnabled => UnderlineInputBorder(
    borderSide: BorderSide(
      color:
          (Theme.of(this).extension<AppliedBorder>() ?? const AppliedBorder())
              .emphasized,
    ),
  );

  TextStyle? getTextStyle(String styleName) {
    switch (styleName) {
      case 'paragraphLargeRegular':
        return styleParagraphLargeRegular;
      case 'paragraphXSmallRegular':
        return styleParagraphXSmallRegular;
      case 'paragraphSmallRegular':
        return styleParagraphSmallRegular;
      case 'paragraphSmallSemiBold':
        return styleParagraphSmallSemiBold;
      case 'paragraphMediumRegular':
        return styleParagraphMediumRegular;
      case 'paragraphMediumSemiBold':
        return styleParagraphMediumSemiBold;
      case 'paragraphMediumBold':
        return styleParagraphMediumBold;

      default:
        return styleParagraphSmallRegular;
    }
  }
}
