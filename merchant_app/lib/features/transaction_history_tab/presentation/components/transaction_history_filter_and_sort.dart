import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/models/filter_item.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/models/sort_item.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/utility/transaction_filter_utility.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/data/utility/transaction_sort_utility.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/presentation/view_models/order_transaction_list_vm.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/presentation/components/transaction_history_filter_sort_tile.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:quiver/strings.dart';

class TransactionHistoryFilterSort extends StatefulWidget {
  final List<TransactionHistoryFilterItem> filters;
  final TransactionHistorySortItem? sort;
  const TransactionHistoryFilterSort({
    Key? key,
    required this.filters,
    required this.sort,
  }) : super(key: key);

  @override
  State<TransactionHistoryFilterSort> createState() =>
      _TransactionHistoryFilterSortState();
}

class _TransactionHistoryFilterSortState
    extends State<TransactionHistoryFilterSort> {
  late List<TransactionHistoryFilterItem> _filterItems;
  late List<TransactionHistorySortItem> _sortItems;
  @override
  void initState() {
    _filterItems = TransactionFilterUtility.generateFilterTiles(widget.filters);
    _sortItems = TransactionSortUtility.generateSortTiles(widget.sort);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OrderTransactionListVM>(
      converter: (store) => OrderTransactionListVM.fromStore(store),
      onDidChange: (oldViewModel, newViewmodel) {
        if ((oldViewModel?.filterTypes ?? []).length !=
            (newViewmodel.filterTypes ?? []).length) {
          setState(() {
            _filterItems = TransactionFilterUtility.generateFilterTiles(
              newViewmodel.filterTypes ?? [],
            );
          });
        }
        if (oldViewModel!.sortType?.type != newViewmodel.sortType?.type) {
          setState(() {
            _sortItems = TransactionSortUtility.generateSortTiles(
              newViewmodel.sortType,
            );
          });
        }
      },
      builder: (ctx, vm) {
        return Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Container(
                height: MediaQuery.of(context).size.height * 1.75,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(25.0),
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(flex: 3, child: _contentSort(context, vm)),
                    Expanded(flex: 8, child: _contentFilter(context, vm)),
                  ],
                ),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                color: Theme.of(context).colorScheme.background,
                height: 88,
                child: Row(
                  children: [
                    Expanded(
                      flex: 1,
                      child: ButtonSecondary(
                        isNegative: true,
                        text: 'Clear All',
                        onTap: (_) async {
                          await vm.clearFilteredList!();
                          await vm.updateFilteredTransactions!([], null);
                          if (isNotBlank(vm.searchText)) {
                            await vm.updateSearchTransactions!(
                              [],
                              null,
                              vm.searchText!,
                            );
                          }
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      flex: 1,
                      child: ButtonPrimary(
                        text: 'Apply Filters',
                        onTap: (_) async {
                          await vm.updateFilteredTransactions!(
                            vm.filterTypes ?? [],
                            vm.sortType,
                          );
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  _contentFilter(BuildContext context, OrderTransactionListVM vm) =>
      GroupedListView(
        sort: false,
        physics: const NeverScrollableScrollPhysics(),
        order: GroupedListOrder.DESC,
        stickyHeaderBackgroundColor: Colors.transparent,
        elements: _filterItems,
        groupBy: (TransactionHistoryFilterItem? ft) {
          return ft!.groupLabel;
        },
        groupSeparatorBuilder: (String? groupName) =>
            _groupTitle(context, groupName),
        itemBuilder: (ctx, TransactionHistoryFilterItem item) {
          if (item.type == OrderTransactionHistoryFilter.startDate ||
              item.type == OrderTransactionHistoryFilter.endDate) {
            return TransactionHistoryFilterDateTile(filter: item, vm: vm);
          }
          return TransactionHistoryFilterTile(vm: vm, filter: item);
        },
        separator: const SizedBox.shrink(),
      );

  _contentSort(BuildContext context, OrderTransactionListVM vm) =>
      GroupedListView(
        sort: true,
        physics: const NeverScrollableScrollPhysics(),
        order: GroupedListOrder.DESC,
        stickyHeaderBackgroundColor: Colors.transparent,
        elements: _sortItems,
        groupBy: (TransactionHistorySortItem? ft) {
          return ft!.groupLabel;
        },
        groupSeparatorBuilder: (String? groupName) =>
            _groupTitle(context, groupName),
        itemBuilder: (ctx, TransactionHistorySortItem item) =>
            TransactionHistorySortTile(
              vm: vm,
              sort: item,
              onTap: (value) async {
                item.enabled = value;
                await vm.updateTransactionSort!(item);
                setState(() {});
              },
            ),
        separator: const SizedBox.shrink(),
      );

  Widget _groupTitle(BuildContext context, String? groupName) => Padding(
    padding: const EdgeInsets.only(left: 16, right: 24, bottom: 0, top: 4),
    child: context.labelLarge(
      groupName ?? '',
      alignLeft: true,
      isSemiBold: true,
    ),
  );
}
