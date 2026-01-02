// remove ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_run_helper.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/ui/business/expenses/refund_utilities.dart';
import 'package:littlefish_merchant/ui/inventory/stock_take/pages/stock_take_intro_page.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/stock/goods_received_voucher.dart';
import 'package:littlefish_merchant/models/stock/stock_run.dart';
import 'package:littlefish_merchant/models/stock/stock_take_item.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/inventory_service.dart';
import 'package:littlefish_merchant/ui/inventory/grv/pages/stock_receivable_page.dart';
import 'package:littlefish_merchant/ui/inventory/stock_take/pages/stock_take_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import '../../bootstrap.dart';
import '../../ui/online_store/tools.dart';

late InventoryService service;

ThunkAction<AppState> uploadStockRun({
  required StockRun? run,
  BuildContext? context,
  Completer? completer,
  bool? isProductPage = false,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      if (run == null || run.items == null || run.items!.isEmpty) {
        if (context != null) {
          showPopupDialog(
            context: context,
            content: const Text(
              'Please select product/s to complete a stock take',
            ),
          );
        }
        completer?.complete();
        return;
      }
      run.capturerName = store.state.userState.profile!.displayName;
      run.businessId = AppVariables.businessId;
      store.dispatch(SetInventoryLoadingAction(true));
      store.dispatch(ProductStateLoadingAction(true));

      await service
          .uploadStockRun(run)
          .catchError((e) {
            store.dispatch(SetInventoryFaultAction(e.toString()));
            store.dispatch(SetInventoryLoadingAction(false));

            completer?.completeError(e, StackTrace.current);
            return null;
          })
          .then((result) async {
            if (result != null) {
              store.dispatch(InventoryRunUploadedAction(result));

              if (isProductPage == true) {
                StockProduct? product = getProductFromState(
                  result.items![0].productId.toString(),
                  store,
                );
                double diff = result.items![0].stockCount!;
                if (StockRunHelper.isDecreaseByReason(result.items![0].type!)) {
                  diff = -diff;
                }
                product!.regularVariance!.quantity =
                    result.items![0].expectedItemCount! + diff;

                if ((product.regularVariance!.quantity ?? 0) < 0) {
                  product.regularVariance!.quantity = 0;
                }
                await store.dispatch(ProductSelectAction(product));
              }
              store.dispatch(SetInventoryLoadingAction(false));
              completer?.complete();
            }
            store.dispatch(ProductStateLoadingAction(false));
          });
    });
  };
}

ThunkAction<AppState> getStockRuns({
  bool refresh = false,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var invState = store.state.inventoryState;

      if (!refresh && (invState.stockRuns?.length ?? 0) > 0) {
        store.dispatch(SetInventoryLoadingAction(false));
        return;
      }

      store.dispatch(SetInventoryLoadingAction(true));

      await service
          .getStockRunList()
          .catchError((e) {
            store.dispatch(SetInventoryFaultAction(e.toString()));
            store.dispatch(SetInventoryLoadingAction(false));

            completer?.completeError(e, StackTrace.current);
            return <StockRun>[];
          })
          .then((result) {
            store.dispatch(StockRunsLoadedAction(result));

            completer?.complete();
          })
          .whenComplete(() => store.dispatch(SetInventoryLoadingAction(false)));
    });
  };
}

ThunkAction<AppState> newStockTake({
  StockRunType type = StockRunType.reCount,
  required BuildContext context,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetInventoryLoadingAction(true));

      store.dispatch(SetSelectedStockRun(StockRun.create()));

      store.dispatch(SetInventoryLoadingAction(false));
      bool? enableNewStockHelper = await getKeyFromPrefsBool(
        'enableNewStockHelper',
      );

      if (store.state.isLargeDisplay ?? false) {
        showPopupDialog(
          context: context,
          content: const StockTakePage(),
          width: MediaQuery.of(context).size.width * 0.95,
          borderDismissable: false,
        );
      } else if (enableNewStockHelper != null) {
        Navigator.pushNamed(
          globalNavigatorKey.currentContext!,
          enableNewStockHelper ? StockIntroPage.route : StockTakePage.route,
        );
      } else {
        Navigator.pushNamed(
          globalNavigatorKey.currentContext!,
          StockIntroPage.route,
        );
      }
    });
  };
}

ThunkAction<AppState> getReceivables({
  bool refresh = false,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      var invState = store.state.inventoryState;

      if (!refresh && (invState.grvs?.length ?? 0) > 0) {
        store.dispatch(SetInventoryLoadingAction(false));
        return;
      }

      store.dispatch(SetInventoryLoadingAction(true));

      await service
          .getGRVs()
          .catchError((e) {
            store.dispatch(SetInventoryFaultAction(e.toString()));
            store.dispatch(SetInventoryLoadingAction(false));

            completer?.completeError(e, StackTrace.current);
            return <GoodsRecievedVoucher>[];
          })
          .then((result) {
            store.dispatch(ReceivablesLoadedAction(result));

            completer?.complete();
          })
          .whenComplete(() => store.dispatch(SetInventoryLoadingAction(false)));
    });
  };
}

ThunkAction<AppState> uploadGRV({
  required GoodsRecievedVoucher? item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      //there is nothing to upload in our state
      if (item == null || item.items == null || item.items!.isEmpty) {
        completer?.complete();
        return;
      }

      item.receivedBy = store.state.userState.profile!.displayName;

      store.dispatch(SetInventoryLoadingAction(true));
      // item.items = item.items.map((e) {
      //   var tt = e;
      //   tt.packUnitQuantity = null;
      //   return tt;
      // }).toList();

      await service
          .uploadGRV(item)
          .catchError((e) {
            store.dispatch(SetInventoryFaultAction(e.toString()));
            store.dispatch(SetInventoryLoadingAction(false));

            completer?.completeError(e, StackTrace.current);
            return null;
          })
          .then((result) {
            if (result != null) {
              store.dispatch(RecievablesUploadedAction(result));
              store.dispatch(SetInventoryLoadingAction(false));

              completer?.complete();
            }
          });
    });
  };
}

ThunkAction<AppState> cancelGRV({
  required GoodsRecievedVoucher? item,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      //there is nothing to upload in our state
      if (item == null || item.items == null || item.items!.isEmpty) {
        completer?.complete();
        return;
      }

      store.dispatch(SetInventoryLoadingAction(true));
      // item.items = item.items.map((e) {
      //   var tt = e;
      //   tt.packUnitQuantity = null;
      //   return tt;
      // }).toList();

      try {
        var result = await service.cancelGRV(item);
        if (result != null) {
          store.dispatch(RecievablesCancelledAction(result));
          store.dispatch(SetInventoryLoadingAction(false));

          completer?.complete();
        }
      } catch (e) {
        store.dispatch(SetInventoryFaultAction(e.toString()));
        store.dispatch(SetInventoryLoadingAction(false));

        completer?.completeError(e, StackTrace.current);
      }
    });
  };
}

ThunkAction<AppState> newGoodsRecievable(BuildContext context) {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(SetInventoryLoadingAction(true));

      store.dispatch(SetSelectedReceivable(GoodsRecievedVoucher.create()));

      store.dispatch(SetInventoryLoadingAction(false));

      if (EnvironmentProvider.instance.isLargeDisplay!) {
        showPopupDialog(
          borderDismissable: false,
          content: const StockReceivablePage(),
          context: context,
          width: MediaQuery.of(context).size.width * 0.95,
        );
      } else {
        Navigator.pushNamed(
          globalNavigatorKey.currentContext!,
          StockReceivablePage.route,
        );
      }
    });
  };
}

_initializeService(Store<AppState> store) {
  service = InventoryService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    token: store.state.authState.token,
    businessId: store.state.currentBusinessId,
  );
}

class SetInventoryLoadingAction {
  bool value;

  SetInventoryLoadingAction(this.value);
}

class StockTakeItemChangedAction {
  StockTakeItem item;

  ChangeType type;

  bool isIncoming;

  StockTakeItemChangedAction(this.item, this.type, this.isIncoming);
}

class SetInventoryFaultAction {
  String value;

  SetInventoryFaultAction(this.value);
}

class InventoryRunUploadedAction {
  StockRun value;

  InventoryRunUploadedAction(this.value);
}

class StockRunsLoadedAction {
  List<StockRun> value;

  StockRunsLoadedAction(this.value);
}

class SetSelectedStockRun {
  StockRun value;

  SetSelectedStockRun(this.value);
}

//RECIEVABLE UI ACTIONS

class ReceivablesLoadedAction {
  List<GoodsRecievedVoucher> value;

  ReceivablesLoadedAction(this.value);
}

class SetSelectedReceivable {
  GoodsRecievedVoucher value;

  SetSelectedReceivable(this.value);
}

class RecievablesUploadedAction {
  GoodsRecievedVoucher value;

  RecievablesUploadedAction(this.value);
}

class RecievablesCancelledAction {
  GoodsRecievedVoucher value;

  RecievablesCancelledAction(this.value);
}

class RecievableItemChangedAction {
  GoodsRecievedItem value;

  ChangeType type;

  RecievableItemChangedAction(this.value, this.type);
}
