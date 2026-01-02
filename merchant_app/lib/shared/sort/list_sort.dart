import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/shared/sort/sort_by_subtypes/business_data_item_sort.dart';
import 'package:littlefish_merchant/shared/sort/sort_by_subtypes/product_combo_sort.dart';
import 'package:littlefish_merchant/shared/sort/sort_by_subtypes/stock_product_sort.dart';
import '../../models/enums.dart';

class ListSort {
  SortOrder updateSortOrder({
    required SortOrder order,
    required SortBy? type,
    required SortBy newType,
  }) {
    if (type == null || newType != type) {
      return SortOrder.ascending;
    }
    if (newType == type && order == SortOrder.ascending) {
      return SortOrder.descending;
    } else if (newType == type && order == SortOrder.descending) {
      return SortOrder.ascending;
    }
    return SortOrder.ascending;
  }

  List<E> getSortedItems<E>({
    required SortBy? type,
    required SortOrder order,
    required List<E> items,
    required List<E> filteredItems,
    required String searchText,
    bool? isOnlyTrackableStock,
    bool? isOnlyOfflineProducts,
  }) {
    // TODO(brandon): Add checkout transaction sorted lists
    // TODO(brandon): Make dynamic menu items for sorts
    if (items is List<BusinessDataItem> &&
        filteredItems is List<BusinessDataItem>) {
      List<BusinessDataItem> sortedList = [];
      if (searchText == '') {
        sortedList = items as List<BusinessDataItem>;
      } else if (searchText != '') {
        sortedList = filteredItems as List<BusinessDataItem>;
      }

      return sortHelper(
        items: items,
        sortedList: sortedList,
        order: order,
        type: type,
        isOnlyOfflineProducts: isOnlyOfflineProducts,
        isOnlyTrackableStock: isOnlyTrackableStock,
      );
    }
    return items;
  }

  static List<E> sortHelper<E>({
    required List<E> items,
    required List<BusinessDataItem> sortedList,
    required SortOrder order,
    required SortBy? type,
    bool? isOnlyTrackableStock,
    bool? isOnlyOfflineProducts,
  }) {
    List<BusinessDataItem> sortedList0 = sortedList;
    if (items is List<StockProduct>) {
      sortedList0 = sortedList0 as List<StockProduct>;
      if (isOnlyTrackableStock == true) {
        sortedList0 = sortedList0
            .where((element) => element.isStockTrackable == true)
            .toList();
      }

      sortedList0 = StockProductSort(
        items: sortedList0,
        selectedSortType: type,
      ).sortList(order);

      if (isOnlyOfflineProducts == true) {
        sortedList0 = sortedList0
            .where((element) => element.isOnline == false)
            .toList();
      }
    } else if (items is List<ProductCombo>) {
      sortedList0 = ProductComboSort(
        items: sortedList0 as List<ProductCombo>,
        selectedSortType: type,
      ).sortList(order);
    } else {
      sortedList0 = BusinessDataItemSort(
        items: sortedList0,
        selectedSortType: type,
      ).sortList(order);
    }
    return sortedList0 as List<E>;
  }
}
