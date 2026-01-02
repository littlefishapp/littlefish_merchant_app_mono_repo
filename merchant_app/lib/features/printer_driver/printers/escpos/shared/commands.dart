import 'dart:convert';
import 'dart:typed_data';

const esc = '\x1B';
const gs = '\x1D';
const fs = '\x1C';

// Miscellaneous
const cInit = '$esc@'; // Initialize printer
Uint8List get cInitBytes {
  return utf8.encode(cInit);
}

const cBeep = '${esc}B'; // Beeper [count] [duration]
Uint8List get cBeepBytes {
  return utf8.encode(cBeep);
}

//Opens Cash Drawer
const cOpenDrawer = '${esc}p';
Uint8List get cOpenDrawerBytes {
  return utf8.encode(cOpenDrawer);
}

// // Print
const cFeedN = '${esc}d'; // Print and feed n lines [N]
Uint8List get cFeedNBytes {
  return utf8.encode(cFeedN);
}

const cReverseFeedN = '${esc}e'; // Print and reverse feed n lines [N]
Uint8List get cReverseFeedNBytes {
  return utf8.encode(cReverseFeedN);
}

// Mech. Control
const cCutFull = '${gs}V0'; // Full cut
Uint8List get cCutFullBytes {
  return utf8.encode(cCutFull);
}

const cCutPart = '${gs}V1'; // Partial cut
Uint8List get cCutPartBytes {
  return utf8.encode(cCutPart);
}

// Character
// Character
const cReverseOn = '${gs}B1'; // Turn white/black reverse print mode on
Uint8List get cReverseOnBytes {
  return utf8.encode(cReverseOn);
}

const cReverseOff = '${gs}B0'; // Turn white/black reverse print mode off
Uint8List get cReverseOffBytes {
  return utf8.encode(cReverseOff);
}

const cSizeGSn = '$gs!'; // Select character size [N]
Uint8List get cSizeGSnBytes {
  return utf8.encode(cSizeGSn);
}

const cSizeESCn = '$esc!'; // Select character size [N]
Uint8List get cSizeESCnBytes {
  return utf8.encode(cSizeESCn);
}

const cUnderlineOff = '$esc-0'; // Turns off underline mode
Uint8List get cUnderlineOffBytes {
  return utf8.encode(cUnderlineOff);
}

const cUnderline1dot = '$esc-1'; // Turns on underline mode (1-dot thick)
Uint8List get cUnderline1dotBytes {
  return utf8.encode(cUnderline1dot);
}

const cUnderline2dots = '$esc-2'; // Turns on underline mode (2-dots thick)
Uint8List get cUnderline2dotsBytes {
  return utf8.encode(cUnderline2dots);
}

const cBoldOn = '${esc}E1'; // Turn emphasized mode on
Uint8List get cBoldOnBytes {
  return utf8.encode(cBoldOn);
}

const cBoldOff = '${esc}E0'; // Turn emphasized mode off
Uint8List get cBoldOffBytes {
  return utf8.encode(cBoldOff);
}

const cFontA = '${esc}M0'; // Font A
Uint8List get cFontABytes {
  return utf8.encode(cFontA);
}

const cFontB = '${esc}M1'; // Font B
Uint8List get cFontBBytes {
  return utf8.encode(cFontB);
}

const cTurn90On = '${esc}V1'; // Turn 90° clockwise rotation mode on
Uint8List get cTurn90OnBytes {
  return utf8.encode(cTurn90On);
}

const cTurn90Off = '${esc}V0'; // Turn 90° clockwise rotation mode off
Uint8List get cTurn90OffBytes {
  return utf8.encode(cTurn90Off);
}

const cCodeTable = '${esc}t'; // Select character code table [N]
Uint8List get cCodeTableBytes {
  return utf8.encode(cCodeTable);
}

const cKanjiOn = '$fs&'; // Select Kanji character mode
Uint8List get cKanjiOnBytes {
  return utf8.encode(cKanjiOn);
}

const cKanjiOff = '$fs.'; // Cancel Kanji character mode
Uint8List get cKanjiOffBytes {
  return utf8.encode(cKanjiOff);
}

// Print Position
const cAlignLeft = '${esc}a0'; // Left justification
Uint8List get cAlignLeftBytes {
  return utf8.encode(cAlignLeft);
}

const cAlignCenter = '${esc}a1'; // Centered
Uint8List get cAlignCenterBytes {
  return utf8.encode(cAlignCenter);
}

const cAlignRight = '${esc}a2'; // Right justification
Uint8List get cAlignRightBytes {
  return utf8.encode(cAlignRight);
}

const cPos = '$esc\$'; // Set absolute print position [nL] [nH]
Uint8List get cPosBytes {
  return utf8.encode(cPos);
}

// Bit Image
const cRasterImg = '${gs}v0'; // Print raster bit image [obsolete command]
Uint8List get cRasterImgBytes {
  return utf8.encode(cRasterImg);
}

const cBitImg = '$esc*'; // Set bit image mode
Uint8List get cBitImgBytes {
  return utf8.encode(cBitImg);
}

// Barcode
const cBarcodeSelectPos =
    '${gs}H'; // Select print position of HRI characters [N]
Uint8List get cBarcodeSelectPosBytes {
  return utf8.encode(cBarcodeSelectPos);
}

const cBarcodeSelectFont = '${gs}f'; // Select font for HRI characters [N]
Uint8List get cBarcodeSelectFontBytes {
  return utf8.encode(cBarcodeSelectFont);
}

const cBarcodeSetH = '${gs}h'; // Set barcode height [N]
Uint8List get cBarcodeSetHBytes {
  return utf8.encode(cBarcodeSetH);
}

const cBarcodeSetW = '${gs}w'; // Set barcode width [N]
Uint8List get cBarcodeSetWBytes {
  return utf8.encode(cBarcodeSetW);
}

const cBarcodePrint = '${gs}k'; // Print barcode
Uint8List get cBarcodePrintBytes {
  return utf8.encode(cBarcodePrint);
}
