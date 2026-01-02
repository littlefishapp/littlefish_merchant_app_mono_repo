// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_variance.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_actions.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class TicketItemVM extends StoreItemViewModel<Ticket?, TicketState> {
  TicketItemVM.fromStore(Store<AppState> store) : super.fromStore(store);

  Customer? customer;

  CaptureMode? mode;
  FormManager? form;

  List<StockProduct>? get stockProducts => store!.state.productState.products;

  late Function(
    StockProduct product,
    StockVariance? variance,
    double quantity,
    BuildContext ctx,
  )
  addCartItem;

  late Function(CheckoutCartItem product) removeItem;

  late Function(Customer customer) setCustomer;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    state = store.state.ticketState;
    this.store = store;
    item = store.state.ticketUIState?.item?.item;
    isNew = item!.isNew ?? false;

    isLoading = state!.isLoading;
    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    setCustomer = (value) {
      item!.customerName = value.displayName;
      item!.customerEmail = value.email;
      item!.customerMobile = value.mobileNumber;
      item!.customerId = value.id;
    };

    onAdd = (item, ctx) {
      if (form?.key != null && form!.key!.currentState!.validate()) {
        form!.key!.currentState!.save();

        // item.totalCost = item.items.fold(0, (p, c) => p + c.valueCost);
        // item.totalValue = item.items.fold(0, (p, c) => p + c.value);

        isLoading = true;
        store.dispatch(
          addTicket(
            ticket: item,
            saveToCheckout: item!.items!.isNotEmpty ? false : true,
            completer: snackBarCompleter(
              ctx!,
              '${item.reference} created successfully',
              shouldPop: true,
              shouldPopTo: SellPage.route,
            ),
          ),
        );
      } else {
        showMessageDialog(
          context!,
          'Please make sure all fields are completed',
          LittleFishIcons.warning,
        );
      }
    };

    isLoading = store.state.productState.isLoading ?? false;
    hasError = store.state.productState.hasError ?? false;
  }
}

enum CaptureMode { create, edit, readOnly }
