import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/stock/full_product.dart';
import 'package:littlefish_merchant/models/stock/product_option.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/branded_info_container.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_options_card.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_variant_tile.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/variant_stock_management_toggle.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class ProductOptionsContent extends StatefulWidget {
  final FullProduct productWithOptions;
  final List<ProductOptionAttribute> allOptionAttributes;
  final void Function(
    ProductOptionAttribute optionAttribute,
    String? originalOptionName,
  )
  onUpsert;
  final void Function(ProductOptionAttribute optionAttribute) onDelete;
  final void Function(ProductOption productOption) onSaveVariant;
  final int maxOptions;
  final void Function(bool isManageVariantStock) onManageVariantStockChanged;

  const ProductOptionsContent({
    super.key,
    required this.productWithOptions,
    required this.allOptionAttributes,
    required this.onUpsert,
    required this.onDelete,
    required this.onSaveVariant,
    required this.onManageVariantStockChanged,
    this.maxOptions = 3,
  });

  @override
  State<ProductOptionsContent> createState() => _ProductOptionsContentState();
}

class _ProductOptionsContentState extends State<ProductOptionsContent> {
  AppliedSurface? surface;
  AppliedTextIcon? textIcon;
  late List<ProductOptionAttribute> allOptionAttributes;
  late List<ProductOptionAttribute> productOptionAttributes;
  late List<ProductOption> productOptions;

  @override
  void initState() {
    super.initState();
    allOptionAttributes = widget.allOptionAttributes;
    productOptionAttributes =
        widget.productWithOptions.product.productOptionAttributes ?? [];
    productOptions = widget.productWithOptions.productOptions ?? [];
  }

  @override
  void didUpdateWidget(covariant ProductOptionsContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.productWithOptions != widget.productWithOptions) {
      productOptionAttributes =
          widget.productWithOptions.product.productOptionAttributes ?? [];
      productOptions = widget.productWithOptions.productOptions ?? [];
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    textIcon ??= theme.extension<AppliedTextIcon>();
    surface ??= theme.extension<AppliedSurface>();

    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoBox(),
            ProductOptionsCard(
              allOptionAttributes: allOptionAttributes,
              productOptionAttributes: productOptionAttributes,
              onUpsert: widget.onUpsert,
              onDelete: widget.onDelete,
              maxOptions: widget.maxOptions,
            ),
            VariantStockManagementToggle(
              isTrackVariantStock:
                  widget.productWithOptions.product.manageVariantStock ?? false,
              onChanged: (value) {
                setState(() {
                  widget.onManageVariantStockChanged(value);
                });
              },
            ),
            if (productOptions.isNotEmpty) _showVariants(productOptions),
          ],
        ),
      ),
    );
  }

  Widget _infoBox() {
    return BrandedInfoContainer(
      title: 'How Product Options Work',
      description:
          'Add options like "Size" or "Colour" to create variants. Each combination becomes a separate variant that you can customise.',
      icon: LittleFishIcons.info,
    );
  }

  Widget _showVariants(List<ProductOption> productOptions) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 16),
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: textIcon?.deEmphasized ?? Colors.green.shade300,
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              context.labelMediumBold('Variants'),
              const Spacer(),
              context.labelSmall(
                productOptions.length == 1
                    ? '${productOptions.length} variant'
                    : '${productOptions.length} variants',
                color: textIcon?.deEmphasized,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: productOptions.length,
            itemBuilder: (context, index) {
              final productOption = productOptions[index];
              return ProductVariantTile(
                productOption: productOption,
                onSave: (variant) {
                  widget.onSaveVariant(variant);
                  setState(() {
                    productOptions[index] = variant;
                  });
                },
              );
            },
            separatorBuilder: (context, index) {
              return const SizedBox(height: 16);
            },
          ),
        ],
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
