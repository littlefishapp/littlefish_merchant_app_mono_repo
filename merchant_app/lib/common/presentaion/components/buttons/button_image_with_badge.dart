import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/badges/badge_ok_24.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_image.dart';

class ButtonImageWithBadge extends StatelessWidget {
  final Widget leading;

  final bool isSelected;

  final String textValue;

  const ButtonImageWithBadge({
    super.key,
    required this.leading,
    this.isSelected = false,
    this.textValue = '',
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ButtonImage(image: leading, isSelected: isSelected),
        if (isSelected)
          Positioned(top: 0, right: 0, child: BadgeOk24(value: textValue)),
      ],
    );
  }
}
