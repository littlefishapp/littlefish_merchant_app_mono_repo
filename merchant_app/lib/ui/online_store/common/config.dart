// import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants.dart';

const bool kAyobaMode = false;

/// Config use mock data (json offline data: \lib\config\mocks)
bool mockData = false;
const serverConfigReal = {'type': 'littlefish'};

const serverConfigMock = {'type': 'littlefish'};

final serverConfig = !mockData ? serverConfigReal : serverConfigMock;

const afterShip = {
  'api': 'e2e9bae8-ee39-46a9-a084-781d0139274f',
  'tracking_url': 'https://fluxstore.aftership.com',
};

const payments = {
  'paypal': AppAssets.paypalPng,
  'momo': AppAssets.mtnMomoJpg,
  'ozow': AppAssets.ozowWhitePng,
  'paygate': AppAssets.paygatePng,
};

/// The product variant config
const productVariantLayout = {
  'color': 'color',
  'size': 'box',
  'height': 'option',
};

/// This option is determine hide some components for web
var kLayoutWeb = true;

String? get kDefaultLanguageCode => kAdvanceConfig['DefaultLanguage'];

String? get kDefaultTheme => kAdvanceConfig['DefaultTheme'];

String? get kCountryCode => kAdvanceConfig['DefaultCountryISOCode'];

String? get kCountryDiallingCode => kAdvanceConfig['DefaultPhoneISOCode'];

String? get kStoreIdentifier => kAdvanceConfig['storeIdentifier'];

String? get kPrivacyPolicyUrl => kAdvanceConfig['privacy_policy_url'];

String? get kTermsAndConditionsUrl => kAdvanceConfig['terms_conditions_url'];

String? get kDynamicLinkPrefix => kAdvanceConfig['DynamicPrefix'];

String? get kDynamicLinkFallbackUrl => kAdvanceConfig['dynamic_fallback_url'];

double? get kBorderRadius => kAdvanceConfig['BorderRadius'];

String? get kAppStoreId => kAdvanceConfig['app_store_id'];

String? get kGoogleApiKey => 'AIzaSyBPHQFdCHYHLG2AmH3K-KOdLGAFZqgYjwA';

Map<String, dynamic> kAdvanceConfig = {
  'DefaultLanguage': 'en',
  'DynamicPrefix': '',
  'DefaultStoreViewCode': '', //for magento
  'DefaultCurrency': {
    'symbol': 'R',
    'decimalDigits': 2,
    'symbolBeforeTheNumber': true,
    'currency': 'ZAR',
  },
  'storeIdentifier': '',
  'IsRequiredLogin': false,
  'ShowMap': false,
  'GuestCheckout': false,
  'EnableShipping': false,
  'EnableAddress': true,
  'DefaultTheme': 'light',
  'EnableReview': true,
  'GridCount': 3,
  'BorderRadius': 4.0,
  'EnablePointReward': true,
  'DefaultPhoneISOCode': '27',
  'DefaultCountryISOCode': 'ZA',
  'DefaultCountryName': 'South Africa',
  'EnableRating': true,
  'EnableSmartChat': true,
  'hideOutOfStock': true,
  'allowSearchingAddress': true,
  'isCaching': false,
  'OnBoardOnlyShowFirstTime': true,
  'EnableAdvertisement': true,
  'MinFreeShippingCost': 200,
  'LocalDBPersistence': true,
  'LocalDBCacheSize': 100000,
  'ShowDefaultProductImage': true,
  'cloud_functions_url': '',
  'app_store_id': '123456',
  'dynamic_prefix': 'https://littlefishcommercedev.page.link',
  'dynamic_fallback_url': '',
  'terms_conditions_url': '',
  'privacy_policy_url': '',
  'support_line': '+27635082092',
  'support_email': 'info@nybble.africa',
  'support_website': 'https://www.littlefish.africa',
};

Map<String, dynamic> kDefaultImagery = {
  'default_user_image': '',
  'default_store_category': '',
  'default_store_logo': '',
  'default_store_banner': '',
  'default_store_cover': '',
  'default_product_image': '',
};

/// The Google API Key to support Pick up the Address automatically
/// We recommend to generate both ios and android to restrict by bundle app id
/// The download package is remove these keys, please use your own key
Map<String, dynamic> kGoogleAPIKey = {
  'google_android_key': 'AIzaSyBPHQFdCHYHLG2AmH3K-KOdLGAFZqgYjwA',
  'google_web_key': 'AIzaSyBPHQFdCHYHLG2AmH3K-KOdLGAFZqgYjwA',
  'google_ios_key': 'AIzaSyBPHQFdCHYHLG2AmH3K-KOdLGAFZqgYjwA',
};

/// use to config the product image height for the product detail
/// height=(percent * width-screen)
/// isHero: support hero animate
const kProductDetail = {
  'height': 0.5,
  'marginTop': 0,
  'isHero': false,
  'safeArea': false,
  'showVideo': true,
  'showThumbnailAtLeast': 3,
  'layout': 'simpleType',
  'maxAllowQuantity': 100, // the maximum quantity items user could purchase
};

/// config for the chat app
// const smartChat = [
//   {
//     'app': 'whatsapp://send?phone=84327433006',
//     'iconData': FontAwesomeIcons.whatsapp
//   },
//   {'app': 'tel:8499999999', 'iconData': FontAwesomeIcons.phone},
//   {'app': 'sms://8499999999', 'iconData': FontAwesomeIcons.sms},
//   {
//     'app': 'https://tawk.to/chat/5e5cab81a89cda5a1888d472/default',
//     'iconData': FontAwesomeIcons.facebookMessenger
//   }
// ];

const String adminEmail = 'admininspireui@gmail.com';
final appName = AppVariables.store?.state.appName ?? '';

const paypalConfig = {
  'clientId':
      'ASlpjFreiGp3gggRKo6YzXMyGM6-NwndBAQ707k6z3-WkSSMTPDfEFmNmky6dBX00lik8wKdToWiJj5w',
  'secret':
      'ECbFREri7NFj64FI_9WzS6A0Az2DqNLrVokBo0ZBu4enHZKMKOvX45v9Y1NBPKFr6QJv2KaSp5vk5A1G',
  'production': false,
  'paymentMethodId': 'paypal',
  'enabled': true,
  'returnUrl': 'http://return.example.com',
  'cancelUrl': 'http://cancel.example.com',
};

const razorPayConfig = {
  'keyId': 'rzp_test_WHBBYP8YoqmqwB',
  'paymentMethodId': 'razorpay',
  'enabled': true,
};

const tapConfig = {
  'SecretKey': 'sk_test_XKokBfNWv6FIYuTMg5sLPjhJ',
  'RedirectUrl': 'http://your_website.com/redirect_url',
  'paymentMethodId': '',
  'enabled': false,
};

// Limit the country list from Billing Address
// const List DefaultCountry = [];
const List defaultCountry = [
  {
    'name': 'South Africa',
    'iosCode': 'ZA',
    'icon': 'https://cdn.britannica.com/41/4041-004-A06CBD63/Flag-Vietnam.jpg',
  },
];

const kProductVariantLanguage = {
  'en': {'color': 'Color', 'size': 'Size', 'height': 'Height'},
  'ar': {'color': 'اللون', 'size': 'بحجم', 'height': 'ارتفاع'},
  'vi': {'color': 'Màu', 'size': 'Kích thước', 'height': 'Chiều Cao'},
};

const kAdConfig = {
  'enable': false,
  'type': KAdType.facebookNative,

  /// ----------------- Facebook Ads  -------------- ///
  'hasdedIdTestingDevice': 'ef9d4a6d-15fd-4893-981b-53d87a212c07',
  'bannerPlacementId': '430258564493822_489007588618919',
  'interstitialPlacementId': '430258564493822_489092398610438',
  'nativePlacementId': '430258564493822_489092738610404',
  'nativeBannerPlacementId': '430258564493822_489092925277052',

  /// ------------------ Google Admob  -------------- ///
  'androidAppId': 'ca-app-pub-2101182411274198~6793075614',
  'androidUnitBanner': 'ca-app-pub-2101182411274198/4052745095',
  'androidUnitInterstitial': 'ca-app-pub-2101182411274198/7131168728',
  'androidUnitReward': 'ca-app-pub-2101182411274198/6939597036',
  'iosAppId': 'ca-app-pub-2101182411274198~6923444927',
  'iosUnitBanner': 'ca-app-pub-2101182411274198/5418791562',
  'iosUnitInterstitial': 'ca-app-pub-2101182411274198/9218413691',
  'iosUnitReward': 'ca-app-pub-2101182411274198/9026842008',
  'waitingTimeToDisplayInterstitial': 10,
  'waitingTimeToDisplayReward': 10,
};
