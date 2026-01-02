// import 'dart:developer';

// import 'package:built_value/built_value.dart';
// import 'package:catcher/core/catcher.dart';

// import 'package:flutter/foundation.dart';
// import 'package:json_annotation/json_annotation.dart';
// import 'package:littlefish_merchant/hardware/hardware_scanner.dart';
// import 'package:littlefish_merchant/hardware/printer_model.dart';
// import 'package:littlefish_merchant/tools/localstorage/local_database.dart';

// part 'hardware_state.g.dart';

// @immutable
// @JsonSerializable()
// abstract class HardwareState
//     implements Built<HardwareState, HardwareStateBuilder> {
//   HardwareState._();

//   factory HardwareState() => _$HardwareState._(
//         hasError: false,
//         isLoading: false,
//         errorMessage: null,
//         models: [],
//         configuredPrinters: [],
//         // barcodeScanner: null,
//       );

//   @JsonKey(includeFromJson: false, includeToJson: false)
//   @nullable
//   bool get isLoading;

//   @nullable
//   bool get isNew;

//   @JsonKey(includeFromJson: false, includeToJson: false)
//   @nullable
//   bool get hasError;

//   @JsonKey(includeFromJson: false, includeToJson: false)
//   @nullable
//   String get errorMessage;

//   @nullable
//   List<dynamic> get models;

//   @nullable
//   List<dynamic> get configuredPrinters;

//   Future<dynamic> get defaultPrinter async {
//     if (!(await hasPrinters)) return null;

//     if (models.any((p) => p.isDefault))
//       return models.firstWhere((printer) => printer.isDefault);

//     return null;
//   }

//   Future<bool> get hasPrinters async {
//     LocalDatabase localdb = LocalDatabase();

//     var result =
//         await localdb.getData("configured_printers").catchError((error) {
//       log("unable to load printers",
//           error: error, stackTrace: StackTrace.current);

//       //note this is to log the error to the observables
//       Catcher2?.reportCheckedError(error, StackTrace.current);
//     });

//     return result == null ? false : true;
//     // models != null && models.isNotEmpty;
//   }

//   // @nullable
//   // HardwareScanner get barcodeScanner;
// }

// // abstract class HardwareUIStateState
// //     implements Built<HardwareUIStateState, HardwareUIStateStateBuilder> {
// //   factory HardwareUIStateState() {
// //     return _$HardwareUIStateState._(
// //         printerModel: dynamic.create(),
// //         );
// //   }

// //   dynamic get printerModel;

// //   HardwareUIStateState._();
// // }
