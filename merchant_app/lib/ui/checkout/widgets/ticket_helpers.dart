// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_actions.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/ui/tickets/ticket_select_page.dart';

import '../../tickets/ticket_details_form.dart';

Future<void> listTicketsPageTrigger(BuildContext context, CheckoutVM vm) async {
  if (vm.ticket == null) {
    if (vm.itemCount == 0) {
      await showPopupDialog(
        context: context,
        content: TicketSelectPage(
          items: vm.items,
          onSelected: (BuildContext ct, Ticket ticket) {
            if (ticket.items != null) vm.addItemsToCart(ticket.items);
            vm.setTicket(ticket);
          },
        ),
      );
    } else {
      if (vm.store!.state.isLargeDisplay ?? false) {
        await showPopupDialog(
          context: context,
          content: TicketSelectPage(
            items: vm.items,
            onSelected: (BuildContext ct, Ticket ticket) {
              vm.store!.dispatch(
                updateTicketItems(ticket: ticket, newItems: vm.items),
              );
              vm.setTicket(ticket);

              vm.onClear();
            },
          ),
        );
      } else {
        await Navigator.of(context).push(
          CustomRoute(
            builder: (BuildContext ctx) => TicketSelectPage(
              items: vm.items,
              onSelected: (BuildContext ct, Ticket ticket) {
                vm.store!.dispatch(
                  updateTicketItems(ticket: ticket, newItems: vm.items),
                );
                vm.setTicket(ticket);
                vm.onClear();
              },
            ),
          ),
        );
      }
    }
  } else {
    vm.ticket!.items = List.from(vm.items!);
    vm.store!.dispatch(
      editTicket(
        ticket: vm.ticket,
        completer: snackBarCompleter(context, 'Ticket Saved'),
      ),
    );
    vm.onClear();
  }
}

Future<void> captureTicketPageTrigger(
  List<CheckoutCartItem> cartItems,
  BuildContext context, {
  Ticket? ticket,
}) async {
  Navigator.of(context).push<Ticket>(
    CustomRoute(
      builder: (BuildContext context) =>
          TicketDetailsForm(item: ticket, cartItems: cartItems),
    ),
  );
}
