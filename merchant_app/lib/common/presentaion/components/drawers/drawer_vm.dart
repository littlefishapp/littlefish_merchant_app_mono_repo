// removed ignore: depend_on_referenced_packages
import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/models/security/access_management/module.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/user/user_state.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class DrawerVM extends StoreViewModel<AppState> {
  DrawerVM.fromStore(Store<AppState> store) : super.fromStore(store);

  AccessManager? accessManager;

  @override
  bool? isOnline;

  UserViewingMode? viewMode;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    state = store!.state;
    isOnline = state!.hasInternet;
    accessManager = state!.authState.accessManager;
    viewMode = store.state.viewMode;
  }
}
