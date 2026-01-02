// Dart imports:
import 'dart:async';
// removed ignore: depend_on_referenced_packages
import 'package:littlefish_core/business/models/business.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/billing/billing_info.dart';

import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';

// Future purchaseProductSubscription(
//   rev_cat.StoreProduct product,
//   BuildContext context, {
//   Completer? completer,
//   bool isUpgrade = false,
//   String? oldIdentifier,
// }) async {
//   var store = AppVariables.store!;

//   try {
//     var pChaser = await rev_cat.Purchases
//         .getCustomerInfo(); // TODO(lampian): check if ok  .getPurchaserInfo();

//     var firstPurchase = pChaser.allPurchasedProductIdentifiers.isEmpty;

//     var pInfo = await rev_cat.Purchases.purchaseStoreProduct(product);

//     var expiration = DateTime.parse(pInfo.latestExpirationDate!);

//     await _saveBillingEntry(
//       store: store,
//       storeProduct: product,
//       isTrial: firstPurchase,
//       expirationDate: expiration,
//     );
//     completer?.complete();
//   } catch (e) {
//     if (e is PlatformException) {
//       if (e.code == '1') {
//       } else if (e.code == '6') {
//         await _saveBillingEntry(
//           store: store,
//           storeProduct: product,
//           isTrial: false,
//         );
//         completer?.complete();
//       } else {
//         completer?.completeError(e.message ?? 'Something went wrong');
//       }
//     } else {
//       completer?.completeError(e);
//     }
//   } finally {
//     store.dispatch(SetBillingLoadingAction(false));
//     // completer!.completeError(e);
//   }
// }

// _saveBillingEntry({
//   required Store<AppState> store,
//   required rev_cat.StoreProduct storeProduct,
//   bool isTrial = false,
//   DateTime? expirationDate,
// }) async {
//   var service = BillingServiceCF.fromStore(store);
//   var subtype = storeProduct.identifier.contains('month')
//       ? SubscriptionDuration.month
//       : SubscriptionDuration.year;

//   var currentDate = DateTime.now().toUtc();

//   var billingEntry = BillingPaymentEntry(
//     amount: storeProduct.price,
//     app: store.state.posLicense!.appName,
//     businessId: store.state.businessId,
//     businessName: store.state.businessState.businesses!.first.displayName,
//     country: store.state.localeState.countryCode,
//     paidBy: store.state.currentUser!.email,
//     currentLicense: 'premium',
//     duration: subtype,
//     isTrial: isTrial,
//     paymentDate: currentDate,
//   );

//   var storeInfo = BillingStoreInfo()
//     ..app = store.state.storeBillingInfo!.app
//     ..businessId = store.state.storeBillingInfo!.businessId
//     ..businessName = store.state.storeBillingInfo!.businessName
//     ..country = store.state.storeBillingInfo!.country
//     ..currentLicense = store.state.storeBillingInfo!.currentLicense
//     ..isPaid = true
//     ..overrideSubscription = store.state.storeBillingInfo!.overrideSubscription
//     ..lastPaymentDate = currentDate
//     ..lastPaymentAmount = storeProduct.price
//     ..duration = billingEntry.duration;

//   if (expirationDate == null) {
//     if (store.state.environment == AppEnvironment.local) {
//       if (storeInfo.duration == SubscriptionDuration.year) {
//         storeInfo.validUntil = currentDate.add(const Duration(minutes: 30));
//       } else {
//         storeInfo.validUntil = currentDate.add(const Duration(minutes: 5));
//       }
//     } else {
//       // TODO(lampian): verify correct operation of adding 1 year, 1 month and 3 days
//       if (isTrial) {
//         //currentDate.add(const Duration(days: 3));
//         storeInfo.validUntil =
//             DateTime(currentDate.year, currentDate.month, currentDate.day + 1);
//         storeInfo.validUntil =
//             DateTime(currentDate.year, currentDate.month, currentDate.day + 1);
//       } else if (storeInfo.duration == SubscriptionDuration.year) {
//         // storeInfo.validUntil = Jiffy.now().add(years: 1).dateTime;
//         storeInfo.validUntil =
//             DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
//         storeInfo.validUntil =
//             DateTime(currentDate.year + 1, currentDate.month, currentDate.day);
//       } else {
//         // storeInfo.validUntil = Jiffy.now().add(months: 1).dateTime;
//         storeInfo.validUntil = DateTime(
//           currentDate.year,
//           currentDate.month + 1,
//           currentDate.day + 1,
//         );
//       }
//     }
//   } else {
//     storeInfo.validUntil = expirationDate;
//   }

//   await service.savePayment(billingEntry, storeInfo);

//   store.dispatch(
//     SetBillingPurchaseAction(
//       billingEntry.amount,
//       billingEntry.currentLicense,
//     ),
//   );

//   store.dispatch(SetBillingStoreInfoAction(storeInfo));

//   // store.dispatch(
//   //   upsertUserBillingInfoAction(
//   //     currentBillingInfo: storeInfo,
//   //   ),
//   // );
// }

// // TODO(lampian): confirm CustomerInfo replacing PurchaserInfo
// //Future renewSubscription(Store<AppState> store, revCat.PurchaserInfo purchaser,
// Future renewSubscription(
//   Store<AppState> store,
//   rev_cat.CustomerInfo purchaser,
//   Completer? completer,
// ) async {
//   // var packs = store.state.billingState.availablePackages!;

//   // var activeSub = purchaser.activeSubscriptions.first;
//   // var expiration = DateTime.parse(purchaser.latestExpirationDate!);

//   // //var package = packs.firstWhere((e) => e.offeringIdentifier == activeSub);
//   // // TODO(lampian): verify change from offering identifier to identifier
//   // var package = packs.firstWhere((e) => e.identifier == activeSub);

//   // try {
//   //   await _saveBillingEntry(
//   //     store: store,
//   //     storeProduct: package.storeProduct,
//   //     isTrial: false,
//   //     expirationDate: expiration,
//   //   );
//   //   completer?.complete();
//   // } catch (e) {
//   //   reportCheckedError(e, trace: StackTrace.current);

//   //   completer?.completeError(e);
//   // } finally {
//   //   store.dispatch(SetBillingLoadingAction(false));
//   // }
// }

// ThunkAction<AppState> setRevenueCatUserInfoAction({
//   required Business business,
// }) {
//   return (Store<AppState> store) async {
//     Future(() async {
//       var usrService = UserProfileService.fromStore(store);
//       var userProfile = await (usrService.getUserProfile());

//       rev_cat.Purchases.setAttributes({
//         '\$displayName': userProfile!.displayName!,
//         '\$email': userProfile.email!,
//         '\$phoneNumber': userProfile.mobileNumber!,
//         //"\$fcmTokens": pushToken,
//         'dateCreated': userProfile.dateCreated!.toIso8601String(),
//         'uid': userProfile.userId!,
//         'businessId': business.id!,
//         'businessName': business.displayName!,
//       });
//     });
//   };
// }

ThunkAction<AppState> upsertUserBillingInfoAction({
  Business? business,
  BillingStoreInfo? currentBillingInfo,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        //BMR REMOVED THIS LOGIC, DEAD CODE BUT MAKING LONG CALLS TO CLOUD FUNCTIONS!

        // if (business == null && currentBillingInfo == null) {
        //   throw Exception('Must have either business or billing info');
        // }

        // var billingService = BillingServiceCF.fromStore(store);
        // var shouldSave = true;

        // // fetch the billing from the database
        // if (currentBillingInfo == null) {
        //   currentBillingInfo =
        //       await billingService.getUserBillingInfo(business!.id);
        //   shouldSave = false;
        // }

        // // if no billing item exists, create a default
        // currentBillingInfo ??= BillingStoreInfo.create(
        //   business!.id,
        //   business.displayName,
        //   business.countryCode ?? 'ZA',
        // );

        // if (shouldSave) {
        //   billingService.saveBillingInfo(currentBillingInfo!);
        //   if (business != null &&
        //       store.state.billingState.billingSupported == true) {
        //     store.dispatch(setRevenueCatUserInfoAction(business: business));
        //   }
        // }

        // store.dispatch(SetBillingStoreInfoAction(currentBillingInfo));

        completer?.complete();
      } catch (e) {
        reportCheckedError(e);
      } finally {
        if (completer != null && (completer.isCompleted == false)) {
          completer.complete();
        }
      }
    });
  };
}

ThunkAction<AppState> updateBillingFromSubscription() {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        var res = await isSubscriptionValid();
        store.dispatch(SetBillingPaidStatusAction(res));
      } catch (e) {
        reportCheckedError(e);
      }
    });
  };
}

class SetBillingStoreInfoAction {
  BillingStoreInfo? value;

  SetBillingStoreInfoAction(this.value);
}

class ValidateSubscriptionAction {
  BillingStoreInfo? value;
  ValidateSubscriptionAction(this.value);
}

class SetBillingLoadingAction {
  bool value;

  SetBillingLoadingAction(this.value);
}

class UpdateBillingStoreInfoAction {
  BillingStoreInfo value;

  UpdateBillingStoreInfoAction(this.value);
}

class SetBillingPurchaseAction {
  double? amount;
  String? license;

  SetBillingPurchaseAction(this.amount, this.license);
}

class SetBillingPaidStatusAction {
  bool isPaid;

  SetBillingPaidStatusAction(this.isPaid);
}

// class SetStoreOfferingsAction {
//   rev_cat.Offerings value;

//   SetStoreOfferingsAction(this.value);
// }

class SetBillingSupportedAction {
  bool value;

  SetBillingSupportedAction(this.value);
}

class SetShowBillingPageAction {
  bool value;

  SetShowBillingPageAction(this.value);
}
