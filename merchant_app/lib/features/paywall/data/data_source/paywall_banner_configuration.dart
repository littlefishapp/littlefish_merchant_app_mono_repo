import 'package:flutter/foundation.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/features/paywall/data/models/paywall_banner_model.dart';
import 'package:littlefish_merchant/features/paywall/domain/entities/paywall_banner.dart';

const String paywallBannerLDFlag = 'paywall_banner';
const String paywallBannerOnlineId = 'online';
const String paywallBannerSoftposId = 'softpos';
const String paywallBannerPaymentLinksId = 'paymentLinks';
const String paywallBannerInvoicesId = 'invoicesLinks';

class PaywallBannerConfiguration {
  LittleFishCore core = LittleFishCore.instance;

  final dynamic defaultJsonMap = [
    {
      'id': 'online',
      'paywallEnabled': false,
      'startScript': 'New! Create a new service.',
      'pendingHeader': '',
      'pendingBody': '',
      'enabledScript': '',
      'startControl': 'Get Started',
    },
    {
      'id': 'softpos',
      'paywallEnabled': false,
      'startScript': 'New! Create a new service.',
      'pendingHeader': '',
      'pendingBody': '',
      'enabledScript': '',
      'startControl': 'Get Started',
    },
    {
      'id': 'paymentLinks',
      'paywallEnabled': true,
      'startScript': 'New! Accept payments directly on your phone.',
      'pendingHeader': 'Request in Progress',
      'pendingBody':
          'Your activation request has been submitted and is being reviewed.',
      'enabledScript': '',
      'startControl': 'Get Started',
    },
    {
      'id': 'invoicesLinks',
      'paywallEnabled': true,
      'startScript': 'New! Accept invoice payments directly on your phone.',
      'pendingHeader': 'Request in Progress',
      'pendingBody':
          'Your activation request has been submitted and is being reviewed.',
      'enabledScript': '',
      'startControl': 'Get Started',
    },
  ];

  PaywallBanner getBannerUIData({required String serviceId}) {
    final ConfigService configService = core.get<ConfigService>();
    var layout = configService.getObjectValue(
      key: paywallBannerLDFlag,
      defaultValue: {},
    );

    if (layout == null || layout.isEmpty) {
      layout = defaultJsonMap;
    }

    debugPrint('### PaywallBannerConfiguration $layout');
    final entity = PaywallBannerModel().fromDynamicObject(
      ldObject: layout,
      id: serviceId,
    );
    return entity;
  }
}
