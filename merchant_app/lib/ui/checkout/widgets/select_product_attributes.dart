import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/selectable_attribute_chip.dart';

class SelectProductAttributes extends StatelessWidget {
  final ProductOptionAttribute optionAttribute;
  final String? selectedAttribute;
  final ValueChanged<String> onAttributeSelected;

  const SelectProductAttributes({
    super.key,
    required this.optionAttribute,
    required this.selectedAttribute,
    required this.onAttributeSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        context.labelLarge(
          TextFormatter.toCapitalize(value: optionAttribute.option ?? ''),
          isBold: true,
        ),
        const SizedBox(height: 12.0),
        _attributesList(context, optionAttribute.attributes ?? []),
      ],
    );
  }

  Widget _attributesList(BuildContext context, List<String> attributes) {
    return Wrap(
      spacing: 8.0,
      runSpacing: 8.0,
      children: attributes
          .map(
            (attribute) => SelectableAttributeChip(
              attribute: attribute,
              isSelected: selectedAttribute == attribute,
              onTap: () => onAttributeSelected(attribute),
            ),
          )
          .toList(),
    );
  }
}
