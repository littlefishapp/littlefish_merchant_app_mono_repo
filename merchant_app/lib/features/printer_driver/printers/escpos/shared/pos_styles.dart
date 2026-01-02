import 'printer_enums.dart';

/// Text styles
class PosStyles {
  const PosStyles({
    this.bold = false,
    this.reverse = false,
    this.underline = false,
    this.turn90 = false,
    this.align = PosTextAlign.left,
    this.height = PosTextSize.size1,
    this.width = PosTextSize.size1,
    this.fontType = PosFontType.fontA,
    this.codeTable = PosCodeTable.greek,
  });

  final bool bold;
  final bool reverse;
  final bool underline;
  final bool turn90;
  final PosTextAlign align;
  final PosTextSize height;
  final PosTextSize width;
  final PosFontType fontType;
  final PosCodeTable codeTable;
}
