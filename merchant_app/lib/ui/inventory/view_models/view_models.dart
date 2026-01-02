// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/stock/goods_received_voucher.dart';
import 'package:littlefish_merchant/models/stock/stock_run.dart';
import 'package:littlefish_merchant/models/stock/stock_take_item.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/inventory/inventory_actions.dart';
import 'package:littlefish_merchant/redux/inventory/inventory_state.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class StockTakeVM extends StoreItemViewModel<StockRun, InventoryStockTakeUI> {
  StockTakeVM.fromStore(Store<AppState> store) : super.fromStore(store);

  ProductState? productState;

  late Function(BuildContext context) onUpload;

  late Function(StockTakeItem item, BuildContext ctx) onAddItem;

  late Function(StockTakeItem item, BuildContext ctx) onRemoveItem;

  String title = 'Stock Take';

  bool get canSave {
    if (item!.items == null || item!.items!.isEmpty) return false;

    return item!.items!.isNotEmpty;
  }

  String getStockMovementDescription(StockTakeItem stockTakeItem) {
    int currentStock = stockTakeItem.expectedItemCount?.round() ?? 0;
    int stockChange = stockTakeItem.stockCount?.round() ?? 0;

    switch (stockTakeItem.type) {
      case StockRunType.reCount:
        currentStock += stockChange;
        return '$currentStock ($stockChange ${stockTakeItem.stockTakeReason})';
      case StockRunType.theft:
      case StockRunType.damagedStock:
      case StockRunType.otherDecrease:
        currentStock -= stockChange;
        return '$currentStock ($stockChange ${stockTakeItem.stockTakeReason})';
      case StockRunType.returnedStock:
      case StockRunType.otherIncrease:
        currentStock += stockChange;
        return '$currentStock ($stockChange ${stockTakeItem.stockTakeReason})';
      default:
        return '$currentStock items';
    }
  }

  Color getStockMovementColor(
    StockTakeItem stockTakeItem,
    BuildContext context,
  ) {
    switch (stockTakeItem.type) {
      case StockRunType.reCount:
      case StockRunType.returnedStock:
        return Theme.of(context).colorScheme.primary;
      case StockRunType.theft:
      case StockRunType.damagedStock:
        return Theme.of(context).colorScheme.secondary;
      default:
        return const Color.fromRGBO(158, 156, 159, 1);
    }
  }

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.stockTakeUI;
    productState = store.state.productState;
    item = state!.stockTakeRun;

    // this.onRefresh = () => store.dispatch(InventoryRunUploadedAction());

    onUpload = (ctx) {
      if (!canSave) return;

      store.dispatch(
        uploadStockRun(
          context: ctx,
          run: item,
          completer: snackBarCompleter(
            (ctx),
            'Stocktake completed successfully!',
            shouldPop: !(store.state.isLargeDisplay ?? false),
          ),
        ),
      );
    };

    onAdd = (item, ctx) {
      uploadStockRun(
        context: ctx,
        run: this.item,
        completer: snackBarCompleter(
          (ctx!),
          'Stocktake completed successfully!',
          shouldPop: !(store.state.isLargeDisplay ?? false),
        ),
      );
    };

    onAddItem = (item, ctx) => store.dispatch(
      StockTakeItemChangedAction(item, ChangeType.added, false),
    );

    onRemoveItem = (item, ctx) => store.dispatch(
      StockTakeItemChangedAction(item, ChangeType.removed, false),
    );

    isLoading = store.state.inventoryState.isLoading ?? false;
    hasError = store.state.inventoryState.hasError ?? false;
  }
}

class StockTakeListVM
    extends StoreCollectionViewModel<StockRun, InventoryState> {
  StockTakeListVM.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  Null loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.inventoryState;
    items = state!.stockRuns;
    selectedItem = store.state.stockTakeUI!.stockTakeRun;
    isLoading = state!.isLoading;
    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    onRefresh = () => store.dispatch(getStockRuns(refresh: true));

    onSetSelected = (value) => store.dispatch(SetSelectedStockRun(value));

    return null;
  }
}

class GRVListVM
    extends StoreCollectionViewModel<GoodsRecievedVoucher, InventoryState> {
  GRVListVM.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  Null loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.inventoryState;
    items = state!.grvs;
    selectedItem = store.state.stockRecievableUI!.item;
    isLoading = state!.isLoading;
    hasError = state!.hasError;
    errorMessage = state!.errorMessage;

    onRefresh = () => store.dispatch(getReceivables(refresh: true));

    onSetSelected = (value) => store.dispatch(SetSelectedReceivable(value));

    return null;
  }
}

class GRVVM
    extends StoreItemViewModel<GoodsRecievedVoucher, InventoryRecievableUI> {
  GRVVM.fromStore(Store<AppState> store) : super.fromStore(store);

  ProductState? productState;

  late Function(BuildContext context) onUpload;

  late Function(GoodsRecievedItem, BuildContext ctx) onAddItem;

  late Function(GoodsRecievedItem item, BuildContext ctx) onRemoveItem;
  late Function(GoodsRecievedVoucher item, BuildContext ctx) removeItem;

  bool get canSave {
    if (item!.items == null || item!.items!.isEmpty) return false;

    if (key == null) return false;

    if (key?.currentState == null) {
      return item!.items!.isNotEmpty &&
          item!.dateReceived != null &&
          item!.invoiceId != null &&
          item!.invoiceId!.isNotEmpty &&
          item!.invoiceAmount != null;
    } else {
      return key!.currentState!.validate() && item!.items!.isNotEmpty;
    }
  }

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.stockRecievableUI;
    productState = store.state.productState;
    isLoading = store.state.inventoryState.isLoading ?? false;
    hasError = store.state.inventoryState.hasError ?? false;
    item = store.state.stockRecievableUI!.item;

    onUpload = (ctx) {
      if (!(key!.currentState?.validate() ?? false)) return;

      if (!canSave) return;

      key!.currentState?.save();

      store.dispatch(
        uploadGRV(
          item: item,
          completer: snackBarCompleter(
            (ctx),
            'uploaded completed successfully!',
            shouldPop: true,
          ),
        ),
      );
    };

    onAdd = (item, ctx) {
      uploadGRV(
        item: this.item,
        completer: snackBarCompleter(
          (ctx!),
          'uploaded completed successfully!',
          shouldPop: true,
        ),
      );
    };

    onAddItem = (item, ctx) =>
        store.dispatch(RecievableItemChangedAction(item, ChangeType.added));

    removeItem = (GoodsRecievedVoucher item, BuildContext ctx) {
      store.dispatch(
        cancelGRV(
          item: item,
          completer: snackBarCompleter(
            (ctx),
            'deleted successfully!',
            shouldPop: true,
          ),
        ),
      );
    };
  }
}
