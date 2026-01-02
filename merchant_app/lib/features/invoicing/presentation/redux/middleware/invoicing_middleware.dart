import 'package:littlefish_merchant/features/invoicing/datasource/invoicing_data_source.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/redux/actions/invoicing_actions.dart';
import 'package:redux/redux.dart';

import '../../../../../injector.dart';
import '../../../../../redux/app/app_state.dart';
import '../../../../../shared/exceptions/general_error.dart';

List<Middleware<AppState>> invoicingMiddleware() {
  return [
    TypedMiddleware<AppState, LoadInvoicesAction>(_loadInvoices()).call,
    TypedMiddleware<AppState, LoadMoreInvoicesAction>(_loadMoreInvoices()).call,
  ];
}

Middleware<AppState> _loadInvoices() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);
    store.dispatch(SetInvoicesLoadingAction(true));

    try {
      final businessId = store.state.currentBusinessId ?? '';

      final links = await getIt<InvoicingDataSource>().fetchInvoices(
        businessId: businessId,
      );

      //store.dispatch(LoadInvoicesSuccessAction(links));
    } catch (error) {
      store.dispatch(
        LoadInvoicesFailureAction(
          GeneralError(
            message: 'Failed to fetch invoices.',
            methodName: 'invoicesMiddleware: _loadInvoices',
            error: error,
          ),
        ),
      );
    } finally {
      store.dispatch(SetInvoicesLoadingAction(false));
    }
  };
}

Middleware<AppState> _loadMoreInvoices() {
  return (Store<AppState> store, action, NextDispatcher next) async {
    next(action);

    store.dispatch(SetInvoicesLoadingAction(true));

    try {
      final businessId = store.state.currentBusinessId ?? '';

      if (action.offset == 0) {
        store.dispatch(ResetInvoicesStateAction());
      }

      final result = await getIt<InvoicingDataSource>().fetchInvoicesPaginated(
        businessId: businessId,
        offset: action.offset,
        limit: action.limit,
      );

      store.dispatch(
        AppendInvoicesSuccessAction(
          result.items,
          action.offset + result.items.length,
          result.totalRecords,
        ),
      );
    } catch (error) {
      store.dispatch(
        LoadInvoicesFailureAction(
          GeneralError(
            message: 'Failed to fetch payment links.',
            methodName: '_loadMorePaymentLinks',
            error: error,
          ),
        ),
      );
    } finally {
      store.dispatch(SetInvoicesLoadingAction(false));
    }
  };
}
