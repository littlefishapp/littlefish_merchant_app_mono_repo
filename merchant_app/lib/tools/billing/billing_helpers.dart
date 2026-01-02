// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/environment/environment_config.dart';
import 'package:littlefish_merchant/redux/billing/billing_actions.dart';
import 'package:littlefish_merchant/common/presentaion/pages/billing/billing_not_enabled_screen.dart';

bool isPremiumAction(String? action) =>
    AppVariables.store!.state.premiumActions.contains(action);

bool isPremiumRoute(String? route) =>
    AppVariables.store!.state.premiumRoutes.contains(route);

bool isNotPremium(String? action) {
  if (isPremium()) {
    return false;
  } else {
    return isPremiumRoute(action) || isPremiumAction(action);
  }
}

bool isPremium() {
  if (AppVariables.store!.state.environment == AppEnvironment.prod) {
    var premSubscription = isPremiumSubscription();
    var enableBilling = AppVariables
        .store!
        .state
        .environmentState
        .environmentConfig!
        .enableBilling!;
    if (!enableBilling || premSubscription) {
      return true;
    } else {
      return false;
    }
  } else {
    return true;
    // var premSubscription = isPremiumSubscription();
    // var enableBilling = AppVariables
    //     .store!.state.environmentState.environmentConfig!.enableBilling!;
    // if (!enableBilling || premSubscription)
    //   return true;
    // else
    //   return false;
  }
}

bool isPremiumSubscription() {
  var billingInfo = AppVariables.store!.state.storeBillingInfo;
  var business = AppVariables.store!.state.businessState.businesses!.first;

  if (billingInfo == null) {
    AppVariables.store!.dispatch(
      upsertUserBillingInfoAction(business: business),
    );
    return false;
  } else {
    var currentDate = DateTime.now().toUtc();
    if (billingInfo.validUntil?.isBefore(currentDate) == true) {
      var previousDay = currentDate.add(const Duration(days: -1));
      if (billingInfo.lastCheckedDate?.isBefore(previousDay) == true) {
        AppVariables.store!.dispatch(ValidateSubscriptionAction(billingInfo));
      }
    }

    return billingInfo.overrideSubscription! || billingInfo.isPaid!;
  }
}

Future<bool> isSubscriptionValid() async {
  var state = AppVariables.store!.state;
  var bInfo = state.storeBillingInfo!;

  if (bInfo.validUntil != null && state.billingState.billingSupported == true) {
    var currentDate = DateTime.now().toUtc(); //.add(Duration(days: -2));

    currentDate = state.environment == AppEnvironment.local
        ? currentDate.add(
            Duration(
              minutes: -state.environmentSettings!.posSubscriptionGracePeriod!,
            ),
          )
        : currentDate.add(
            Duration(
              days: -state.environmentSettings!.posSubscriptionGracePeriod!,
            ),
          );

    if (currentDate.isBefore(bInfo.validUntil!)) {
      return true;
    } else {
      return true;

      // var purchaser = await Purchases
      //     .getCustomerInfo(); // TODO(lampian): check  .getPurchaserInfo();

      // var purchaseActive = validatePurchaser(purchaser);

      // if (purchaseActive) {
      //   // AppVariables.store!.dispatch(renewPurchase());
      //   // await renewSubscription(AppVariables.store!, purchaser, null);
      //   return true;
      // } else {
      //   return false;
      // }
    }
  }

  return false;
}

bool validatePurchaser(dynamic purchaser) {
  return true;

  // // TODO(lampian): check PurchaserInfo purchaser) {
  // if (purchaser.activeSubscriptions.isEmpty) return false;

  // var activeSub = purchaser.activeSubscriptions.first;
  // if (AppVariables.store!.state.subscriptionKeys!.contains(activeSub)) {
  //   return true;
  // } else {
  //   return false;
  // }
}

Widget billingNavigationHelper({
  String? targetRoute,
  bool isModal = false,
  bool skipNavigatesToRoute = false,
}) => AppVariables.store?.state.billingState.billingSupported == true
    ? BillingNotEnabledScreen(
        targetRoute: targetRoute,
        isModal: isModal,
        skipNavigatesToRoute: skipNavigatesToRoute,
      )
    : BillingNotEnabledScreen(
        targetRoute: targetRoute,
        isModal: isModal,
        skipNavigatesToRoute: skipNavigatesToRoute,
      );

void checkSubscriptionFrequency() {
  var baseState = AppVariables.store!.state;

  if (baseState.billingState.showBillingPage == true) return;

  var subFrequency =
      baseState.environmentState.environmentConfig!.subscriptionFrequency!;

  var dateRegistered = baseState.businessState.businesses?.first.dateCreated;
  if (dateRegistered != null) {
    var daysRegistered = DateTime.now().toUtc().difference(dateRegistered);
    var days = daysRegistered.inDays;

    SharedPreferences.getInstance().then((instance) {
      var dd =
          instance.getInt('lastRun') ?? dateRegistered.millisecondsSinceEpoch;

      if (subFrequency.lowDays <= days) {
        _billingPageUpdate(subFrequency.low, dd);
      } else if (subFrequency.mediumDays <= days) {
        _billingPageUpdate(subFrequency.medium, dd);
      } else {
        _billingPageUpdate(subFrequency.high, dd);
      }
    });
  }
}

_billingPageUpdate(String duration, int dd) {
  var lastRun = DateTime.fromMillisecondsSinceEpoch(dd);

  var now = DateTime.now().toUtc();
  var freq = duration.replaceAll('*', '0').split(' ');
  // var dur = Duration(
  //   minutes: 1,
  //   hours: 0,
  //   days: 0,
  // );
  var dur = Duration(
    minutes: int.parse(freq[0]),
    hours: int.parse(freq[1]),
    days: int.parse(freq[2]),
  );

  if (now.isAfter(lastRun.add(dur))) {
    AppVariables.store!.dispatch(SetShowBillingPageAction(true));
  }
}
