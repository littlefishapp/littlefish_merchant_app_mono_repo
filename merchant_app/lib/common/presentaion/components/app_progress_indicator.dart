import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class AppProgressIndicator extends StatelessWidget {
  const AppProgressIndicator({
    Key? key,
    this.isCentered = true,
    this.hasScaffold = false,
    this.customLoader,
    this.backgroundColor,
    this.loaderColor,
  }) : super(key: key);

  final bool isCentered;
  final bool hasScaffold;
  final Widget? customLoader;
  final Color? backgroundColor;
  final Color? loaderColor;

  @override
  Widget build(BuildContext context) {
    final color =
        loaderColor ??
        Theme.of(context).extension<AppliedTextIcon>()?.brand ??
        Colors.red;
    var loader =
        customLoader ??
        LoadingAnimationWidget.threeArchedCircle(color: color, size: 32);

    if (!isCentered && !hasScaffold) {
      return loader;
    } else {
      if (hasScaffold) {
        return AppScaffold(
          body: Center(child: loader),
          displayAppBar: true,
          titleWidget: const Text('Loading...'),
        );
      }

      return Center(child: loader);
    }
  }
}
