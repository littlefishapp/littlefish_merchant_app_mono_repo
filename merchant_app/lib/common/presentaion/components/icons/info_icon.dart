import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/app_colours.dart';

class InfoIcon extends StatelessWidget {
  final IconData iconData;
  final bool useOutlineStyling, enableOpacity, enableBackground;
  final Color? backgroundColour;
  final double borderRadius, backgroundOpacity, width, height, iconSize;
  final Color? iconColour;
  final Color? borderColour;

  const InfoIcon({
    super.key,
    required this.iconData,
    this.useOutlineStyling = true,
    this.enableOpacity = false,
    this.borderRadius = 6.0,
    this.backgroundColour,
    this.iconColour,
    this.borderColour,
    this.backgroundOpacity = 0.1,
    this.width = 56,
    this.height = 56,
    this.iconSize = 24,
    this.enableBackground = true,
  });

  @override
  Widget build(BuildContext context) {
    final Color colourIcon = _getIconColour(context);
    final Color colourBackground = _getBackgroundColour(context);
    final Color colourBorder = _getBorderColour(context);

    return Container(
      height: height,
      width: width,
      decoration: ShapeDecoration(
        color: colourBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          side: useOutlineStyling
              ? BorderSide(color: colourBorder, style: BorderStyle.solid)
              : BorderSide.none,
        ),
      ),
      child: Center(child: _buildIcon(iconData, iconSize, colourIcon)),
    );
  }

  Color _getIconColour(BuildContext ctx) {
    final AppColours appColours =
        Theme.of(ctx).extension<AppColours>() ?? AppColours();
    return iconColour ?? appColours.appOnPrimary;
  }

  Color _getBackgroundColour(BuildContext ctx) {
    if (enableBackground == false) {
      return Colors.transparent;
    }

    final AppColours appColours =
        Theme.of(ctx).extension<AppColours>() ?? AppColours();

    Color colourBackground = backgroundColour ?? appColours.appPrimary;

    if (enableOpacity) {
      colourBackground = colourBackground.withOpacity(backgroundOpacity);
    }
    return colourBackground;
  }

  Color _getBorderColour(BuildContext ctx) {
    return borderColour ?? _getIconColour(ctx);
  }

  Icon _buildIcon(IconData icon, double size, Color colour) {
    return Icon(iconData, size: iconSize, color: colour);
  }
}
