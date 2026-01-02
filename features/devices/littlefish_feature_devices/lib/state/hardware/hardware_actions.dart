import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/localstorage/local_database.dart';
import 'package:littlefish_merchant/ui/settings/pages/hardware/printers/pages/printer_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/app/custom_route.dart';

LittleFishCore core = LittleFishCore.instance;

LoggerService get logger => LittleFishCore.instance.get<LoggerService>();

ThunkAction<AppState> initializeDrivers({bool refresh = false}) {
  return (Store<AppState> store) async {
    Future(() async {
      // var state = store.state.hardwareState;

      // if (!refresh && await state.hasPrinters) return;

      store.dispatch(SetHardwareStateLoadingAction(true));

      //here we need to get all the existing printers that are available
      //these are loaded from local storage
      LocalDatabase localdb = LocalDatabase();

      //here we load the basic key which would be printers...
      await localdb
          .getData('configured_printers')
          .then((result) {
            if (result != null) {
              // var printers =
              // (result as List)?.map((p) => dynamic.fromJson(p))?.toList();

              // store.dispatch(SetPrintersLoadedAction(printers));

              store.dispatch(SetHardwareStateLoadingAction(false));
            } else {
              store.dispatch(SetHardwareStateLoadingAction(false));
            }
          })
          .catchError((error) {
            store.dispatch(SetHardwareStateLoadingAction(false));
            store.dispatch(SetHardwareErrorStateAction(error.toString()));

            log(
              'unable to load cached hardware devices',
              error: error,
              stackTrace: StackTrace.current,
            );

            logger.debug(
              'hardware-actions',
              '### hardwareActions initializeDrivers error[$error]',
            );
          });

      //let us look for the handheld scanner :)
      await localdb
          .getData('configured_scanner')
          .then((result) {
            if (result != null) {
              // var scanner = HardwareScanner.fromJson(result);

              // store.dispatch(SetBarcodeScannerAction(scanner));
            }
            store.dispatch(SetHardwareStateLoadingAction(false));
          })
          .catchError((error) {
            store.dispatch(SetHardwareStateLoadingAction(false));
            store.dispatch(SetHardwareErrorStateAction(error.toString()));

            log(
              'unable to load cached barcode scanner',
              error: error,
              stackTrace: StackTrace.current,
            );

            logger.debug(
              'hardware-actions',
              '### hardwareActions initializeDrivers error[$error]',
            );
          });

      //here we will push the changes to ensure that the hardware provider is always in sync with state adjustments
      // await HardwareProvider.fromStore(store).initialize();
    });
  };
}

ThunkAction<AppState> saveEditPrinter({
  required BuildContext context,
  required dynamic printer,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      if (printer == null) return;

      store.dispatch(SetHardwareStateLoadingAction(true));

      //here we need to do what????
      store.dispatch(SetPrinterChangedAction(ChangeType.added, printer));

      //save this down to sembas storage
      //here we need to get all the existing printers that are available
      //these are loaded from local storage
      LocalDatabase localdb = LocalDatabase();

      String encodedDrivers;

      try {
        List<Map<String, dynamic>?>? mappedPrinters;

        await localdb.getData('configured_printers').then((result) {
          if (result == null || result == '') {
            mappedPrinters = [printer.toJson()];
          } else {
            // var currentPrinters = (result as List)
            //     ?.map((p) => dynamic.fromJson(p))
            //     ?.toList();

            // currentPrinters.add(printer);

            // mappedPrinters = currentPrinters.map((f) => f.toJson()).toList();
          }
        });

        encodedDrivers = jsonEncode(mappedPrinters);
      } catch (e) {
        log(
          'an error occurred converting printer listing',
          error: e,
          stackTrace: StackTrace.current,
        );
        rethrow;
      }

      //here we load the basic key which would be printers...
      await localdb
          .storeData<String>('configured_printers', encodedDrivers)
          .catchError((error) {
            store.dispatch(SetHardwareStateLoadingAction(false));
            store.dispatch(SetHardwareErrorStateAction(error.toString()));

            log(
              'unable to load cached hardware devices',
              error: error,
              stackTrace: StackTrace.current,
            );

            logger.debug(
              'hardware-actions',
              '### hardwareActions saveEditPrint error[$error]',
            );

            completer?.completeError(error);
          })
          .whenComplete(() {
            store.dispatch(SetHardwareStateLoadingAction(false));

            if (!completer!.isCompleted) completer.complete();

            //here we will push the changes to ensure that the hardware provider is always in sync with state adjustments
            // HardwareProvider.fromStore(store).initialize();
          });
    });
  };
}

ThunkAction<AppState> savePrinter({
  required BuildContext context,
  required dynamic printer,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      if (printer == null) return;

      store.dispatch(SetHardwareStateLoadingAction(true));

      //here we need to do what????
      store.dispatch(SetPrinterChangedAction(ChangeType.added, printer));

      //save this down to sembas storage
      //here we need to get all the existing printers that are available
      //these are loaded from local storage
      LocalDatabase localdb = LocalDatabase();

      String encodedDrivers;

      try {
        List<Map<String, dynamic>?>? mappedPrinters;

        await localdb.getData('configured_printers').then((result) {
          if (result == null || result == '') {
            mappedPrinters = [printer.toJson()];
          } else {
            // var currentPrinters = (result as List)
            //     ?.map((p) => dynamic.fromJson(p))
            //     ?.toList();

            // var index = currentPrinters
            //     .indexWhere((print) => print.identifier == printer.identifier);
            // if (index == -1)
            //   currentPrinters.add(printer);
            // else
            //   currentPrinters[index] = printer;

            // mappedPrinters = currentPrinters.map((f) => f.toJson()).toList();
          }
        });

        encodedDrivers = jsonEncode(mappedPrinters);
      } catch (e) {
        log(
          'an error occurred converting printer listing',
          error: e,
          stackTrace: StackTrace.current,
        );
        rethrow;
      }

      //here we load the basic key which would be printers...
      await localdb
          .storeData<String>('configured_printers', encodedDrivers)
          .catchError((error) {
            store.dispatch(SetHardwareStateLoadingAction(false));
            store.dispatch(SetHardwareErrorStateAction(error.toString()));

            log(
              'unable to load cached hardware devices',
              error: error,
              stackTrace: StackTrace.current,
            );

            logger.debug(
              'hardware-actions',
              '### hardwareActions savePrinter error[$error]',
            );

            completer?.completeError(error);
          })
          .whenComplete(() {
            store.dispatch(SetHardwareStateLoadingAction(false));

            if (!completer!.isCompleted) completer.complete();

            //here we will push the changes to ensure that the hardware provider is always in sync with state adjustments
            // HardwareProvider.fromStore(store).initialize();
          });
    });
  };
}

ThunkAction<AppState> removePrinter({
  required BuildContext context,
  required dynamic printer,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      if (printer == null) return;

      store.dispatch(SetHardwareStateLoadingAction(true));

      //here we need to do what????
      store.dispatch(SetPrinterChangedAction(ChangeType.removed, printer));

      //save this down to sembas storage
      //here we need to get all the existing printers that are available
      //these are loaded from local storage
      LocalDatabase localdb = LocalDatabase();

      String? encodedDrivers;

      try {
        // var mappedPrinters = store.state.hardwareState.configuredPrinters
        //     .map((p) => p.toJson())
        //     .toList();

        // encodedDrivers = jsonEncode(mappedPrinters);
      } catch (e) {
        log(
          'an error occurred converting printer listing',
          error: e,
          stackTrace: StackTrace.current,
        );
        rethrow;
      }

      //here we load the basic key which would be printers...
      await localdb
          .storeData<String?>('configured_printers', encodedDrivers)
          .catchError((error) {
            store.dispatch(SetHardwareStateLoadingAction(false));
            store.dispatch(SetHardwareErrorStateAction(error.toString()));

            log(
              'unable to load cached hardware devices',
              error: error,
              stackTrace: StackTrace.current,
            );

            logger.debug(
              'hardware-actions',
              '### hardwareActions removePrinter error[$error]',
            );

            completer?.completeError(error);
          })
          .whenComplete(() {
            store.dispatch(SetHardwareStateLoadingAction(false));

            if (!completer!.isCompleted) completer.complete();
          });

      //here we will push the changes to ensure that the hardware provider is always in sync with state adjustments
      // HardwareProvider.fromStore(store).initialize();
    });
  };
}

ThunkAction<AppState> saveScanner({
  required BuildContext context,
  required dynamic scanner,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      if (scanner == null) return;

      store.dispatch(SetHardwareStateLoadingAction(true));

      //here we need to do what????
      store.dispatch(SetBarcodeScannerAction(scanner));

      //save this down to sembas storage
      //here we need to get all the existing printers that are available
      //these are loaded from local storage
      LocalDatabase localdb = LocalDatabase();

      String encodedDrivers;

      try {
        encodedDrivers = jsonEncode(scanner.toJson());
      } catch (e) {
        log(
          'an error occurred converting printer listing',
          error: e,
          stackTrace: StackTrace.current,
        );
        rethrow;
      }

      //here we load the basic key which would be printers...
      await localdb
          .storeData<String>('configured_scanner', encodedDrivers)
          .catchError((error) {
            store.dispatch(SetHardwareStateLoadingAction(false));
            store.dispatch(SetHardwareErrorStateAction(error.toString()));

            log(
              'unable to load cached hardware scanner devices',
              error: error,
              stackTrace: StackTrace.current,
            );

            logger.debug(
              'hardware-actions',
              '### hardwareActions saveScanner error[$error]',
            );

            completer?.completeError(error);
          })
          .whenComplete(() {
            store.dispatch(SetHardwareStateLoadingAction(false));

            if (!completer!.isCompleted) completer.complete();
          });

      //here we will push the changes to ensure that the hardware provider is always in sync with state adjustments
      // HardwareProvider.fromStore(store).initialize();
    });
  };
}

ThunkAction<AppState> removeScanner({
  required BuildContext context,
  required dynamic scanner,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      if (scanner == null) return;

      store.dispatch(SetHardwareStateLoadingAction(true));

      //here we need to do what????
      // store.dispatch(SetBarcodeScannerAction(HardwareScanner.create()));

      //save this down to sembas storage
      //here we need to get all the existing printers that are available
      //these are loaded from local storage
      LocalDatabase localdb = LocalDatabase();

      String? encodedDrivers;

      try {
        // encodedDrivers =
        // jsonEncode(store.state.hardwareState.barcodeScanner.toJson());
      } catch (e) {
        log(
          'an error occurred converting scanner',
          error: e,
          stackTrace: StackTrace.current,
        );
        rethrow;
      }

      //here we load the basic key which would be printers...
      await localdb
          .storeData<String?>('configured_scanner', encodedDrivers)
          .catchError((error) {
            store.dispatch(SetHardwareStateLoadingAction(false));
            store.dispatch(SetHardwareErrorStateAction(error.toString()));

            log(
              'unable to load cached hardware devices',
              error: error,
              stackTrace: StackTrace.current,
            );

            logger.debug(
              'hardware-actions',
              '### hardwareActions removeScanner error[$error]',
            );

            completer?.completeError(error);
          })
          .whenComplete(() {
            store.dispatch(SetHardwareStateLoadingAction(false));

            if (!completer!.isCompleted) completer.complete();
          });

      //here we will push the changes to ensure that the hardware provider is always in sync with state adjustments
      // HardwareProvider.fromStore(store).initialize();
    });
  };
}

ThunkAction<AppState> createPrinter({required BuildContext context, vm}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(CreatePrinterAction());

      if (store.state.isLargeDisplay ?? false) {
        //popup dialog
        showPopupDialog(
          context: context,
          content: const HardwarePrinterPage(isEmbedded: true),
        );
      } else {
        Navigator.of(context).push(
          CustomRoute(
            builder: (ctx) => HardwarePrinterPage(parentContext: context),
          ),
        );
      }
    });
  };
}

ThunkAction<AppState> editPrinter({
  required BuildContext context,
  required dynamic printer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SelectPrinterAction(printer));

      if (store.state.isLargeDisplay ?? false) {
        //popup dialog
        showPopupDialog(
          context: context,
          content: HardwarePrinterPage(isEmbedded: true, defaultItem: printer),
        );
      } else {
        Navigator.of(context).push(
          CustomRoute(
            builder: (ctx) => HardwarePrinterPage(defaultItem: printer),
          ),
        );
      }
    });
  };
}

class SetHardwareStateLoadingAction {
  bool value;

  SetHardwareStateLoadingAction(this.value);
}

class SetHardwareErrorStateAction {
  String value;

  SetHardwareErrorStateAction(this.value);
}

class SetPrinterModelsLoadedAction {
  List<dynamic> value;

  SetPrinterModelsLoadedAction(this.value);
}

class SetPrintersLoadedAction {
  List<dynamic> value;

  SetPrintersLoadedAction(this.value);
}

class SetPrinterChangedAction {
  dynamic value;

  ChangeType type;

  SetPrinterChangedAction(this.type, this.value);
}

class SetDefaultPrinterAction {
  dynamic value;

  SetDefaultPrinterAction(this.value);
}

//Scanner
class SetBarcodeScannerAction {
  dynamic value;

  SetBarcodeScannerAction(this.value);
}

//UI Actions
class SelectPrinterAction {
  dynamic value;

  SelectPrinterAction(this.value);
}

//sets the UI State to clear
class CreatePrinterAction {}

class SelectPrinterModel {
  dynamic value;

  SelectPrinterModel(this.value);
}
