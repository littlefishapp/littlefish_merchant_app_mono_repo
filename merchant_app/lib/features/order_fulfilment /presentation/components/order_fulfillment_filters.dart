// flutter imports
// remove ignore_for_file: implementation_imports

import 'package:flutter/material.dart';

// package imports
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/features/order_fulfilment%20/presentation/components/order_fulfilmentmethod_filter.dart';
import 'package:redux/src/store.dart';

// project imports
import 'package:littlefish_merchant/features/order_transaction_history/presentation/widgets/date_range_filter.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/actions/order_transaction_history_actions.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/features/order_common/data/model/order_filter.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/viewmodels/order_history_list_vm.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

class OrderFulfillmentFilters extends StatefulWidget {
  const OrderFulfillmentFilters({super.key});

  @override
  State<OrderFulfillmentFilters> createState() =>
      _OrderFulfillmentFiltersState();
}

class _OrderFulfillmentFiltersState extends State<OrderFulfillmentFilters> {
  late OrderFilter _orderFilter;
  late GlobalKey _buttonsKey;
  late double _buttonsHeight;

  @override
  void initState() {
    _buttonsKey = GlobalKey();
    _buttonsHeight = 0;
    _orderFilter = OrderFilter();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _calculateButtonsHeight();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, OrderHistoryListVM>(
      converter: (Store<AppState> store) {
        return OrderHistoryListVM.fromStore(store);
      },
      onInit: (store) {
        var stateOrderFilter =
            store.state.orderTransactionHistoryState.orderFilter;
        if (stateOrderFilter != null) {
          _orderFilter = stateOrderFilter.copyWith();
        }
      },
      builder: (BuildContext context, OrderHistoryListVM vm) {
        return _layout(context, vm);
      },
    );
  }

  Widget _layout(BuildContext context, OrderHistoryListVM vm) {
    return Stack(
      children: [
        SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.only(bottom: _buttonsHeight),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [_dateRangeFilters(vm), _fulfillmentMethodFilter()],
            ),
          ),
        ),
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: Container(
            key: _buttonsKey,
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Column(
                children: [
                  const CommonDivider(),
                  _clearAndSaveButtons(context, vm),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _dateRangeFilters(OrderHistoryListVM vm) {
    return DateRangeFilter(
      title: 'Filter By Date',
      initialStartDate: vm.orderFilter?.startDate,
      initialEndDate: vm.orderFilter?.endDate,
      onSaveStartDate: (date) {
        setState(() {
          _orderFilter = _orderFilter.copyWith(startDate: date);
        });
      },
      onSaveEndDate: (date) {
        setState(() {
          _orderFilter = _orderFilter.copyWith(endDate: date);
        });
      },
    );
  }

  Widget _fulfillmentMethodFilter() {
    return FulfilmentMethodFilter(
      selectedFulfilmentMethod: _orderFilter.fulfilmentMethod,
      onChanged: (fulfilmentMethod) {
        setState(() {
          _orderFilter = _orderFilter.copyWith(
            fulfilmentMethod: fulfilmentMethod,
          );
        });
      },
    );
  }

  Widget _clearAndSaveButtons(BuildContext context, OrderHistoryListVM vm) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _clearButton(context, vm),
          const SizedBox(width: 16),
          _saveButton(vm),
        ],
      ),
    );
  }

  Widget _clearButton(BuildContext context, OrderHistoryListVM vm) {
    return Expanded(
      child: ButtonSecondary(
        isNegative: true,
        text: 'Clear All',
        onTap: (ctx) {
          setState(() {
            _clearFilters(vm);
          });
        },
      ),
    );
  }

  Widget _saveButton(OrderHistoryListVM vm) {
    return Expanded(
      child: ButtonPrimary(
        text: 'Apply Filters',
        upperCase: false,
        disabled: !_orderFilter.hasData(),
        onTap: (ctx) {
          if (_changesMadeToFilter(_orderFilter, vm.orderFilter)) {
            vm.saveAndApplyFilter(_orderFilter);
          }
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void _clearFilters(OrderHistoryListVM vm) {
    setState(() {
      _orderFilter = _orderFilter.copyWith(fulfilmentMethod: null);
    });
    vm.store?.dispatch(SetOrderFiltersAction(_orderFilter));
    vm.store?.dispatch(ClearFilteredOrdersAction());
    vm.store?.dispatch(SearchOrdersAction(vm.searchText));
  }

  void _calculateButtonsHeight() {
    final RenderBox renderBox =
        _buttonsKey.currentContext?.findRenderObject() as RenderBox;
    setState(() {
      _buttonsHeight = renderBox.size.height;
    });
  }

  bool _changesMadeToFilter(OrderFilter? filterOne, OrderFilter? filterTwo) =>
      filterOne != filterTwo;

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
