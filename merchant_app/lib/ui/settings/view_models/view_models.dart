// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/models/settings/orders/order_setting.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/models/shared/form_view_model.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/models/tax/sales_tax.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_actions.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

import 'package:littlefish_merchant/redux/business/business_selectors.dart'
    as business_selector;

import '../../../models/tax/vat_level.dart';

class SalesTaxViewModel
    extends StoreItemViewModel<SalesTax?, AppSettingsState> {
  SalesTaxViewModel.fromStore(Store<AppState> store, {this.form})
    : super.fromStore(store);

  FormManager? form;
  List<SalesTax>? get vatRates => state?.salesTaxesList;

  List<VatLevel>? get vatLevels => state?.vatLevelsList;
  VatLevel? selectedVatLevel;
  String? get selectedVatLevelId => selectedVatLevel?.vatLevelId;

  late void Function() initialiseTax;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    state = store.state.appSettingsState;
    item = state!.salesTax;
    isLoading = state!.isLoading;
    hasError = state!.hasError;

    initialiseTax = () {
      store.dispatch(initialzeSalesTax(refresh: false));
      store.dispatch(getBusinessSalesTaxes());
    };

    onAdd = (item, ctx) {
      var thisKey = key ?? form?.key;

      if (thisKey == null || !thisKey.currentState!.validate()) return;

      thisKey.currentState!.save();

      item!.taxPricingMode = TaxPricingMode.alreadyIncluded;

      store.dispatch(
        updateSalesTax(
          item: item,
          completer: snackBarCompleter(
            ctx!,
            'Sales taxes updated successfully! Updating Business Profile...',
          ),
        ),
      );

      store.dispatch(
        updateBusinessTaxDetailsThunk(
          address: item.address,
          taxNumber: item.vatRegistrationNumber,
          vatEnabled: item.enabled,
          completer: snackBarCompleter(
            ctx,
            'Business Profile updated successfully!',
            shouldPop: true,
          ),
        ),
      );
    };
  }
}

class TicketSettingsViewModel
    extends StoreItemViewModel<Ticket, AppSettingsState> {
  TicketSettingsViewModel.fromStore(Store<AppState> store, {this.form})
    : super.fromStore(store);

  FormManager? form;
  late Function(bool value, BuildContext ctx) setValue;
  bool? allowTickets;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.appSettingsState;
    allowTickets = state!.allowTickets;

    isLoading = state!.isLoading;
    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    setValue = (value, ctx) {
      isLoading = true;
      store.dispatch(
        setTicketAllowed(
          enabled: value,
          completer: snackBarCompleter(
            ctx,
            'Parked carts are now ${value ? "enabled" : "disabled"}',
          ),
        ),
      );
    };
  }
}

class PaymentTypesViewModel
    extends StoreCollectionViewModel<PaymentType, AppSettingsState> {
  PaymentTypesViewModel.fromStore(Store<AppState> store)
    : super.fromStore(store);

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    state = store.state.appSettingsState;
    items = state!.paymentTypes;
    isLoading = state!.isLoading;
    hasError = state!.hasError;
    onAdd = (item, ctx) => store.dispatch(
      setPaymentType(
        enabled: item.enabled,
        name: item.name,
        completer: snackBarCompleter(
          ctx,
          '${item.enabled! ? "you" : "you do not"} accept ${item.name!.toLowerCase()} payments',
        ),
      ),
    );
  }
}

class StoreCreditVM extends StoreViewModel<AppSettingsState> {
  StoreCreditVM.fromStore(Store<AppState> store) : super.fromStore(store);

  late Function(StoreCreditSettings? value, BuildContext ctx) saveCredit;
  late Function(StoreCreditSettings? value, BuildContext ctx) disableCredit;

  StoreCreditSettings? get currentSettingsState =>
      business_selector.storeCreditSettings(store!.state);

  bool? allowCredit;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    state = store!.state.appSettingsState;

    isLoading = state!.isLoading;
    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    allowCredit = state!.allowStoreCredit;

    //here we need to trigger a change on the server
    saveCredit = (value, ctx) {
      store.dispatch(
        setStoreCredit(
          value,
          enabled: value!.enabled,
          completer: snackBarCompleter(
            ctx,
            'Store Credit is ${value.enabled! ? "active" : "disabled"}',
            shouldPop: true,
          ),
        ),
      );
    };

    disableCredit = (value, ctx) {
      store.dispatch(
        disableStoreCredit(
          value,
          enabled: value!.enabled,
          completer: snackBarCompleter(
            ctx,
            'Store Credit is ${value.enabled! ? "active" : "disabled"}',
            shouldPop: true,
          ),
        ),
      );
    };
  }
}

class SettingsOrderViewModel
    extends StoreItemViewModel<OrderSetting?, AppSettingsState> {
  SettingsOrderViewModel.fromStore(Store<AppState> store, {this.form})
    : super.fromStore(store);

  FormManager? form;

  late Function(OrderSettingItem item) addItem;

  late Function(OrderSettingItem item) removeItem;

  late Function onRefresh;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    state = store.state.appSettingsState;
    item ??= state!.orderSettings;
    hasError = state!.hasError;
    isLoading = state!.isLoading;
    onRefresh = () => store.dispatch(getOrderSetttings(refresh: true));
    onAdd = (item, ctx) => store.dispatch(updateOrderSettings(settings: item));
    addItem = (item) => store.dispatch(
      AppSettingsOrderItemChangedAction(item, ChangeType.added),
    );
    removeItem = (item) => store.dispatch(
      AppSettingsOrderItemChangedAction(item, ChangeType.removed),
    );
  }
}
