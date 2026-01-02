// Project imports:
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/reducer/order_transaction_history_reducer.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/redux/order_receipt_reducer.dart';
import 'package:littlefish_merchant/features/sell/presentation/redux/sell_reducer.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_reducer.dart';
import 'package:littlefish_merchant/redux/auth/auth_reducer.dart';
import 'package:littlefish_merchant/redux/business/business_reducer.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_reducer.dart';
import 'package:littlefish_merchant/redux/customer/customer_reducer.dart';
import 'package:littlefish_merchant/redux/discounts/discounts_reducer.dart';
import 'package:littlefish_merchant/redux/discounts/product_discount_reducer.dart';
import 'package:littlefish_merchant/redux/environment/environment_reducer.dart';
import 'package:littlefish_merchant/redux/expenses/expenses_reducer.dart';
import 'package:littlefish_merchant/redux/inventory/inventory_reducer.dart';
import 'package:littlefish_merchant/redux/invoice/invoice_reducer.dart';
import 'package:littlefish_merchant/redux/locale/locale_reducer.dart';
import 'package:littlefish_merchant/redux/permission/permission_reducer.dart';
import 'package:littlefish_merchant/redux/product/product_reducer.dart';
import 'package:littlefish_merchant/redux/promotions/promotions_reducer.dart';
import 'package:littlefish_merchant/redux/sales/sales_reducer.dart';
import 'package:littlefish_merchant/redux/search/search_reducer.dart';
import 'package:littlefish_merchant/redux/store/store_reducer.dart';
import 'package:littlefish_merchant/redux/suppliers/supplier_reducer.dart';
import 'package:littlefish_merchant/redux/system_data/system_data_reducer.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_reducer.dart';
import 'package:littlefish_merchant/redux/ui/ui_state_reducers.dart';
import 'package:littlefish_merchant/redux/user/user_reducer.dart';
import 'package:littlefish_merchant/redux/user_preferences/user_preferences_reducer.dart';
import 'package:littlefish_merchant/redux/workspaces/workspace_reducer.dart';

import '../../features/invoicing/presentation/redux/reducer/invoicing_reducer.dart';
import '../../features/store_switching/redux/reducer/business_store_reducer.dart';
import '../../features/payment_links/presentation/view_models/payment_links/reducer/payment_links_reducer.dart';
import '../device/device_reducer.dart';

AppState appReducer(AppState state, action) => state.rebuild((b) {
  b.authState.replace(authReducer(state.authState, action));
  b.environmentState.replace(
    environmentReducer(state.environmentState, action),
  );
  b.localeState.replace(localeReducer(state.localeState, action));
  b.userState.replace(userProfileReducer(state.userState, action));
  b.storeState.replace(storeReducer(state.storeState, action));
  b.businessState.replace(businessProfileReducer(state.businessState, action));

  b.productState.replace(productReducer(state.productState, action));
  b.customerstate.replace(customerReducer(state.customerstate, action));
  b.checkoutState.replace(checkoutReducer(state.checkoutState, action));
  b.appSettingsState.replace(
    appSettingsReducer(state.appSettingsState, action),
  );

  b.inventoryState.replace(inventoryReducer(state.inventoryState, action));

  b.promotionsState.replace(promotionsReducer(state.promotionsState, action));

  b.userPreferencesState.replace(
    userPreferenceReducer(state.userPreferencesState, action),
  );

  b.uiState.replace(uiStateReducer(state.uiState, action));

  b.supplierState.replace(suppliersReducer(state.supplierState, action));

  b.invoiceState.replace(invoiceReducer(state.invoiceState, action));

  b.salesState.replace(salesReducer(state.salesState, action));

  b.expensesState.replace(expensesReducer(state.expensesState, action));

  b.discountState.replace(discountReducer(state.discountState, action));

  b.productDiscountState.replace(
    productDiscountReducer(state.productDiscountState, action),
  );

  b.systemDataState.replace(systemDataReducer(state.systemDataState, action));

  b.ticketState.replace(ticketsReducer(state.ticketState, action));

  // b.billingState.replace(billingReducer(state.billingState, action));
  b.searchState.replace(searchReducer(state.searchState, action));
  b.workspaceState.replace(workspacesReducer(state.workspaceState, action));
  b.permissionState.replace(permissionReducer(state.permissionState, action));
  b.sellState.replace(sellReducer(state.sellState, action));
  b.orderTransactionHistoryState.replace(
    orderTransactionHistoryReducer(state.orderTransactionHistoryState, action),
  );
  b.orderReceiptState.replace(
    orderReceiptReducer(state.orderReceiptState, action),
  );
  b.deviceState.replace(deviceReducer(state.deviceState, action));
  b.businessStoreState.replace(
    businessStoreReducer(state.businessStoreState, action),
  );
  b.paymentLinksState.replace(
    paymentLinkReducer(state.paymentLinksState, action),
  );
  b.invoicingState.replace(invoicingReducer(state.invoicingState, action));
});
