// // removed ignore: depend_on_referenced_packages
// import 'package:redux/redux.dart' as rx;

// import 'package:littlefish_merchant/redux/app/app_state.dart';

// class BillingMiddleware extends rx.MiddlewareClass<AppState> {
//   @override
//   void call(rx.Store<AppState> store, action, rx.NextDispatcher next) async {
//     next(action);

//     // if (action is LogonFirebaseSuccessAction) {
//     //   try {
//     //     if (store.state.billingState.billingSupported == true) {
//     //       await Purchases.logIn(action.user!.uid);
//     //     }
//     //   } catch (e) {
//     //     reportCheckedError(e);
//     //   }
//     // }

//     // if (action is UserProfileLoadedAction) {
//     //   var profile = action.value;

//     //   if (profile != null &&
//     //       store.state.billingState.billingSupported == true) {
//     //     Purchases.setAttributes({
//     //       '\$email': profile.email!,
//     //       '\$displayName': profile.displayName ?? '',
//     //       '\$phoneNumber': profile.mobileNumber ?? '',
//     //       'uid': profile.userId!,
//     //     });
//     //   }
//     // }

//     // if (action is BusinessProfileLoadedAction) {
//     //   var profile = action.value;

//     //   if (profile != null &&
//     //       store.state.billingState.billingSupported == true) {
//     //     Purchases.setAttributes({
//     //       'businessId': profile.id!,
//     //       'businessName': profile.name ?? '',
//     //     });
//     //   }
//     // }

//     // if (action is SetBusinessListAction) {
//     //   var result = action.value;

//     //   //ToDo: need to determine the correct action here or assume that no business has been registered yet?
//     //   if (result == null || result.isEmpty) return;

//     //   store.dispatch(
//     //     upsertUserBillingInfoAction(
//     //       business: result.first,
//     //       completer: actionCompleter(globalNavigatorKey.currentContext, () {
//     //         if (store.state.billingState.billingSupported == true) {
//     //           store.dispatch(updateBillingFromSubscription());
//     //         }
//     //       }),
//     //     ),
//     //   );

//     //   //var currBusiness = result.first;
//     //   //try {

//     //   // var purchaser = await revCat.Purchases.getPurchaserInfo();

//     //   // littlefish_pos_professional_1_month

//     //   // lllllll@gmail.com

//     //   //} catch (e) {
//     //   //  reportCheckedError(e);
//     //   // }
//     // }

//     //   if (action is SetBillingStoreInfoAction ||
//     //       action is ValidateSubscriptionAction) {
//     //     var billingInfo = action.value!;

//     //     var billingService = BillingServiceCF.fromStore(store);
//     //     var validSubscription = await isSubscriptionValid();
//     //     if (validSubscription || billingInfo.overrideSubscription == true) {
//     //       billingInfo.isPaid = true;
//     //     } else {
//     //       billingInfo.isPaid = false;
//     //     }

//     //     billingInfo.lastCheckedDate = DateTime.now().toUtc();

//     //     if (billingInfo.syncedToRevenueCat != true) {
//     //       // setRevenueCatUserInfoAction(business: currBusiness);

//     //       // billingInfo.syncedToRevenueCat = true;
//     //     }

//     //     billingService.saveBillingInfo(billingInfo);
//     //     store.dispatch(UpdateBillingStoreInfoAction(billingInfo));
//     //   }
//   }
// }
