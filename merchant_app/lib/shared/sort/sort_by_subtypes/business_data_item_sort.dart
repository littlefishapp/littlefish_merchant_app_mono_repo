import 'package:littlefish_merchant/models/shared/simple_data_item.dart';
import 'package:littlefish_merchant/shared/sort/sort_by_subtypes/tools/sort_by_types.dart';

import '../../../models/enums.dart';

class BusinessDataItemSort {
  final List<BusinessDataItem> items;
  final SortBy? selectedSortType;

  BusinessDataItemSort({required this.items, required this.selectedSortType});

  List<BusinessDataItem> sortList(SortOrder order) {
    List<BusinessDataItem> itemList = items;
    final sortType = BusinessDataItemSortBy();
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
