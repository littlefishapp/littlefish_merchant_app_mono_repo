import 'package:intl/intl.dart';

class TextFormatter {
  // static String formatCurrency(String textValue,
  //     {bool displayCurrency = true}) {
  //   var locale = LocaleProvider.instance.currentLocale;

  //   try {
  //     if (textValue == null || textValue.isEmpty) textValue = "0.00";
  //     var formatter = displayCurrency
  //         ? NumberFormat(
  //             "${locale.shortCurrencyCode ?? locale.currencyCode} ###,##0.00",
  //             "en_US")
  //         : NumberFormat("###,##0.00", "en_US");

  //     var formatValue = double.parse(textValue);
  //     var formattedText = formatter.format(formatValue / 100);
  //     return formattedText;
  //   } catch (e) {
  //     ////debugPrint(e);
  //   }

  //   return textValue;
  // }

  static String toStringCurrency(
    double? value, {
    bool displayCurrency = true,
    String? currencyCode,
    bool addCommas = true,
  }) {
    // var locale = LocaleProvider.instance.currentLocale;
    try {
      if (value == null) return '$currencyCode 0';

      var formatter = addCommas
          ? NumberFormat('###,##0.00', 'en_US')
          : NumberFormat('#0.00', 'en_US');
      var formattedText = formatter.format(value);

      return displayCurrency == true && currencyCode != null
          ? '$currencyCode $formattedText'
          : formattedText;
    } catch (e) {
      ////debugPrint(e);
    }

    return '0';
  }

  static String toShortDate({
    required DateTime? dateTime,
    String format = 'yyy-MM-dd',
  }) {
    var formatter = DateFormat(format);
    return formatter.format((dateTime ?? DateTime.now()).toLocal());
  }

  static String toCapitalize({required String value}) {
    return value[0].toUpperCase() + value.substring(1);
  }
}
