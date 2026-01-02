import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/banner_entity.dart';
import 'package:littlefish_merchant/features/initial_pages/presentation/components/helper_component.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';

class BannerComponent extends StatelessWidget {
  final BannerEntity config;
  const BannerComponent({super.key, required this.config});
  @override
  Widget build(BuildContext context) {
    final textColour =
        Theme.of(context).extension<AppliedTextIcon>()?.primary ?? Colors.black;
    final inversColour =
        Theme.of(context).extension<AppliedTextIcon>()?.inversePrimary ??
        Colors.white;
    final versionText = 'Version: ${AppVariables.store?.state.version ?? ''}';
    final boxFit = getBoxFit(config.boxFit);

    Widget bannerImage = Image.asset(
      AppAssets.appLoginBannerPng,
      fit: boxFit,
      alignment: Alignment.topCenter,
      width: config.useWidth ? config.width : null,
      height: config.useHeight ? config.height : null,
    );

    if (config.useGradient) {
      bannerImage = Container(
        foregroundDecoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.white, Colors.white.withAlpha(0)],
          ),
        ),
        child: bannerImage,
      );
    }
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            config.leftPadding,
            config.topPadding,
            config.rightPadding,
            config.bottomPadding,
          ),
          child: bannerImage,
        ),
        if (config.showVersion)
          context.labelXXSmall(
            versionText,
            color: config.inverseColour ? inversColour : textColour,
          ),
      ],
    );
  }
}
