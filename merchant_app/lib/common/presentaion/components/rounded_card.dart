// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';

import 'cards/card_neutral.dart';

class RoundedCard extends StatelessWidget {
  const RoundedCard({
    Key? key,
    required this.child,
    this.radius = 8.0,
    this.elevation,
    this.hasBorder,
    this.onTap,
  }) : super(key: key);

  final Widget child;

  final double radius;

  final double? elevation;

  final bool? hasBorder;

  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return CardNeutral(
      elevation: elevation ?? UIStateData.cardElevation,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(radius),
      ),
      child: InkWell(
        onTap: () {
          if (onTap != null) onTap!();
        },
        child: child,
      ),
    );
  }
}
