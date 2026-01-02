import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/app_colours.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';

class DialogCardSkeleton extends StatelessWidget {
  final String title;
  final String description;
  final Widget? customWidget;
  final Widget? leading;
  final List<Widget>? footerWidgets;
  final EdgeInsetsGeometry outerPadding;
  final bool enableCloseButton;

  const DialogCardSkeleton({
    Key? key,
    required this.title,
    required this.description,
    this.customWidget,
    this.leading,
    this.footerWidgets,
    this.outerPadding = const EdgeInsets.only(
      left: 16.0,
      right: 16.0,
      bottom: 16.0,
    ),
    this.enableCloseButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isLargeDisplay = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final widthAvailable =
        EnvironmentProvider.instance.screenWidth ??
        MediaQuery.of(context).size.width;
    final widthUsed = isLargeDisplay ? widthAvailable * 0.3 : widthAvailable;

    return Dialog(
      surfaceTintColor: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppVariables.appDefaultRadius),
      ),
      child: SizedBox(
        width: widthUsed,
        //height: height,
        child: SingleChildScrollView(
          child: Padding(
            padding: outerPadding,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (enableCloseButton) _buildCloseButton(context),
                if (leading != null) leading!,
                if (title.isNotEmpty)
                  context.labelLarge(
                    title,
                    isBold: true,
                    color: Theme.of(
                      context,
                    ).extension<AppliedTextIcon>()?.primary,
                  ),
                const SizedBox(height: 8),
                context.paragraphMedium(
                  description,
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.secondary,
                ),
                if (customWidget != null) ...[
                  const SizedBox(height: 15),
                  customWidget!,
                ],
                const SizedBox(height: 16),
                if (footerWidgets != null) ...footerWidgets!,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCloseButton(BuildContext context) {
    return Align(
      alignment: Alignment.bottomRight,
      child: IconButton(
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints(),
        icon: const Icon(Icons.close),
        onPressed: () => Navigator.of(context).pop(),
        color: Theme.of(context).extension<AppColours>()?.appNeutral,
      ),
    );
  }
}
