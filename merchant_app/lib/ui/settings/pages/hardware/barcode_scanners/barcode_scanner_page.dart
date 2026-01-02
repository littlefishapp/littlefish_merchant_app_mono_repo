// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/managers/device_manager.dart';
import 'package:littlefish_merchant/ui/settings/pages/hardware/barcode_scanners/barcode_scanner_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../../../common/presentaion/components/icons/delete_icon.dart';

// import 'package:littlefish_printer_driver/littlefish_printer_driver.dart';
// import 'package:usb_serial/usb_serial.dart';

class BarcodeScannerPage extends StatefulWidget {
  static const String route = 'hardware/barcode-scanners';

  final bool isEmbedded;

  const BarcodeScannerPage({Key? key, this.isEmbedded = false})
    : super(key: key);

  @override
  State<BarcodeScannerPage> createState() => _BarcodeScannerPageState();
}

class _BarcodeScannerPageState extends State<BarcodeScannerPage> {
  GlobalKey<FormState>? formKey;

  DeviceManager deviceManager = DeviceManager();

  @override
  void initState() {
    formKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, BarcodeScannerVM>(
      rebuildOnChange: false,
      converter: (store) => BarcodeScannerVM.fromStore(store)
        ..key = formKey
        ..deviceManager = deviceManager,
      builder: (ctx, vm) => scaffold(context, vm),
    );
  }

  AppSimpleAppScaffold scaffold(context, BarcodeScannerVM vm) =>
      AppSimpleAppScaffold(
        isEmbedded: widget.isEmbedded,
        actions: <Widget>[
          Builder(
            builder: (ctx) => IconButton(
              icon: const Icon(Icons.save),
              onPressed: () => vm.onAdd(vm.item, ctx),
            ),
          ),
          Visibility(
            visible: (vm.isNew ?? false),
            child: Builder(
              builder: (ctx) => IconButton(
                icon: const DeleteIcon(),
                onPressed: () => vm.onRemove(vm.item, ctx),
              ),
            ),
          ),
        ],
        title: (vm.isNew ?? true)
            ? 'New Scanner'
            : vm.item.displayName ?? 'Edit Scanner',
        body: vm.isLoading! ? const AppProgressIndicator() : form(context, vm),
        // resizeToAvoidBottomPadding: widget.isEmbedded ?? false,
      );

  Form form(context, BarcodeScannerVM vm) => Form(
    key: vm.key,
    child: ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        StringFormField(
          hintText: 'i.e. handy scanner one',
          key: const Key('scannerName'),
          isRequired: true,
          maxLength: 50,
          enforceMaxLength: true,
          labelText: 'Scanner Name',
          initialValue: vm.item.displayName,
          onSaveValue: (value) {
            vm.item.name = vm.item.displayName = value;
          },
          onFieldSubmitted: (value) {
            vm.item.name = vm.item.displayName = value;
          },
        ),
        // DropdownFormField(
        //   hintText: "Interface Type",
        //   key: Key("interfaceType"),
        //   labelText: "Interface Type",
        //   onSaveValue: (value) => vm.item.connectionType = value.value,
        //   onFieldSubmitted: (value) =>
        //       vm.item.connectionType = value.value,
        //   // initialValue: vm.item?.connectionType,
        //   isRequired: true,
        //   values: ConnectionType.values
        //       .asMap()
        //       .entries
        //       .map((e) => DropDownValue(
        //           index: e.key,
        //           displayValue: e
        //               .toString()
        //               .substring(e.toString().lastIndexOf('.') + 1)
        //               .toUpperCase(),
        //           value: e.value))
        //       .toList(),
        // ),
        // Visibility(
        //   visible: vm.item.connectionType == ConnectionType.usb,
        //   child: CapsuleButton(
        //     icon: Icons.usb,
        //     text: "select device",
        //     onTap: (c) {
        //       searchUsbDevices(c, vm);
        //     },
        //   ),
        // ),
        Visibility(
          visible:
              vm.item.manufacturerName == null ||
              vm.item.manufacturerName.isEmpty,
          child: const LongText(
            'No devices selected, select a device and try again',
            alignment: TextAlign.center,
            maxLines: 2,
          ),
        ),
        Visibility(
          visible:
              vm.item.manufacturerName != null &&
              vm.item.manufacturerName.isNotEmpty,
          child: ListTile(
            tileColor: Theme.of(context).colorScheme.background,
            leading: const OutlineGradientAvatar(child: Icon(Icons.print)),
            title: Text(vm.item.productName ?? ''),
            subtitle: LongText(vm.item.manufacturerName),
          ),
        ),
      ],
    ),
  );

  searchUsbDevices(context, BarcodeScannerVM vm) async {
    // await showPopupDialog<UsbDevice>(
    //   context: context,
    //   content: DeviceSelectPage(
    //     connectionType: ConnectionType.usb,
    //     scanner: true,
    //   ),
    // ).then((device) {
    //   if (device != null) {
    //     vm.selectedDevice = device;
    //     vm.item.productName = device.productName;
    //     vm.item.deviceId = device.deviceId;
    //     vm.item.deviceSerial = device.serial;
    //     vm.item.manufacturerName = device.manufacturerName;
    //     vm.item.productId = device.pid;
    //     vm.item.vendorId = device.vid;

    //     // if (mounted) setState(() {});
    //   }
    // });
  }
}
