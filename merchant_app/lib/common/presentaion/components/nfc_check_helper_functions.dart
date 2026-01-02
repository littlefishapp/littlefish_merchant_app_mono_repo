import 'package:flutter/material.dart';

import 'dialogs/common_dialogs.dart';

class NfcCheckHelperFunctions {
  static void noNFCDialog(BuildContext context) async {
    return showMessageDialog(
      context,
      'This device does not have NFC capabilities.\n\nPlease try again using a device with NFC.',
      Icons.nfc,
    );
  }

  static Future<void> enableNFCDialog(BuildContext context) async {
    return showMessageDialog(
      context,
      'Please make sure NFC is enabled.',
      Icons.nfc,
    );
  }
}
