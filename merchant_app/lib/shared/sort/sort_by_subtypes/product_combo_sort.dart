import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/shared/sort/sort_by_subtypes/tools/sort_by_types.dart';

import '../../../models/enums.dart';

class ProductComboSort {
  final List<ProductCombo> items;
  final SortBy? selectedSortType;

  ProductComboSort({required this.items, required this.selectedSortType});

  List<ProductCombo> sortList(SortOrder order) {
    List<ProductCombo> itemList = List.from(items);
    final sortType = ProductSortBy();
    if (selectedSortType != null) {
      if (selectedSortType == sortType.name) {
        itemList.sort(
          ((a, b) => order == SortOrder.descending
              ? b.displayName!.toLowerCase().compareTo(
                  a.displayName!.toLowerCase(),
                )
              : a.displayName!.toLowerCase().compareTo(
                  b.displayName!.toLowerCase(),
                )),
        );
      } else if (selectedSortType == sortType.createdDate) {
        itemList.sort(
          ((a, b) => order == SortOrder.descending
              ? b.dateCreated!.compareTo(a.dateCreated!)
              : a.dateCreated!.compareTo(b.dateCreated!)),
        );
      } else if (selectedSortType == sortType.price) {
        itemList.sort(
          ((a, b) => order == SortOrder.descending
              ? b.comboSellingPrice.compareTo(a.comboSellingPrice)
              : a.comboSellingPrice.compareTo(b.comboSellingPrice)),
        );
      } else {
        itemList.sort(
          ((a, b) => order == SortOrder.ascending
              ? b.dateCreated!.compareTo(a.dateCreated!)
              : a.dateCreated!.compareTo(b.dateCreated!)),
        );
      }
    } else {
      itemList.sort(
        ((a, b) => order == SortOrder.ascending
            ? b.dateCreated!.compareTo(a.dateCreated!)
            : a.dateCreated!.compareTo(b.dateCreated!)),
      );
    }
    return itemList;
  }
}
