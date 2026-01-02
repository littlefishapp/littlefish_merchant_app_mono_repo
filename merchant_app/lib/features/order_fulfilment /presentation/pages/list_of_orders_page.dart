// flutter imports
// remove ignore_for_file: implementation_imports

import 'package:flutter/material.dart';

// package imports
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/components/order_fulfillment_filters.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/components/order_list_tile.dart';
import 'package:quiver/strings.dart';
import 'package:redux/src/store.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

// project imports
import 'package:littlefish_merchant/features/order_transaction_history/presentation/widgets/search_and_button.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottom_sheet_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/errors/show_error.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/viewmodels/order_history_list_vm.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

class ListOfOrdersPage extends StatefulWidget {
  final List<Order> orders;
  const ListOfOrdersPage({super.key, required this.orders});
  @override
  State<ListOfOrdersPage> createState() => _OrdersTabState();
}

class _OrdersTabState extends State<ListOfOrdersPage> {
  late ScrollController _scrollController;
  late bool _isLoadingMoreOrders;
  late OrderHistoryListVM _vm;

  @override
  void initState() {
    _isLoadingMoreOrders = false;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScrollLoading);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ListOfOrdersPage oldWidget) {
    if (widget.orders != oldWidget.orders) {
      setState(() {
        _isLoadingMoreOrders = false;
      });
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScrollLoading);
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OrderHistoryListVM>(
      converter: (Store<AppState> store) {
        return OrderHistoryListVM.fromStore(store);
      },
      onDidChange: (previousViewModel, viewModel) =>
          _onDidChange(previousViewModel, viewModel),
      builder: (BuildContext context, OrderHistoryListVM vm) {
        _vm = vm;
        return _layout(context, vm);
      },
    );
  }

  Widget _layout(BuildContext context, OrderHistoryListVM vm) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SearchAndButton(
          padding: const EdgeInsets.only(right: 22.0),
          onButtonPressed: (ctx) => _onFilterButtonPressed(ctx),
          onTextChanged: (text) => vm.searchOrders(text),
        ),
        Expanded(flex: 1, child: _ordersListView(context, vm)),
      ],
    );
  }

  Widget _ordersListView(BuildContext context, OrderHistoryListVM vm) {
    if (vm.isLoading == true) return const AppProgressIndicator();
    if (widget.orders.isEmpty) return _noOrdersLayout(context, vm);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: ListView.builder(
            key: const PageStorageKey<String>('orders-list'),
            controller: _scrollController,
            itemCount: widget.orders.length,
            itemBuilder: (context, index) {
              final order = widget.orders[index];
              return FulfillmentOrderTile(order: order);
            },
          ),
        ),
        if (_isLoadingMoreOrders)
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: AppProgressIndicator(),
          ),
      ],
    );
  }

  Widget _noOrdersLayout(BuildContext context, OrderHistoryListVM vm) {
    return ShowError(
      message: 'No orders found at the moment',
      iconData: LittleFishIcons.info,
    );
  }

  void _onScrollLoading() {
    if (_scrollController.position.maxScrollExtent ==
            _scrollController.offset &&
        !_isLoadingMoreOrders) {
      setState(() {
        _isLoadingMoreOrders = true;

        if (isNotBlank(_vm.searchText)) {
          _isLoadingMoreOrders = false;
        }
      });

      _vm.getMoreOrders();
    }
  }

  void _onDidChange(
    OrderHistoryListVM? previousViewModel,
    OrderHistoryListVM viewModel,
  ) {
    if (viewModel.hasFetchedAllOrders !=
            previousViewModel?.hasFetchedAllOrders ||
        viewModel.hasFetchedAllOrders == true) {
      setState(() {
        _isLoadingMoreOrders = false;
      });
    }
  }

  _onFilterButtonPressed(BuildContext ctx) async {
    await showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (buildContext) => SafeArea(
        top: false,
        bottom: true,
        child: Container(
          color: Colors.white,
          child: const Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              BottomSheetIndicator(),
              Expanded(child: OrderFulfillmentFilters()),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
