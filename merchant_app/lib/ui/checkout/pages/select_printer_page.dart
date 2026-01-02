// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:littlefish_merchant/ui/checkout/viewmodels/print_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/text_tag.dart';

class SelectPrinterPage extends StatefulWidget {
  final BuildContext? parentContext;
  final PrintVM? vm;

  const SelectPrinterPage({Key? key, this.parentContext, this.vm})
    : super(key: key);
  @override
  State<SelectPrinterPage> createState() => _SelectPrinterPageState();
}

class _SelectPrinterPageState extends State<SelectPrinterPage> {
  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      title: 'Select Printer',
      isEmbedded: true,
      body: _layout(context: widget.parentContext ?? context, vm: widget.vm),
    );
  }

  Widget _layout({BuildContext? context, PrintVM? vm}) {
    return vm?.configuredPrinters != null
        ? ListView.separated(
            itemBuilder: (ctx, index) {
              var printer = vm!.configuredPrinters![index];
              return ListTile(
                tileColor: Theme.of(context!).colorScheme.background,
                trailing: (printer?.isDefault ?? false)
                    ? const Icon(Icons.favorite)
                    : null,
                subtitle: LongText(printer.name),
                title: Row(
                  children: <Widget>[
                    Icon(MdiIcons.printer),
                    const SizedBox(width: 4),
                    Text(printer.displayName ?? printer.name ?? 'no name'),
                  ],
                ),
                onTap: () {
                  Navigator.of(context).pop(printer);
                },
              );
            },
            separatorBuilder: (ctx, index) => const CommonDivider(),
            itemCount: vm?.configuredPrinters?.length ?? 0,
          )
        : const Center(child: TextTag(displayText: 'No Printers Configured'));
  }
}
