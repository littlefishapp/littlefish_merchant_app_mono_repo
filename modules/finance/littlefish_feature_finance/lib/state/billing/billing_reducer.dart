// // Package imports:
// // removed ignore: depend_on_referenced_packages
// import 'package:redux/redux.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// // Project imports:
// import 'package:littlefish_merchant/redux/billing/billing_actions.dart';
// import 'package:littlefish_merchant/redux/billing/billing_state.dart';

// final billingReducer = combineReducers<BillingState>([
//   TypedReducer<BillingState, SetBillingStoreInfoAction>(
//     onSetBillingStoreInfoAction,
//   ).call,
//   TypedReducer<BillingState, SetBillingPurchaseAction>(
//     onSetBillingPurchaseAction,
//   ).call,
//   TypedReducer<BillingState, UpdateBillingStoreInfoAction>(
//     onUpdateBillingPurchaseAction,
//   ).call,
//   TypedReducer<BillingState, SetBillingPaidStatusAction>(
//     onSetBillingPaidStatusAction,
//   ).call,
//   TypedReducer<BillingState, SetBillingLoadingAction>(
//     onSetBillingLoadingAction,
//   ).call,
//   TypedReducer<BillingState, SetStoreOfferingsAction>(
//     onSetStoreOfferingsAction,
//   ).call,
//   TypedReducer<BillingState, SetShowBillingPageAction>(
//     onSetShowBillingPageAction,
//   ).call,
//   TypedReducer<BillingState, SetBillingSupportedAction>(
//     onSetBillingSupportedAction,
//   ).call,
// ]);

// BillingState onSetBillingPurchaseAction(
//   BillingState state,
//   SetBillingPurchaseAction action,
// ) {
//   return state.rebuild((b) {
//     b.billingStoreInfo!.lastPaymentAmount = action.amount;
//     b.billingStoreInfo!.currentLicense = action.license;
//   });
// }

// BillingState onSetBillingStoreInfoAction(
//   BillingState state,
//   SetBillingStoreInfoAction action,
// ) {
//   return state.rebuild((b) => b.billingStoreInfo = action.value);
// }

// BillingState onSetShowBillingPageAction(
//   BillingState state,
//   SetShowBillingPageAction action,
// ) {
//   if (action.value == false) {
//     SharedPreferences.getInstance().then((instance) {
//       var currentDate = DateTime.now().toUtc().millisecondsSinceEpoch;
//       instance.setInt('lastRun', currentDate);
//     });
//   }
//   return state.rebuild((b) => b.showBillingPage = action.value);
// }

// BillingState onSetBillingSupportedAction(
//   BillingState state,
//   SetBillingSupportedAction action,
// ) {
//   return state.rebuild((b) => b.billingSupported = action.value);
// }

// BillingState onSetBillingLoadingAction(
//   BillingState state,
//   SetBillingLoadingAction action,
// ) {
//   return state.rebuild((b) => b.isLoading = action.value);
// }

// BillingState onSetStoreOfferingsAction(
//   BillingState state,
//   SetStoreOfferingsAction action,
// ) {
//   return state.rebuild((b) => b.storeOfferings = action.value);
// }

// BillingState onSetBillingPaidStatusAction(
//   BillingState state,
//   SetBillingPaidStatusAction action,
// ) {
//   return state.rebuild((b) => b.billingStoreInfo!.isPaid = action.isPaid);
// }

// BillingState onUpdateBillingPurchaseAction(
//   BillingState state,
//   UpdateBillingStoreInfoAction action,
// ) {
//   return state.rebuild((b) => b.billingStoreInfo = action.value);
// }
