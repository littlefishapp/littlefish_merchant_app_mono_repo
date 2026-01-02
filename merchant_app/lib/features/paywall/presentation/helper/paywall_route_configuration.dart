import 'package:littlefish_merchant/features/paywall/data/data_source/paywall_configuration.dart';

class PaywallRouteConfiguration {
  static final Set<String> _accepted = {};

  PaywallRouteConfiguration._();

  static List<String> paywallRoutes = [];

  static Future<void> initialize() async {
    paywallRoutes = PaywallConfiguration().getPaywallRoutes();
  }

  static bool hasAccepted(String routeName) => _accepted.contains(routeName);

  static void accept(String? routeName) {
    if (routeName == null) return;
    _accepted.add(routeName);
  }

  static bool mustGuard(String? routeName) {
    if (routeName == null) return false;
    final compareOutcome =
        paywallRoutes.contains(routeName) && !hasAccepted(routeName);
    return compareOutcome;
  }
}
