import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/toggle_switch.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/models/stock/product_option.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/edit_variant_page.dart';

class ProductVariantTile extends StatelessWidget {
  final ProductOption productOption;
  final void Function(ProductOption productOption) onSave;
  const ProductVariantTile({
    super.key,
    required this.productOption,
    required this.onSave,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
        children: [
          ListTile(
            contentPadding: const EdgeInsets.only(left: 16, right: 4),
            leading: _leading(context, productOption),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                context.labelSmall(
                  _getVariantName(productOption),
                  isBold: true,
                ),
              ],
            ),
            trailing: _trailing(context, productOption),
            subtitle: _priceAndCost(context, productOption),
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: _toggleEnabled(context, productOption.enabled ?? false),
              ),
              const Spacer(),
              if (productOption.isStockTrackable)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: context.labelSmall(
                    '${productOption.variances.first.quantity} units',
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _leading(BuildContext context, ProductOption productOption) {
    if (productOption.imageUri.isNotEmpty) {
      return ListLeadingImageTile(url: productOption.imageUri);
    }

    var displayName = productOption.displayName ?? productOption.name;
    if (displayName == null || displayName.isEmpty || displayName.length < 2) {
      return const ListLeadingIconTile(icon: Icons.inventory_2_outlined);
    }
    var displayNameSubstring = displayName.substring(0, 2);

    return ListLeadingTextTile(text: displayNameSubstring);
  }

  String _getVariantName(ProductOption productOption) {
    var variantName = productOption.displayName ?? productOption.name;
    if (variantName == null || variantName.isEmpty) {
      return 'Unnamed Variant';
    }
    return variantName;
  }

  Widget _priceAndCost(BuildContext context, ProductOption productOption) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        context.labelXSmall(_getVariantPrice(productOption)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: context.labelXSmall('•'),
        ),
        context.labelXSmall('${_getVariantCostPrice(productOption)} cost'),
      ],
    );
  }

  String _getVariantPrice(ProductOption productOption) {
    if (productOption.variances.isEmpty) return 'No price available';
    return TextFormatter.toStringCurrency(
      productOption.variances.first.sellingPrice,
    );
  }

  String _getVariantCostPrice(ProductOption productOption) {
    if (productOption.variances.isEmpty) return 'No cost price available';
    return TextFormatter.toStringCurrency(
      productOption.variances.first.costPrice,
    );
  }

  Widget _trailing(BuildContext context, ProductOption productOption) {
    return IconButton(
      icon: const Icon(Icons.edit_outlined),
      onPressed: () async {
        await showCustomDialog(
          borderDismissable: false,
          context: context,
          content: EditVariantPage(
            productOption: productOption,
            onSave: onSave,
          ),
        );
      },
    );
  }

  Widget _toggleEnabled(BuildContext context, bool isEnabled) {
    return Row(
      children: [
        ToggleSwitch(
          initiallyEnabled: isEnabled,
          enabledColor: Theme.of(context).extension<AppliedTextIcon>()?.brand,
        ),
        const SizedBox(width: 12),
        context.labelSmall(isEnabled ? 'Enabled' : 'Disabled'),
      ],
    );
  }
}
