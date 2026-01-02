import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/features/pos/data/data_source/pos_service.dart';
import 'package:littlefish_merchant/features/pos/presentation/view_model/pos_pay_view_model.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/product/product_reducer.dart';
import 'package:littlefish_merchant/services/accounts_service.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/linked_acounts_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/utils/linked_account_utils.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';

late AccountsService accountsService;

ThunkAction<AppState> updateLinkedAccount() {
  return (Store<AppState> store) async {
    Future(() async {
      _initializeService(store);

      store.dispatch(loadBusinessProfile(refresh: true));

      PosPayVM payVM = PosPayVM.fromStore(store);
      await payVM.updateLinkedAccount();
      debugPrint('Linked account updated');
    });
  };
}

_initializeService(Store<AppState> store) {
  accountsService = AccountsService(
    store: store,
    baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
    token: store.state.authState.token,
    businessId: store.state.currentBusinessId,
  );
}

ThunkAction<AppState> registerProviderMerchantAction({
  required String providerName,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      store.dispatch(SetBusinessStateLoadingAction(true));
      PosService service = PosService.fromStore(store: store);

      try {
        var result = await service.enrollProviderMerchant(
          providerName: providerName,
        );

        store.dispatch(updateLinkedAccount());

        store.dispatch(SetBusinessStateLoadingAction(false));
        BuildContext? context = globalNavigatorKey.currentContext;
        if (context != null) {
          await showMessageDialog(
            context,
            'You have been successfully registered with ${LinkedAccountUtils.cleanUpProviderName(providerName)}.',
            Icons.check_circle,
          );

          Navigator.of(context).popUntil(
            (route) => route.settings.name == LinkedAccountsPage.route,
          );
        }
      } on PlatformException catch (e) {
        store.dispatch(SetBusinessStateLoadingAction(false));
        logger.error(
          'RegisterProviderMerchantAction',
          'Error enrolling provider merchant: $e',
          error: e.message,
          stackTrace: StackTrace.current,
        );
        BuildContext? context = globalNavigatorKey.currentContext;
        if (context != null) {
          await showMessageDialog(
            context,
            'Could not register with $providerName. Please try again later.\n${e.message}',
            LittleFishIcons.error,
          );
        }
        debugPrint('Error enrolling provider merchant: $e');
        rethrow;
      } catch (e) {
        store.dispatch(SetBusinessStateLoadingAction(false));
        logger.error(
          'RegisterProviderMerchantAction',
          'Error enrolling provider merchant: $e',
          error: e,
          stackTrace: StackTrace.current,
        );
        BuildContext? context = globalNavigatorKey.currentContext;
        if (context != null) {
          await showMessageDialog(
            context,
            'Could not register with $providerName. Please try again later.\nError: ${e.toString()}',
            LittleFishIcons.error,
          );
        }
        debugPrint('Error enrolling provider merchant: $e');
        rethrow;
      }
    });
  };
}
