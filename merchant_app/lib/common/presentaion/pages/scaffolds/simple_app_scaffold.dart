import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/custom_app_bar.dart';

class SimpleAppScaffold extends StatelessWidget {
  final Widget body;
  final String bottomButtonText;
  final Function()? bottomButtonFunction;
  final AppBar? appBar;
  final String? title;
  final bool resizeToAvoidBottomPadding;
  final bool titleIsWidget;
  final Widget? titleWidget;
  final List<Widget> footerActions;
  final List<Widget> actions;
  final bool isEmbedded;

  const SimpleAppScaffold({
    Key? key,
    required this.body,
    this.bottomButtonFunction,
    this.appBar,
    this.bottomButtonText = 'Save',
    this.title,
    this.resizeToAvoidBottomPadding = false,
    this.titleIsWidget = false,
    this.titleWidget,
    this.footerActions = const [],
    this.actions = const [],
    this.isEmbedded = false,
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
    return Scaffold(
      appBar:
          appBar ??
          CustomAppBar(
            leading: isEmbedded
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
            actions: actions,
            title: titleUsed,
          ),
      persistentFooterButtons: <Widget>[
        ...footerActions,
        if (bottomButtonFunction != null)
          ButtonBar(
            buttonHeight: 48,
            buttonMinWidth: MediaQuery.of(context).size.width * 0.95,
            children: <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.9,
                child: ElevatedButton(
                  child: Text(
                    bottomButtonText,
                    style: const TextStyle(color: Colors.white),
                  ),
                  onPressed: () async {
                    bottomButtonFunction!();
                  },
                ),
              ),
            ],
          ),
      ],
      body: SafeArea(child: body),
    );
  }
}
