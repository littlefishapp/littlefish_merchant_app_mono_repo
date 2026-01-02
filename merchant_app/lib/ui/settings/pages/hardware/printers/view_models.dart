// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:littlefish_merchant/hardware/hardware_scanner.dart';
// import 'package:littlefish_merchant/hardware/printer_model.dart';
// import 'package:littlefish_merchant/redux/app/app_state.dart';
// import 'package:littlefish_merchant/redux/hardware/hardware_actions.dart';
// import 'package:littlefish_merchant/redux/hardware/hardware_state.dart';
// import 'package:littlefish_merchant/tools/managers/device_manager.dart';
// import 'package:littlefish_merchant/ui/shared/completers/completers.dart';
// import 'package:littlefish_merchant/ui/shared/dialogs/common_dialogs.dart';
// import 'package:littlefish_merchant/ui/shared/viewmodels/store_collection_viewmodel.dart';
// // import 'package:littlefish_printer_driver/littlefish_printer_driver.dart';
// import 'package:redux/redux.dart';

// class PrintersVM extends StoreCollectionViewModel<dynamic, HardwareState> {
//   PrintersVM.fromStore(Store<AppState> store) : super.fromStore(store);

//   List<dynamic> models;

//   List<InterfaceType> get hardwareModels => PrinterManager()
//       .getInterfaceTypes()
//       .where((x) => x != InterfaceType.starMPop)
//       .toList();

//   @override
//   loadFromStore(Store<AppState> store, {BuildContext context}) async {
//     this.store = store;
//     this.state = store.state.hardwareState;

//     this.isLoading = state.isLoading;
//     this.hasError = state.hasError;
//     this.errorMessage = state.errorMessage;

//     this.items = state.configuredPrinters;

//     this.models = state.models;

//     this.onRemove = (value, ctx) {
//       store.dispatch(
//         removePrinter(
//           context: ctx,
//           printer: value,
//           completer: snackBarCompleter(ctx, 'Printer removed successfully'),
//         ),
//       );
//     };
//   }
// }

// class PrinterVM extends StoreItemViewModel<dynamic, HardwareState> {
//   PrinterVM.fromStore(Store<AppState> store) : super.fromStore(store);

//   List<dynamic> configuredPrinters;

//   List<InterfaceType> get hardwareModels => PrinterManager()
//       .getInterfaceTypes()
//       .where((x) => x != InterfaceType.starMPop)
//       .toList();

//   Future<List<PrinterDevice>> getDevices(ConnectionType connection) async =>
//       await PrinterManager().getDevices(connection);

//   Function(InterfaceType hardware) setPrinter;
//   Function(InterfaceType hardware) setInterface;
//   Function(ConnectionType hardware) setConnectionType;
//   Function(PrinterDevice hardware) setSelectedDevice;
//   Function() setIsNew;
//   @override
//   loadFromStore(Store<AppState> store, {BuildContext context}) {
//     this.store = store;
//     this.state = store.state.hardwareState;
//     this.item = store.state.hardwareUIState.printerModel;

//     this.isNew = state.isNew ?? false;

//     this.isLoading = state.isLoading;
//     this.hasError = state.hasError;
//     this.errorMessage = state.errorMessage;

//     this.configuredPrinters = state.configuredPrinters;

//     this.setInterface = (value) => this.item.interfaceType = value;
//     this.setConnectionType = (value) => this.item.connectionType = value;
//     this.setPrinter = (value) {
//       this.item.printer =
//           PrinterManager().getPrinter(model: this.item.interfaceType);
//     };

//     this.setSelectedDevice = (value) async {
//       this.item.device = value;
//       this.item.setPrinterDevice();
//       await item.configurePrinter();
//     };

//     this.onAdd = (value, ctx) {
//       if (this.key == null || this.key.currentState == null)
//         showMessageDialog(
//           context,
//           "We cannot save this printer now, please try again later",
//           LittleFishIcons.warning,
//         );
//       else {
//         if (this.key.currentState.validate()) {
//           this.key.currentState.save();

//           if (item.connectionType == null || item.printer == null) {
//             showMessageDialog(
//                 ctx, "Please select the model and connection type", LittleFishIcons.info);
//             return;
//           }

//           if (item.connectionType == ConnectionType.usb) {
//             if (item.device == null) {
//               showMessageDialog(
//                   ctx,
//                   "Please select choose a device before attempting to save",
//                   LittleFishIcons.info);
//               return;
//             } else {
//               // this.item.printer.configure(item.device);
//               if (item.connectionType == ConnectionType.usb) {
//                 item.identifier = jsonEncode(
//                   {
//                     'vid': item.device.device.vid.toString(),
//                     'pid': item.device.device.pid.toString()
//                   },
//                 );
//               }

//               if (this
//                       .configuredPrinters
//                       .any((x) => x.identifier == item.identifier) &&
//                   isNew) {
//                 showMessageDialog(
//                     ctx,
//                     "This device was already added, please choose another one",
//                     LittleFishIcons.info);
//                 return;
//               } else {
//                 store.dispatch(
//                   savePrinter(
//                     context: ctx,
//                     printer: value,
//                     completer: snackBarCompleter(
//                         ctx, 'Printer saved successfully',
//                         shouldPop: true),
//                   ),
//                 );
//               }
//             }
//           } else {
//             showMessageDialog(
//               ctx,
//               "Only USB devices are supported at this time",
//               LittleFishIcons.info,
//             );
//           }
//         }
//       }
//     };
//   }
// }
