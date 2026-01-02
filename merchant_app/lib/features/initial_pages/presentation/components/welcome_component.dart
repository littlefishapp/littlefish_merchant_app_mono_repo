import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/features/initial_pages/domain/entities/welcome_entity.dart';
import 'package:littlefish_merchant/features/initial_pages/presentation/components/helper_component.dart';

class WelcomeComponent extends StatelessWidget {
  final WelcomeEntity config;
  const WelcomeComponent({super.key, required this.config});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: config.componentPadding.isEmpty
          ? EdgeInsets.zero
          : EdgeInsets.only(
              top: config.componentPadding[0],
              right: config.componentPadding[1],
              bottom: config.componentPadding[2],
              left: config.componentPadding[3],
            ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: _buildChildren(context),
      ),
    );
  }

  List<Widget> _buildChildren(BuildContext context) {
    final List<Widget> children = [];
    final Color textColor = _getTextColor(context);
    if (config.topRow.isNotEmpty) {
      children.add(
        _buildRow(
          context,
          config.topRow,
          config.topWeight,
          textColor,
          rowSize: config.topSize,
        ),
      );
    }
    if (config.middleRow.isNotEmpty) {
      children.add(const SizedBox(height: 8.0));
      children.add(
        _buildRow(
          context,
          config.middleRow,
          config.middleWeight,
          textColor,
          rowSize: config.middleSize,
        ),
      );
    }
    if (config.bottomRow.isNotEmpty) {
      children.add(const SizedBox(height: 8.0));
      children.add(
        _buildRow(
          context,
          config.bottomRow,
          config.bottomWeight,
          textColor,
          rowSize: config.bottomSize,
        ),
      );
    }
    return children;
  }

  Widget _buildRow(
    BuildContext context,
    List<String> texts,
    List<String> weights,
    Color textColor, {
    required String rowSize,
  }) {
    return Wrap(
      children: List.generate(texts.length, (index) {
        final String text = texts[index];
        final String weight = index < weights.length
            ? weights[index]
            : 'normal';
        final bool isXSmall = rowSize.toLowerCase() == 'xsmall';
        final bool useSemiBold = isXSmall && weight == 'semibold';
        final bool useBold = !isXSmall && weight == 'bold';
        return buildTextComponent(
          context,
          text,
          textColor,
          rowSize,
          useSemiBold,
          useBold,
        );
      }),
    );
  }

  Color _getTextColor(BuildContext context) {
    final textColour =
        Theme.of(context).extension<AppliedTextIcon>()?.primary ?? Colors.black;
    final inversColour =
        Theme.of(context).extension<AppliedTextIcon>()?.inversePrimary ??
        Colors.white;

    if (config.inverseColour) {
      return inversColour;
    } else {
      return textColour;
    }
  }
}
