// Dart imports:
import 'dart:convert';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:littlefish_merchant/models/assets/app_assets.dart';

// Package imports:
import 'package:google_fonts/google_fonts.dart';

const kAppConfig = 'lib/config/config_en.json';

const kDefaultImage =
    'https://trello-attachments.s3.amazonaws.com/5d64f19a7cd71013a9a418cf/640x480/1dfc14f78ab0dbb3de0e62ae7ebded0c/placeholder.jpg';

const kLogoImage = 'assets/images/logo.png';

const kBargainStoryCollection = 'bargain_storyboards';

const kUserIcon = AppAssets.iconUserPng;

const kProfileBackground =
    'https://images.unsplash.com/photo-1494253109108-2e30c049369b?ixlib=rb-1.2.1&auto=format&fit=crop&w=3150&q=80';

const welcomeGift =
    'https://media.giphy.com/media/3oz8xSjBmD1ZyELqW4/giphy.gif';

// const kSplashScreen = "assets/images/splashscreen.flr";

const kDefaultDistance = 20.0;
const kSplashScreen = 'assets/images/splashscreen.png';

// /Google fonts: https://fonts.google.com/
TextTheme kTextTheme(theme, String? language) {
  switch (language) {
    case 'vi':
      return GoogleFonts.montserratTextTheme(theme);
    case 'ar':
      return GoogleFonts.ralewayTextTheme(theme);
    default:
      return GoogleFonts.nunitoSansTextTheme(theme);
  }
}

TextTheme kHeadlineTheme(theme, [language = 'en']) {
  switch (language) {
    case 'vi':
      return GoogleFonts.montserratTextTheme(theme);
    case 'ar':
      return GoogleFonts.ralewayTextTheme(theme);
    default:
      return GoogleFonts.nunitoSansTextTheme(theme);
  }
}

const debugNetworkProxy = false;

enum KCategoriesLayout {
  card,
  sideMenu,
  column,
  subCategories,
  animation,
  grid,
}

const kEmptyColor = 0XFFF2F2F2;

const kColorNameToHex = {
  'red': '#ec3636',
  'black': '#000000',
  'white': '#ffffff',
  'green': '#36ec58',
  'grey': '#919191',
  'yellow': '#f6e46a',
  'blue': '#3b35f3',
};

/// Filter value
const kSliderActiveColor = 0xFF2c3e50;
const kSliderInactiveColor = 0x992c3e50;
const kMaxPriceFilter = 1000.0;
const kFilterDivision = 10;

const kOrderStatusColor = {
  'processing': '#bcd5bc',
  'refunded': '#e5e5e5',
  'cancelled': '#e5e5e5',
  'completed': '#b9c5ce',
  'failed': '#eba4a4',
  'pendding': '#e5e5e5',
  'on-hold': '#f7deaa',
};

const kLocalKey = {
  'userInfo': 'userInfo',
  'shippingAddress': 'shippingAddress',
  'recentSearches': 'recentSearches',
  'wishlist': 'wishlist',
  'home': 'home',
  'cart': 'cart',
};

Widget kLoadingWidget(context) => const Center(
  // TODO(lampian): fix widget
  child: SizedBox.shrink(),
);
//   child: SpinKitChasingDots(
//     color: Theme.of(context).colorScheme.primary,
//     size: 30.0,
//   ),
// );

enum KBlogLayout {
  simpleType,
  fullSizeImageType,
  halfSizeImageType,
  oneQuarterImageType,
}

const kProductListLayout = [
  {'layout': 'list', 'image': AppAssets.iconListPng},
  {'layout': 'columns', 'image': AppAssets.iconColumnsPng},
  {'layout': 'card', 'image': AppAssets.iconCardPng},
  {'layout': 'horizontal', 'image': AppAssets.iconHorizonPng},
];

enum KAdType {
  googleBanner,
  googleInterstitial,
  googleReward,
  facebookBanner,
  facebookInterstitial,
  facebookNative,
  facebookNativeBanner,
}

const kLogTag = '[LITTLEFISH SELLER]';
const kLogEnable = true;

printLog(dynamic data) {
  if (kLogEnable) {
    debugPrint('$kLogTag ${data.toString()}');
  }
}

printRelease(String data) {
  print('$kLogTag $data');
}

Future<dynamic> parseJsonFromAssets(String assetsPath) async {
  return rootBundle.loadString(assetsPath).then(jsonDecode);
}

// // check if the environment is web
// const bool kIsWeb = identical(0, 0.0);

const kMagentoPayments = [
  'HyperPay_Amex',
  'HyperPay_ApplePay',
  'HyperPay_Mada',
  'HyperPay_Master',
  'HyperPay_PayPal',
  'HyperPay_SadadNcb',
  'HyperPay_Visa',
  'HyperPay_SadadPayware',
];

const posResultSuccessCode = '0000';

const appName = 'appName';
const appVersion = 'appVersion';
const appBuild = 'appBuild';
const appIntegrityCheck = 'appIntegrityCheck';
const channel = 'channel';
