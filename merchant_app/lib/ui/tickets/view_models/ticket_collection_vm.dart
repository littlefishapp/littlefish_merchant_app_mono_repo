// Flutter imports:
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_actions.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_state.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class TicketCollectionVM
    extends StoreCollectionViewModel<Ticket?, TicketState> {
  TicketCollectionVM.fromStore(Store<AppState> store) : super.fromStore(store);

  // List<Ticket> get items => state?.tickets;

  List<Ticket?>? get incompleteTickets =>
      state?.tickets?.where((x) => !x!.completed!).toList();

  String? searchText;

  List<Ticket?>? get filteredItems {
    if (isBlank(searchText)) {
      return items;
    }
    return items!
        .where(
          (x) => x!.name!.toLowerCase().contains(searchText!.toLowerCase()),
        )
        .toList();
  }

  Function(String? text)? setSearchText;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.ticketState;
    items = state?.tickets;
    searchText = state?.searchText;
    //this.incompleteTickets = state?.tickets?.where((x) => !x.completed)?.toList();

    onRefresh = () => store.dispatch(getTickets(refresh: true));

    setSearchText = (text) {
      store.dispatch(SetSearchTextAction(text ?? ''));
    };

    onRemove = (item, ctx) {
      store.dispatch(removeTicket(ticket: item));
    };

    onAdd = (item, ctx) {};

    isLoading = store.state.productState.isLoading ?? false;
    hasError = store.state.productState.hasError ?? false;

    errorMessage = state!.errorMessage;
  }
}
