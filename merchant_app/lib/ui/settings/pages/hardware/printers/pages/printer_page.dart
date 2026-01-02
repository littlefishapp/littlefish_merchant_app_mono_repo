// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:quiver/strings.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

// import 'package:littlefish_printer_driver/littlefish_printer_driver.dart';

class HardwarePrinterPage extends StatefulWidget {
  static const String route = '/settings/hardware/printer';

  final bool isEmbedded;
  final dynamic defaultItem;
  final BuildContext? parentContext;

  const HardwarePrinterPage({
    this.parentContext,
    this.defaultItem,
    Key? key,
    this.isEmbedded = false,
  }) : super(key: key);

  @override
  State<HardwarePrinterPage> createState() => _HardwarePrinterPageState();
}

class _HardwarePrinterPageState extends State<HardwarePrinterPage> {
  GlobalKey<FormState>? formKey;
  @override
  void initState() {
    formKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if(widget.defaultItem != null) defaultItem = widget.defaultItem;

    // var result = StoreConnector<AppState, PrinterVM>(
    //     // rebuildOnChange: false,
    //     converter: (store) => PrinterVM.fromStore(store)..key = formKey,
    //     builder: (ctx, vm) {
    //       if (widget.defaultItem != null) {
    //         vm.item = widget.defaultItem;
    //         vm.isNew = false;
    //         vm.item.configurePrinter();
    //       } else {
    //         vm.isNew = true;
    //         // vm.item = dynamic(connectionType: null, deviceAddress: null, displayName: null, identifier: null, isDefault: null, name: 'Printer', printReceipts: null);
    //       }

    //       return scaffold(context, vm);
    //     });

    return Container();
  }
}

class PrinterAddressPage extends StatefulWidget {
  final GlobalKey<FormState>? formKey;
  final String? ip;

  const PrinterAddressPage({Key? key, this.formKey, this.ip}) : super(key: key);
  @override
  State<PrinterAddressPage> createState() => _PrinterAddressPageState();
}

class _PrinterAddressPageState extends State<PrinterAddressPage> {
  String? ip;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    if (isBlank(ip)) ip = widget.ip;
    return AppSimpleAppScaffold(
      resizeToAvoidBottomPadding: false,
      isEmbedded: true,
      title: 'Network Printer',
      displayAppBar: false,
      body: SafeArea(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const LongText(
                'Please enter the IP Address of your WiFi/Network Printer.',
              ),
              const CommonDivider(),
              StringFormField(
                initialValue: ip,
                hintText: '192.168.1.123',
                key: const Key('ip'),
                labelText: 'IP Address',
                onSaveValue: (value) {
                  ip = value;
                },
                onFieldSubmitted: (value) {
                  ip = value;
                },
                isRequired: true,
              ),
              ButtonPrimary(
                text: 'Send',
                onTap: (ctx) {
                  formKey.currentState?.save();
                  Navigator.of(context).pop(ip);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
