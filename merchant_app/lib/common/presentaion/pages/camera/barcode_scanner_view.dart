import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:littlefish_merchant/common/presentaion/pages/camera/camera_view.dart';

class BarcodeScannerView extends StatefulWidget {
  final void Function(String? value) onItemScanned;
  final Widget? customWidget;

  const BarcodeScannerView({
    Key? key,
    required this.onItemScanned,
    this.customWidget,
  }) : super(key: key);

  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  final barcodeScanner = BarcodeScanner();
  var canProcess = true;
  bool isBusy = false;
  bool hasBarcode = false;

  @override
  void dispose() async {
    canProcess = false;
    super.dispose();
    await barcodeScanner.close();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('### BarcodeScannerView build -> CamerView()');
    return CameraView(
      title: 'Scanner',
      customWidget: widget.customWidget,
      onInputImageAvailable: (inputImage) async {
        await _extractBarcodeFromImage(inputImage);
      },
    );
  }

  Future<void> _extractBarcodeFromImage(InputImage inputImage) async {
    if (!canProcess || isBusy) return;
    isBusy = true;
    if (hasBarcode) {
      await Future.delayed(const Duration(milliseconds: 900), () {
        if (context.mounted) {
          debugPrint(
            '### Camera BarcodeScannerView _extractBarcodeFromImage reset',
          );
          hasBarcode = false;
          isBusy = false;
        }
      });
    } else {
      try {
        final barcodes = await barcodeScanner.processImage(inputImage);
        if (barcodes.isNotEmpty) {
          var firstBarcodeScanned = barcodes.first;
          debugPrint(
            '### Camera BarcodeScannerView _extractBarcodeFromImage '
            'found barcode: ${firstBarcodeScanned.displayValue}',
          );
          widget.onItemScanned(firstBarcodeScanned.displayValue);
          hasBarcode = true;
        }
      } catch (e) {
        debugPrint(
          '### Camera BarcodeScannerView _extractBarcodeFromImage error: $e',
        );
        return;
      }
    }
    isBusy = false;
  }
}
