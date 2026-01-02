// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_actions.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/ui/tickets/tickets_list.dart';
import 'package:littlefish_merchant/ui/tickets/view_models/ticket_collection_vm.dart';

import '../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class TicketSelectPage extends StatefulWidget {
  static const String route = '/ticket-select';

  final bool isDialog;

  final bool canAddNew;

  final List<CheckoutCartItem>? items;

  final Function(BuildContext context, Ticket ticket) onSelected;

  const TicketSelectPage({
    Key? key,
    required this.onSelected,
    this.items,
    this.isDialog = false,
    this.canAddNew = false,
  }) : super(key: key);

  @override
  State<TicketSelectPage> createState() => _TicketSelectPageState();
}

class _TicketSelectPageState extends State<TicketSelectPage> {
  GlobalKey<AutoCompleteTextFieldState<Ticket>>? searchKey;
  List<CheckoutCartItem>? cartItems = [];

  @override
  void initState() {
    searchKey = GlobalKey<AutoCompleteTextFieldState<Ticket>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.items != null) cartItems = widget.items;

    var result = StoreConnector<AppState, TicketCollectionVM>(
      onInit: (store) => store.dispatch(getTickets()),
      converter: (Store store) =>
          TicketCollectionVM.fromStore(store as Store<AppState>),
      builder: (BuildContext context, TicketCollectionVM vm) =>
          vm.isLoading! ? const AppProgressIndicator() : body(context, vm),
    );

    if (widget.isDialog) {
      return Container(
        // constraints: BoxConstraints.tightFor(width: 376),
        alignment: Alignment.center,
        child: result,
      );
    } else {
      return AppScaffold(title: 'Select Sale', body: result);
    }
  }

  Widget body(context, TicketCollectionVM vm) {
    return TicketsList(
      cartItems: cartItems,
      incompleteOnly: true,
      onTap: (ticket) {
        widget.onSelected(context, ticket);
        Navigator.of(context).pop(ticket);
      },
      vm: vm,
      canAddNew: true,
    );
  }
}
