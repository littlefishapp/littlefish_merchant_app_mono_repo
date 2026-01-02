import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/shared/sort/sort_by_subtypes/tools/sort_by_types.dart';

import '../../../models/enums.dart';

class StockProductSort {
  final List<StockProduct> items;
  final SortBy? selectedSortType;

  StockProductSort({required this.items, required this.selectedSortType});

  List<StockProduct> sortList(SortOrder order) {
    List<StockProduct> itemList = List.from(items);
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
              ? b.regularSellingPrice!.compareTo(a.regularSellingPrice!)
              : a.regularSellingPrice!.compareTo(b.regularSellingPrice!)),
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
