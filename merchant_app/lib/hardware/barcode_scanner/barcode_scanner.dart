import 'dart:convert';
import 'dart:developer';
import 'package:flutter/services.dart';

typedef ScanCallback = void Function(String scanString);
typedef EventCallback = void Function(String scanString);
typedef KeyCodeCallback = void Function(int keyCode);

class BarcodeScanner {
  String? name;
  bool? enabled;
  int? scanKeyCode;
  ScanCallback? onScan;
  KeyCodeCallback? onKeyPressed;
  EventCallback? eventCallback;

  BarcodeScanner({
    this.name,
    this.enabled,
    this.onKeyPressed,
    this.onScan,
    this.scanKeyCode,
    this.eventCallback,
  });

  BarcodeScanner._internal({
    bool this.enabled = false,
    required this.name,
    required this.onKeyPressed,
    required this.onScan,
    this.scanKeyCode,
    this.eventCallback,
  }) {
    if (enabled!) {
      // TODO(lampian): fix
      // removed ignore: deprecated_member_use
      RawKeyboard.instance.addListener(_onKeyEvent);
      isScanning = false;
      hasListener = true;

      _writeLog('scanner intialized succesfully');
    }
  }

  factory BarcodeScanner.initialize({
    bool enabled = true,
    String? name,
    ScanCallback? onScan,
    KeyCodeCallback? onKeyPressed,
    int? scanKeyCode,
    EventCallback? eventCallback,
  }) => BarcodeScanner._internal(
    enabled: enabled,
    name: name,
    onKeyPressed: onKeyPressed,
    onScan: onScan,
    scanKeyCode: scanKeyCode,
    eventCallback: eventCallback,
  );

  factory BarcodeScanner.fromUsbDevice({
    bool enabled = true,
    required dynamic device,
    // @required UsbDevice device,
    ScanCallback? onScan,
    KeyCodeCallback? onKeyPressed,
    int? scanKeyCode,
    EventCallback? eventCallback,
  }) => BarcodeScanner._internal(
    enabled: enabled,
    name: device.toString(),
    onKeyPressed: onKeyPressed,
    onScan: onScan,
    scanKeyCode: scanKeyCode,
    eventCallback: eventCallback,
  );

  dispose() {
    if (hasListener) {
      // TODO(lampian): fix
      // removed ignore: deprecated_member_use
      RawKeyboard.instance.removeListener(_onKeyEvent);
      hasListener = false;
    }
  }

  bool isScanning = false;

  bool hasListener = false;

  List<int> scannedUnits = <int>[];

  _writeLog(String message) {
    if (eventCallback != null) {
      eventCallback!(message);
    }
  }

  // TODO(lampian): fix
  // removed ignore: deprecated_member_use
  void _onKeyEvent(RawKeyEvent keyEvent) {
    try {
      _writeLog('1');
      // TODO(lampian): fix
      // removed ignore: deprecated_member_use
      var key = keyEvent.data as RawKeyEventDataAndroid;

      _writeLog('2');
      // if (keyEvent == null) {
      //   _writeLog("key event is null, dead key detected");
      //   return;
      // }

      _writeLog('3');
      _writeLog(
        "key event invoked: '${keyEvent.character ?? "no character"}',codePoint:${key.codePoint},scancode:${key.scanCode},keycode: ${key.keyCode}\n${key.toString()}",
      );

      _writeLog('4');
      if ((key.codePoint) == 0) {
        _writeLog('dead-key');
        return;
      }

      _writeLog('5');
      //we should ignore events / keys as this scanner is not active
      if (!enabled!) return;

      scanKeyCode ??= key.keyCode;

      _writeLog('6');
      //set the scanning state to await a stream of characters...
      if (!isScanning &&
          // TODO(lampian): fix
          // removed ignore: deprecated_member_use
          keyEvent is RawKeyDownEvent &&
          key.keyCode == scanKeyCode) {
        isScanning = true;

        _writeLog('7');
        _writeLog('barcode scanning flag set');
      }

      _writeLog('8');

      //do not pass unless in the scanning state
      if (!isScanning) return;

      _writeLog('9');
      //add a scanned character to the list
      // TODO(lampian): fix
      // removed ignore: deprecated_member_use
      if (keyEvent is RawKeyDownEvent &&
          (key.codePoint != 0 && key.codePoint != 10)) {
        scannedUnits.add(key.codePoint);
      }

      _writeLog('10');
      // TODO(lampian): fix
      // removed ignore: deprecated_member_use
      if (keyEvent is RawKeyUpEvent) {
        _writeLog('user has released the key');
      }

      _writeLog('11');
      // TODO(lampian): fix
      // removed ignore: deprecated_member_use
      if (keyEvent is RawKeyDownEvent) {
        _writeLog('user has pressed the key');
      }

      _writeLog('12');
      //new line action / key serves for EOD
      if (key.codePoint == 10) {
        _writeLog("detected EOD, with keycode: '${key.keyCode}'");

        if (scannedUnits.isNotEmpty) {
          var barcode = utf8.decode(scannedUnits);
          onScan!(barcode);
          scannedUnits.clear();
          isScanning = false;
          scanKeyCode = null;
        }
      }

      // _writeLog("13");
      // //scan button on device released, all scanned characters to be converted and sent or it is a new line
      // if (keyEvent is RawKeyUpEvent && key.keyCode == scanKeyCode) {
      //   _writeLog("detected EOD, by key release and keycode: '${key.keyCode}'");

      //   if (this.scannedUnits.isNotEmpty) {
      //     var barcode = utf8.decode(this.scannedUnits);
      //     this.onScan(barcode);
      //     this.scannedUnits.clear();
      //     this.isScanning = false;
      //     this.scanKeyCode = null;
      //   }
      // }

      // _writeLog("14");
    } catch (e) {
      _writeLog(
        'error handling key:${e.toString()}, stack:\n${StackTrace.current.toString()}',
      );
      log('unable to handle key event, from scanner', error: e);
    }
  }
}
