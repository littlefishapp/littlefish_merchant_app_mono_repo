// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_actions.dart';
import 'package:littlefish_merchant/stores/stores.dart';

class TicketMiddleware extends MiddlewareClass<AppState> {
  final TicketStore ticketStore = TicketStore();

  @override
  void call(Store<AppState> store, action, NextDispatcher next) async {
    //trigger the next action in the chain as expected
    next(action);

    if (action is PushTicketCompletedAction) {
      if ((store.state.hasInternet ?? false) &&
          (action.value!.pendingSync ?? false)) {
        store.dispatch(syncTickets());
      }
    }

    if (action is TicketChangedAction) {
      if ((store.state.hasInternet ?? false) &&
          (action.value!.pendingSync ?? false) &&
          action.type != ChangeType.added) {
        store.dispatch(syncTickets());
      }
    }
  }
}
