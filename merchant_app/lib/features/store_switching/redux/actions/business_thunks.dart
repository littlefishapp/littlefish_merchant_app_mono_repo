import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:littlefish_core_utils/httpErrors/models/api_error.dart';
import 'package:littlefish_merchant/services/api_authentication_service.dart';
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import '../../../../app/app.dart';
import '../../../../bootstrap.dart';
import '../../../../models/security/user/business_user_profile.dart';
import '../../../../redux/app/app_state.dart';
import '../../../../redux/auth/auth_actions.dart';
import '../../../../redux/business/business_actions.dart';
import '../../../../services/business_service.dart';
import '../../../../tools/exceptions/common_exceptions.dart';
import '../../../store_switching/presentation/pages/store_added_successfully.dart';
import 'business_actions.dart';
import 'package:collection/collection.dart';

const secureStorage = FlutterSecureStorage();

ThunkAction<AppState> createBusinessThunk(
  BusinessUserProfile value, {
  Completer? completer,
  required BuildContext context,
}) {
  return (Store<AppState> store) async {
    final service = BusinessService(
      store: store,
      baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
      token: store.state.authState.token,
      businessId: store.state.currentBusinessId,
    );

    store.dispatch(SetBusinessStoresLoadingAction(true));

    try {
      value = BusinessUserProfile(
        business: value.business,
        user: store.state.userProfile,
        password: value.password,
      );

      final businessResult = await service.createBusinessWithUser(value);
      final businessId = businessResult?.data['businessId'];
      final userId = businessResult?.data['userId'];

      final authService = ApiAuthenticationService(
        baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
        token: store.state.authState.token,
        store: store,
      );

      final savedRefreshToken = await secureStorage.read(key: 'refresh_token');

      if (savedRefreshToken == null || savedRefreshToken.isEmpty) {
        const errorMsg = 'Something went wrong, please log out and log in.';
        completer?.completeError(errorMsg);
        return;
      }

      final refreshClaims = await authService.refreshWithCustomClaims(
        store.state.authState.token,
        savedRefreshToken,
      );

      if (refreshClaims?.refreshToken != null &&
          refreshClaims!.refreshToken!.isNotEmpty) {
        await secureStorage.write(
          key: 'refresh_token',
          value: refreshClaims.refreshToken,
        );
      } else {
        const errorMsg = 'Something went wrong, please try again.';
        completer?.completeError(errorMsg);
        return;
      }

      store.dispatch(RefreshClaimsTokenAction(refreshClaims.accessToken));

      final matchedBusiness = refreshClaims.businesses?.firstWhereOrNull(
        (b) => b.id == businessId,
      );

      Future(() async {
        try {
          verifyHelper(
            verifiedResult: refreshClaims,
            store: store,
            context: context,
            navigateToSplashScreen: false,
            selectedBusinessId: businessId,
            business: matchedBusiness,
          );
        } catch (e) {
          reportCheckedError(e, trace: StackTrace.current);
          completer?.completeError(e);
        }
      });

      store.dispatch(SetBusinessListAction(refreshClaims.businesses));

      completer?.complete();

      await Navigator.pushAndRemoveUntil(
        globalNavigatorKey.currentContext!,
        MaterialPageRoute(
          builder: (_) => StoreAddedSuccessfully(
            profile: value,
            newBusiness: matchedBusiness,
            businessId: businessId,
            userId: userId,
          ),
        ),
        (_) => false,
      );
    } on ApiErrorException catch (e) {
      final msg = e.error.userMessage;
      store.dispatch(BusinessProfileLoadFailure(msg));
      completer?.completeError(
        AuthorizationException('unable to refresh session', msg),
      );
      reportCheckedError(e, trace: StackTrace.current);
    } catch (e, stack) {
      store.dispatch(BusinessProfileLoadFailure(e.toString()));
      completer?.completeError(e, stack);
    } finally {
      store.dispatch(SetBusinessStoresLoadingAction(false));
    }
  };
}
