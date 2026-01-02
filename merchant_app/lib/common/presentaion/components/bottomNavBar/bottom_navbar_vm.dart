// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/workspaces/workspace_state.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

class BottomNavBarVM extends StoreViewModel<AppState> {
  BottomNavBarVM.fromStore(Store<AppState> store, {BuildContext? context})
    : super.fromStore(store, context: context);

  WorkspaceState? workspaceState;

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    workspaceState = store?.state.workspaceState;
  }
}
