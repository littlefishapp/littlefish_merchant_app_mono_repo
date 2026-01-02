// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/invoice/invoice_actions.dart';
import 'package:littlefish_merchant/ui/inventory/grv/forms/grv_details_form.dart';
import 'package:littlefish_merchant/ui/inventory/grv/widgets/grv_item_list.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/inventory/view_models/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';

import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class StockReceivablePage extends StatefulWidget {
  static const String route = 'inventory/receive-stock';

  const StockReceivablePage({Key? key}) : super(key: key);

  @override
  State<StockReceivablePage> createState() => _StockReceivablePageState();
}

class _StockReceivablePageState extends State<StockReceivablePage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, GRVVM>(
      onInit: (store) {
        store.dispatch(getInvoices());
      },
      converter: (store) => GRVVM.fromStore(store)..key = formKey,
      builder: (context, vm) => scaffold(context, vm),
    );
  }

  // TODO(lampian): require big time alignement to ui design or improved layout
  Widget scaffold(context, GRVVM vm) => AppScaffold(
    title: vm.item!.isNew ?? true
        ? 'Receive Stock'
        : vm.item!.displayName ?? '',
    actions: vm.item!.isNew ?? true
        ? <Widget>[
            Builder(
              builder: (ctx) => IconButton(
                icon: Icon(
                  Icons.save,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                // onPressed: () => vm.onUpload(ctx),
                onPressed: () {
                  // TODO(lampian): check logic
                  // if (vm.item?.items == null ||
                  //     vm.item?.items.isEmpty) {
                  if (vm.item == null ||
                      vm.item!.items == null ||
                      vm.item!.items!.isEmpty) {
                    showMessageDialog(
                      context,
                      'Please add items.',
                      LittleFishIcons.info,
                    );
                  } else if (vm.key?.currentState?.validate() ?? false) {
                    vm.onUpload(ctx);
                  } else {
                    showMessageDialog(
                      context,
                      'Please fill in all necessary details',
                      LittleFishIcons.info,
                    );
                  }
                },
              ),
            ),
          ]
        : null,
    body: EnvironmentProvider.instance.isLargeDisplay! && vm.item!.isNew!
        ? Row(
            children: <Widget>[
              Expanded(
                child: GRVDetailsForm(item: vm.item, formKey: vm.key),
              ),
              const VerticalDivider(width: 0.5),
              Expanded(child: GRVItemList(vm: vm)),
            ],
          )
        : Column(
            children: <Widget>[
              Expanded(
                child: GRVDetailsForm(item: vm.item, formKey: vm.key),
              ),
              SizedBox(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ButtonSecondary(
                    onTap: (c) => Navigator.of(context).push(
                      CustomRoute(
                        maintainState: true,
                        builder: (b) => AppScaffold(
                          title: 'Add Items',
                          body: GRVItemList(vm: vm),
                        ),
                      ),
                    ),
                    text: 'Items',
                  ),
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
  );
}
