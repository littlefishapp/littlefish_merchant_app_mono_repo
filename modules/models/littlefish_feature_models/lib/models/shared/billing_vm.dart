// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/billing/billing_state.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class BillingVM extends StoreViewModel<BillingState> {
  BillingVM.fromStore(Store<AppState> store, {BuildContext? context})
    : super.fromStore(store, context: context);
  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    state = store!.state.billingState;
    this.store = store;

    isLoading = state!.isLoading ?? false;
  }
}
