// Dart imports:
import 'dart:ui' as ui;
import 'dart:ui';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/pages/camera/coordinates_translator.dart';

class BarcodeDetectorPainter extends CustomPainter {
  BarcodeDetectorPainter(this.barcodes, this.absoluteImageSize, this.rotation);

  final List<Barcode> barcodes;
  final Size absoluteImageSize;
  final InputImageRotation rotation;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0
      ..color = Colors.lightGreenAccent;

    final Paint background = Paint()..color = const Color(0x99000000);

    for (final Barcode barcode in barcodes) {
      final ParagraphBuilder builder = ParagraphBuilder(
        ParagraphStyle(
          textAlign: TextAlign.left,
          fontSize: 16,
          textDirection: TextDirection.ltr,
        ),
      );
      builder.pushStyle(
        ui.TextStyle(color: Colors.lightGreenAccent, background: background),
      );
      builder.addText('${barcode.displayValue}');
      builder.pop();

      final left = translateX(10, rotation, size, absoluteImageSize);
      // barcode.value.boundingBox.left, rotation, size, absoluteImageSize);
      final top = translateY(10, rotation, size, absoluteImageSize);
      // barcode.value.boundingBox.top, rotation, size, absoluteImageSize);
      final right = translateX(10, rotation, size, absoluteImageSize);
      // barcode.value.boundingBox.right, rotation, size, absoluteImageSize);
      final bottom = translateY(10, rotation, size, absoluteImageSize);
      // barcode.value.boundingBox.bottom, rotation, size, absoluteImageSize);

      canvas.drawParagraph(
        builder.build()..layout(ParagraphConstraints(width: right - left)),
        Offset(left, top),
      );

      canvas.drawRect(Rect.fromLTRB(left, top, right, bottom), paint);
    }
  }

  @override
  bool shouldRepaint(BarcodeDetectorPainter oldDelegate) {
    return oldDelegate.absoluteImageSize != absoluteImageSize ||
        oldDelegate.barcodes != barcodes;
  }
}
