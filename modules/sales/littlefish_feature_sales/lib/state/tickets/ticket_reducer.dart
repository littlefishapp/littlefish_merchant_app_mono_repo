// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_actions.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_state.dart';
import 'package:littlefish_merchant/redux/ui/ui_entity_state.dart';

final ticketsReducer = combineReducers<TicketState>([
  TypedReducer<TicketState, TicketChangedAction>(onTicketChanged).call,
  TypedReducer<TicketState, TicketsLoadedAction>(onTicketsLoaded).call,
  TypedReducer<TicketState, SetTicketStateErrorAction>(onSetError).call,
  TypedReducer<TicketState, SetTicketLoadingAction>(onSetLoading).call,
  TypedReducer<TicketState, PushTicketCompletedAction>(onTicketsPushed).call,
  TypedReducer<TicketState, SignoutAction>(onClearState).call,
  TypedReducer<TicketState, SetSearchTextAction>(onSetTicketSearchText).call,
]);

TicketState onClearState(TicketState state, SignoutAction action) =>
    state.rebuild((b) {
      b.isLoading = false;
      b.hasError = false;
      b.errorMessage = null;
      b.tickets = [];
    });

TicketState onSetTicketSearchText(
  TicketState state,
  SetSearchTextAction action,
) => state.rebuild((b) {
  b.searchText = action.value;
});

TicketState onTicketChanged(TicketState state, TicketChangedAction action) =>
    state.rebuild(
      (_) {},
      // TODO(lampian): fix 33 to 35
      // (b) => b.tickets = action.type != ChangeType.removed
      //     ? _addOrUpdateItem(b.tickets, action.value)
      //     : _removeItem(b.tickets, action.value),
    );

TicketState onSetError(TicketState state, SetTicketStateErrorAction action) =>
    state.rebuild(
      (b) => b
        ..hasError = true
        ..errorMessage = action.value,
    );

TicketState onTicketsLoaded(TicketState state, TicketsLoadedAction action) =>
    state.rebuild((b) => b.tickets = action.value);

TicketState onSetLoading(TicketState state, SetTicketLoadingAction action) =>
    state.rebuild((b) => b.isLoading = action.value);

TicketState onTicketsPushed(
  TicketState state,
  PushTicketCompletedAction action,
) {
  if (action.success) {
    return state.rebuild((b) => b.tickets?..add(action.value));
  } else {
    return state;
  }
}

// removed ignore: unused_element
List<Ticket?> _addOrUpdateItem(List<Ticket?>? state, Ticket? item) {
  if (state == null || state.isEmpty) {
    state = [item];
    return state;
  }

  var index = state.indexWhere((i) => i!.id == item!.id);
  if (index >= 0) {
    return state..[index] = item;
  } else {
    return state..add(item);
  }
}

// removed ignore: unused_element
void _removeItem(List<Ticket?>? state, Ticket? item) =>
    state?.removeWhere((i) => i!.id == item!.id);

//UI
final ticketUIReducer = combineReducers<TicketUIState>([
  TypedReducer<TicketUIState, TicketSelectAction>(onTicketSelected).call,
  TypedReducer<TicketUIState, TicketCreateAction>(onCreateTicket).call,
  TypedReducer<TicketUIState, TicketChangedAction>(onSetTicketChanged).call,
]);

TicketUIState onTicketSelected(
  TicketUIState state,
  TicketSelectAction action,
) => state.rebuild((b) => b.item = UIEntityState(action.value, isNew: false));

TicketUIState onCreateTicket(TicketUIState state, TicketCreateAction action) =>
    state.rebuild((b) => b.item = UIEntityState(Ticket.create(), isNew: true));

TicketUIState onSetTicketChanged(
  TicketUIState state,
  TicketChangedAction action,
) {
  return state.rebuild(
    (b) => b.item = UIEntityState<Ticket>(Ticket.create(), isNew: true),
  );
}
