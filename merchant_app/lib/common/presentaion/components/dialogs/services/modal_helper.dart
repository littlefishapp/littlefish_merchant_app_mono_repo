import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_informational.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class ModalHelper {
  static IconData getIconByStatus(StatusType status) {
    switch (status) {
      case StatusType.success:
        return Icons.check_circle_outline;
      case StatusType.warning:
      case StatusType.destructive:
        return LittleFishIcons.warning;
      case StatusType.neutral:
        return LittleFishIcons.info;
      case StatusType.defaultStatus:
      default:
        return LittleFishIcons.error;
    }
  }

  static Color getFillColour({
    required BuildContext context,
    required StatusType status,
    required bool isBoxIcon,
  }) {
    final infoTheme = Theme.of(context).extension<AppliedInformational>();
    final boxIconColours = {
      StatusType.success: infoTheme?.successBorder,
      StatusType.warning: infoTheme?.warningBorder,
      StatusType.destructive: infoTheme?.errorBorder,
      StatusType.defaultStatus: infoTheme?.defaultBorder,
      StatusType.neutral: infoTheme?.neutralBorder,
    };

    final surfaceTheme = Theme.of(context).extension<AppliedSurface>()?.primary;
    final freeStandingColours = {
      StatusType.success: surfaceTheme,
      StatusType.warning: surfaceTheme,
      StatusType.destructive: surfaceTheme,
      StatusType.defaultStatus: surfaceTheme,
      StatusType.neutral: surfaceTheme,
    };
    if (isBoxIcon) {
      return boxIconColours[status] ?? Colors.red;
    }
    return freeStandingColours[status] ?? Colors.red;
  }

  static Color getstrokeColour({
    required BuildContext context,
    required StatusType status,
    required bool isBoxIcon,
  }) {
    final infoTheme = Theme.of(context).extension<AppliedInformational>();
    final boxIconColours = {
      StatusType.success: Colors.white,
      StatusType.warning: Colors.white,
      StatusType.destructive: Colors.white,
      StatusType.defaultStatus: Colors.white,
      StatusType.neutral: Colors.white,
    };
    final freeStandingColours = {
      StatusType.success: infoTheme?.successBorder,
      StatusType.warning: infoTheme?.warningBorder,
      StatusType.destructive: infoTheme?.errorBorder,
      StatusType.defaultStatus: infoTheme?.defaultBorder,
      StatusType.neutral: infoTheme?.neutralBorder,
    };
    if (isBoxIcon) {
      return boxIconColours[status] ?? Colors.red;
    }
    return freeStandingColours[status] ?? Colors.red;
  }
}
