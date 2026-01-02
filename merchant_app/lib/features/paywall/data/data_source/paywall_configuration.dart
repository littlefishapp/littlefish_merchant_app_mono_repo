import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/features/paywall/data/models/paywall_activation_model.dart';
import 'package:littlefish_merchant/features/paywall/data/models/paywall_routes_model.dart';
import 'package:littlefish_merchant/features/paywall/domain/entities/paywall_activiation.dart';

const String paymentLinkLDFlag = 'paymentLink_za';
const String softposLDFlag = 'softpos_za';
const String onlineStoreLDFlag = 'online_store_za';
const String invoicesLDFlag = 'invoices_za';

class PaywallConfiguration {
  LittleFishCore core = LittleFishCore.instance;

  final Map<String, String> defaultJsonMap = {
    'title': 'Enable New Services',
    'summary_text': 'Enable new service via your mobile device.',
    'pricing_information': 'Contact call centre for more information',
    'terms_url': 'https://www.littlefish.co.za',
    'terms_link_text': 'Terms and Conditions',
    'activation_type': 'instant',
    'tap_description_text': 'By tapping ACCEPT, you agree to the',
    'get_started_banner_text': 'New! Create a new service.',
    'get_started_control_text': 'Get Started',
  };

  final Map<String, String> softPosJsonMap = {
    'title': 'Enable Soft POS',
    'summary_text': 'Turn your Android phone into a point-of-sale terminal.',
    'pricing_information': 'Contact call centre for more information',
    'terms_url': 'https://www.littlefish.co.za/soft-pos-terms',
    'terms_link_text': 'Soft POS Terms and Conditions',
    'activation_type': 'instant',
    'tap_description_text': 'By tapping ACCEPT, you agree to the',
    'get_started_banner_text':
        'New! Accept payments directly on your mobile device.',
    'get_started_control_text': 'Get Started',
  };

  final Map<String, String> onlineStoreJsonMap = {
    'title': 'Enable Online Store',
    'summary_text': 'Create and manage your online store.',
    'pricing_information': 'Contact call centre for more information',
    'terms_url': 'https://www.littlefish.co.za/soft-pos-terms',
    'terms_link_text': 'Soft POS Terms and Conditions',
    'activation_type': 'instant',
    'tap_description_text': 'By tapping ACCEPT, you agree to the',
    'get_started_banner_text':
        'New! Accept payments directly on your mobile device.',
    'get_started_control_text': 'Get Started',
  };

  final Map<String, String> paymentsLinkJsonMap = {
    'title': 'Payment Links',
    'summary_text': 'Get paid via payment links.',
    'pricing_information': 'Contact call centre for more information',
    'terms_url': 'https://www.littlefish.co.za/soft-pos-terms',
    'terms_link_text': 'Terms and Conditions',
    'activation_type': 'instant',
    'tap_description_text': 'By tapping ACCEPT, you agree to the',
    'get_started_banner_text':
        'New! Accept payments directly on your mobile device.',
    'get_started_control_text': 'Get Started',
  };

  final Map<String, String> invoicesJsonMap = {
    'title': 'Invoices',
    'summary_text': 'Create and send invoices to your customers.',
    'pricing_information': 'Contact call centre for more information',
    'terms_url': 'https://www.littlefish.co.za/invoices-terms',
    'terms_link_text': 'Invoices Terms and Conditions',
    'activation_type': 'instant',
    'tap_description_text': 'By tapping ACCEPT, you agree to the',
    'get_started_banner_text':
        'New! Create and send invoices to your customers.',
    'get_started_control_text': 'Get Started',
  };

  // TODO(lampian): Remove the hardcoded jsonString1 after testing
  final Map<String, String> jsonString1 = {
    'title': 'Enable Soft POS SHGHG HGHSAGHGSDH. HGSHDGHGD HGDSHGG HGSDHG ',
    'summary_text':
        'Turn your Android phone into a point-of-sale terminal. JKJKJi I JHJHH AFGSFF HFF NBnbb RTRTR ',
    'pricing_information':
        '4.0% per transaction. 6767 67676. HGGHg HGHghg hgHGhg klkJkjkj kjkJ ',
    'terms_url': 'https://www.littlefish.co.za/soft-pos-terms',
    'terms_link_text':
        'Soft POS Terms and Conditions QWWYUYU UYUYY jHHUYUYU UYYUYUY UYUyuy uyUYY v',
    'activation_type': 'instant',
    'tap_description_text':
        'By tapping Accept, you agree to the hsdjhjh jhjh jhjhjhsuiyoiy sdvbv tytt m,m,mmk suuiii ashjhjhh qwqweh ajsdhjsdh zxcncbx ',
    'get_started_banner_text':
        'New! Accept payments directly on your phone. kdjdkjfkdj kjjdkfjkj kjdkjfkdj kdfjkjkj kdjfkjdfkj dkjkjkj dkfjkjj ',
    'get_started_control_text':
        'Get Started qwertyyulkflklfklk flklfklkd lkkk flklkk ',
  };

  final getStartedBannerText = 'New! Accept payments directly on your phone.';
  final getStartedControlText = 'Get Started';

  PaywallActivation getActivationUIData({required String ldFlag}) {
    final ConfigService configService = core.get<ConfigService>();
    final layout = configService.getObjectValue(
      key: ldFlag,
      defaultValue: getDefaultMap(ldFlag),
    );

    debugPrint('### PaywallConfiguration $layout');
    final entity = PaywallActivationModel().fromJson(layout);
    return entity;
  }

  Map<String, String> getDefaultMap(String ldFlag) {
    switch (ldFlag) {
      case paymentLinkLDFlag:
        return paymentsLinkJsonMap;
      case softposLDFlag:
        return softPosJsonMap;
      case onlineStoreLDFlag:
        return onlineStoreJsonMap;
    }
    return defaultJsonMap;
  }

  List<String> getPaywallRoutes() {
    final ConfigService configService = core.get<ConfigService>();
    var layout = configService.getObjectValue(
      key: 'config_paywall_routes',
      defaultValue: {},
    );

    if (layout is Map && layout.isEmpty) {
      layout = {
        'routes': [
          // 'payment-links-landing-page',
          // 'softpos-paywall',
          // 'online-store/setup-home-page',
          // 'business/online-store-router',
          // 'invoice-landing-page',
        ],
      };
    }

    final routes = PaywallRoutesModel().fromJson(layout);
    debugPrint('#### getPaywallRoutes ${routes.length}');
    return routes;
  }
}
