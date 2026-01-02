// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:json_annotation/json_annotation.dart';
// // import 'package:littlefish_printer_driver/littlefish_printer_driver.dart';
// // import 'package:usb_serial/usb_serial.dart';
// import 'package:uuid/uuid.dart';

// part 'hardware_scanner.g.dart';

// @JsonSerializable()
// class HardwareScanner extends HardwareDevice {
//   HardwareScanner({
//     this.isNew = false,
//   });

//   @override
//   Future<bool> connect({BuildContext context}) async {
//     return false;
//   }

//   String name;

//   @JsonKey(ignore: true, defaultValue: false)
//   bool isNew;

//   HardwareScanner.create() {
//     this.isNew = true;
//     this.id = Uuid().v4();

//     // this.connectionType = ConnectionType.usb;
//   }

//   // HardwareScanner.fromUsbDevice(UsbDevice device) {
//   //   this.id = Uuid().v4();
//   //   this.connectionType = ConnectionType.usb;
//   //   this.deviceId = device.deviceId;
//   //   this.deviceSerial = device.serial;
//   //   this.manufacturerName = device.manufacturerName;
//   //   this.productId = device.pid;
//   //   this.vendorId = device.vid;
//   // }

//   factory HardwareScanner.fromJson(Map<String, dynamic> json) =>
//       _$HardwareScannerFromJson(json);

//   Map<String, dynamic> toJson() => _$HardwareScannerToJson(this);
// }

// abstract class HardwareDevice {
//   HardwareDevice({
//     this.deviceId,
//     this.deviceSerial,
//     this.connectionType,
//     this.manufacturerName,
//     this.productId,
//     this.productName,
//     this.vendorId,
//     this.id,
//   });

//   String id;

//   String displayName;

//   // ConnectionType connectionType;

//   int vendorId;

//   int productId;

//   String productName;

//   String manufacturerName;

//   int deviceId;

//   //IF USB, same as deviceID
//   //IF bluetooth, then BT MAC ADDRESS
//   //IF wireless, then I.P
//   String deviceAddress;

//   String deviceSerial;

//   bool _isConnected = false;

//   bool get isConnected => _isConnected;

//   set isConnected(bool value) => _isConnected = value;

//   Future<bool> connect({@required BuildContext context});
// }

// enum PrinterSize {
//   fiftyMM,
//   eightyMM,
// }
