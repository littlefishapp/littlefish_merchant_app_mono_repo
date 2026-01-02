// Dart imports:
import 'dart:async';
import 'dart:developer';

// Flutter imports:

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/services/sales_service.dart';
import 'package:littlefish_merchant/stores/stores.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';

ThunkAction<AppState> getTickets({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      // _initializeService(store);

      var ticketState = store.state.ticketState;

      if (!refresh && (ticketState.tickets?.length ?? 0) > 0) {
        return;
      }

      store.dispatch(SetTicketLoadingAction(true));
      var ticketStore = TicketStore();

      try {
        var localTickets = await ticketStore.getTickets();

        if (localTickets.isNotEmpty) {
          store.dispatch(TicketsLoadedAction(localTickets));
          store.dispatch(SetTicketLoadingAction(false));
          return;
        }
      } catch (e) {
        log(
          'unable to get local transactions from storage',
          error: e,
          stackTrace: StackTrace.current,
        );

        //let us wipe out so it can cache clean working data next time
        ticketStore.clear();

        reportCheckedError(e, trace: StackTrace.current);
      }

      var service = SalesService.fromStore(store);

      await service
          .getTickets()
          .catchError((e) {
            store.dispatch(SetTicketStateErrorAction(e.toString()));
            reportCheckedError(e, trace: StackTrace.current);
            return <Ticket>[];
          })
          .then((result) {
            store.dispatch(TicketsLoadedAction(result));
          });

      store.dispatch(SetTicketLoadingAction(false));
    });
  };
}

ThunkAction<AppState> removeTicket({
  required Ticket? ticket,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetTicketLoadingAction(true));
      var service = SalesService.fromStore(store);

      await service
          .deleteTicket(ticketId: ticket!.id)
          .catchError((e) {
            store.dispatch(SetTicketStateErrorAction(e.toString()));
            reportCheckedError(e, trace: StackTrace.current);

            completer?.completeError(e);
            return false;
          })
          .then((result) {
            if (result) {
              store.dispatch(TicketChangedAction(ticket, ChangeType.removed));
            }
            if (!(completer?.isCompleted ?? false)) {
              completer?.complete();
            }
          })
          .whenComplete(() => store.dispatch(SetTicketLoadingAction(false)));
    });
  };
}

ThunkAction<AppState> addTicket({
  required Ticket? ticket,
  bool saveToCheckout = false,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetTicketLoadingAction(true));
      var service = SalesService.fromStore(store);

      await service
          .upsertTicket(ticket: ticket!)
          .catchError((e) {
            store.dispatch(SetTicketStateErrorAction(e.toString()));

            store.dispatch(PushTicketCompletedAction(false, null));
            reportCheckedError(e, trace: StackTrace.current);

            completer?.completeError(e);
            return null;
          })
          .then((result) {
            if (result != null) {
              store.dispatch(PushTicketCompletedAction(true, result));
              store.dispatch(TicketChangedAction(result, ChangeType.added));

              if (saveToCheckout) {
                store.dispatch(CheckoutSetTicketAction(result));
              } else {
                store.dispatch(CheckoutClearAction(null));
              }
            }
            if (!(completer?.isCompleted ?? false)) {
              completer?.complete();
            }
          })
          .whenComplete(() => store.dispatch(SetTicketLoadingAction(false)));
    });
  };
}

ThunkAction<AppState> editTicket({
  required Ticket? ticket,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetTicketLoadingAction(true));
      var service = SalesService.fromStore(store);

      await service
          .upsertTicket(ticket: ticket!)
          .catchError((e) {
            store.dispatch(SetTicketStateErrorAction(e.toString()));

            reportCheckedError(e, trace: StackTrace.current);

            completer?.completeError(e);
            return null;
          })
          .then((result) {
            if (result != null) {
              store.dispatch(TicketChangedAction(result, ChangeType.updated));
            }
            if (!(completer?.isCompleted ?? false)) {
              completer?.complete();
            }
          })
          .whenComplete(() => store.dispatch(SetTicketLoadingAction(false)));
    });
  };
}

ThunkAction<AppState> updateTicketItems({
  required Ticket ticket,
  List<CheckoutCartItem>? newItems,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      List<CheckoutCartItem>? items = <CheckoutCartItem>[];
      ticket.items = ticket.items ?? [];
      for (var i = 0; i < newItems!.length; i++) {
        items = _addItem(ticket.items, newItems[i]);
      }

      ticket.items = items;
      ticket.dateUpdated = DateTime.now().toUtc();
      store.dispatch(editTicket(ticket: ticket));
    });
  };
}

ThunkAction<AppState> syncTickets({Completer? completer}) {
  return (Store<AppState> store) async {
    Future(() async {
      if (!store.state.hasInternet!) {
        completer?.completeError(
          ManagedException(message: 'No Internet Access'),
        );
        return;
      }

      // _initializeService(store);

      TicketStore ticketStore = TicketStore();

      var pendingCount = await ticketStore.getPendingTicketsCount();

      //nothing to send to the server at this time
      if (pendingCount <= 0) {
        completer?.complete();
        return;
      }

      List<String?> exclusions = [];
      var service = SalesService.fromStore(store);

      //here we send until there is nothing left to send sir
      while (pendingCount > 0) {
        var batch = await ticketStore.getPendingTicketsBatch(
          exclusions: exclusions,
        );

        //exit the loop there is nothing to do here.
        if (batch.isEmpty) {
          break;
        }

        for (var ticket in batch) {
          await service
              .upsertTicket(ticket: ticket, pushToServer: true)
              .catchError((error) {
                log(
                  'unable to upload ticket with ID:${ticket.id} to server at this time',
                );

                //add the failed transaction as an exclusion, as it has failed and should not proceed
                exclusions.add(ticket.id);

                reportCheckedError(error, trace: StackTrace.current);
                return null;
              })
              .then((result) {
                if (result != null) {
                  ticketStore.updateTicket(result);

                  //we need to dispatch a new action, this is key for reporting back to the UI
                  store.dispatch(
                    TicketChangedAction(result, ChangeType.updated),
                  );
                }
              });
        }

        pendingCount = await ticketStore.getPendingTicketsCount(
          exclusions: exclusions,
        );
      }

      completer?.complete();
    });
  };
}

List<CheckoutCartItem>? _addItem(
  List<CheckoutCartItem>? state,
  CheckoutCartItem cartItem,
) {
  if (cartItem.isCombo ?? false) {
    bool hasItem = state!.any((i) => i.comboId == cartItem.comboId);

    if (hasItem) {
      var existingItemIndex = state.indexWhere(
        (i) => i.comboId == cartItem.comboId,
      );

      var existingItem = state[existingItemIndex];

      existingItem.quantity += cartItem.quantity;

      state[existingItemIndex] = existingItem;

      return state;
    } else {
      state.add(cartItem);

      return state;
    }
  } else {
    bool hasItem = state!.any(
      (i) => i.productId == cartItem.productId && i.barcode == cartItem.barcode,
    );

    if (hasItem) {
      var existingItemIndex = state.indexWhere(
        (i) =>
            i.productId == cartItem.productId && i.barcode == cartItem.barcode,
      );

      var existingItem = state[existingItemIndex];

      existingItem.quantity += cartItem.quantity;

      state[existingItemIndex] = existingItem;

      return state;
    } else {
      bool hasItem = state.any((i) => i.description == cartItem.description);

      if (hasItem) {
        var existingItemIndex = state.indexWhere(
          (i) => i.description == cartItem.description,
        );

        var existingItem = state[existingItemIndex];

        existingItem.quantity += cartItem.quantity;

        state[existingItemIndex] = existingItem;

        return state;
      } else {
        state.add(cartItem);

        return state;
      }
    }
  }
}

class PushTicketCompletedAction {
  bool success;

  Ticket? value;

  PushTicketCompletedAction(this.success, this.value);
}

class UpdateTicketCompletedAction {
  bool success;

  Ticket ticket;

  UpdateTicketCompletedAction(this.success, this.ticket);
}

class SetTicketLoadingAction {
  bool value;

  SetTicketLoadingAction(this.value);
}

class SetTicketStateErrorAction {
  String value;

  SetTicketStateErrorAction(this.value);
}

class TicketsLoadedAction {
  List<Ticket?> value;

  TicketsLoadedAction(this.value);
}

class UpdateTicketItemsAction {
  List<CheckoutCartItem> value;

  UpdateTicketItemsAction(this.value);
}

class SetSearchTextAction {
  String value;

  SetSearchTextAction(this.value);
}

class TicketChangedAction {
  Ticket? value;

  ChangeType type;

  TicketChangedAction(this.value, this.type);
}

class TicketSelectAction {
  Ticket value;

  TicketSelectAction(this.value);
}

class TicketCreateAction {}
