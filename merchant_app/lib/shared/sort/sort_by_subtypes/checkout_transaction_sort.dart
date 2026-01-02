import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/shared/sort/sort_by_subtypes/tools/sort_by_types.dart';
import '../../../models/enums.dart';

class CheckoutTransactionSort {
  final List<CheckoutTransaction> products;
  final SortBy? selectedSortType;

  CheckoutTransactionSort({
    required this.products,
    required this.selectedSortType,
  });

  List<CheckoutTransaction> sortList(SortOrder order) {
    List<CheckoutTransaction> itemList = List.from(products);
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
