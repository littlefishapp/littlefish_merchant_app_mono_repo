import 'package:flutter/material.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/features/pos/data/data_source/pos_service.dart';
import 'package:littlefish_payments/models/terminal/terminal_data.dart';
import '../../../../app/theme/ui_state_data.dart';
import '../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../common/presentaion/components/form_fields/string_form_field.dart';
import '../../../../common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';

class LinkedDevicesVM {}

class POSDevicePage extends StatefulWidget {
  final LinkedDevicesVM? vm;

  const POSDevicePage(this.vm, {Key? key}) : super(key: key);

  @override
  State<POSDevicePage> createState() => _POSDevicePageState();
}

class _POSDevicePageState extends State<POSDevicePage> {
  LoggerService get logger => LittleFishCore.instance.get<LoggerService>();
  String? merchantId, siteId;

  FocusNode focusNode1 = FocusNode();
  FocusNode focusNode2 = FocusNode();
  FocusNode focusNode3 = FocusNode();
  FocusNode focusNode4 = FocusNode();
  FocusNode focusNode5 = FocusNode();

  GlobalKey<FormState> formKey = GlobalKey();

  Future<TerminalData> getTerminalInfo() async {
    PosService posService = PosService.fromStore(store: AppVariables.store);

    return posService.getTerminalInfo();
  }

  @override
  Widget build(BuildContext context) {
    return AppSimpleAppScaffold(
      title: 'Merchant Terminal',
      isEmbedded: true,
      body: FutureBuilder<TerminalData>(
        future: getTerminalInfo(),
        builder: (BuildContext context, AsyncSnapshot<TerminalData> snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const AppProgressIndicator();
          }

          if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Icon(LittleFishIcons.error, size: 40, color: Colors.red),
                  const SizedBox(height: 10),
                  Text(
                    'Failed to load terminal information',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            );
          }

          if (snapshot.hasData) {
            TerminalData result = snapshot.data!;
            return Column(
              children: <Widget>[
                const SizedBox(height: 20),
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      UIStateData().appLogo,
                      fit: BoxFit.fitHeight,
                      height: 40,
                    ),
                  ),
                ),
                Expanded(child: _layout(context, widget.vm, result)),
              ],
            );
          } else {
            return const AppProgressIndicator();
          }
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  _layout(BuildContext context, LinkedDevicesVM? vm, TerminalData result) {
    var formFields = <Widget>[
      StringFormField(
        enabled: false,
        isRequired: true,
        hintText: 'The name of the account linked to this terminal',
        key: const Key('merchantName'),
        initialValue: result.merchantName,
        labelText: 'Merchant Name',
        onSaveValue: (String? value) {},
        onFieldSubmitted: (String value) {},
      ),
      StringFormField(
        enabled: false,
        hintText: 'The merchant ID',
        initialValue: result.merchantId,
        key: const Key('merchantId'),
        isRequired: true,
        labelText: 'Merchant ID',
        onSaveValue: (String? value) {},
        onFieldSubmitted: (String value) {},
      ),
      StringFormField(
        enabled: false,
        hintText: 'The ID of this terminal',
        key: const Key('terminalID'),
        initialValue: result.terminalId,
        isRequired: true,
        labelText: 'Terminal ID',
        onSaveValue: (String? value) {},
        onFieldSubmitted: (String value) {},
      ),
      StringFormField(
        enabled: false,
        hintText: 'A920, A920Pro etc',
        key: const Key('deviceModel'),
        initialValue: result.modelNumber,
        labelText: 'Device Model',
        onSaveValue: (String? value) {},
        onFieldSubmitted: (String value) {},
      ),
      StringFormField(
        enabled: false,
        hintText: 'Check back of device S/N:..',
        key: const Key('deviceSerial'),
        initialValue: result.serialNumber,
        labelText: 'Terminal Serial Number',
        onSaveValue: (String? value) {},
        onFieldSubmitted: (String value) {},
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Form(
        key: formKey,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: formFields,
        ),
      ),
    );
  }
}
