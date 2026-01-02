import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/product_attribute_chip.dart';

class ProductOptionTile extends StatelessWidget {
  final ProductOptionAttribute optionAttribute;
  final void Function(ProductOptionAttribute) onEdit;
  final void Function(ProductOptionAttribute) onDelete;
  const ProductOptionTile({
    super.key,
    required this.optionAttribute,
    required this.onEdit,
    required this.onDelete,
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
      child: ListTile(
        contentPadding: const EdgeInsets.only(left: 16, right: 4),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.max,
          children: [
            context.labelSmall(
              optionAttribute.option ?? 'Error loading option',
              isBold: true,
            ),
            _trailing(context, optionAttribute),
          ],
        ),
        // trailing: _trailing(context, optionAttribute),
        subtitle: _attributesList(context, optionAttribute.attributes ?? []),
      ),
    );
  }

  Widget _trailing(
    BuildContext context,
    ProductOptionAttribute optionAttribute,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.edit_outlined),
          onPressed: () => onEdit(optionAttribute),
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline),
          onPressed: () => onDelete(optionAttribute),
        ),
      ],
    );
  }

  Widget _attributesList(BuildContext context, List<String> attributes) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 4.0,
      children: attributes
          .map((attribute) => ProductAttributeChip(attribute: attribute))
          .toList(),
    );
  }
}
