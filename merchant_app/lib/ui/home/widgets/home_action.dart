// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

class HomeAction extends StatelessWidget {
  final String? title;

  final IconData? icon;

  final Function? onTap;

  final String? route;

  final Color? color;

  final bool isLargeDisplay;

  const HomeAction({
    Key? key,
    required this.title,
    required this.icon,
    this.onTap,
    this.route,
    this.color,
    this.isLargeDisplay = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        Material(
          color: color ?? Theme.of(context).colorScheme.primary,
          elevation: 2,
          borderRadius: BorderRadius.circular(4),
          child: InkWell(
            splashColor: color == Theme.of(context).colorScheme.primary
                ? Theme.of(context).colorScheme.secondary
                : Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(4),
            onTap: (route != null)
                ? () => Navigator.of(context).pushNamed(route!)
                : () {
                    if (onTap != null) {
                      onTap!();
                    } else {
                      () => showComingSoon(context: context);
                    }
                  },
            child: Container(
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(4)),
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isLargeDisplay ? 24 : 12,
                  vertical: isLargeDisplay ? 24 : 12,
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: isLargeDisplay ? 64 : 48,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          child: LongText(
            title,
            maxLines: 2,
            fontSize: isLargeDisplay ? null : 12,
            alignment: TextAlign.center,
            textColor: Theme.of(context).colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
