import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

class StockProductTileMore extends StatelessWidget {
  final bool showMore;
  final bool hasDiscount;
  final void Function(String)? removeItem;
  final String productId;

  const StockProductTileMore({
    super.key,
    this.showMore = false,
    this.hasDiscount = false,
    this.removeItem,
    this.productId = '',
  });

  @override
  Widget build(BuildContext context) {
    final menuItems = [
      if (hasDiscount) 'Apply Discount' else 'Edit Discount',
      'Remove Item',
    ];
    return showMore
        ? Padding(
            padding: const EdgeInsets.only(left: 12),
            child: DropdownButton2(
              customButton: Icon(
                Icons.more_vert,
                color: Theme.of(context).colorScheme.secondary,
              ),
              alignment: Alignment.centerRight,
              isDense: true,
              underline: const SizedBox.shrink(),
              items: menuItems
                  .map(
                    (item) => DropdownMenuItem(
                      value: item,
                      child: context.paragraphMedium(
                        item,
                        color: Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (menuItems[0] == value) {
                  // TODO(lampian): add product level discount actions
                } else if (menuItems[1] == value && removeItem != null) {
                  removeItem!(productId);
                }
                debugPrint('StockProductTileMore selected $value');
              },
              dropdownStyleData: DropdownStyleData(
                decoration: const BoxDecoration(color: Colors.white),
                maxHeight: menuItems.length * 75,
                width: MediaQuery.of(context).size.width * 0.5,
              ),
            ),
          )
        : const SizedBox.shrink();
  }
}
