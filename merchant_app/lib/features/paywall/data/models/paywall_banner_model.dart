import 'package:littlefish_merchant/features/paywall/domain/entities/paywall_banner.dart'; // Adjust the import path as needed

class PaywallBannerModel {
  PaywallBanner fromDynamicObject({
    required dynamic ldObject,
    required String id,
  }) {
    if (ldObject is List) {
      for (var item in ldObject) {
        if (item is Map<String, dynamic>) {
          if (item.containsKey('id') && item['id'] == id) {
            return PaywallBanner(
              paywallEnabled: item['paywallEnabled'] ?? false,
              startScript: item['startScript'] ?? '',
              pendingHeader: item['pendingHeader'] ?? '',
              pendingBody: item['pendingBody'] ?? '',
              enabledScript: item['enabledScript'] ?? '',
              startControl: item['startControl'] ?? '',
              id: item['id'] ?? '',
            );
          }
        }
      }
    }
    return PaywallBanner();
  }

  Map<String, dynamic> toJson(PaywallBanner instance) {
    return {
      'paywallEnabled': instance.paywallEnabled,
      'startScript': instance.startScript,
      'pendingHeader': instance.pendingHeader,
      'pendingBody': instance.pendingBody,
      'enabledScript': instance.enabledScript,
      'startControl': instance.startControl,
      'id': instance.id,
    };
  }
}
