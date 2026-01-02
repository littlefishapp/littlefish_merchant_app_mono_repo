import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/search_text_field.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/presentation/view_models/order_transaction_list_vm.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/presentation/components/transaction_history_action_button.dart';
import 'package:littlefish_merchant/features/transaction_history_tab/presentation/components/transaction_history_filter_and_sort.dart';

class TransactionHistoryActionsBar extends StatefulWidget {
  final OrderTransactionListVM _vm;
  const TransactionHistoryActionsBar(OrderTransactionListVM vm, {Key? key})
    : _vm = vm,
      super(key: key);
  @override
  State<TransactionHistoryActionsBar> createState() =>
      _TransactionHistoryActionsBarState();
}

class _TransactionHistoryActionsBarState
    extends State<TransactionHistoryActionsBar> {
  late TextEditingController _controller;

  FocusNode? _focusNode;

  @override
  void initState() {
    _controller = TextEditingController();
    _focusNode = FocusNode();
    super.initState();
  }

  @override
  Widget build(BuildContext context) => _body(context, widget._vm);

  _body(BuildContext ctx, OrderTransactionListVM vm) => Row(
    children: [
      _spacing(),
      _spacing(),
      _searchField(ctx, flex: 4),
      _spacing(),
      _filterSortActions(ctx, vm, flex: 1),
    ],
  );

  _spacing() => const SizedBox(width: 8);

  Widget _searchField(BuildContext context, {required int flex}) => Flexible(
    flex: flex,
    child: SearchTextField(
      hintText: 'Search by transaction number, total amount or customer name',
      initialValue: widget._vm.searchText ?? '',
      controller: _controller,
      onChanged: (_) => {},
      focusNode: _focusNode,
      onFieldSubmitted: (text) async {
        if (text == '') {
          await widget._vm.setTransactionSearchText!('');
          if (mounted) setState(() {});
        } else {
          await widget._vm.updateSearchTransactions!(
            widget._vm.filterTypes ?? [],
            widget._vm.sortType,
            text,
          );
        }
        if (mounted) setState(() {});
      },
      onClear: () async {
        await widget._vm.setTransactionSearchText!('');
        if (mounted) setState(() {});
      },
    ),
  );

  Widget _filterSortActions(
    BuildContext context,
    OrderTransactionListVM vm, {
    required int flex,
  }) => Flexible(
    flex: flex,
    child: TransactionFilterSortActionButton(
      onPressed: (ctx) async {
        await showModalBottomSheet<double>(
          context: context,
          isScrollControlled: true,
          elevation: 0,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          enableDrag: true,
          showDragHandle: true,
          builder: (ctx) => SafeArea(
            top: false,
            bottom: true,
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
              ),
              height: MediaQuery.of(context).size.height * 0.8,
              child: TransactionHistoryFilterSort(
                filters: vm.filterTypes ?? [],
                sort: vm.sortType,
              ),
            ),
          ),
        );
      },
    ),
  );
}
