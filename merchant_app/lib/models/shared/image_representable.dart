import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

abstract class ImageRepresentable {
  Widget buildWidget({double? size, Color? colour});
}

class AssetImageRepresentable implements ImageRepresentable {
  final String assetName;

  AssetImageRepresentable(this.assetName);

  @override
  Widget buildWidget({double? size, Color? colour}) {
    return Image.asset(assetName, width: size, height: size, color: colour);
  }
}

class SvgImageRepresentable implements ImageRepresentable {
  final String assetName;

  SvgImageRepresentable(this.assetName);

  @override
  Widget buildWidget({double? size, Color? colour}) {
    return SvgPicture.asset(
      assetName,
      width: size,
      height: size,
      colorFilter: colour != null
          ? ColorFilter.mode(colour, BlendMode.srcIn)
          : null,
    );
  }
}

class IconRepresentable implements ImageRepresentable {
  final IconData iconData;

  IconRepresentable(this.iconData);

  @override
  Widget buildWidget({double? size, Color? colour}) {
    return Icon(iconData, size: size, color: colour);
  }
}

class AnyImageRepresentable {
  final String name;
  final double? width;
  final double? height;
  final Color? colour;
  final IconData? iconData;

  const AnyImageRepresentable({
    required this.name,
    this.width,
    this.height,
    this.colour,
    this.iconData,
  });

  dynamic buildWidget() {
    if (name.endsWith('.svg')) {
      return SvgImageRepresentable(
        name,
      ).buildWidget(size: width, colour: colour);
    } else if (name.endsWith('.png') || name.endsWith('.jpg')) {
      return AssetImageRepresentable(
        name,
      ).buildWidget(size: width, colour: colour);
    } else if (iconData != null) {
      return IconRepresentable(
        iconData!,
      ).buildWidget(size: width, colour: colour);
    }
    return SizedBox(
      width: width,
      height: height,
      child: Icon(LittleFishIcons.error),
    );
  }
}
