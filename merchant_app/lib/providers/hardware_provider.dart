// import 'dart:async';
// import 'dart:convert';

// import 'package:littlefish_merchant/hardware/hardware_scanner.dart';
// import 'package:littlefish_merchant/hardware/printer_model.dart';
// import 'package:littlefish_merchant/redux/app/app_state.dart';
// import 'package:littlefish_merchant/redux/app_settings/app_settings_actions.dart';
// import 'package:littlefish_merchant/tools/localstorage/local_database.dart';
// import 'package:usb_serial/usb_serial.dart';
// import 'package:redux/redux.dart';

// class HardwareProvider {
//   static final HardwareProvider instance = HardwareProvider._internal();

//   LocalDatabase database;

//   HardwareProvider._internal();

//   factory HardwareProvider() => instance;

//   factory HardwareProvider.fromStore(Store<AppState> store) {
//     instance.store = store;
//     instance.database = LocalDatabase();
//     return instance;
//   }

//   dispose() {
//     this.onDeviceChanged?.cancel();
//     this.onDeviceChanged = null;
//   }

//   Store<AppState> store;

//   List<UsbDevice> devices = [];

//   dynamic printerSettings;

//   UsbDevice printerPort;

//   bool get hasPrinter {
//     if (printerSettings == null)
//       this.printerSettings =
//           store.state.hardwareState?.configuredPrinters?.first;

//     if (printerSettings == null ||
//         devices == null ||
//         devices.length == 0 ||
//         printerSettings.identifier == null ||
//         printerSettings.identifier == '') return false;

//     var mappedIdentifier = jsonDecode(printerSettings.identifier);

//     var thisDevice = this.devices.firstWhere(
//         (d) =>
//             d.pid.toString() == mappedIdentifier['pid'] &&
//             d.vid.toString() == mappedIdentifier['vid'],
//         orElse: () => null);

//     return thisDevice == null ? false : true;
//   }

//   HardwareScanner scannerSettings;

//   UsbDevice scanner;

//   bool get hasScanner {
//     if (scannerSettings == null || scannerSettings.isNew) return false;

//     if (scannerSettings == null || devices.length == 0) return false;
//     var thisDevice = this.devices.firstWhere(
//           (d) =>
//               d.pid == scannerSettings?.productId &&
//               d.vid == scannerSettings?.vendorId,
//           orElse: () => null,
//         );

//     if (thisDevice != null) {
//       if (thisDevice.deviceId != scannerSettings?.deviceId) {
//         scanner = thisDevice;
//       }

//       scanner = thisDevice;
//       return true;
//     }
//     return false;
//   }

//   StreamSubscription<UsbEvent> onDeviceChanged;

//   Future<void> initialize() async {
//     populate(refresh: true);

//     if (null == onDeviceChanged)
//       onDeviceChanged =
//           UsbSerial.usbEventStream.listen((event) => populate(refresh: true));

//     // TODO: should change
//     //this.printerSettings = store.state.hardwareState?.configuredPrinters?.first;

//     this.scannerSettings = store.state.hardwareState.barcodeScanner;
//   }

//   Future<List<UsbDevice>> populate({bool refresh = false}) async {
//     if (refresh) this.devices = [];

//     if (devices == null || devices.length == 0) {
//       this.devices = await UsbSerial.listDevices();
//       if (store != null)
//         store.dispatch(AppSettingsSetUsbDeviceList(this.devices));
//     }

//     return this.devices;
//   }
// }
