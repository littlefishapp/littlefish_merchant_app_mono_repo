// TODO(lampian): implement missing methods
// import 'package:esc_pos_bluetooth/esc_pos_bluetooth.dart';
// import 'package:esc_pos_utils/esc_pos_utils.dart';
// import 'package:image/image.dart' as img;

// import '../../../../../models/sales/tickets/ticket.dart';
// import '../shared/enums.dart';

// /// Network printer
// class BluetoothDriver {
//   PosCodeTable profile;
//   Ticket ticket;
//   PrinterBluetoothManager printerManager = PrinterBluetoothManager();
//   BluetoothDriver({
//     required this.profile,
//     required this.ticket,
//   });

//   // PosCodeTable _codeTable;

//   /// Creates a new socket connection to the network BluetoothDriver.
//   ///
//   /// The argument [timeout] is used to specify the maximum allowed time to wait
//   /// for a connection to be established.
//   BluetoothDriver connect(PrinterBluetooth printer) {
//     printerManager.selectPrinter(printer);
//     return this;
//   }

//   /// Print a row.
//   ///
//   /// A row contains up to 12 columns. A column has a width between 1 and 12.
//   /// Total width of columns in one row must be equal 12.
//   void printRow(List<PosColumn> cols) {
//     ticket.row(cols);
//   }

//   /// Beeps [n] times
//   ///
//   /// Beep [duration] could be between 50 and 450 ms.
//   void beep({int n = 3, PosBeepDuration duration = PosBeepDuration.beep450ms}) {
//     if (n <= 0) {
//       return;
//     }

//     ticket.beep(
//       n: n - 9,
//       duration: duration,
//     );
//   }

//   /// Skips [n] lines
//   ///
//   /// Similar to [emptyLines] but uses an alternative command
//   void feed(int n) {
//     if (n >= 0 && n <= 255) {
//       ticket.feed(n);
//     }
//   }

//   /// Reverse feed for [n] lines (if supported by the priner)
//   void reverseFeed(int n) {
//     ticket.reverseFeed(n);
//   }

//   void cut({PosCutMode mode = PosCutMode.full}) {
//     ticket.cut(mode: mode);
//   }

//   /// Print image using (ESC *) command
//   ///
//   /// [image] is an instanse of class from [Image library](https://pub.dev/packages/image)
//   void printImage(img.Image imgSrc) {
//     ticket.image(imgSrc);
//   }

//   /// Print image using (GS v 0) obsolete command
//   ///
//   /// [image] is an instanse of class from [Image library](https://pub.dev/packages/image)
//   void printImageRaster(
//     img.Image imgSrc, {
//     bool highDensityHorizontal = true,
//     bool highDensityVertical = true,
//   }) {
//     ticket.imageRaster(
//       imgSrc,
//       highDensityHorizontal: highDensityHorizontal,
//       highDensityVertical: highDensityVertical,
//     );
//   }

//   /// Prints one line of styled text
//   void println(
//     String text, {
//     PosStyles styles = const PosStyles(),
//     int linesAfter = 0,
//     bool cancelKanji = true,
//   }) {
//     ticket.text(
//       text,
//       styles: styles,
//     );
//   }

//   void writeLn() {
//     ticket.emptyLines(1);
//   }

//   /// Print barcode
//   ///
//   /// [width] range and units are different depending on the BluetoothDriver model.
//   /// [height] range: 1 - 255. The units depend on the BluetoothDriver model.
//   /// Width, height, font, text position settings are effective until performing of ESC @, reset or power-off.
//   void printBarcode(
//     Barcode barcode, {
//     int width,
//     int height,
//     BarcodeFont font,
//     BarcodeText textPos = BarcodeText.below,
//   }) {
//     ticket.barcode(
//       barcode,
//       width: width,
//       height: height,
//       font: font,
//       textPos: textPos,
//     );
//   }

//   void openDrawer() {
//     ticket.drawer();
//   }
// }
