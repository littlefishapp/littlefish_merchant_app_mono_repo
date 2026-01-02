// features/home/presentation/components/home_header_component.dart
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/components/dashed_border.dart';
import 'package:littlefish_merchant/features/initial_pages/presentation/components/helper_component.dart';
import 'package:littlefish_merchant/ui/home/home_board_header/home_header_entity.dart';
import 'package:littlefish_merchant/ui/home/widgets/select_business_tile.dart';

class HomeHeaderComponent extends StatelessWidget {
  final HomeHeaderEntity config;

  const HomeHeaderComponent({super.key, required this.config});

  @override
  Widget build(BuildContext context) {
    final backgroundColor = _getDecorationColor(context);
    final textColor = _getTextColor(context);

    return Container(
      decoration: BoxDecoration(color: backgroundColor),
      padding: EdgeInsets.only(
        top: config.widgetPadding[0],
        right: config.widgetPadding[1],
        bottom: config.widgetPadding[2],
        left: config.widgetPadding[3],
      ),
      width: double.infinity,
      child: Column(
        children: [
          if (config.header1Texts.isNotEmpty)
            _buildRow(
              context,
              config.header1Texts,
              config.header1Weights,
              config.header1Sizes,
              textColor,
            ),
          if (config.useBusinessNameForHeader2) ...[
            const SizedBox(height: 8),
            _buildRow(context, [AppVariables.businessName], ['bold'], [
              'large',
            ], textColor),
          ],
          if (!config.useBusinessNameForHeader2 &&
              config.header2Texts.isNotEmpty) ...[
            const SizedBox(height: 8),
            _buildRow(
              context,
              config.header2Texts,
              config.header2Weights,
              config.header2Sizes,
              textColor,
            ),
          ],
          if (config.businessTileEnabled)
            Padding(
              padding: EdgeInsets.only(
                top: config.businessTilePadding[0],
                right: config.businessTilePadding[1],
                bottom: config.businessTilePadding[2],
                left: config.businessTilePadding[3],
              ),
              child: _buildBusinessTile(context),
            ),
        ],
      ),
    );
  }

  Widget _buildRow(
    BuildContext context,
    List<String> texts,
    List<String> weights,
    List<String> sizes,
    Color textColor,
  ) {
    return Wrap(
      children: List.generate(texts.length, (i) {
        final text = texts[i];
        final weight = i < weights.length ? weights[i] : 'normal';
        final size = i < sizes.length ? sizes[i] : 'large';

        final bool useBold = weight == 'bold';
        final bool useSemiBold = weight == 'semibold';

        return buildTextComponent(
          context,
          text,
          textColor,
          size,
          useSemiBold,
          useBold,
        );
      }),
    );
  }

  Widget _buildBusinessTile(BuildContext context) {
    final tile = SelectBusinessTile(context: context);

    if (config.businessTileDashEnabled) {
      return DashedBorder(
        dashSpace: 4,
        borderRadius: BorderRadius.circular(config.businessTileBorderRadius),
        color: Theme.of(context).colorScheme.surface,
        child: Padding(padding: EdgeInsets.all(4.0), child: tile),
      );
    }
    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.white, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: tile,
    );
  }

  Color _getDecorationColor(BuildContext context) {
    var fillColorUsed = Theme.of(context).extension<AppliedSurface>()?.primary;
    if (config.hasDecoratedSurface) {
      fillColorUsed = Theme.of(context).extension<AppliedSurface>()?.inverse;
    }
    return fillColorUsed ?? Colors.transparent;
  }

  Color _getTextColor(BuildContext context) {
    var textColour =
        Theme.of(context).extension<AppliedTextIcon>()?.primary ?? Colors.black;
    if (config.hasDecoratedSurface) {
      textColour =
          Theme.of(context).extension<AppliedTextIcon>()?.inversePrimary ??
          Colors.white;
    }
    return textColour;
  }
}
