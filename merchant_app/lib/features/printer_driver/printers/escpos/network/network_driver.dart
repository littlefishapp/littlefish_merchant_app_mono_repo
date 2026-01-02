// TODO(lampian): implement missing methods
// import 'package:flutter_esc_pos_network/flutter_esc_pos_network.dart';
// import 'package:flutter_esc_pos_utils/flutter_esc_pos_utils.dart' as utils;
// import 'package:image/image.dart' as img;

// import '../shared/enums.dart';

// /// Network printer
// class NetworkDriver {
//   PosCodeTable profile;
//   Ticket ticket;
//   final printerManager = PrinterNetworkManager();
//   NetworkDriver({
//     required this.profile,
//     required this.ticket, // TODO (lampian): check required
//   });

//   // PosCodeTable _codeTable;

//   /// Creates a new socket connection to the network NetworkDriver.
//   ///
//   /// The argument [timeout] is used to specify the maximum allowed time to wait
//   /// for a connection to be established.
//   NetworkDriver connect(
//     String host, {
//     int port = 9100,
//     Duration? timeout,
//   }) {
//     // TODO(lampian): fix
//     //printerManager.selectPrinter(host, port: port);
//     return this;
//   }

//   /// Print a row.
//   ///
//   /// A row contains up to 12 columns. A column has a width between 1 and 12.
//   /// Total width of columns in one row must be equal 12.
//   void printRow(List<utils.PosColumn> cols) {
//     ticket.row(cols);
//   }

//   /// Beeps [n] times
//   ///
//   /// Beep [duration] could be between 50 and 450 ms.
//   void beep({int n = 3, utils.PosBeepDuration duration = utils.PosBeepDuration.beep450ms}) {
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

//   void writeLn() {
//     ticket.emptyLines(1);
//   }

//   /// Reverse feed for [n] lines (if supported by the priner)
//   void reverseFeed(int n) {
//     ticket.reverseFeed(n);
//   }

//   void cut({utils.PosCutMode mode = utils.PosCutMode.full}) {
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

//   /// Print barcode
//   ///
//   /// [width] range and units are different depending on the NetworkDriver model.
//   /// [height] range: 1 - 255. The units depend on the NetworkDriver model.
//   /// Width, height, font, text position settings are effective until performing of ESC @, reset or power-off.
//   void printBarcode(
//     utils.Barcode barcode, {
//     int? width,
//     int? height,
//     utils.BarcodeFont? font,
//     utils.BarcodeText textPos = utils.BarcodeText.below,
//   }) {
//     ticket.barcode(
//       barcode,
//       width: width,
//       height: height,
//       font: font,
//       textPos: textPos,
//     );
//   }

//   void println(
//     String text, {
//     utils.PosStyles styles = const utils.PosStyles(),
//     int linesAfter = 0,
//     bool cancelKanji = true,
//   }) {
//     ticket.text(
//       text,
//       styles: styles,
//     );
//   }

//   void openDrawer() {
//     ticket.drawer();
//   }
// }
