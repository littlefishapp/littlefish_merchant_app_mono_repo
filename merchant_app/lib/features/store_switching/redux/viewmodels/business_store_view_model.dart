import 'dart:async';
import 'package:flutter/material.dart';
import 'package:littlefish_core_utils/httpErrors/models/api_error.dart';
import 'package:littlefish_merchant/features/store_switching/redux/actions/business_thunks.dart';
import 'package:littlefish_merchant/models/security/user/business_user_profile.dart';
import 'package:littlefish_merchant/services/api_authentication_service.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:redux/redux.dart';

import '../../../../app/custom_route.dart';
import '../../../../common/view_models/store_collection_viewmodel.dart';
import '../../../../injector.dart';
import '../../../../models/security/authentication/activation_option.dart';
import '../../../../redux/app/app_state.dart';
import '../../../../redux/app/app_actions.dart';
import '../../../../redux/auth/auth_actions.dart';
import '../../../../redux/business/business_actions.dart';
import '../../../../redux/checkout/checkout_actions.dart';
import '../../../../redux/store/store_actions.dart';
import '../../../../ui/checkout/layouts/library/select_products_page.dart';
import '../../../../ui/home/home_page.dart';
import '../../model/business_store.dart';
import '../actions/business_actions.dart';
import '../state/business_store_state.dart';

class BusinessStoreViewModel
    extends StoreCollectionViewModel<BusinessStore, BusinessStoreState> {
  BusinessStoreViewModel.fromStore(
    Store<AppState> store, {
    BuildContext? context,
  }) : super.fromStore(store, context: context);

  late void Function(
    BuildContext context,
    BusinessStore businessStore,
    void Function(bool) setLoading,
    Completer? completer,
  )
  selectAndNavigateStore;

  late void Function(
    BusinessUserProfile profile,
    BuildContext context, {
    Completer? completer,
  })
  registerBusinessThunk;

  late Future<ActivationOption?> Function(List<String>) getActivationOptions;
  late void Function(
    BuildContext context,
    String merchantId,
    VoidCallback onFailure,
  )
  midLookup;

  late Future<Map<String, dynamic>> Function(
    BuildContext context,
    String merchantId,
  )
  merchantLookup;

  bool get isStoreLoading => state?.isLoading ?? false;

  void setBusinessStoresLoading(bool value) {
    store?.dispatch(SetBusinessStoresLoadingAction(value));
  }

  List<BusinessStore> filteredStores(String searchText) {
    if (searchText.isEmpty) return items ?? [];
    return items!.where((store) {
      final name = store.businessName?.toLowerCase() ?? '';
      final role = store.role?.toLowerCase() ?? '';
      return name.contains(searchText) || role.contains(searchText);
    }).toList();
  }

  @override
  loadFromStore(Store<AppState> store, {BuildContext? context}) {
    this.store = store;
    state = store.state.businessStoreState;
    isLoading = state?.isLoading;
    hasError = state?.hasError;

    items = state?.businessStores;

    onRefresh = () {
      store.dispatch(LoadBusinessesAction());
    };

    selectAndNavigateStore =
        (context, businessStore, setLoading, completer) async {
          store.dispatch(CheckoutClearAction(null));

          final businesses = store.state.businessState.businesses;
          if (businesses == null) {
            completer?.completeError('No businesses available in state.');
            return;
          }
          ;

          try {
            final matchingBusiness = businesses.firstWhere(
              (b) => b.id == businessStore.businessId,
            );

            store.dispatch(SetSelectedBusinessAction(matchingBusiness));
            store.dispatch(SetUserAccessPermissions(store.state.permissions));
            store.dispatch(setCurrentStore(matchingBusiness.id));

            final completer = Completer();
            setLoading(true);
            store.dispatch(
              appInitialize(
                countryCode: null,
                completer: completer,
                isActivation: true,
              ),
            );

            await completer.future;

            setLoading(false);
            Navigator.of(
              context,
            ).pushReplacement(CustomRoute(builder: (_) => SellPage()));
          } catch (e) {
            setLoading(false);
            completer?.completeError(
              'No matching business found for ID: ${businessStore.businessId}',
            );
          }
        };

    registerBusinessThunk = (profile, context, {Completer? completer}) {
      store.dispatch(
        createBusinessThunk(profile, completer: completer, context: context),
      );
    };

    getActivationOptions = (options) async {
      final authService = ApiAuthenticationService(
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        store: store,
      );
      try {
        return await authService.getActivationOptions(options, encodeToken());
      } on ApiErrorException catch (e) {
        // surface backend message to UI layer if needed
        store.dispatch(AuthSetErrorAction(true, e.error.userMessage));
        return Future.error(e.error.userMessage);
      }
    };

    midLookup = (context, merchantId, VoidCallback onFailure) {
      store.dispatch(
        createActivation(
          merchantId: merchantId,
          userLoggedIn: true,
          onFailure: onFailure,
          isActivation: false,
        ),
      );
    };

    merchantLookup = (context, merchantId) async {
      final completer = Completer<Map<String, dynamic>>();

      store.dispatch(
        hasMerchantBeenActivated(
          merchantId: merchantId,
          onResult: (result) {
            completer.complete(result);
          },
        ),
      );

      return completer.future;
    };
  }
}
