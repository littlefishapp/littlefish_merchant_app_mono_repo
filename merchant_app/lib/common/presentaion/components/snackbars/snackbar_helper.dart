import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/bootstrap.dart';

class SnackBarHelper {
  static void showSuccessSnackbar(BuildContext context, String message) {
    BuildContext? ctx = context.mounted
        ? context
        : globalNavigatorKey.currentContext;
    if (ctx == null) return;

    Color? textColour = Theme.of(
      context,
    ).extension<AppliedTextIcon>()?.positive;
    Color? backgroundColour = Theme.of(
      ctx,
    ).extension<AppliedSurface>()?.successEmphasized;
    showSnackbar(
      context: context,
      message: message,
      textColour: textColour,
      backgroundColour: backgroundColour,
      iconData: Icons.check_circle_outline,
    );
  }

  static void showFailureSnackbar(BuildContext context, String message) {
    BuildContext? ctx = context.mounted
        ? context
        : globalNavigatorKey.currentContext;
    if (ctx == null) return;

    Color? textColour = Theme.of(ctx).extension<AppliedTextIcon>()?.errorAlt;
    Color? backgroundColour = Theme.of(ctx).extension<AppliedSurface>()?.error;
    showSnackbar(
      context: context,
      message: message,
      textColour: textColour,
      backgroundColour: backgroundColour,
      iconData: LittleFishIcons.error,
    );
  }

  static void showSnackbar({
    required BuildContext context,
    required String message,
    Color? textColour,
    Color? backgroundColour,
    IconData? iconData,
  }) {
    BuildContext? ctx = globalNavigatorKey.currentContext;
    if (ctx == null) return;

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(ctx).showSnackBar(
      SnackBar(
        duration: const Duration(milliseconds: 2000),
        content: Row(
          children: [
            Icon(iconData ?? LittleFishIcons.info, color: textColour),
            const SizedBox(width: 8),
            Expanded(child: ctx.paragraphLarge(message, color: textColour)),
          ],
        ),
        backgroundColor: backgroundColour,
      ),
    );
  }
}
