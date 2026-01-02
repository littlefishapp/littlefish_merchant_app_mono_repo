import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dashed_border.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/add_option.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_option_tile.dart';

class ProductOptionsCard extends StatefulWidget {
  final List<ProductOptionAttribute> productOptionAttributes;
  final List<ProductOptionAttribute> allOptionAttributes;
  final void Function(
    ProductOptionAttribute optionAttribute,
    String? originalOptionName,
  )
  onUpsert;
  final void Function(ProductOptionAttribute optionAttribute) onDelete;
  final int maxOptions;

  const ProductOptionsCard({
    super.key,
    required this.productOptionAttributes,
    required this.allOptionAttributes,
    required this.onUpsert,
    required this.onDelete,
    this.maxOptions = 3,
  });

  @override
  State<ProductOptionsCard> createState() => _ProductOptionsCardState();
}

class _ProductOptionsCardState extends State<ProductOptionsCard> {
  AppliedSurface? surface;
  AppliedTextIcon? textIcon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    textIcon ??= theme.extension<AppliedTextIcon>();
    surface ??= theme.extension<AppliedSurface>();
    return _productOptionsCard();
  }

  Widget _productOptionsCard() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: textIcon?.deEmphasized ?? Colors.green.shade300,
          width: 1,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          children: [
            Row(
              children: [
                context.labelMediumBold('Product Options'),
                const Spacer(),
                context.labelSmall(
                  '${widget.productOptionAttributes.length}/${widget.maxOptions}',
                  color: textIcon?.deEmphasized,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: widget.productOptionAttributes.isEmpty
                  ? _noOptions()
                  : _optionsList(),
            ),
            ButtonPrimary(
              text: 'Add Option',
              icon: Icons.add,
              disabled:
                  widget.productOptionAttributes.length >= widget.maxOptions,
              onTap: (ctx) async {
                await showCustomDialog(
                  context: context,
                  content: AddOption(
                    allOptionsAndAttributes: widget.allOptionAttributes,
                    onUpsert: widget.onUpsert,
                    alreadyUsedOptionNames: widget.productOptionAttributes
                        .map((optionAttributes) => optionAttributes.option)
                        .whereType<String>()
                        .toList(),
                  ),
                  borderDismissable: false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _noOptions() {
    return DashedBorder(
      borderRadius: BorderRadius.circular(8),
      color: textIcon?.deEmphasized ?? Colors.grey.shade300,
      child: Container(
        width: double.infinity,
        height: 90,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add,
              size: 32,
              color: textIcon?.deEmphasized ?? Colors.grey.shade400,
            ),
            const SizedBox(height: 4),
            context.paragraphSmall(
              'No options added yet',
              color: textIcon?.deEmphasized,
            ),
          ],
        ),
      ),
    );
  }

  Widget _optionsList() {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.productOptionAttributes.length,
      itemBuilder: (context, index) {
        final optionAttribute = widget.productOptionAttributes[index];
        return ProductOptionTile(
          optionAttribute: optionAttribute,
          onEdit: (option) {
            showCustomDialog(
              context: context,
              content: AddOption(
                allOptionsAndAttributes: widget.allOptionAttributes,
                onUpsert: widget.onUpsert,
                initialOptionAttribute: option,
                alreadyUsedOptionNames: widget.productOptionAttributes
                    .map((optionAttributes) => optionAttributes.option)
                    .whereType<String>()
                    .toList(),
              ),
              borderDismissable: false,
            );
          },
          onDelete: (option) {
            widget.onDelete(option);
            setState(() {});
          },
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          const SizedBox(height: 16),
    );
  }
}
