// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/hardware/hardware_actions.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/tools/managers/device_manager.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

// import 'package:littlefish_printer_driver/littlefish_printer_driver.dart';

class BarcodeScannerVM extends StoreItemViewModel<dynamic, dynamic> {
  BarcodeScannerVM.fromStore(Store<AppState> store) : super.fromStore(store);

  DeviceManager? deviceManager;

  dynamic selectedDevice;

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    // this.state = store.state.hardwareState;
    // this.item = HardwareScanner.fromJson(
    //   (state.barcodeScanner ?? HardwareScanner.create()).toJson(),
    // );

    isLoading = state.isLoading;
    hasError = state.hasError;
    errorMessage = state.errorMessage;

    onRemove = (value, ctx) {
      store.dispatch(
        removeScanner(
          context: ctx,
          scanner: value,
          completer: snackBarCompleter(ctx, 'Scanner removed successfully'),
        ),
      );
    };

    onAdd = (value, ctx) {
      if (key == null || key!.currentState == null) {
        showMessageDialog(
          context!,
          'We cannot save this scanner now, please try again later',
          LittleFishIcons.warning,
        );
      } else {
        if (key!.currentState!.validate()) {
          key!.currentState!.save();

          if (item.connectionType == null) {
            showMessageDialog(
              ctx!,
              'Please select the interface type',
              LittleFishIcons.info,
            );
            return;
          }

          // if (item.connectionType == ConnectionType.usb) {
          //   if (item.manufacturerName == null ||
          //       item.manufacturerName.isEmpty) {
          //     showMessageDialog(
          //       ctx,
          //       "Please select a device from the list",
          //       LittleFishIcons.info,
          //     );
          //     return;
          //   } else {
          //     store.dispatch(
          //       saveScanner(
          //         context: ctx,
          //         scanner: value,
          //         completer: snackBarCompleter(
          //             ctx, 'Scanner saved successfully',
          //             shouldPop: true),
          //       ),
          //     );
          //   }
          // } else {
          //   showMessageDialog(
          //     ctx,
          //     "Only USB devices are supported at this time",
          //     LittleFishIcons.info,
          //   );
          // }
        }
      }
    };
  }
}
