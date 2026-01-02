// logo.dart (transformed to use LogoEntity)
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/logo_entity.dart';
import 'package:littlefish_merchant/features/initial_pages/presentation/components/helper_component.dart';

class LogoComponent extends StatelessWidget {
  final LogoEntity config;

  const LogoComponent({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final textColour =
        Theme.of(context).extension<AppliedTextIcon>()?.primary ?? Colors.black;
    final inversColour =
        Theme.of(context).extension<AppliedTextIcon>()?.inversePrimary ??
        Colors.white;
    final versionText = 'Version: ${AppVariables.store?.state.version ?? ''}';

    Widget logoImage = Image.asset(
      UIStateData().appLogo, // AppAssets.appLoginBannerPng,
      fit: getBoxFit(config.boxFit),
      width: config.useWidth ? config.width : null,
      height: config.useHeight ? config.height : null,
    );

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(
            config.leftPadding,
            config.topPadding,
            config.rightPadding,
            config.bottomPadding,
          ),
          child: logoImage,
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
