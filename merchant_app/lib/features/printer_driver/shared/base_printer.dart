// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:usb_serial/usb_serial.dart';

import '../../usb_serial_024/usb_serial.dart';

enum InterfaceType { escPos, starMPop }

enum ConnectionType { usb, bluetooth, network }

enum PrinterSize { fiftyMM, eightyMM }

abstract class BasePrinter {
  bool usbSupported = false;
  bool bluetoothSupported = false;
  bool networkSupported = false;
  InterfaceType model = InterfaceType.escPos;
  BasePrinterSettings settings = BasePrinterSettings();
  PrinterDevice device = PrinterDevice();
  bool get isConnected => false;

  List<ConnectionType> get availableConnectionTypes {
    List<ConnectionType> value = [];

    // if (networkSupported) value.add(ConnectionType.network);
    // if (bluetoothSupported) value.add(ConnectionType.bluetooth);
    value.add(ConnectionType.network);
    value.add(ConnectionType.bluetooth);
    if (usbSupported) value.add(ConnectionType.usb);

    return value;
  }

  bool get isConfigured => true;
  // device.connectionType != null;

  bool get isSupported {
    if (!isConfigured) return false;

    if (device.connectionType == ConnectionType.bluetooth &&
        !bluetoothSupported) {
      return false;
    }

    if (device.connectionType == ConnectionType.usb && !usbSupported) {
      return false;
    }

    if (device.connectionType == ConnectionType.network && !networkSupported) {
      return false;
    }

    return true;
  }

  Future<bool> configure(
    PrinterDevice device, {
    required BasePrinterSettings settings,
  }) async {
    this.device = device;
    this.settings = settings;

    return isSupported;
  }

  Future<bool> connect();

  Future<bool> printReceipt(dynamic recieptData);

  Future<bool> openDrawer();
  Future<bool> cutPaper();
  Future<bool> beep();
}

class BasePrinterSettings {
  final PrinterSize printerSize;
  final bool openDrawer;
  final bool autoPrint;
  final bool cutPaper;
  final bool beepOnPrint;

  BasePrinterSettings({
    this.beepOnPrint = false,
    this.autoPrint = false,
    this.openDrawer = false,
    this.printerSize = PrinterSize.eightyMM,
    this.cutPaper = false,
  });
}

//used to pass to configure printer from these properties paired with settings
class PrinterDevice {
  late ConnectionType connectionType;
  late String id;
  late String name;
  late String deviceAddress;
  dynamic device;

  PrinterDevice({
    this.device,
    this.id = '',
    this.name = '',
    this.connectionType = ConnectionType.bluetooth,
    this.deviceAddress = '',
  });

  //set properties in here
  PrinterDevice.fromUsb(UsbDevice this.device) {
    connectionType = ConnectionType.usb;
    name = device.productName;
    id = device.deviceId.toString();
    deviceAddress = device.deviceId.toString();
  }

  //set properties in here
  // TODO(lampian): fix PrinterBluetooth dep
  // PrinterDevice.fromBluetooth(PrinterBluetooth bluetooth) {
  //   this.device = bluetooth;
  //   connectionType = ConnectionType.bluetooth;
  //   this.name = bluetooth.name;
  //   this.id = '';
  //   this.deviceAddress = bluetooth.address;
  // }

  PrinterDevice.fromNetwork(String address, int port) {
    connectionType = ConnectionType.network;
    id = address;
    deviceAddress = '$address:$port';
  }
}
