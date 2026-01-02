// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';

// import 'package:usb_serial/usb_serial.dart';
// import 'package:bluetooth/bluetooth.dart';

class DeviceManager {
  DeviceManager();

  Store<AppState>? store;

  // DeviceManager() {
  //   flutterBlue = FlutterBlue.instance;
  // }

  DeviceManager.fromStore(Store<AppState> storeValue) {
    store = storeValue;
  }

  // FlutterBlue flutterBlue;

  List<dynamic> usbDevices = [];

  bool get hasDevices => usbDevices.isNotEmpty;

  //will return a list of available USB devices that are currently connected to
  //the device
  Future<List<dynamic>> getUSBDeviceList() async {
    // usbDevices = await UsbSerial.listDevices();
    usbDevices = [];

    return usbDevices;
  }

  //will get a list of available bonded bluetooth devices (i.e. paired with the phone beforehand)
  // Future<List<BluetoothDevice>> getBluetoothDeviceList() async {
  //   if (flutterBlue == null) flutterBlue = FlutterBlue.instance;

  //   if (!(await flutterBlue.isAvailable)) {
  //     log('bluetooth not supported on device');
  //     return null;
  //   }

  //   if (!(await flutterBlue.isOn)) {
  //     log('bluetooth not enabled on device');
  //     return null;
  //   }

  //   List<BluetoothDevice> result = [];

  //   var subscription = flutterBlue.scan().listen((scanResult) {
  //     if (scanResult != null && scanResult.device != null)
  //       result.add(scanResult.device);
  //   });

  //   //scans for 5 seconds until the subscription is cancelled.
  //   await Future.delayed(Duration(seconds: 5)).then((_) {
  //     subscription?.cancel();
  //   });

  //   return result;
  // }
}
