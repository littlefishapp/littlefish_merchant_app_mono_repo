// Package imports:
import 'package:intl/intl.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/app/app.dart';

// Project imports:
import 'package:littlefish_merchant/providers/locale_provider.dart';

class TextFormatter {
  static LoggerService get logger =>
      LittleFishCore.instance.get<LoggerService>();
  static String? formatCurrency(
    String? textValue, {
    bool displayCurrency = true,
  }) {
    var locale = LocaleProvider.instance.currentLocale;

    try {
      if (textValue == null || textValue.isEmpty) textValue = '0.00';
      var formatter = displayCurrency
          ? NumberFormat(
              '${locale!.shortCurrencyCode ?? locale.currencyCode}###,##0.00',
              'en_US',
            )
          : NumberFormat('###,##0.00', 'en_US');

      var formatValue = double.parse(textValue);
      var formattedText = formatter.format(formatValue / 100);
      return formattedText;
    } catch (e) {
      logger.error('tools.textformatter', 'Error formatting currency: $e');
    }

    return textValue;
  }

  static String toStringCurrency(
    double? value, {
    bool displayCurrency = true,
    String? currencyCode,
  }) {
    var locale = LocaleProvider.instance.currentLocale;
    try {
      if (value == null) {
        return '${locale!.shortCurrencyCode ?? locale.currencyCode} 0';
      }
      var formatter = displayCurrency
          ? NumberFormat(
              '${locale!.shortCurrencyCode ?? locale.currencyCode} ###,##0.00',
              'en_US',
            )
          : NumberFormat('###,##0.00', 'en_US');

      var formattedText = formatter.format(value);
      return formattedText;
    } catch (e) {
      logger.error(
        'tools.textformatter',
        'Error converting to string currency: $e',
      );
    }

    return '${locale!.shortCurrencyCode ?? locale.currencyCode} 0';
  }

  static String toOneDecimalPlace(double? value) {
    var locale = LocaleProvider.instance.currentLocale;
    try {
      if (value == null) {
        return '${locale!.shortCurrencyCode ?? locale.currencyCode} 0';
      }
      var formatter = NumberFormat('###,##0.0', 'en_US');

      var formattedText = formatter.format(value);
      return formattedText;
    } catch (e) {
      logger.error(
        'tools.textformatter',
        'Error converting to one decimal place: $e',
      );
    }

    return '${locale!.shortCurrencyCode ?? locale.currencyCode} 0';
  }

  static String toFlatNumber(double? value) {
    var locale = LocaleProvider.instance.currentLocale;
    try {
      if (value == null) {
        return '${locale!.shortCurrencyCode ?? locale.currencyCode} 0';
      }
      var formatter = NumberFormat('0', 'en_US');

      var formattedText = formatter.format(value);
      return formattedText;
    } catch (e) {
      logger.error(
        'tools.textformatter',
        'Error converting to one decimal place: $e',
      );
    }

    return '${locale!.shortCurrencyCode ?? locale.currencyCode} 0';
  }

  static String toTwoDecimalPlace(
    double? value, {
    bool displayCurrency = true,
  }) {
    var currency = '';
    var locale = LocaleProvider.instance.currentLocale;
    if (locale != null && locale.shortCurrencyCode != null) {
      currency = locale.shortCurrencyCode ?? '';
      currency += ' ';
    } else if (locale != null && locale.currencyCode != null) {
      currency = locale.currencyCode ?? '';
      currency += ' ';
    } else {
      currency = 'R ';
    }

    try {
      if (value == null) {
        return '${locale!.shortCurrencyCode ?? locale.currencyCode} 0';
      }
      var formatter = NumberFormat('###,##0.00', 'en_US');
      final formattedValue = formatter.format(value);

      var formattedText = displayCurrency
          ? '$currency$formattedValue'
          : formattedValue;
      return formattedText;
    } catch (e) {
      logger.error(
        'tools.textformatter',
        'Error converting to two decimal place: $e',
        error: e,
        stackTrace: StackTrace.current,
      );
    }

    return '${locale!.shortCurrencyCode ?? locale.currencyCode} 0';
  }

  static String toStringCurrencyNoDecimal(
    num? value, {
    bool displayCurrency = true,
  }) {
    var locale = LocaleProvider.instance.currentLocale;

    if (locale == null && value != null) return value.round().toString();
    if (locale != null && value == null) {
      return '${locale.shortCurrencyCode ?? locale.currencyCode} 0';
    }
    if (locale == null && value == null) return '0';

    var formatter = displayCurrency
        ? NumberFormat(
            '${locale!.shortCurrencyCode ?? locale.currencyCode} ###,##0',
            'en_US',
          )
        : NumberFormat('###,##0', 'en_US');

    return formatter.format(value);
  }

  static String toStringRemoveZeroDecimals(
    double value, {
    bool? displayCurrency,
  }) {
    String valueText;
    if (value == value.toInt()) {
      valueText = value.toInt().toString();
    } else {
      valueText = value
          .toStringAsFixed(value.truncateToDouble() == value ? 0 : 2)
          .replaceAll(RegExp(r'0+$'), '')
          .replaceAll(RegExp(r'\.$'), '');
    }

    var locale = LocaleProvider.instance.currentLocale;
    if (locale == null) return valueText;
    return displayCurrency == true
        ? '${locale.shortCurrencyCode ?? locale.currencyCode} $valueText'
        : valueText;
  }

  static String toShortDate({required DateTime? dateTime, String format = ''}) {
    var formatter = DateFormat(
      format.isEmpty ? AppVariables.appDateFormat : format,
    );
    return formatter.format((dateTime?.toLocal() ?? DateTime.now()).toLocal());
  }

  static String toFullDate({required DateTime? dateTime, String format = ''}) {
    var formatter = DateFormat(
      format.isEmpty ? AppVariables.appDateFormat : format,
    );
    return formatter.format((dateTime ?? DateTime.now()).toLocal());
  }

  static String toTimeFormat({
    required DateTime? dateTime,
    String format = 'HH:mm:ss',
  }) {
    DateFormat formatter = DateFormat(format);
    return formatter.format((dateTime ?? DateTime.now()).toLocal());
  }

  static String toCapitalize({required String value}) {
    if (value.isEmpty) return value;
    if (value.length == 1) return value.toUpperCase();
    return value[0].toUpperCase() + value.substring(1);
  }

  static String toCapitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text
        .split(' ')
        .map((word) {
          if (word.isEmpty) return word;
          return word[0].toUpperCase() + word.substring(1).toLowerCase();
        })
        .join(' ');
  }

  static String formatStringFromFontCasing(String text) {
    String textUsed;
    switch (AppVariables.appDefaultFontCasing) {
      case AppFontCasing.upperCase:
        textUsed = text.toUpperCase();
        break;
      case AppFontCasing.lowerCase:
        textUsed = text.toLowerCase();
        break;
      case AppFontCasing.titleCase:
        textUsed = TextFormatter.toCapitalizeWords(text);
        break;
      default:
        textUsed = text;
        break;
    }
    return textUsed;
  }
}
