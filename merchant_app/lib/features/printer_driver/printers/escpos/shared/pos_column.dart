import 'pos_styles.dart';

/// Column contains text, styles and width (an integer in 1..12 range)
class PosColumn {
  String text;
  bool containsChinese;
  int width;
  PosStyles? styles; // TODO(lampian): check null

  PosColumn({
    this.text = '',
    this.containsChinese = false,
    this.width = 2,
    this.styles,
  }) {
    if (width < 1 || width > 12) {
      throw Exception('Column width must be between 1..12');
    }
  }
}
