import '../../shared/base_printer.dart';

// TODO(lampian): implement missing methods
class EscPosPrinter extends BasePrinter {
  @override
  Future<bool> beep() {
    // TODO: implement beep
    throw UnimplementedError();
  }

  @override
  Future<bool> connect() {
    // TODO: implement connect
    throw UnimplementedError();
  }

  @override
  Future<bool> cutPaper() {
    // TODO: implement cutPaper
    throw UnimplementedError();
  }

  @override
  Future<bool> openDrawer() {
    // TODO: implement openDrawer
    throw UnimplementedError();
  }

  @override
  Future<bool> printReceipt(recieptData) {
    // TODO: implement printReceipt
    throw UnimplementedError();
  }
  // USBDriver _usbDriver;

  // dynamic _bluetoothDriver;

  // NetworkDriver _networkDriver;

  // @override
  // bool get isConnected =>
  //     _usbDriver != null || _bluetoothDriver != null || _networkDriver != null;

  // EscPosPrinter() {
  //   this.usbSupported = true;
  //   this.bluetoothSupported = false;
  //   this.networkSupported = false;
  // }

  // @override
  // Future<bool> configure(PrinterDevice device,
  //     {BasePrinterSettings settings}) async {
  //   bool result = await super.configure(device, settings: settings);

  //   return result;
  // }

  // @override
  // Future<bool> connect() async {
  //   if (!this.isConfigured) throw Exception('printer not configured');

  //   if (!this.isSupported)
  //     throw Exception('configuration for printer not supported');

  //   //do what you need to do here (change result if required)

  //   switch (device.connectionType) {
  //     case ConnectionType.bluetooth:
  //       throw Exception('not supported yet');
  //       break;
  //     case ConnectionType.usb:
  //       _usbDriver =
  //           await USBDriver.connect(device.device, eventCallback: (value) {
  //         log(value);
  //       });

  //       return true;
  //       break;
  //     case ConnectionType.network:
  //       _networkDriver = NetworkDriver(profile: PosCodeTable.westEur);

  //       _networkDriver.connect(
  //         device.device,
  //         timeout: Duration(
  //           seconds: 10,
  //         ),
  //       );

  //       _networkDriver.ticket = Ticket(PaperSize.mm80);
  //       return true;
  //       break;
  //     case ConnectionType.bluetooth:
  //       _bluetoothDriver = NetworkDriver(profile: PosCodeTable.westEur);

  //       _bluetoothDriver.connect(
  //         device.device,
  //         timeout: Duration(
  //           seconds: 10,
  //         ),
  //       );

  //       _bluetoothDriver.ticket = Ticket(PaperSize.mm80);

  //       return true;
  //       break;
  //     default:
  //       return false;
  //   }
  // }

  // @override
  // Future<bool> cutPaper() async {
  //   var driver = await _getDriver();

  //   try {
  //     await driver.cut();
  //   } catch (e) {
  //     return false;
  //   }

  //   return true;
  // }

  // @override
  // Future<bool> openDrawer() async {
  //   var driver = await _getDriver();

  //   try {
  //     await driver.openDrawer();
  //   } catch (e) {
  //     return false;
  //   }

  //   return true;
  // }

  // @override
  // Future<bool> beep() async {
  //   var driver = await _getDriver();

  //   try {
  //     await driver.beep();
  //   } catch (e) {
  //     return false;
  //   }

  //   return true;
  // }

  // @override
  // Future<bool> printReceipt(receiptData) async {
  //   if (receiptData == null)
  //     throw Exception('receipt data cannot be null, please verify input');

  //   var driver = await _getDriver();

  //   try {
  //     await _printReceipt(driver, receiptData);
  //   } catch (e) {
  //     return false;
  //   }
  //   return true;
  // }

  // _getDriver() async {
  //   if (this.isConfigured && this.isSupported && !this.isConnected) {
  //     await this.connect();
  //   }

  //   if (!isConnected)
  //     throw Exception(
  //         'printer not connected, please ensure that the printer is connected');

  //   return this.device.connectionType == ConnectionType.bluetooth
  //       ? _bluetoothDriver
  //       : device.connectionType == ConnectionType.usb
  //           ? _usbDriver
  //           : _networkDriver;
  // }

  // _printReceipt(dynamic driver, ReceiptData receiptData) async {
  //   if (receiptData == null || driver == null)
  //     throw Exception(
  //         'input parameters cannot be null, please verify that the method parameters are correct');

  //   try {
  //     driver.printRow([
  //       PosColumn(
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //           bold: true,
  //           underline: true,
  //           height: PosTextSize.size4,
  //         ),
  //         text: receiptData.businessName,
  //         width: 12,
  //       ),
  //     ]);

  //     if (receiptData.header != null && receiptData.header != "") {
  //       driver.writeLn();
  //       driver.printRow([
  //         PosColumn(
  //             styles: PosStyles(
  //               align: PosAlign.center,
  //               height: PosTextSize.size2,
  //               bold: true,
  //             ),
  //             text: receiptData.header,
  //             width: 12)
  //       ]);
  //     }

  //     if (receiptData.businessContactNumber != "") {
  //       driver.printRow([
  //         PosColumn(
  //           styles: PosStyles(
  //             align: PosAlign.center,
  //             height: PosTextSize.size1,
  //           ),
  //           text: "Tel  : ${receiptData.businessContactNumber}",
  //           width: 12,
  //         )
  //       ]);
  //     }

  //     driver.writeLn();

  //     driver.printRow([
  //       PosColumn(
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //           height: PosTextSize.size1,
  //           underline: false,
  //         ),
  //         text: receiptData.saleDescription,
  //         width: 12,
  //       )
  //     ]);

  //     driver.writeLn();

  //     if (receiptData?.transactionNumber != null) {
  //       driver.printRow([
  //         PosColumn(
  //           styles: PosStyles(
  //             align: PosAlign.left,
  //             height: PosTextSize.size1,
  //           ),
  //           text: "Sale No",
  //           width: 5,
  //         ),
  //         PosColumn(
  //           styles: PosStyles(
  //             align: PosAlign.center,
  //             height: PosTextSize.size1,
  //           ),
  //           text: ":",
  //           width: 2,
  //         ),
  //         PosColumn(
  //           styles: PosStyles(
  //             align: PosAlign.left,
  //             height: PosTextSize.size1,
  //           ),
  //           text: "${receiptData.transactionNumber.toString()}",
  //           width: 5,
  //         )
  //       ]);
  //     }

  //     driver.printRow([
  //       PosColumn(
  //           styles: PosStyles(
  //             align: PosAlign.left,
  //             height: PosTextSize.size1,
  //           ),
  //           text: "Served By",
  //           width: 5),
  //       PosColumn(
  //         styles: PosStyles(
  //           align: PosAlign.center,
  //           height: PosTextSize.size1,
  //         ),
  //         text: ":",
  //         width: 2,
  //       ),
  //       PosColumn(
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           height: PosTextSize.size1,
  //         ),
  //         text: "${receiptData.sellerName}",
  //         width: 5,
  //       )
  //     ]);

  //     if (receiptData.customerName != null &&
  //         receiptData.customerName.isNotEmpty)
  //       driver.printRow([
  //         PosColumn(
  //             styles: PosStyles(
  //               align: PosAlign.left,
  //               height: PosTextSize.size1,
  //             ),
  //             text: "Sold To:",
  //             width: 5),
  //         PosColumn(
  //           styles: PosStyles(
  //             align: PosAlign.center,
  //             height: PosTextSize.size1,
  //           ),
  //           text: ":",
  //           width: 2,
  //         ),
  //         PosColumn(
  //           styles: PosStyles(
  //             align: PosAlign.left,
  //             height: PosTextSize.size1,
  //           ),
  //           text: "${receiptData.customerName}",
  //           width: 5,
  //         )
  //       ]);
  //     driver.println("-------------------------------");
  //     driver.printRow([
  //       PosColumn(
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           height: PosTextSize.size1,
  //         ),
  //         text: "Qty  Description",
  //         width: 8,
  //       ),
  //       PosColumn(
  //         styles: PosStyles(
  //           align: PosAlign.right,
  //           height: PosTextSize.size1,
  //         ),
  //         text: "Total",
  //         width: 4,
  //       )
  //     ]);
  //     driver.println("-------------------------------");

  //     receiptData.items.forEach((item) {
  //       driver.printRow([
  //         PosColumn(
  //           styles: PosStyles(
  //             align: PosAlign.left,
  //             height: PosTextSize.size1,
  //           ),
  //           text: "${item.quantity} x ",
  //           width: 1,
  //         ),
  //         PosColumn(
  //           styles: PosStyles(
  //             align: PosAlign.left,
  //             height: PosTextSize.size1,
  //           ),
  //           text: item.productName,
  //           width: 7,
  //         ),
  //         PosColumn(
  //           styles: PosStyles(
  //             align: PosAlign.right,
  //             height: PosTextSize.size1,
  //           ),
  //           text: toStringCurrency(item.value * item.quantity ?? 1),
  //           width: 4,
  //         )
  //       ]);
  //     });

  //     driver.println("-------------------------------");

  //     driver.printRow([
  //       PosColumn(
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           height: PosTextSize.size1,
  //         ),
  //         text: "Total Discount",
  //         width: 4,
  //       ),
  //       PosColumn(
  //         styles: PosStyles(
  //           align: PosAlign.right,
  //           height: PosTextSize.size1,
  //         ),
  //         text: "- " + toStringCurrency(receiptData.totalDiscount),
  //         width: 8,
  //       )
  //     ]);

  //     driver.writeLn();

  //     driver.printRow([
  //       PosColumn(
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           height: PosTextSize.size1,
  //         ),
  //         text: "Tax Total ",
  //         width: 4,
  //       ),
  //       PosColumn(
  //         styles: PosStyles(
  //           align: PosAlign.right,
  //           height: PosTextSize.size1,
  //         ),
  //         text: toStringCurrency(receiptData.totalTax),
  //         width: 8,
  //       )
  //     ]);

  //     driver.writeLn();

  //     driver.printRow([
  //       PosColumn(
  //         styles: PosStyles(
  //           align: PosAlign.left,
  //           height: PosTextSize.size1,
  //         ),
  //         text: "Cart Total ",
  //         width: 4,
  //       ),
  //       PosColumn(
  //         styles: PosStyles(
  //           align: PosAlign.right,
  //           height: PosTextSize.size1,
  //         ),
  //         text: toStringCurrency(receiptData.cartTotal),
  //         width: 8,
  //       )
  //     ]);

  //     // var receiptData = businessProfile.receiptData;

  //     if (receiptData.footer != null && receiptData.footer.isNotEmpty) {
  //       driver.writeLn();
  //       driver.printRow([
  //         PosColumn(
  //           styles: PosStyles(
  //             align: PosAlign.center,
  //             height: PosTextSize.size2,
  //             bold: true,
  //           ),
  //           text: receiptData.footer,
  //           width: 12,
  //         )
  //       ]);
  //     }

  //     if (this.settings?.beepOnPrint == true) driver.beep(n: 1);

  //     if (this.settings?.cutPaper == true) driver.cut();

  //     if (this.settings?.openDrawer == true) driver.openDrawer();
  //   } catch (e) {
  //     throw Exception(e);
  //   }
  // }

  // toStringCurrency(double value) {
  //   // var formatter = NumberFormat('###,##0.00', 'en_US');
  //   return NumberFormat('###,##0.00', 'en_US').format(value);
  // }
}
