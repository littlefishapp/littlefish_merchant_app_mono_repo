import 'package:littlefish_merchant/features/sell/presentation/redux/sell_state.dart';
import 'package:redux/redux.dart';

import '../../../../injector.dart';
import '../../../../redux/app/app_state.dart';
import '../../../order_common/data/data_source/order_data_source.dart';
import '../../../order_common/data/model/order.dart';
import 'sell_actions.dart';

List<Middleware<AppState>> createSellMiddleware() {
  return [
    TypedMiddleware<AppState, CreateOrderAction>(_createOrderAction()).call,
    TypedMiddleware<AppState, UpdateOrderAction>(_updateOrderAction()).call,
    TypedMiddleware<AppState, CreateDraftOrderAction>(
      _createDraftOrderAction(),
    ).call,
    TypedMiddleware<AppState, UpdateDraftOrderAction>(
      _updateDraftOrderAction(),
    ).call,
    TypedMiddleware<AppState, SavePurchaseAction>(
      _savePurchaseTransactionAction(),
    ).call,
    TypedMiddleware<AppState, SavePurchaseFailureAction>(
      _savePurchaseFailureTransactionAction(),
    ).call,
    TypedMiddleware<AppState, DiscardOrderAction>(_discardOrderAction()).call,
    TypedMiddleware<AppState, SaveWithdrawalAction>(
      _saveWithdrawalTransactionAction(),
    ).call,
    TypedMiddleware<AppState, GetDraftOrdersAction>(
      _getDraftOrderAction(),
    ).call,
  ];
}

Middleware<AppState> _createDraftOrderAction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as CreateDraftOrderAction;
    final updatedOrder = await getIt<OrderDataSource>().createDraftOrder(
      act.order,
    );

    store.dispatch(SaveDraftOrderToStateAction(updatedOrder));

    next(action);
  };
}

Middleware<AppState> _updateDraftOrderAction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as UpdateDraftOrderAction;
    final updatedOrder = await getIt<OrderDataSource>().updateDraftOrder(
      act.order,
    );

    store.dispatch(SaveDraftOrderToStateAction(updatedOrder));

    next(action);
  };
}

Middleware<AppState> _discardOrderAction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as DiscardOrderAction;
    try {
      store.dispatch(const SetOrderStateIsLoadingAction(true));
      await getIt<OrderDataSource>().discardOrder(act.order);
      store.dispatch(
        const ResetCartAction(
          uiState: PurchasePaymentMethodPageState.orderDiscarded,
        ),
      );
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    } on Error catch (e) {
      store.dispatch(
        SetOrderFailureAction(
          errorMessage: e.toString(),
          stackTrace: e.stackTrace,
          failureReason: e.toString(),
        ),
      );
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    } on Exception catch (e) {
      store.dispatch(
        SetOrderFailureAction(
          errorMessage: e.toString(),
          failureReason: e.toString(),
        ),
      );
      store.dispatch(const SetOrderStateIsLoadingAction(false));

      next(action);
    }
  };
}

Middleware<AppState> _createOrderAction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as CreateOrderAction;
    try {
      store.dispatch(const SetOrderStateIsLoadingAction(true));
      final updatedOrder = await getIt<OrderDataSource>().saveNewOrder(
        act.order,
      );

      store.dispatch(SaveOrderToStateAction(updatedOrder));
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    } on Error catch (e) {
      store.dispatch(
        SetOrderFailureAction(
          errorMessage: e.toString(),
          stackTrace: e.stackTrace,
          failureReason: e.toString(),
        ),
      );
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    } on Exception catch (e) {
      store.dispatch(
        SetOrderFailureAction(
          errorMessage: e.toString(),
          failureReason: e.toString(),
        ),
      );
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    }

    next(action);
  };
}

Middleware<AppState> _updateOrderAction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as UpdateOrderAction;
    try {
      store.dispatch(const SetOrderStateIsLoadingAction(true));
      final updatedOrder = await getIt<OrderDataSource>().updateOrder(
        act.order,
      );

      store.dispatch(SaveOrderToStateAction(updatedOrder));
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    } on Error catch (e) {
      store.dispatch(
        SetOrderFailureAction(
          errorMessage: e.toString(),
          stackTrace: e.stackTrace,
          failureReason: e.toString(),
        ),
      );
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    } on Exception catch (e) {
      store.dispatch(
        SetOrderFailureAction(
          errorMessage: e.toString(),
          failureReason: e.toString(),
        ),
      );
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    }

    next(action);
  };
}

Middleware<AppState> _savePurchaseTransactionAction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as SavePurchaseAction;
    try {
      store.dispatch(const SetOrderStateIsLoadingAction(true));
      var transaction = action.transaction;
      if (transaction.failureReason.isNotEmpty) {
        transaction = act.transaction.copyWith(failureReason: '');
      }
      Order updatedOrder = await getIt<OrderDataSource>().savePurchase(
        transaction,
      );

      final latestTransaction = updatedOrder.transactions.firstOrNull;
      store.dispatch(SaveOrderToStateAction(updatedOrder));
      if (latestTransaction != null) {
        store.dispatch(
          SaveOrderTransactionToStateAction(
            latestTransaction,
            transactionSucceeded: true,
          ),
        );
      }
      store.dispatch(SellResetErrorStateAction());
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    } on Error catch (e) {
      store.dispatch(
        SetTransactionFailureAction(
          errorMessage: e.toString(),
          stackTrace: e.stackTrace,
          failureReason: e.toString(),
        ),
      );

      store.dispatch(const SetOrderStateIsLoadingAction(false));
    } on Exception catch (e) {
      store.dispatch(
        SetTransactionFailureAction(
          errorMessage: e.toString(),
          failureReason: e.toString(),
        ),
      );
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    }
    next(action);
  };
}

Middleware<AppState> _saveWithdrawalTransactionAction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as SaveWithdrawalAction;
    try {
      store.dispatch(const SetOrderStateIsLoadingAction(true));
      var transaction = action.transaction;
      if (transaction.failureReason.isNotEmpty) {
        transaction = act.transaction.copyWith(failureReason: '');
      }
      Order updatedOrder = await getIt<OrderDataSource>().saveWithdrawal(
        transaction,
      );

      final latestTransaction = updatedOrder.transactions.firstOrNull;
      store.dispatch(SaveOrderToStateAction(updatedOrder));
      if (latestTransaction != null) {
        store.dispatch(
          SaveOrderTransactionToStateAction(
            latestTransaction,
            transactionSucceeded: true,
          ),
        );
      }
      store.dispatch(SellResetErrorStateAction());
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    } on Error catch (e) {
      store.dispatch(
        SetTransactionFailureAction(
          errorMessage: e.toString(),
          stackTrace: e.stackTrace,
          failureReason: e.toString(),
        ),
      );

      store.dispatch(const SetOrderStateIsLoadingAction(false));
    } on Exception catch (e) {
      store.dispatch(
        SetTransactionFailureAction(
          errorMessage: e.toString(),
          failureReason: e.toString(),
        ),
      );
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    }
    next(action);
  };
}

Middleware<AppState> _savePurchaseFailureTransactionAction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    final act = action as SavePurchaseFailureAction;
    try {
      store.dispatch(const SetOrderStateIsLoadingAction(true));

      final transaction = act.transaction.copyWith(
        failureReason: act.failureReason,
      );

      final updatedOrder = await getIt<OrderDataSource>().saveFailedTransaction(
        transaction,
      );

      final latestTransaction = updatedOrder.transactions.firstOrNull;
      store.dispatch(SaveOrderToStateAction(updatedOrder));
      if (latestTransaction != null) {
        store.dispatch(SaveOrderTransactionToStateAction(latestTransaction));
      }
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    } on Error catch (e) {
      store.dispatch(
        SetPushFailedTrxFailureAction(
          errorMessage: e.toString(),
          stackTrace: e.stackTrace,
          failureReason: e.toString(),
        ),
      );
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    } on Exception catch (e) {
      store.dispatch(
        SetPushFailedTrxFailureAction(
          errorMessage: e.toString(),
          failureReason: e.toString(),
        ),
      );
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    }
    next(action);
  };
}

Middleware<AppState> _getDraftOrderAction() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    try {
      store.dispatch(const SetOrderStateIsLoadingAction(true));
      final draftOrder = await getIt<OrderDataSource>().getDraftOrder();
      store.dispatch(SaveDraftOrdersToStateAction(draftOrder));
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    } catch (e) {
      store.dispatch(
        SetOrderFailureAction(
          errorMessage: e.toString(),
          failureReason: e.toString(),
        ),
      );
      store.dispatch(const SetOrderStateIsLoadingAction(false));
    }

    next(action);
  };
}
