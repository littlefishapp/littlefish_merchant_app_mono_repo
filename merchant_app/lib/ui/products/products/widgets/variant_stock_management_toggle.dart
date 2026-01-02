import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/toggle_switch.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/branded_info_container.dart';

class VariantStockManagementToggle extends StatelessWidget {
  final void Function(bool isEnabled) onChanged;
  final bool isTrackVariantStock;

  const VariantStockManagementToggle({
    super.key,
    required this.isTrackVariantStock,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color:
              Theme.of(context).extension<AppliedTextIcon>()?.deEmphasized ??
              Colors.green.shade300,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.labelMediumBold('Stock Management'),
          _toggleEnabled(
            context: context,
            isEnabled: isTrackVariantStock,
            onChanged: onChanged,
          ),
          if (isTrackVariantStock)
            _variantTrackingInfoBox(context)
          else
            _parentTrackingInfoBox(context),
        ],
      ),
    );
  }

  Widget _toggleEnabled({
    required BuildContext context,
    required bool isEnabled,
    required void Function(bool) onChanged,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        context.labelSmall('Track per variant'),
        ToggleSwitch(
          initiallyEnabled: isEnabled,
          enabledColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
          onChanged: onChanged,
        ),
      ],
    );
  }

  Widget _variantTrackingInfoBox(BuildContext context) {
    return const BrandedInfoContainer(
      title: 'Variant tracking enabled',
      description: 'Each variant has individual inventory',
    );
  }

  Widget _parentTrackingInfoBox(BuildContext context) {
    return const BrandedInfoContainer(
      title: 'Parent product tracking',
      description: 'Stock managed at product level',
    );
  }
}
