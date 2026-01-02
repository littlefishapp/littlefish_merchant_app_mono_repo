// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_actions.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/ui/tickets/tickets_list.dart';
import 'package:littlefish_merchant/ui/tickets/view_models/ticket_collection_vm.dart';

class TicketsPage extends StatefulWidget {
  static const route = 'checkout/tickets';

  const TicketsPage({Key? key}) : super(key: key);

  @override
  State<TicketsPage> createState() => _TicketsPageState();
}

class _TicketsPageState extends State<TicketsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, TicketCollectionVM>(
      onInit: (store) {
        store.dispatch(getTickets());
      },
      converter: (store) => TicketCollectionVM.fromStore(store),
      builder: (ctx, vm) => scaffoldMobile(context, vm),
    );
  }

  AppScaffold scaffoldMobile(context, TicketCollectionVM vm) => AppScaffold(
    title: 'Tickets',
    // displayFloat: true,
    // floatLocation: FloatingActionButtonLocation.endTop,
    // floatIcon: Icons.search,
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          vm.onRefresh();
          if (mounted) setState(() {});
        },
      ),
    ],
    body: vm.isLoading!
        ? const AppProgressIndicator()
        : TicketsList(vm: vm, canRemove: true),
  );
}
