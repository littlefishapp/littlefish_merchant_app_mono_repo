// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/products_menu_item.dart';

import '../../../../app/theme/applied_system/applied_text_icon.dart';

class ProductsMenuItems {
  static const List<MenuItem> firstItems = [name, price, createdDate];

  static const createdDate = MenuItem(text: 'Created Date');
  static const name = MenuItem(text: 'Product Name');
  static const price = MenuItem(text: 'Price');

  static Widget buildItem(
    MenuItem item,
    String sortSelection,
    SortOrder sortOrder,
    BuildContext context,
  ) {
    if (sortSelection.toLowerCase() == item.text.toLowerCase()) {
      return Row(
        children: [
          Flexible(
            flex: 10,
            child: Text(
              item.text,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Flexible(
            flex: 1,
            child: Icon(
              sortOrder == SortOrder.descending
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: Theme.of(context).extension<AppliedTextIcon>()?.primary,
              size: 20,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Text(item.text, style: const TextStyle(color: Colors.black)),
        ],
      );
    }
  }
}
