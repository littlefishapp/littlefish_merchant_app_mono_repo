import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';

import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';

import 'package:littlefish_merchant/redux/sales/sales_actions.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

import 'package:littlefish_merchant/ui/sales/view_models.dart';

import 'package:littlefish_merchant/ui/sales/widgets/sales_transaction_tile.dart';
import 'package:quiver/strings.dart';

class SalesTabLayout extends StatefulWidget {
  final SalesVM vm;
  final TextEditingController searchController;
  final bool isFiltered;
  final ScrollController? controller;
  final SalesSubType type;
  final List<CheckoutTransaction?> transactions;

  const SalesTabLayout({
    Key? key,
    required this.vm,
    required this.searchController,
    required this.isFiltered,
    required this.controller,
    required this.type,
    required this.transactions,
  }) : super(key: key);

  @override
  State<SalesTabLayout> createState() => _SalesTabLayoutState();
}

class _SalesTabLayoutState extends State<SalesTabLayout> {
  late List<CheckoutTransaction?> _transactions;

  @override
  void initState() {
    _transactions = List.from(widget.transactions);

    _sortTransactions(widget.type);

    super.initState();
  }

  _sortTransactions(SalesSubType type) {
    _transactions.sort(
      (a, b) => (_groupDate(type, a)).compareTo((_groupDate(widget.type, b))),
    );
  }

  DateTime _getRefundSortDate(CheckoutTransaction? item) {
    if (item == null) return DateTime.now();

    var isQuickRefund = item.refunds?.first.isQuickRefund ?? false;

    return isQuickRefund
        ? item.dateCreated ?? DateTime.now()
        : item.refunds?.last.dateCreated ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    _transactions = List.from(widget.transactions);
    return _body(context, widget.vm, widget.type);
  }

  Column _body(BuildContext ctx, SalesVM vm, SalesSubType type) => Column(
    children: [
      _content(ctx),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: FooterButtonsIconPrimary(
          primaryButtonText: 'Load More Transactions',
          onPrimaryButtonPressed: (ctx) async {
            if (isBlank(widget.searchController.text)) {
              vm.onLoadMoreBySalesSubType(context, type);
            } else {
              await vm.store!.dispatch(
                getFilteredBatchBySalesSubType(
                  type,
                  widget.searchController.text,
                ),
              );
            }
          },
          secondaryButtonIcon: Icons.refresh,
          onSecondaryButtonPressed: (ctx) {
            vm.store!.dispatch(getInitialTransactions(forceRefresh: true));
            vm.onSyncSales(ctx);
          },
        ),
      ),
    ],
  );

  Expanded _content(BuildContext ctx) {
    return Expanded(
      child: _transactions.isEmpty
          ? _noTransactionsFound()
          : _transactionsFound(),
    );
  }

  Center _noTransactionsFound() {
    return const Center(child: Text('No transactions found'));
  }

  _transactionsFound() => GroupedListView(
    sort: false,
    order: widget.isFiltered ? GroupedListOrder.ASC : GroupedListOrder.DESC,
    controller: widget.controller,
    physics: const BouncingScrollPhysics(),
    elements: _transactions,
    groupBy: (CheckoutTransaction? tx) {
      var date = _groupDate(widget.type, tx);

      return DateTime(date.year, date.month, date.day);
    },
    groupSeparatorBuilder: (DateTime? date) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: _groupTitle(date ?? DateTime.now()),
    ),
    itemBuilder: (ctx, CheckoutTransaction? item) => _listItemTile(ctx, item!),
  );

  DateTime _groupDate(SalesSubType type, CheckoutTransaction? tx) {
    if (tx == null) return DateTime.now();

    switch (type) {
      case SalesSubType.cancelled:
        return tx.dateUpdated ?? tx.dateCreated ?? DateTime.now();
      case SalesSubType.refunded:
        return _getRefundSortDate(tx);
      case SalesSubType.all:
      case SalesSubType.withdrawals:
      case SalesSubType.completed:
      default:
        return tx.dateCreated ?? DateTime.now();
    }
  }

  _groupTitle(DateTime date) => Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      _groupTitleLeadingText(date),
      // _groupTitleTrailingText(date),
    ],
  );

  _groupTitleLeadingText(DateTime date) => context.labelSmall(
    TextFormatter.toShortDate(
      dateTime: date,
      format: 'dd MMMM yyyy',
    ).toUpperCase(),
    isSemiBold: true,
  );

  _listItemTile(BuildContext ctx, CheckoutTransaction item) =>
      SalesTransactionTile(sale: item);

  String toTitleCase(String text) {
    return text
        .toLowerCase()
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1);
        })
        .join(' ');
  }
}
