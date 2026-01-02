import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';

import 'app_scaffold.dart';

class AppSimpleAppScaffold extends StatelessWidget {
  final String? title;
  final Widget body;
  final bool displayAppBar;
  final Function()? mySave;
  final bool centreTitle;

  final bool? isEmbedded;
  final bool titleIsWidget;
  final Widget? titleWidget;
  final FloatingActionButtonLocation floatingActionButtonLocation;
  final List<Widget>? actions;
  final List<Widget>? footerActions;
  final FloatingActionButton? floatingActionButton;
  final bool? resizeToAvoidBottomPadding;
  final bool noElevation;
  final Color? backgroundColor;

  const AppSimpleAppScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.mySave,
    this.displayAppBar = true,
    this.floatingActionButton,
    this.floatingActionButtonLocation = FloatingActionButtonLocation.endFloat,
    this.actions,
    this.titleIsWidget = false,
    this.titleWidget,
    this.centreTitle = true,
    this.isEmbedded = false,
    this.footerActions,
    this.resizeToAvoidBottomPadding,
    this.noElevation = false,
    this.backgroundColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Widget titleUsed;
    if (titleWidget != null) {
      titleUsed = titleWidget!;
      if (titleUsed is Text) {
        final titleString = titleUsed.data ?? '';
        titleUsed = context.labelLarge(
          titleString,
          color: Theme.of(context).colorScheme.primary,
          isSemiBold: true,
        );
      } else {
        titleUsed = titleWidget!;
      }
    } else if (title != null && title!.isNotEmpty) {
      titleUsed = context.labelLarge(
        title!,
        color: Theme.of(context).colorScheme.primary,
        isSemiBold: true,
      );
    } else {
      titleUsed = context.labelLarge('', isSemiBold: true);
    }

    return KeyboardDismissalUtility(
      content: AppScaffold(
        backgroundColor:
            backgroundColor ?? Theme.of(context).colorScheme.background,
        titleWidget: titleUsed,
        body: body,
        persistentFooterButtons: footerActions,
        //resizeToAvoidBottomInset: resizeToAvoidBottomPadding,
      ),
    );
  }
}
