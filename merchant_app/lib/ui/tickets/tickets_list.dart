// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/search_text_field.dart';

// Project imports:
import 'package:littlefish_merchant/models/sales/checkout/checkout_cart_item.dart';
import 'package:littlefish_merchant/models/sales/tickets/ticket.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/ui/tickets/ticket_details_form.dart';
import 'package:littlefish_merchant/ui/tickets/view_models/ticket_collection_vm.dart';
import 'package:quiver/strings.dart';

import '../../app/theme/applied_system/applied_surface.dart';

class TicketsList extends StatefulWidget {
  final Function(Ticket item)? onTap;

  final bool canAddNew;
  final bool canRemove;
  final bool incompleteOnly;
  final List<CheckoutCartItem>? cartItems;
  final TicketCollectionVM? vm;
  const TicketsList({
    Key? key,
    this.vm,
    this.onTap,
    this.cartItems,
    this.canAddNew = true,
    this.canRemove = false,
    this.incompleteOnly = false,
  }) : super(key: key);

  @override
  State<TicketsList> createState() => _TicketsListState();
}

class _TicketsListState extends State<TicketsList> {
  GlobalKey<AutoCompleteTextFieldState<Ticket>>? filterkey;
  TicketCollectionVM? vm;
  List<CheckoutCartItem>? cartItems;

  TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    filterkey = GlobalKey<AutoCompleteTextFieldState<Ticket>>();
    _controller = TextEditingController();
    _controller.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.vm != null) vm = widget.vm;

    if (widget.incompleteOnly) vm!.items = vm!.incompleteTickets;

    if (widget.cartItems != null && widget.cartItems!.isNotEmpty) {
      cartItems = widget.cartItems;
    }

    return layout(context, vm!);
  }

  Widget layout(BuildContext context, TicketCollectionVM vm) {
    return Column(
      children: <Widget>[
        // const SizedBox(height: 24),
        topBar(
          context,
          // onAdd:
          //     widget.canAddNew ? () => captureTicket(context, vm) : null,
          vm: vm,
        ),
        Expanded(
          flex: 60,
          child: vm.isLoading!
              ? const AppProgressIndicator()
              : ticketList(context, vm),
        ),
      ],
    );
  }

  Widget topBar(
    BuildContext context, {
    Function? onAdd,
    required TicketCollectionVM vm,
  }) {
    return SearchTextField(
      hintText: 'Search by transaction number, total amount or customer name',
      initialValue: widget.vm?.searchText ?? '',
      controller: _controller,
      onChanged: (text) async {
        await widget.vm!.setSearchText!(text);
        if (mounted) setState(() {});
      },
      onFieldSubmitted: (text) async {
        if (text == '') {
          await widget.vm!.setSearchText!('');
          if (mounted) setState(() {});
        } else {
          await widget.vm!.setSearchText!(text);
        }
        if (mounted) setState(() {});
      },
      onClear: () async {
        await widget.vm!.setSearchText!('');
        if (mounted) setState(() {});
      },
    );
  }

  Future<void> captureTicket(
    BuildContext context,
    TicketCollectionVM vm, {
    Ticket? ticket,
  }) async {
    //this is an existing ticket that should be edited
    if (ticket != null) {
      if (!(vm.store!.state.isLargeDisplay ?? false)) {
        //vm.store.dispatch(editTicket(ticket: ticket));
      }
    } else {
      Navigator.of(context).push<Ticket>(
        CustomRoute(
          builder: (BuildContext context) =>
              TicketDetailsForm(item: ticket, cartItems: cartItems),
        ),
      );
    }
  }

  Widget ticketList(BuildContext context, TicketCollectionVM vm) {
    return _getTickets(vm).isEmpty
        ? Container(
            padding: const EdgeInsets.all(16),
            child: context.paragraphLarge('No tickets found'),
          )
        : ListView.builder(
            physics: const BouncingScrollPhysics(),
            itemCount: _getTickets(vm).length,
            itemBuilder: (BuildContext context, int index) {
              Ticket? item = _getTickets(vm)[index];

              return TicketListTile(
                item: item,
                dismissAllowed: widget.canRemove,
                selected: vm.selectedItem == item,
                onTap: (item) {
                  if (widget.onTap == null) {
                    captureTicket(context, vm, ticket: item);
                  } else {
                    widget.onTap!(item);
                  }
                },
                onRemove: (item) {
                  vm.onRemove(item, context);
                },
              );
            },
          );
  }
}

List<Ticket?> _getTickets(TicketCollectionVM vm) {
  if (isNotBlank(vm.searchText)) {
    return vm.filteredItems ?? [];
  } else {
    return vm.items!;
  }
}

class TicketListTile extends StatelessWidget {
  const TicketListTile({
    Key? key,
    required this.item,
    this.onTap,
    this.dismissAllowed = false,
    this.onRemove,
    this.category,
    this.selected = false,
  }) : super(key: key);

  final bool selected;

  final Ticket? item;

  final bool dismissAllowed;

  final Function(Ticket item)? onTap;

  final Function(Ticket item)? onRemove;

  final StockCategory? category;

  @override
  Widget build(BuildContext context) {
    return dismissAllowed
        ? dismissibleTicketTile(context, item!)
        : ticketTile(context, item!);
  }

  Widget dismissibleTicketTile(BuildContext context, Ticket item) {
    return Slidable(
      key: GlobalKey(),
      endActionPane: ActionPane(
        extentRatio: .25,
        motion: const ScrollMotion(),
        children: [
          SlidableAction(
            onPressed: (ctx) async {
              var result = await confirmDismissal(context, item);

              if (result == true) {
                onRemove!(item);
              }
            },
            backgroundColor:
                Theme.of(context).extension<AppliedSurface>()?.primary ??
                Colors.red,
            foregroundColor: Theme.of(
              context,
            ).extension<AppliedTextIcon>()?.secondary,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ticketTile(context, item),
    );
  }

  Widget ticketTile(BuildContext context, Ticket item) {
    return ListTile(
      tileColor: Theme.of(context).extension<AppliedSurface>()?.primary,
      dense: !EnvironmentProvider.instance.isLargeDisplay!,
      selected: selected,
      title: Text('${item.reference}'),
      leading: const ListLeadingIconTile(icon: Icons.event_note),
      subtitle: LongText(item.notes ?? ''),
      trailing: ListLeadingTextTile(text: item.itemCount.toString()),
      onTap: onTap == null
          ? null
          : () {
              if (onTap != null) onTap!(item);
            },
    );
  }
}
