import '../../usb_serial_024/littlefish_printer_driver.dart';
import '../../usb_serial_024/usb_serial.dart';

class PrinterManager {
  Future<List<PrinterDevice>> getDevices(
    ConnectionType type, {
    required String host,
    required int port,
  }) async {
    switch (type) {
      case ConnectionType.usb:
        final devices = await UsbSerial.listDevices();
        return devices.map(((e) => PrinterDevice.fromUsb(e))).toList();

      case ConnectionType.bluetooth:
        // TODO(lampian): fix case
        return [];
      // var blueMan = PrinterBluetoothManager();
      // blueMan.startScan(Duration(seconds: 5));

      // blueMan.scanResults.listen((event) {
      //   if (event != null) {
      //     return event.map((e) => PrinterDevice.fromBluetooth(e)).toList();
      //   }
      // });
      // break;
      case ConnectionType.network:
        return [PrinterDevice.fromNetwork(host, port)];
      default:
        return [];
    }
  }

  List<InterfaceType> getInterfaceTypes() {
    return InterfaceType.values;
  }

  BasePrinter getPrinter({
    required ConnectionType connectionType,
    required InterfaceType model,
  }) {
    switch (model) {
      case InterfaceType.escPos:
        return EscPosPrinter();
      case InterfaceType.starMPop:
        return StarMpopPrinter();
      default:
        return EscPosPrinter();
    }
  }
}
