import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:quiver/strings.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../injector.dart';
import '../../../tools/network_image/flutter_network_image.dart';
import 'icons/error_icon.dart';

class ListLeadingIconTile extends StatelessWidget {
  final dynamic icon;
  final double? width;
  final double? height;

  final Color? color;
  final Color? iconColor;

  final double? radius;

  const ListLeadingIconTile({
    Key? key,
    required this.icon,
    this.color,
    this.height,
    this.width,
    this.iconColor,
    this.radius = 8,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppVariables.appDefaultlistItemSize,
      height: AppVariables.appDefaultlistItemSize,
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppliedSurface>()?.brandSubTitle,
        border: Border.all(color: Colors.transparent, width: 1),
        borderRadius: BorderRadius.circular(AppVariables.appDefaultRadius),
      ),
      child: Center(child: _buildIcon(context)),
    );
  }

  Widget _buildIcon(BuildContext context) {
    if (icon is IconData) {
      // Render the icon if it's IconData
      return Icon(
        icon as IconData,
        size: AppVariables.appDefaultlistItemSize / 2,
      );
    } else if (icon is String) {
      // Render an SVG image if it's a String (asset path to SVG)

      final String assetImage = icon as String;

      if (assetImage.contains('svg')) {
        return SvgPicture.asset(
          assetImage,
          width: AppVariables.appDefaultlistItemSize,
          height: AppVariables.appDefaultlistItemSize,
        );
      } else {
        return Container(
          alignment: Alignment.center,
          width: AppVariables.appDefaultlistItemSize,
          height: AppVariables.appDefaultlistItemSize,
          child: isNotBlank(assetImage)
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(
                    AppVariables.appDefaultRadius,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(assetImage),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                )
              : Icon(
                  Icons.inventory_2_outlined,
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.secondary,
                ),
        );
      }
    } else {
      // Return a default icon
      return const ErrorIcon();
    }
  }
}

class ListLeadingTileTablet extends StatelessWidget {
  final IconData icon;

  final Color? color;

  const ListLeadingTileTablet({Key? key, required this.icon, this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width:
          MediaQuery.of(context).size.width * 0.15 >=
              AppVariables.appDefaultlistItemSize
          ? AppVariables.appDefaultlistItemSize
          : MediaQuery.of(context).size.width * 0.15,
      height: (MediaQuery.of(context).size.width * 0.15) * 0.35,
      decoration: BoxDecoration(
        color: color ?? Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(icon, color: Colors.white),
    );
  }
}

class ListLeadingImageTile extends StatelessWidget {
  final String? url;

  final Color? color;
  final double height;
  final double width;

  const ListLeadingImageTile({
    Key? key,
    required this.url,
    this.color,
    this.height = 56,
    this.width = 56,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: AppVariables.appDefaultlistItemSize,
      height: AppVariables.appDefaultlistItemSize,
      child: isNotBlank(url)
          ? getIt<FlutterNetworkImage>().asWidgetUri(
              uri: url!,
              height: AppVariables.appDefaultlistItemSize,
              width: AppVariables.appDefaultlistItemSize,
            )
          : Icon(
              Icons.inventory_2_outlined,
              color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
            ),
    );
  }
}

class ListLeadingImageTileTablet extends StatelessWidget {
  final String url;

  final Color? color;

  const ListLeadingImageTileTablet({Key? key, required this.url, this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width:
          MediaQuery.of(context).size.width * 0.15 >=
              AppVariables.appDefaultlistItemSize
          ? AppVariables.appDefaultlistItemSize
          : MediaQuery.of(context).size.width * 0.15,
      height: (MediaQuery.of(context).size.width * 0.15) * 0.35,
      decoration: BoxDecoration(
        border: Border.all(
          color: color ?? Theme.of(context).colorScheme.secondary,
        ),
        color: color ?? Colors.transparent,
        borderRadius: BorderRadius.circular(4),
        image: DecorationImage(
          image: getIt<FlutterNetworkImage>().asImageProviderById(
            id: '',
            category: '',
            legacyUrl: url,
          ),
        ),
      ),
    );
  }
}

class ListLeadingTextTile extends StatelessWidget {
  final String text;

  final Color? color;

  const ListLeadingTextTile({Key? key, required this.text, this.color})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: AppVariables.appDefaultlistItemSize,
      height: AppVariables.appDefaultlistItemSize,
      decoration: BoxDecoration(
        color: Theme.of(context).extension<AppliedSurface>()?.brandSubTitle,
        borderRadius: BorderRadius.circular(AppVariables.appDefaultRadius),
      ),
      child: context.labelLarge(text, isSemiBold: true),
    );
  }
}
