// File: drawer_title_component.dart
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/components/drawers/main_drawer_title.dart/domain/entity/drawer_title_entity.dart';
import 'package:littlefish_merchant/features/initial_pages/presentation/components/helper_component.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';

class DrawerTitleComponent extends StatelessWidget {
  final DrawerTitleEntity config;
  const DrawerTitleComponent({super.key, required this.config});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: _buildPadding(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: _buildChildren(context),
      ),
    );
  }

  EdgeInsets _buildPadding() {
    if (config.padding.length < 4) {
      return EdgeInsets.zero;
    }
    return EdgeInsets.only(
      left: config.padding[0],
      top: config.padding[1],
      right: config.padding[2],
      bottom: config.padding[3],
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    final List<Widget> children = [];
    final Color textColor = _getTextColor(context);

    final int textCount = config.texts.length;
    if (textCount == 0) {
      return children;
    }

    final List<String> sizes = _padList(config.textSizes, textCount, 'medium');
    final List<String> weights = _padList(
      config.textWeights,
      textCount,
      'normal',
    );

    for (int i = 0; i < textCount; i++) {
      final String text = config.texts[i];
      if (text.isEmpty) continue;
      final String size = sizes[i];
      final String weight = weights[i];
      final bool useBold = weight.toLowerCase() == 'bold';
      final bool useSemiBold = weight.toLowerCase() == 'semibold';
      children.add(
        buildTextComponent(
          context,
          text,
          textColor,
          size,
          useSemiBold,
          useBold,
        ),
      );
    }

    if (config.showIcon && config.useAssetLogo) {
      children.add(const Expanded(child: SizedBox()));
      children.add(
        Image.asset(AppAssets.appLogo, fit: BoxFit.fitWidth, width: 24),
      );
    }

    return children;
  }

  List<String> _padList(List<String> list, int length, String defaultVal) {
    if (list.length >= length) {
      return list.sublist(0, length);
    }
    return [...list, ...List.filled(length - list.length, defaultVal)];
  }

  Color _getTextColor(BuildContext context) {
    final textColour =
        Theme.of(context).extension<AppliedTextIcon>()?.primary ?? Colors.black;
    final inverseColour =
        Theme.of(context).extension<AppliedTextIcon>()?.inversePrimary ??
        Colors.white;

    if (config.inverseColour) {
      return inverseColour;
    } else {
      return textColour;
    }
  }
}
