import 'dart:async';
import 'package:flutter/material.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/features/multi_cart_item_infrared_barcode_scanner/data/multi_item_infrared_barcode_scanner.dart';
import 'package:littlefish_merchant/features/pos/presentation/pages/pos_scan_hw_page.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:littlefish_merchant/providers/permissions_provider.dart';
import 'package:littlefish_merchant/common/presentaion/pages/camera/barcode_scanner_view.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_informational.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:redux/redux.dart';

import '../../../../features/multi_cart_item_infrared_barcode_scanner/presentation/viewmodel/pos_multi_barcode_scanner_vm.dart';
import '../../../../redux/app/app_state.dart';
import '../scaffolds/app_scaffold.dart';

class BarcodePopupForm extends StatefulWidget {
  final bool laserScannerAvailable;
  const BarcodePopupForm({
    Key? key,
    this.store,
    required this.laserScannerAvailable,
  }) : super(key: key);
  final Store<AppState>? store;

  @override
  State<BarcodePopupForm> createState() => _BarcodePopupFormState();
}

class _BarcodePopupFormState extends State<BarcodePopupForm> {
  bool _showScanError = false;
  bool _reading = false;
  Timer? _errorTimer;
  String? _lastDetectedBarcode;
  int _consecutiveCount = 0;
  LittleFishCore get core => LittleFishCore.instance;
  static const int _confirmationThreshold = 3;

  @override
  void initState() {
    debugPrint('### BarcodePopupForm initState');
    super.initState();
    _checkCameraPermission();
  }

  @override
  void dispose() {
    debugPrint('### BarcodePopupForm dispose');
    _errorTimer?.cancel();
    super.dispose();
  }

  Future<void> _checkCameraPermission() async {
    debugPrint('### BarcodePopupForm _checkCameraPermission start');
    try {
      if (!await scanAllowed(context)) {
        debugPrint(
          '### BarcodePopupForm _checkCameraPermission camera permission not granted',
        );
        bool? granted = await requestScanPermission(context);
        debugPrint(
          '### BarcodePopupForm _checkCameraPermission request result: $granted',
        );
        if (granted != true && mounted) {
          setState(() {
            _showScanError = true;
            debugPrint(
              '### BarcodePopupForm _checkCameraPermission setState _showScanError=true',
            );
          });
          _errorTimer?.cancel();
          _errorTimer = Timer(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _showScanError = false;
                debugPrint(
                  '### BarcodePopupForm _checkCameraPermission timer setState _showScanError=false',
                );
              });
            }
          });
        }
      } else {
        debugPrint(
          '### BarcodePopupForm _checkCameraPermission camera permission already granted',
        );
      }
    } catch (e, stackTrace) {
      debugPrint('### BarcodePopupForm _checkCameraPermission error: $e');
      debugPrint(
        '### BarcodePopupForm _checkCameraPermission stackTrace: $stackTrace',
      );
      if (mounted) {
        setState(() {
          _showScanError = true;
          debugPrint(
            '### BarcodePopupForm _checkCameraPermission error setState _showScanError=true',
          );
        });
        _errorTimer?.cancel();
        _errorTimer = Timer(const Duration(seconds: 3), () {
          if (mounted) {
            setState(() {
              _showScanError = false;
              debugPrint(
                '### BarcodePopupForm _checkCameraPermission error timer setState _showScanError=false',
              );
            });
          }
        });
      }
    }
  }

  bool usePosBarcodeScanner() {
    debugPrint(
      '### BarcodePopupForm usePosBarcodeScanner: ${widget.laserScannerAvailable}',
    );
    return widget.laserScannerAvailable &&
        core.isRegistered<MultiCartItemInfraBarcodeScanner>();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint(
      '### BarcodePopupForm build, _showScanError=$_showScanError, _consecutiveCount=$_consecutiveCount',
    );
    return usePosBarcodeScanner()
        ? PosScanHWPage(context)
        : AppScaffold(
            title: 'Scan Barcode',
            body: SizedBox(
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 3,
              child: BarcodeScannerView(
                onItemScanned: (barcode) async {
                  debugPrint(
                    '### BarcodePopupForm onItemScanned received barcode=$barcode',
                  );
                  await _onItemScanned(barcode);
                },
                customWidget: _showScanError ? _errorTile(context) : null,
              ),
            ),
          );
  }

  Future<void> _onItemScanned(String? barcode) async {
    debugPrint(
      '### BarcodePopupForm _onItemScanned start, barcode=$barcode, _reading=$_reading, _consecutiveCount=$_consecutiveCount',
    );
    final effectiveBarcode = barcode ?? '';
    final now = DateTime.now();
    if (_reading) {
      debugPrint('### BarcodePopupForm _onItemScanned skipped: _reading=true');
      return;
    }

    _reading = true;
    try {
      if (effectiveBarcode.isEmpty) {
        debugPrint(
          '### BarcodePopupForm _onItemScanned no valid barcode detected',
        );
        _lastDetectedBarcode = null;
        _consecutiveCount = 0;
        if (mounted) {
          setState(() {
            _showScanError = true;
            debugPrint(
              '### BarcodePopupForm _onItemScanned setState _showScanError=true',
            );
          });
          _errorTimer?.cancel();
          _errorTimer = Timer(const Duration(seconds: 2), () {
            if (mounted) {
              setState(() {
                _showScanError = false;
                debugPrint(
                  '### BarcodePopupForm _onItemScanned timer setState _showScanError=false',
                );
              });
            }
          });
        }
      } else {
        // Confirmation logic for consistent barcodes
        if (_lastDetectedBarcode == effectiveBarcode) {
          _consecutiveCount++;
          debugPrint(
            '### BarcodePopupForm _onItemScanned same barcode, count=$_consecutiveCount',
          );
        } else {
          _lastDetectedBarcode = effectiveBarcode;
          _consecutiveCount = 1;
          debugPrint(
            '### BarcodePopupForm _onItemScanned new barcode: $effectiveBarcode, reset count to $_consecutiveCount',
          );
        }

        if (_consecutiveCount >= _confirmationThreshold) {
          debugPrint(
            '### BarcodePopupForm _onItemScanned confirmed barcode after $_consecutiveCount scans, popping: $effectiveBarcode',
          );
          if (mounted) {
            Navigator.of(context).pop(effectiveBarcode);
            debugPrint(
              '### BarcodePopupForm _onItemScanned Navigator.pop called with $effectiveBarcode',
            );
          } else {
            debugPrint(
              '### BarcodePopupForm _onItemScanned widget unmounted, skipping Navigator.pop',
            );
          }
        } else {
          debugPrint(
            '### BarcodePopupForm _onItemScanned waiting for $_confirmationThreshold consecutive scans, current count=$_consecutiveCount',
          );
        }
      }
    } catch (e, _) {
      debugPrint('### BarcodePopupForm _onItemScanned error: $e');
      _lastDetectedBarcode = null;
      _consecutiveCount = 0;
      if (mounted) {
        setState(() {
          _showScanError = true;
          debugPrint(
            '### BarcodePopupForm _onItemScanned error setState _showScanError=true',
          );
        });
        _errorTimer?.cancel();
        _errorTimer = Timer(const Duration(seconds: 2), () {
          if (mounted) {
            setState(() {
              _showScanError = false;
              debugPrint(
                '### BarcodePopupForm _onItemScanned error timer setState _showScanError=false',
              );
            });
          }
        });
      }
    } finally {
      _reading = false;
      debugPrint(
        '### BarcodePopupForm _onItemScanned completed, _reading=false',
      );
    }
  }

  Widget _errorTile(BuildContext context) {
    debugPrint('### BarcodePopupForm _errorTile build');
    return Container(
      color: Theme.of(
        context,
      ).extension<AppliedInformational>()?.neutralSurface,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: Center(
          child: context.labelLarge(
            'No barcode detected',
            color: Theme.of(
              context,
            ).extension<AppliedInformational>()?.neutralText,
          ),
        ),
      ),
    );
  }

  Container noAccessCamera(BuildContext context) {
    debugPrint('### BarcodePopupForm noAccessCamera build');
    return Container(
      alignment: Alignment.center,
      height: MediaQuery.of(context).size.height / 5,
      color: Theme.of(context).colorScheme.error,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          context.labelLarge(
            'Camera access denied',
            color: Theme.of(context).colorScheme.onError,
          ),
          TextButton(
            onPressed: () {
              debugPrint('### BarcodePopupForm noAccessCamera retry tapped');
              _checkCameraPermission();
            },
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<bool> scanAllowed(BuildContext context) async {
    debugPrint('### BarcodePopupForm scanAllowed start');
    try {
      var permissionStatus = await PermissionsProvider.instance.hasPermission(
        Permission.camera,
      );
      debugPrint('### BarcodePopupForm scanAllowed result: $permissionStatus');
      return permissionStatus;
    } catch (e, stackTrace) {
      debugPrint('### BarcodePopupForm scanAllowed error: $e');
      debugPrint('### BarcodePopupForm scanAllowed stackTrace: $stackTrace');
      return false;
    }
  }

  Future<bool?> requestScanPermission(BuildContext context) async {
    debugPrint('### BarcodePopupForm requestScanPermission start');
    try {
      if (await scanAllowed(context)) {
        debugPrint(
          '### BarcodePopupForm requestScanPermission already granted',
        );
        return true;
      }
      var result = await PermissionsProvider.instance.requestPermission(
        Permission.camera,
      );
      var st = await result?.status;
      debugPrint(
        '### BarcodePopupForm requestScanPermission result: ${st?.isGranted}',
      );
      return st?.isGranted;
    } catch (e, stackTrace) {
      debugPrint('### BarcodePopupForm requestScanPermission error: $e');
      debugPrint(
        '### BarcodePopupForm requestScanPermission stackTrace: $stackTrace',
      );
      return false;
    }
  }
}
