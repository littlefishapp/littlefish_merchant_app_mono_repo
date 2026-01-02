// Flutter imports:

// Package imports:
import 'package:intl/intl.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/form_helpers/compact_format_type.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_helpers/money_formatter_settings.dart';

enum FastCalcType {
  addition,
  substraction,
  multiplication,
  division,
  percentageAddition,
  percentageSubstraction,
}

class Utilities {
  Utilities({required this.amount, this.settings}) {
    settings = settings ?? MoneyFormatterSettings();
  }

  double amount;

  MoneyFormatterSettings? settings;

  /// Returns formatted number
  String get baseFormat => NumberFormat.currency(
    symbol: '',
    decimalDigits: settings!.fractionDigits,
    locale: 'en_US',
  ).format(amount);

  /// Returns formatted number with refined separator chars
  String get refineSeparator => baseFormat
      .replaceAll(',', '(,)')
      .replaceAll('.', '(.)')
      .replaceAll('(,)', settings!.thousandSeparator!)
      .replaceAll('(.)', settings!.decimalSeparator!);

  /// Returns spacer as `spaceBetweenSymbolAndNumber` value
  String? get spacer => settings!.symbolAndNumberSeparator;

  /// Returns base compact format
  NumberFormat get baseCompact =>
      settings!.compactFormatType == CompactFormatType.short
      ? NumberFormat.compact()
      : NumberFormat.compactLong();
}
