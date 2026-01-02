// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/stock/goods_received_voucher.dart';
import 'package:littlefish_merchant/models/stock/stock_run.dart';
import 'package:littlefish_merchant/models/stock/stock_take_item.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/inventory/inventory_actions.dart';
import 'package:littlefish_merchant/redux/inventory/inventory_state.dart';

final inventoryReducer = combineReducers<InventoryState>([
  TypedReducer<InventoryState, SetInventoryLoadingAction>(onSetLoading).call,
  TypedReducer<InventoryState, InventoryRunUploadedAction>(
    onUploadedStockTake,
  ).call,
  TypedReducer<InventoryState, RecievablesUploadedAction>(
    onGRVUploadedOverall,
  ).call,
  TypedReducer<InventoryState, RecievablesCancelledAction>(
    onGRVCancelledAction,
  ).call,
  TypedReducer<InventoryState, SignoutAction>(onClearState).call,
  TypedReducer<InventoryState, StockRunsLoadedAction>(onStockRunsLoaded).call,
  TypedReducer<InventoryState, ReceivablesLoadedAction>(onGRVsLoaded).call,
]);

InventoryState onGRVsLoaded(
  InventoryState state,
  ReceivablesLoadedAction action,
) => state.rebuild((b) => b.grvs = action.value);

InventoryState onStockRunsLoaded(
  InventoryState state,
  StockRunsLoadedAction action,
) => state.rebuild((b) => b.stockRuns = action.value);

InventoryState onClearState(InventoryState state, SignoutAction action) =>
    state.rebuild((b) {
      b.isLoading = false;
      b.hasError = false;
      b.errorMessage = null;
      b.stockRuns = [];
      b.grvs = [];
    });

InventoryState onSetLoading(
  InventoryState state,
  SetInventoryLoadingAction action,
) => state.rebuild((b) => b.isLoading = action.value);

InventoryState onSetInventoryFault(
  InventoryState state,
  SetInventoryFaultAction action,
) => state.rebuild((b) {
  b.hasError = true;
  b.errorMessage = action.value;
});

InventoryState onUploadedStockTake(
  InventoryState state,
  InventoryRunUploadedAction action,
) {
  return state.rebuild((b) {
    b.stockRuns = List.from(b.stockRuns ?? [])..add(action.value);
  });
}

InventoryState onGRVUploadedOverall(
  InventoryState state,
  RecievablesUploadedAction action,
) {
  return state.rebuild((b) {
    b.grvs = List.from(b.grvs ?? [])..add(action.value);
  });
}

InventoryState onGRVCancelledAction(
  InventoryState state,
  RecievablesCancelledAction action,
) {
  return state.rebuild((b) {
    return List.from(
      b.grvs ?? [],
    ).removeWhere((element) => element.id == action.value.id);
  });
}

final stockTakeUIReducer = combineReducers<InventoryStockTakeUI>([
  TypedReducer<InventoryStockTakeUI, StockTakeItemChangedAction>(
    onSetItemChanged,
  ).call,
  TypedReducer<InventoryStockTakeUI, InventoryRunUploadedAction>(
    onRunUploaded,
  ).call,
  TypedReducer<InventoryStockTakeUI, SignoutAction>(onClearUIState).call,
  TypedReducer<InventoryStockTakeUI, SetSelectedStockRun>(
    onSetStockTakeItem,
  ).call,
]);

InventoryStockTakeUI onSetStockTakeItem(
  InventoryStockTakeUI state,
  SetSelectedStockRun action,
) => state.rebuild((b) => b.stockTakeRun = action.value);

InventoryStockTakeUI onClearUIState(
  InventoryStockTakeUI state,
  SignoutAction action,
) => state.rebuild((b) {
  b.isLoading = false;
  b.hasError = false;
  b.errorMessage = null;

  b.stockTakeRun = StockRun.create();
});

InventoryStockTakeUI onRunUploaded(
  InventoryStockTakeUI state,
  InventoryRunUploadedAction action,
) => state.rebuild((b) => b.stockTakeRun = StockRun.create());

InventoryStockTakeUI onSetItemChanged(
  InventoryStockTakeUI state,
  StockTakeItemChangedAction action,
) {
  return state.rebuild(
    (b) => b.stockTakeRun!.items = action.type != ChangeType.removed
        ? _addOrUpdateItem(b.stockTakeRun!.items, action.item)
        : _removeItem(b.stockTakeRun!.items!, action.item),
  );
}

List<StockTakeItem> _addOrUpdateItem(
  List<StockTakeItem>? state,
  StockTakeItem item,
) {
  if (state == null || state.isEmpty) return <StockTakeItem>[item];

  var existingIndex = state.indexWhere(
    (p) => p.productId == item.productId && p.varianceId == item.varianceId,
  );

  if (existingIndex >= 0) {
    state[existingIndex] = item;
  } else {
    state.add(item);
  }

  return state;
}

List<StockTakeItem> _removeItem(List<StockTakeItem> state, StockTakeItem item) {
  if (state.isEmpty) return state;

  state.removeWhere(
    (st) => st.productId == item.productId && st.varianceId == item.varianceId,
  );

  return state;
}

final grvUIReducers = combineReducers<InventoryRecievableUI>([
  TypedReducer<InventoryRecievableUI, RecievableItemChangedAction>(
    onRItemChanged,
  ).call,
  TypedReducer<InventoryRecievableUI, RecievablesUploadedAction>(
    onGRVUploaded,
  ).call,
  TypedReducer<InventoryRecievableUI, SignoutAction>(
    onClearRecievableState,
  ).call,
  TypedReducer<InventoryRecievableUI, SetSelectedReceivable>(
    onSetSelectedGRV,
  ).call,
  TypedReducer<InventoryRecievableUI, SetInventoryLoadingAction>(
    onGRVUILoading,
  ).call,
]);

InventoryRecievableUI onGRVUILoading(
  InventoryRecievableUI state,
  SetInventoryLoadingAction action,
) => state.rebuild((b) => b.isLoading = action.value);

InventoryRecievableUI onSetSelectedGRV(
  InventoryRecievableUI state,
  SetSelectedReceivable action,
) => state.rebuild((b) => b.item = action.value);

InventoryRecievableUI onClearRecievableState(
  InventoryRecievableUI state,
  SignoutAction action,
) => state.rebuild((b) {
  b.isLoading = false;
  b.hasError = false;
  b.errorMessage = null;

  b.item = GoodsRecievedVoucher.create();
});

InventoryRecievableUI onGRVUploaded(
  InventoryRecievableUI state,
  RecievablesUploadedAction action,
) {
  return state.rebuild((b) {
    b.item = GoodsRecievedVoucher.create();
  });
}

InventoryRecievableUI onRItemChanged(
  InventoryRecievableUI state,
  RecievableItemChangedAction action,
) {
  return state.rebuild(
    (b) => b.item!.items = action.type != ChangeType.removed
        ? _addOrUpdateGRVItem(b.item!.items, action.value)
        : _removeGRVItem(b.item!.items!, action.value),
  );
}

List<GoodsRecievedItem> _addOrUpdateGRVItem(
  List<GoodsRecievedItem>? state,
  GoodsRecievedItem item,
) {
  if (state == null || state.isEmpty) return <GoodsRecievedItem>[item];

  var existingIndex = state.indexWhere(
    (p) => p.productId == item.productId && p.variantId == item.variantId,
  );

  if (existingIndex >= 0) {
    state[existingIndex] = item;
  } else {
    state.add(item);
  }

  return state;
}

List<GoodsRecievedItem> _removeGRVItem(
  List<GoodsRecievedItem> state,
  GoodsRecievedItem item,
) {
  if (state.isEmpty) return state;

  state.removeWhere(
    (st) => st.productId == item.productId && st.variantId == item.variantId,
  );

  return state;
}
