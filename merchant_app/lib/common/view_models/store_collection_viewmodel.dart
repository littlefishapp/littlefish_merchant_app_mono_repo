// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';

abstract class StoreCollectionViewModel<T, Y> {
  StoreCollectionViewModel.fromStore(
    Store<AppState> store, {
    BuildContext? context,
  }) {
    this.loadFromStore(store, context: context);
  }

  Store<AppState>? store;

  bool get isOnline => store!.state.hasInternet ?? true;

  late Function onRefresh;

  late Function(T item, BuildContext context) onRemove;
  late Function(T item, BuildContext context) onAdd;

  Function? onResetErorr;

  Function? onValidate;

  late Function(T item) onSetSelected;

  String? previousItem;
  Function(String item)? onSetPreviousItem;
  bool? isLoading;

  bool? hasError;

  bool? isSelectedItemDifferent;

  String? errorMessage;

  Y? state;

  List<T>? items;

  T? _selectedItem;

  T? get selectedItem {
    return _selectedItem;
  }

  set selectedItem(T? value) {
    if (_selectedItem != value) {
      _selectedItem = value;
    }
  }

  bool? isNew;

  loadFromStore(Store<AppState> store, {BuildContext? context});
}

abstract class StoreItemViewModel<T, Y> {
  StoreItemViewModel.fromStore(Store<AppState> store, {BuildContext? context}) {
    this.loadFromStore(store, context: context);
  }

  late Function(T item, BuildContext context) onRemove;
  late Function(T item, BuildContext? context) onAdd;

  Function? onResetErorr;

  bool get isOnline => (store?.state)?.hasInternet ?? true;

  bool? isLoading;

  String? errorMessage;

  bool? hasError;

  Y? state;

  T? item;

  bool? isNew;

  Store<AppState>? store;

  GlobalKey<FormState>? key;

  loadFromStore(Store<AppState> store, {BuildContext? context});
}

abstract class StoreViewModel<T> {
  StoreViewModel.fromStore(Store<AppState>? store, {BuildContext? context}) {
    this.loadFromStore(store, context: context);
  }

  T? state;

  Function? onResetErorr;

  bool? get isOnline => (store?.state)?.hasInternet ?? true;

  bool? isLoading;

  bool? hasError;

  String? errorMessage;

  Function? onLoadingChanged;

  Store<AppState>? store;

  GlobalKey<FormState>? key;

  loadFromStore(Store<AppState>? store, {BuildContext? context});

  toggleLoading({bool? value}) {
    if (this.isLoading == null) this.isLoading = false;

    if (value != null) {
      this.isLoading = value;
    } else {
      this.isLoading = !this.isLoading!;
    }

    if (this.onLoadingChanged != null) onLoadingChanged!();
  }
}
