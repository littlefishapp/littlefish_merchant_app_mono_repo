// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/ui/online_store/common/config.dart';

class ListTrailingWidget extends StatelessWidget {
  final Color? borderColor;

  final Widget? child;

  final double elevation;

  final Function? onTap;

  final double? width;

  const ListTrailingWidget({
    Key? key,
    this.borderColor,
    this.child,
    this.elevation = 1,
    this.onTap,
    this.width,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(kBorderRadius!),
      color: borderColor,
      elevation: elevation,
      child: Container(
        margin: const EdgeInsets.all(1),
        child: Material(
          borderRadius: BorderRadius.circular(kBorderRadius!),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: InkWell(
            onTap: onTap as void Function()?,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class LargeListTrailingWidget extends StatelessWidget {
  final Color? borderColor;

  final Widget? child;

  final double elevation;

  final Function? onTap;

  const LargeListTrailingWidget({
    Key? key,
    this.borderColor,
    this.child,
    this.elevation = 1,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 2),
      child: Material(
        borderRadius: BorderRadius.circular(kBorderRadius!),
        color: borderColor,
        elevation: elevation,
        child: Material(
          borderRadius: BorderRadius.circular(kBorderRadius!),
          color: Theme.of(context).scaffoldBackgroundColor,
          child: InkWell(
            customBorder: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(kBorderRadius!),
            ),
            onTap: onTap as void Function()?,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
