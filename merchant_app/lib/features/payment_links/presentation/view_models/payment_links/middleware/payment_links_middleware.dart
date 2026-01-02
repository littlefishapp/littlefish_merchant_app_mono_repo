import 'package:littlefish_core_utils/httpErrors/models/api_error.dart';
import 'package:littlefish_merchant/features/payment_links/data/datasource/payment_links_data_source.dart';
import 'package:littlefish_merchant/features/payment_links/presentation/view_models/payment_links/actions/payment_links_actions.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/shared/exceptions/general_error.dart';
import 'package:redux/redux.dart';

// import your api error types
// import 'package:littlefish_merchant/models/security/authentication/api_error_exception.dart';

List<Middleware<AppState>> paymentLinkMiddleware() {
  return [
    TypedMiddleware<AppState, LoadPaymentLinksAction>(_loadPaymentLinks()).call,
    TypedMiddleware<AppState, LoadMorePaymentLinksAction>(
      _loadMorePaymentLinks(),
    ).call,
  ];
}

Middleware<AppState> _loadPaymentLinks() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    store.dispatch(SetPaymentLinksLoadingAction(true));

    try {
      final businessId = store.state.currentBusinessId ?? '';

      final links = await getIt<PaymentLinksDataSource>().fetchPaymentLinks(
        businessId: businessId,
      );

      store.dispatch(
        LoadPaymentLinksSuccessAction(links, links.length, links.length),
      );
    }
    // 👇 new: show backend’s structured error
    on ApiErrorException catch (e) {
      store.dispatch(
        LoadPaymentLinksFailureAction(
          GeneralError(
            message: e.error.userMessage,
            methodName: 'paymentLinkMiddleware: _loadPaymentLinks',
            error: e,
          ),
        ),
      );
    } catch (error) {
      store.dispatch(
        LoadPaymentLinksFailureAction(
          GeneralError(
            message: 'Failed to fetch payment links.',
            methodName: 'paymentLinkMiddleware: _loadPaymentLinks',
            error: error,
          ),
        ),
      );
    } finally {
      store.dispatch(SetPaymentLinksLoadingAction(false));
    }
  };
}

Middleware<AppState> _loadMorePaymentLinks() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    store.dispatch(SetPaymentLinksLoadingAction(true));

    try {
      final businessId = store.state.currentBusinessId ?? '';

      if (action.offset == 0) {
        store.dispatch(ResetPaymentLinksStateAction());
      }

      final result = await getIt<PaymentLinksDataSource>()
          .fetchPaymentLinksPaginated(
            businessId: businessId,
            offset: action.offset,
            limit: action.limit,
          );

      store.dispatch(
        AppendPaymentLinksSuccessAction(
          result.items,
          action.offset + result.items.length,
          result.totalRecords,
        ),
      );
    } on ApiErrorException catch (e) {
      store.dispatch(
        LoadPaymentLinksFailureAction(
          GeneralError(
            message: e.error.userMessage,
            methodName: 'paymentLinkMiddleware: _loadMorePaymentLinks',
            error: e,
          ),
        ),
      );
    } catch (error) {
      store.dispatch(
        LoadPaymentLinksFailureAction(
          GeneralError(
            message: 'Failed to fetch payment links.',
            methodName: 'paymentLinkMiddleware: _loadMorePaymentLinks',
            error: error,
          ),
        ),
      );
    } finally {
      store.dispatch(SetPaymentLinksLoadingAction(false));
    }
  };
}
