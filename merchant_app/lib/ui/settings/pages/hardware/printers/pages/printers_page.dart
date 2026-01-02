// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:littlefish_merchant/redux/hardware/hardware_actions.dart';
import 'package:littlefish_merchant/ui/settings/pages/hardware/printers/widgets/printers_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class PrintersPage extends StatelessWidget {
  static const String route = 'hardware/printers';

  const PrintersPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }

  AppSimpleAppScaffold scaffold(context, vm) => AppSimpleAppScaffold(
    title: 'Printers',
    floatingActionButton: FloatingActionButton(
      backgroundColor: Theme.of(context).colorScheme.primary,
      onPressed: () =>
          vm.store.dispatch(createPrinter(context: context, vm: vm)),
      child: const Icon(Icons.add),
    ),
    actions: <Widget>[
      IconButton(
        icon: const Icon(Icons.refresh),
        onPressed: () {
          // vm.store.dispatch(
          //     // initializeDrivers(refresh: true),
          //     );
        },
      ),
    ],
    body: vm.isLoading ? const AppProgressIndicator() : const PrintersList(),
  );
}
