// import 'package:littlefish_merchant/models/enums.dart';
// import 'package:littlefish_merchant/redux/hardware/hardware_state.dart';
// import 'package:redux/redux.dart';
// import 'package:uuid/uuid.dart';

// import 'hardware_actions.dart';

// final hardwareReducer = combineReducers<HardwareState>([
//   TypedReducer<HardwareState, SetHardwareStateLoadingAction>(onSetStateLoading),
//   TypedReducer<HardwareState, SetHardwareErrorStateAction>(onSetStateError),
//   TypedReducer<HardwareState, SetPrintersLoadedAction>(onSetPrintersLoaded),
//   // TypedReducer<HardwareState, SetPrinterModelsLoadedAction>(
//   //     onSetSupportedPrinters),
//   TypedReducer<HardwareState, SetPrinterChangedAction>(onPrinterChanged),
//   TypedReducer<HardwareState, SetDefaultPrinterAction>(onSetDefaultPrinter),
//   TypedReducer<HardwareState, SetBarcodeScannerAction>(onSetBarcodeScanner),
// ]);

// HardwareState onSetStateLoading(
//         HardwareState state, SetHardwareStateLoadingAction action) =>
//     state.rebuild((b) => b.isLoading = action.value);

// HardwareState onSetStateError(
//         HardwareState state, SetHardwareErrorStateAction action) =>
//     state.rebuild((b) {
//       b.hasError = action.value != null && action.value.isNotEmpty;
//       b.errorMessage = action.value;
//     });

// HardwareState onSetPrintersLoaded(
//         HardwareState state, SetPrintersLoadedAction action) =>
//     state.rebuild((b) {
//       b.configuredPrinters = action.value ?? [];
//     });

// HardwareState onPrinterChanged(
//     HardwareState state, SetPrinterChangedAction action) {
//   return state.rebuild((b) {
//     if (action.type == ChangeType.removed) {
//       var existingIndex = b.configuredPrinters
//           .indexWhere((p) => p.identifier == action.value.identifier);

//       if (existingIndex >= 0)
//         b.configuredPrinters = b.configuredPrinters
//           ..removeWhere((p) => p.identifier == action.value.identifier);
//     } else {
//       // action.value.isNew = false;

//       if (action.value.identifier == null)
//         action.value.identifier = Uuid().v4();

//       if (b.configuredPrinters == null || b.configuredPrinters.isEmpty)
//         b.configuredPrinters = [action.value];
//       else {
//         var existingIndex = b.configuredPrinters
//             .indexWhere((p) => p.identifier == action.value.identifier);

//         if (existingIndex != null && existingIndex >= 0) {
//           b.configuredPrinters[existingIndex] = action.value;
//         } else
//           b.configuredPrinters = b.configuredPrinters..add(action.value);
//       }
//     }
//   });
// }

// HardwareState onSetDefaultPrinter(
//     HardwareState state, SetDefaultPrinterAction action) {
//   if (action.value == null) return state;

//   return state.rebuild((b) {
//     if (b.configuredPrinters == null || b.configuredPrinters.length == 0)
//       b.configuredPrinters = [action.value..isDefault = true];
//     else
//       b.configuredPrinters.forEach((printer) {
//         if (printer == action.value)
//           printer.isDefault = true;
//         else
//           printer.isDefault = false;
//       });
//   });
// }

// // HardwareState onSetSupportedPrinters(
// //         HardwareState state, SetPrinterModelsLoadedAction action) =>
// //     state.rebuild((b) => b.models = action.value ?? []);

// // final hardwareUIReducer = combineReducers<HardwareUIStateState>([
// //   // TypedReducer<HardwareUIStateState, SelectPrinterAction>(onSelectPrinter),
// //   TypedReducer<HardwareUIStateState, SelectPrinterModel>(onSelectPrinterModel),
// //   //TypedReducer<HardwareUIStateState, CreatePrinterAction>(onCreatePrinter),
// //   // TypedReducer<HardwareUIStateState, SetPrinterChangedAction>(onResetPrinter),
// // ]);

// // HardwareUIStateState onCreatePrinter(
// //         HardwareUIStateState state, CreatePrinterAction action) =>
// //     state.rebuild((b) => b.printer = dynamic.create());

// // HardwareUIStateState onSelectPrinter(
// //         HardwareUIStateState state, SelectPrinterAction action) =>
// //     state.rebuild((b) => b.printer = action.value);

// // HardwareUIStateState onResetPrinter(
// //         HardwareUIStateState state, SetPrinterChangedAction action) =>
// //     state.rebuild((b) => b.printer = dynamic.create());

// HardwareUIStateState onSelectPrinterModel(
//         HardwareUIStateState state, SelectPrinterModel action) =>
//     state.rebuild((b) => b.printerModel = action.value);

// HardwareState onSetBarcodeScanner(
//         HardwareState state, SetBarcodeScannerAction action) =>
//     state.rebuild((b) {
//       // b.barcodeScanner = action.value;
//     });
