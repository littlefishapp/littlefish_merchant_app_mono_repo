import 'dart:convert' as convert;
import 'dart:io' show Platform;
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/HomePage/online_store_main_home_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/pages/HomePage/online_store_setup_home_page.dart';
import 'package:quiver/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:url_launcher/url_launcher.dart';
import 'package:whatsapp_unilink/whatsapp_unilink.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';

import '../../features/ecommerce_shared/models/store/store_product.dart';

enum KSize { small, medium, large }

class HexColor extends Color {
  static int _getColorFromHex(String hexColor) {
    hexColor = hexColor.toUpperCase().replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor';
    }
    return int.parse(hexColor, radix: 16);
  }

  HexColor(final String hexColor) : super(_getColorFromHex(hexColor));
}

class Tools {
  static double? formatDouble(dynamic value) => value * 1.0;

  static String generateOTP({int digits = 4}) {
    var rnd = Random();
    var l = List.generate(digits, (_) => rnd.nextInt(10).toString());
    return l.join();
  }

  static String formatDateString(String date) {
    DateTime timeFormat = DateTime.parse(date);
    final timeDif = DateTime.now().difference(timeFormat);
    return timeago.format(DateTime.now().subtract(timeDif), locale: 'en');
  }

  static String? getVariantPriceProductValue(
    product,
    String currency, {
    bool? onSale,
  }) {
    String? price = onSale == true
        ? (isNotBlank(product.salePrice) ? product.salePrice : product.price)
        : product.price;
    if (product.multiCurrencies != null &&
        product.multiCurrencies[currency] != null) {
      return product.multiCurrencies[currency]['price'];
    } else {
      return price;
    }
  }

  static String? getPriceProductValue(
    product,
    String currency, {
    bool? onSale,
  }) {
    String? price = onSale == true
        ? (isNotBlank(product.salePrice) ? product.salePrice : product.price)
        : (isNotBlank(product.regularPrice)
              ? product.regularPrice
              : product.price);
    if (product.multiCurrencies != null &&
        product.multiCurrencies[currency] != null &&
        onSale == true) {
      return product.multiCurrencies[currency]['price'];
    } else {
      return price;
    }
  }

  static String? getPriceProduct(product, String currency, {bool? onSale}) {
    String? price = getPriceProductValue(product, currency, onSale: onSale);
    return getCurrecyFormatted(price, currency: currency);
  }

  static String? getCurrecyFormatted(price, {currency}) {
    Map<String, dynamic>? defaultCurrency = kAdvanceConfig['DefaultCurrency'];
    List currencies = kAdvanceConfig['Currencies'] ?? [];
    if (currency != null && currencies.isNotEmpty) {
      for (var item in currencies) {
        if ((item as Map)['currency'] == currency) {
          defaultCurrency = item as Map<String, dynamic>?;
        }
      }
    }

    final formatCurrency = NumberFormat.currency(
      symbol: '',
      decimalDigits: defaultCurrency!['decimalDigits'],
    );
    try {
      String number = '';
      if (price is String) {
        number = formatCurrency.format(
          price.isNotEmpty ? double.parse(price) : 0,
        );
      } else {
        number = formatCurrency.format(price);
      }
      return defaultCurrency['symbolBeforeTheNumber']
          ? defaultCurrency['symbol'] + number
          : number + defaultCurrency['symbol'];
    } catch (err) {
      return defaultCurrency['symbolBeforeTheNumber']
          ? defaultCurrency['symbol'] + formatCurrency.format(0)
          : formatCurrency.format(0) + defaultCurrency['symbol'];
    }
  }

  static Future<String> createCategoryLink(
    context,
    StoreProductCategory storeCategory,
  ) async {
    final appName = AppVariables.store?.state.appName ?? '';
    var link =
        'https://littlefish.africa/?type=product&id=${storeCategory.businessId}&itemId=${storeCategory.id}&preview=true';
    var title = 'View ${storeCategory.displayName} on $appName!';
    var description = storeCategory.description;
    var imageUrl = storeCategory.featureImageUrl;

    var url = await createDynamicLink(
      link,
      title,
      description,
      imageUrl: imageUrl,
    );

    return url;
  }

  static Future<String> createDynamicLink(
    String urlParameters,
    String linkTitle,
    String? linkDescription, {
    String? imageUrl =
        'https://marketingweek.imgix.net/content/uploads/2017/09/06163244/price-tags_750.jpg?auto=compress,format&q=60&w=750&h=460',
  }) async {
    return '';
  }

  /// check tablet screen
  static bool isTablet(MediaQueryData query) {
    if (kIsWeb) {
      return true;
    }

    if (Platform.isWindows || Platform.isMacOS) {
      return false;
    }

    var size = query.size;
    var diagonal = sqrt(
      (size.width * size.width) + (size.height * size.height),
    );
    var isTablet = diagonal > 1100.0;
    return isTablet;
  }

  static Future<List<String>> loadStatesByCountry(String country) async {
    try {
      // load local config
      String path = 'lib/config/states/state_${country.toLowerCase()}.json';
      final appJson = await rootBundle.loadString(path);
      return List<String>.from(convert.jsonDecode(appJson));
    } catch (e) {
      return [];
    }
  }
}

class Videos {
  static String? getVideoLink(String content) {
    if (_getYoutubeLink(content) != null) {
      return _getYoutubeLink(content);
    } else if (_getFacebookLink(content) != null) {
      return _getFacebookLink(content);
    } else {
      return _getVimeoLink(content);
    }
  }

  static String? _getYoutubeLink(String content) {
    final regExp = RegExp(
      'https://www.youtube.com/((v|embed))/?[a-zA-Z0-9_-]+',
      multiLine: true,
      caseSensitive: false,
    );

    String? youtubeUrl;

    try {
      Iterable<RegExpMatch> matches = regExp.allMatches(content);
      youtubeUrl = matches.first.group(0);
    } catch (error) {
      //      printLog('[_getYoutubeLink] ${error.toString()}');
    }
    return youtubeUrl;
  }

  static String? _getFacebookLink(String content) {
    final regExp = RegExp(
      'https://www.facebook.com/[a-zA-Z0-9.]+/videos/(?:[a-zA-Z0-9.]+/)?([0-9]+)',
      multiLine: true,
      caseSensitive: false,
    );

    String? facebookVideoId;
    String? facebookUrl;
    try {
      Iterable<RegExpMatch> matches = regExp.allMatches(content);
      facebookVideoId = matches.first.group(1);
      if (facebookVideoId != null) {
        facebookUrl =
            'https://www.facebook.com/video/embed?video_id=$facebookVideoId';
      }
    } catch (error) {
      debugPrint(error.toString());
    }
    return facebookUrl;
  }

  static String? _getVimeoLink(String content) {
    final regExp = RegExp(
      'https://player.vimeo.com/((v|video))/?[0-9]+',
      multiLine: true,
      caseSensitive: false,
    );

    String? vimeoUrl;

    try {
      Iterable<RegExpMatch> matches = regExp.allMatches(content);
      vimeoUrl = matches.first.group(0);
    } catch (error) {
      debugPrint(error.toString());
    }
    return vimeoUrl;
  }
}

void setStatusBarWhiteForeground(bool active) {
  if (kIsWeb == true) {
    return;
  }
}

class Utils {
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
  }
}

List<String> toArray(String value) {
  if (value.isEmpty) return [];

  List items = [];
  for (var i = 0; i < value.length; i++) {
    items.add(value[i]);
  }
  return items as List<String>;
}

double? toDouble(String value) {
  var amt = value;

  amt = amt.replaceAll(RegExp(r'\s\b|\b\s\t'), '');

  return double.tryParse(amt);
}

int toInt(String value) {
  var amt = value;

  amt = amt.replaceAll(RegExp(r'\s\b|\b\s\t'), '');

  return double.tryParse(amt)!.floor();
}

String enumToString(dynamic value) {
  if (value == null) return value;

  return value.toString().substring(value.toString().lastIndexOf('.') + 1);
}

launchWhatsapp(context, {required String? mobile, String? message}) async {
  WhatsAppUnilink(phoneNumber: mobile, text: message ?? 'Hi');
}

launchTel(context, String? telephone) async {
  await launchUrl(Uri(path: 'tel:$telephone'));
}

launchEmail(context, String? email) async {
  await launchUrl(Uri(path: 'mailto:$email'));
}

launchSMS(context, String mobile) async {
  await launchUrl(Uri(path: 'sms:$mobile'));
}

launchWebSite(context, String url) async {
  final launchUri = Uri.parse(url);
  if (await canLaunchUrl(launchUri)) {
    await launchUrl(
      launchUri,
      // universalLinksOnly: true,
    );
  } else {
    throw 'There was a problem to open the url: $url';
  }
}

launchMaps(double? latitude, double? longitude) async {
  String googleUrl =
      'https://www.google.com/maps/search/?api=1&query=$latitude,$longitude';
  final launcUrl = Uri.parse(googleUrl);
  if (await canLaunchUrl(launcUrl)) {
    await launchUrl(launcUrl);
  } else {
    throw 'Could not open the map.';
  }
}

launchInstagram(String profile) async {
  var url = 'https://www.instagram.com/$profile/';
  final launcUrl = Uri.parse(url);
  if (await canLaunchUrl(launcUrl)) {
    await launchUrl(
      launcUrl,
      // universalLinksOnly: true,
    );
  } else {
    throw 'There was a problem to open the url: $url';
  }
}

saveLastTheme(String theme) async {
  var key = 'lastTheme';

  var prefs = await SharedPreferences.getInstance();

  debugPrint('saving last theme code');

  await prefs.setString(key, theme);

  debugPrint('saved last theme code');
}

Future<void> saveKeyToPrefs(String key, String value) async {
  var prefs = await SharedPreferences.getInstance();

  debugPrint('saving $key to shared preferences');

  await prefs.setString(key, value);

  debugPrint('saved $key to shared preferences');
}

Future<void> saveKeyToPrefsBool(String key, bool value) async {
  var prefs = await SharedPreferences.getInstance();

  debugPrint('saving $key to shared preferences');

  await prefs.setBool(key, value);

  debugPrint('saved $key to shared preferences as type $value');
}

Future<String?> getKeyFromPrefs(String key, {String? defaultValue}) async {
  var prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey(key)) {
    return prefs.getString(key);
  } else {
    return defaultValue;
  }
}

Future<bool?> getKeyFromPrefsBool(String key, {bool? defaultValue}) async {
  var prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey(key)) {
    return prefs.getBool(key);
  } else {
    return defaultValue;
  }
}

saveLastLanguageCode(String languageCode) async {
  var key = 'lastLanguage';

  var prefs = await SharedPreferences.getInstance();

  debugPrint('saving last language code');

  await prefs.setString(key, languageCode);

  debugPrint('saved last language code');
}

Future<String?> getLastLanguageCode() async {
  var key = 'lastLanguage';

  var prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey(key)) {
    return prefs.getString(key);
  } else {
    return kDefaultLanguageCode;
  }
}

Future<String?> getLasttheme() async {
  var key = 'lastTheme';

  var prefs = await SharedPreferences.getInstance();

  if (prefs.containsKey(key)) {
    return prefs.getString(key);
  } else {
    return kDefaultTheme;
  }
}

Future<void> saveDefaultWorkspace(String value) async {
  var key = 'defaultSelectedWorkspace';
  var prefs = await SharedPreferences.getInstance();
  debugPrint('saving $key to shared preferences');
  await prefs.setString(key, value);
  debugPrint('saved $key to shared preferences as type $value');
}

Future<String?> getDefaultWorkspace() async {
  return 'Store';
  //will comment out for now, but still important
  // var key = 'defaultSelectedWorkspace';
  // var prefs = await SharedPreferences.getInstance();
  // if (prefs.containsKey(key))
  //   return prefs.getString(key);
  // else
  //   return null;
}

String getOnlineStoreRoute(bool isPublished) {
  if (!isPublished) {
    return OnlineStoreSetupHomePage.route;
  } else {
    return OnlineStoreMainHomePage.route;
  }
}

getOnlineStorePage(bool isPublished) {
  if (!isPublished) {
    return const OnlineStoreSetupHomePage();
  } else {
    return const OnlineStoreMainHomePage();
  }
}
