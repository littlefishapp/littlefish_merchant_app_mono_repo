import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/shared/constants/semantics_constants.dart';

import '../../../../app/theme/applied_system/applied_surface.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../injector.dart';
import '../../../../tools/network_image/flutter_network_image.dart';

class AvatarXSmall extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String placeholder;
  final void Function()? onTap;

  const AvatarXSmall({
    super.key,
    this.text = '',
    this.imageUrl = '',
    this.placeholder = '',
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final appliedTextIconTheme = Theme.of(context).extension<AppliedTextIcon>();
    final appliedSurface = Theme.of(context).extension<AppliedSurface>();
    final avatarBackgroundColor = appliedSurface?.brand ?? Colors.red;
    final avatarForegroundColor =
        appliedTextIconTheme?.inversePrimary ?? Colors.red;

    return Padding(
      padding: const EdgeInsets.only(right: 10),
      child: Semantics(
        identifier: SemanticsConstants.kWorkspaceSwitch, // For UI Tests
        label: SemanticsConstants.kWorkspaceSwitch, //For screen reader
        child: InkWell(
          onTap: onTap,
          child: CircleAvatar(
            radius: 16,
            backgroundColor: avatarBackgroundColor,
            foregroundColor: avatarForegroundColor,
            child: imageUrl.isEmpty
                ? text.isEmpty
                      ? context.body02x14R('U', color: avatarForegroundColor)
                      : context.body02x14R(
                          text.characters.first.toString(),
                          color: avatarForegroundColor,
                        )
                : SizedBox(
                    width: 32,
                    height: 32,
                    child: ClipOval(
                      child: FadeInImage(
                        image: getIt<FlutterNetworkImage>().asImageProviderById(
                          id: '',
                          category: '',
                          legacyUrl: imageUrl,
                          height: AppVariables.listImageHeight,
                          width: AppVariables.listImageWidth,
                        ),
                        placeholder: AssetImage(placeholder),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}
