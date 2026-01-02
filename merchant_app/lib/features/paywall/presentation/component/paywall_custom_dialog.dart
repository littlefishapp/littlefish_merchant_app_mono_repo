import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';

Future<T?> paywallCustomDialog<T>({
  required BuildContext context,
  required Widget content,
  double? width,
  double? widthFactor,
  double? height,
  bool borderDismissable = true,
  bool defaultPadding = true,
  String title = '',
  Color backgroundColor = Colors.white,
  Color? materialBackgroundColor,
  double elevation = 5.0,
  Color barrierColor = Colors.black54,
  double? borderRadius,
}) {
  final availableWidth =
      EnvironmentProvider.instance.screenWidth ??
      MediaQuery.of(context).size.width;
  final isLargeDisplay = EnvironmentProvider.instance.isLargeDisplay ?? false;

  // Width: Use provided width, or factor (default 0.8), cap on large displays
  double? widthUsed;
  if (width != null) {
    widthUsed = width;
  } else {
    final factor = widthFactor ?? (isLargeDisplay ? 0.6 : 0.9);
    widthUsed = availableWidth * factor;
    // Cap max width on large displays to avoid "full width"
    if (isLargeDisplay) {
      widthUsed = widthUsed.clamp(0.0, 500.0); // e.g., max 500px
    }
  }

  final borderRadiusToUse = borderRadius ?? AppVariables.appDefaultRadius;

  return showDialog<T>(
    context: context,
    barrierDismissible: borderDismissable,
    barrierColor: barrierColor,
    builder: (context) => Center(
      child: Material(
        elevation: elevation,
        color: materialBackgroundColor,
        child: Container(
          width: widthUsed,
          height: height,
          constraints: BoxConstraints(
            minWidth: 280.0,
            maxWidth: widthUsed ?? 280,
            minHeight: 200.0,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(borderRadiusToUse),
          ),
          child: defaultPadding
              ? Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(child: content),
                )
              : SingleChildScrollView(child: content),
        ),
      ),
    ),
  );
}
