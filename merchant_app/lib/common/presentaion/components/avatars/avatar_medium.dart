// Flutter imports:

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/injector.dart';

import '../../../../app/theme/applied_system/applied_surface.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../tools/network_image/flutter_network_image.dart';

class AvatarMedium extends StatelessWidget {
  final String text;
  final String imageUrl;
  final String placeholder;
  final void Function()? onTap;

  const AvatarMedium({
    super.key,
    required this.context,
    this.text = '',
    this.imageUrl = '',
    this.placeholder = '',
    this.onTap,
  });

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    final avatarBackgroundColor = Theme.of(
      context,
    ).extension<AppliedSurface>()?.brand;
    final avatarForegroundColor = Theme.of(
      context,
    ).extension<AppliedTextIcon>()?.inversePrimary;

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: onTap,
        child: CircleAvatar(
          radius: 50,
          backgroundColor: avatarBackgroundColor,
          foregroundColor: avatarForegroundColor,
          child: imageUrl.isEmpty
              ? text.isEmpty
                    ? Icon(Icons.person, color: avatarForegroundColor, size: 48)
                    : context.body02x14R(
                        text.characters.first.toString(),
                        color: avatarForegroundColor,
                      )
              : SizedBox(
                  width: 48,
                  height: 48,
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
    );
  }
}
