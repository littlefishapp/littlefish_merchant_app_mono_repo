// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:built_value/built_value.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:littlefish_auth/littlefish_auth_manager.dart';
import 'package:littlefish_core/auth/models/auth_user.dart';
import 'package:littlefish_core/business/models/business.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/domain/entity/square_button_entity.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config_entity.dart';

// Project imports:
import 'package:littlefish_merchant/environment/environment_config.dart';
import 'package:littlefish_merchant/features/order_refund/redux/state/order_refund_state.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/state/order_transaction_history_state.dart';
import 'package:littlefish_merchant/features/receipt_common/presentation/redux/order_receipt_state.dart';
import 'package:littlefish_merchant/models/billing/billing_info.dart';
import 'package:littlefish_merchant/models/billing/pos_store_license.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/cashback_requirements.dart';
import 'package:littlefish_merchant/models/sales/checkout/withdraw_requirements.dart';

import 'package:littlefish_merchant/models/security/user/user_profile.dart';

import 'package:littlefish_merchant/redux/app_settings/app_settings_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_state.dart';
import 'package:littlefish_merchant/redux/billing/billing_state.dart';
import 'package:littlefish_merchant/redux/business/business_state.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_state.dart';
import 'package:littlefish_merchant/redux/customer/customer_state.dart';
import 'package:littlefish_merchant/redux/discounts/discounts_state.dart';
import 'package:littlefish_merchant/redux/discounts/product_discount_state.dart';
import 'package:littlefish_merchant/redux/environment/environment_state.dart';
import 'package:littlefish_merchant/redux/expenses/expenses_state.dart';
import 'package:littlefish_merchant/redux/inventory/inventory_state.dart';
import 'package:littlefish_merchant/redux/invoice/invoice_state.dart';
import 'package:littlefish_merchant/redux/locale/locale_state.dart';
import 'package:littlefish_merchant/redux/permission/permission_state.dart';
import 'package:littlefish_merchant/redux/product/product_state.dart';
import 'package:littlefish_merchant/redux/promotions/promotions_state.dart';
import 'package:littlefish_merchant/redux/sales/sales_state.dart';
import 'package:littlefish_merchant/redux/search/search_state.dart';
import 'package:littlefish_merchant/redux/store/store_state.dart';
import 'package:littlefish_merchant/redux/suppliers/supplier_state.dart';
import 'package:littlefish_merchant/redux/system_data/system_data_state.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_state.dart';
import 'package:littlefish_merchant/redux/ui/ui_state.dart';
import 'package:littlefish_merchant/redux/user/user_state.dart';
import 'package:littlefish_merchant/redux/user_preferences/user_preferences_state.dart';
import 'package:littlefish_merchant/redux/workspaces/workspace_state.dart';
import 'package:littlefish_merchant/tools/converters/iso_date_time_converter.dart';
import 'package:littlefish_merchant/ui/business/organisation/organisation_info/organisation_info.dart';

import '../../features/invoicing/presentation/redux/state/invoicing_state.dart';
import '../../features/payment_links/presentation/view_models/payment_links/state/payment_link_state.dart';
import '../../features/sell/presentation/redux/sell_state.dart';
import '../../features/store_switching/redux/state/business_store_state.dart';
import '../device/device_state.dart';

part 'app_state.g.dart';

@immutable
@JsonSerializable()
@IsoDateTimeConverter()
abstract class AppState implements Built<AppState, AppStateBuilder> {
  const AppState._();

  factory AppState({
    AuthProviderType authProviderType = AuthProviderType.systemDefault,
  }) => _$AppState._(
    authState: AuthState(),
    environmentState: EnvironmentState(),
    localeState: LocaleState(),
    businessState: BusinessState(),
    userState: UserState(),
    productState: ProductState(),
    customerstate: CustomerState(),
    checkoutState: CheckoutState(transactionNumber: -1),
    appSettingsState: AppSettingsState(),
    inventoryState: InventoryState(),
    promotionsState: PromotionsState(),
    userPreferencesState: UserPreferencesState(),
    uiState: UIState(),
    supplierState: SupplierState(),
    invoiceState: InvoiceState(),
    salesState: SalesState(),
    expensesState: ExpensesState(),
    discountState: DiscountState(),
    // hardwareState: HardwareState(),
    ticketState: TicketState(),
    productDiscountState: ProductDiscountState(),
    billingState: BillingState(),
    storeState: StoreState(),
    systemDataState: SystemDataState(),
    searchState: SearchState(),
    workspaceState: WorkspaceState(),
    permissionState: PermissionState(),
    sellState: SellState(),
    orderTransactionHistoryState: OrderTransactionHistoryState(),
    deviceState: DeviceState(),
    refundOrderState: RefundOrderState(),
    orderReceiptState: OrderReceiptState(),
    paymentLinksState: PaymentLinksState(),
    businessStoreState: BusinessStoreState(),
    invoicingState: InvoicingState(),
  );

  @nullable
  AppEnvironment? get environment => environmentState.environment;

  AuthState get authState;

  @JsonKey(includeFromJson: false, includeToJson: false)
  EnvironmentState get environmentState;

  SystemDataState get systemDataState;

  SellState get sellState;

  OrderReceiptState get orderReceiptState;

  PaymentLinksState get paymentLinksState;

  InvoicingState get invoicingState;

  OrderTransactionHistoryState get orderTransactionHistoryState;

  BusinessStoreState get businessStoreState;

  EnvironmentConfig? get envConfig => environmentState.environmentConfig;

  LocaleState get localeState;

  UserState get userState;

  PermissionState get permissionState;

  BusinessState get businessState;

  BillingState get billingState;

  ProductState get productState;

  TicketState get ticketState;

  StoreState get storeState;

  CustomerState get customerstate;

  CheckoutState get checkoutState;

  AppSettingsState get appSettingsState;

  InventoryState get inventoryState;

  PromotionsState get promotionsState;

  UserPreferencesState get userPreferencesState;

  SupplierState get supplierState;

  InvoiceState get invoiceState;

  StoreUIState get storeUIState => uiState.storeUIState;

  AuthUser? get authUser => authState.currentUser;

  bool get isNotPremium => storeBillingInfo!.isPaid ?? false;

  BillingStoreInfo? get storeBillingInfo => billingState.billingStoreInfo;

  ExpensesState get expensesState;

  SalesState get salesState;

  SearchState get searchState;

  WorkspaceState get workspaceState;

  RefundOrderState get refundOrderState;

  String? get uniqueSubdomin => storeState.store?.uniqueSubdomain;

  String? get shortenCatalogueUrl => storeState.store?.shortenCatalogueUrl;

  // @nullable
  // HardwareState get hardwareState;

  UIState get uiState;

  UserViewingMode? get viewMode => userState.viewMode;

  bool? get canChangeViewMode => userState.canChangeViewMode;

  bool? get showBilling => billingState.showBillingPage;

  Business? get defaultBusinss =>
      businessState.businesses != null && businessState.businesses!.isNotEmpty
      ? businessState.businesses!.first
      : null;

  DiscountState get discountState;

  ProductDiscountState get productDiscountState;

  DeviceState get deviceState;

  String? get appName => appSettingsState.appName;

  String? get organizationName => getOrganisationInfo().name;

  String? get version => appSettingsState.appVersion;

  String? get builderNumber => appSettingsState.buildNumber;

  EnvironmentConfig? get environmentSettings =>
      environmentState.environmentConfig;

  POSStoreLicense? get posLicense => environmentSettings!.posStoreLicense;

  List<String?>? get subscriptionKeys => environmentSettings!.subscriptionKeys;

  List<String?> get premiumRoutes {
    List<String?> routes = [];

    for (var element in posLicense!.modules!) {
      routes.addAll(
        element.premiumRoutes!
            .where((e) => e.enabled == true)
            .map((e) => e.name),
      );
    }

    return routes;
  }

  List<String?> get premiumActions {
    List<String?> actions = [];

    for (var element in posLicense!.modules!) {
      actions.addAll(
        element.premiumActions!
            .where((e) => e.enabled == true)
            .map((e) => e.name),
      );
    }

    return actions;
  }

  String? get businessId => businessState.businessId;

  UserPermissions? get permissions => businessState.businessPermissions;

  bool? get isLargeDisplay => environmentState.isLargeDisplay ?? false;

  String? get baseUrl => environmentState.environmentConfig?.baseUrl;

  String? get paymentsUrl => environmentState.environmentConfig?.paymentsUrl;

  String? get paymentLinksPayUrl =>
      environmentState.environmentConfig?.paymentLinksPayUrl;

  String? get reportsUrl => environmentState.environmentConfig?.reportingUrl;

  String? get financeUrl => environmentState.environmentConfig?.financingingUrl;
  String? get clientSupportEmail =>
      environmentState.environmentConfig?.clientSupportEmail;
  String? get clientSupportMobileNumber =>
      environmentState.environmentConfig?.clientSupportMobileNumber;
  String? get softPosProviderName =>
      environmentState.environmentConfig?.softPosProviderName;
  String get customPaymentLinksBannerMessage =>
      environmentState.environmentConfig?.customPaymentLinksBannerMessage ?? '';
  String get customStoreReviewMessage =>
      environmentState.environmentConfig?.customStoreReviewMessage ?? '';
  bool? get financeEnabled =>
      environmentState.environmentConfig?.financeEnabled;

  bool? get enablePrintLastReceipt =>
      environmentState.environmentConfig?.enablePrintLastReceipt ?? false;

  bool? get enableBalanceEnquiry =>
      environmentState.environmentConfig?.enableBalanceEnquiry ?? false;

  bool? get onlineStoreEnabled =>
      environmentState.environmentConfig?.onlineStoreSettings?.enableStore ??
      false;

  bool? get enableGetPaid =>
      environmentState.environmentConfig?.enableGetPaid ?? false;

  bool? get enablePaymentLinks =>
      environmentState.environmentConfig?.enablePaymentLinks ?? false;

  bool? get enableInvoices =>
      environmentState.environmentConfig?.enableInvoices ?? false;

  int get slowNetworkNotificationInterval =>
      environmentState.environmentConfig?.slowNetworkNotificationInterval ??
      1; // in minutes

  int get merchantIdLength =>
      environmentState.environmentConfig?.merchantIdLength ?? 10;

  bool get configEnableSlowNetworkCheck =>
      environmentState.environmentConfig?.configEnableSlowNetworkCheck ?? false;

  bool? get enableOnlineStore =>
      environmentState.environmentConfig?.enableOnlineStore;

  bool get enableProductVarianceManagement =>
      environmentState.environmentConfig?.enableProductVarianceManagement ??
      false;

  String? get guestTimeOut =>
      environmentState.environmentConfig?.guestUserTimeout ?? '1D';
  bool? get enableStoreSetupV2 =>
      environmentState.environmentConfig?.enableStoreSetupV2;
  bool? get enableFinance => environmentState.environmentConfig?.enableFinance;
  bool? get enableTax => environmentState.environmentConfig?.enableTax;
  bool? get enableStoreCredit =>
      environmentState.environmentConfig?.enableStoreCredit;
  bool? get enableFinancialStatements =>
      environmentState.environmentConfig?.enableFinancialStatements ?? false;
  bool? get enableContactUs =>
      environmentState.environmentConfig?.enableContactUs;
  bool? get enableUserGuide =>
      environmentState.environmentConfig?.enableUserGuide;
  bool? get enableEmployee =>
      environmentState.environmentConfig?.enableEmployee;
  bool? get enableStaffSales =>
      environmentState.environmentConfig?.enableStaffSales;
  bool? get enableFulfilment =>
      environmentState.environmentConfig!.enableFulfilment;
  bool? get enableTips => environmentState.environmentConfig!.enableTips;
  List<double>? get presetCheckoutTipPercentages =>
      environmentState.environmentConfig!.presetCheckoutTipPercentages ?? [];
  bool? get enableAdvancedReporting => false;
  //environmentState.environmentConfig?.enableAdvancedReporting;
  bool? get enableUsers => environmentState.environmentConfig?.enableUsers;
  bool? get enableKYC => environmentState.environmentConfig?.enableKYC;
  List<double>? get presetDiscountPercentages =>
      environmentState.environmentConfig?.presetDiscountPercentages ?? [];
  bool? get enableDiscounts =>
      environmentState.environmentConfig?.enableDiscounts;
  bool? get enableDiscountSettings =>
      environmentState.environmentConfig?.enableDiscountSettings;
  bool? get enableProductDiscounts =>
      environmentState.environmentConfig?.enableProductDiscounts;
  bool? get enableGetStarted =>
      environmentState.environmentConfig?.enableGetStarted;
  bool? get enablePendingTransactions =>
      environmentState.environmentConfig?.enablePendingTransactions;
  bool? get enableCheckoutFavourites =>
      environmentState.environmentConfig?.enableCheckoutFavourites;
  bool? get enableBottomBarHamburgerMenu =>
      environmentState.environmentConfig?.enableBottomBarHamburgerMenu;
  bool? get enableSellNowInFavourites =>
      environmentState.environmentConfig?.enableSellNowInFavourites;
  bool get enableTerminalReportFiltering =>
      environmentState.environmentConfig?.enableTerminalReportFiltering ??
      false;

  EnableOption get enableVoidSale =>
      environmentState.environmentConfig?.enableVoid ?? EnableOption.disabled;
  bool? get enableUsePosMerchantName =>
      environmentState.environmentConfig?.enableUsePosMerchantName ?? false;
  bool? get enablesuppliersModule =>
      environmentState.environmentConfig?.enableSuppliersModule;
  bool? get enableOverviewInFavourites =>
      environmentState.environmentConfig?.enableOverviewInFavourites;
  bool? get enableOnlyCashCardSnapscanPayments =>
      environmentState.environmentConfig?.enableOnlyCashCardSnapscanPayments ??
      false;
  bool? get enableCashback =>
      environmentState.environmentConfig?.enableCashback ?? false;
  bool? get enableWithdrawal =>
      environmentState.environmentConfig?.enableWithdrawal ?? false;
  bool? get socialMediaEnabled =>
      environmentState
          .environmentConfig
          ?.onlineStoreSettings
          ?.enableSocialMedia ??
      false;
  bool? get enableStock =>
      environmentState.environmentConfig?.enableStock ?? true;
  bool? get enableReceiveStock =>
      environmentState.environmentConfig?.enableReceiveStock ?? true;
  bool? get enableReceivedStock =>
      environmentState.environmentConfig?.enableReceivedStock ?? true;
  bool? get enableStockTake =>
      environmentState.environmentConfig?.enableStockTaking ?? true;
  bool? get enableCombos =>
      environmentState.environmentConfig?.enableCombos ?? true;
  bool? get enableSignup =>
      environmentState.environmentConfig?.enableSignup ?? true;
  bool? get enableGuestUser =>
      environmentState.environmentConfig?.enableGuestUser ?? true;
  bool? get enableSignupActivation =>
      environmentState.environmentConfig?.enableSignupActivation ?? true;
  String? get authorizationToken =>
      environmentState.environmentConfig?.authorizationToken ?? '';
  List<String> get activationOptions =>
      environmentState.environmentConfig?.activationOptions ?? [];
  bool? get enableOnboarding =>
      environmentState.environmentConfig?.enableOnboarding ?? true;
  bool? get enableDeleteAccountPage =>
      environmentState.environmentConfig?.enableDeleteAccountPage ?? false;
  String? get onlineStoreUrl =>
      environmentState.environmentConfig?.onlineStoreSettings?.baseUrl;
  bool? get enableSideNavDrawer =>
      environmentState.environmentConfig?.enableSideNavDrawer ?? false;
  bool? get enableBottomNavBar =>
      environmentState.environmentConfig?.enableBottomNavBar ?? true;
  bool? get enableProfileNavBar =>
      environmentState.environmentConfig?.enableProfileNavBar ?? false;
  bool? get instagramEnabled =>
      environmentState
          .environmentConfig
          ?.onlineStoreSettings
          ?.enableInstagram ??
      false;

  SquareButtonEntity get squareButtonConfig =>
      environmentState.environmentConfig?.squareButtonConfig ??
      const SquareButtonEntity();

  FormFieldConfigEntity get formFieldConfig =>
      environmentState.environmentConfig?.formFieldConfig ??
      const FormFieldConfigEntity();

  bool? get facebookEnabled =>
      environmentState.environmentConfig?.onlineStoreSettings?.enableFacebook ??
      false;

  bool? get googleEnabled =>
      environmentState.environmentConfig?.onlineStoreSettings?.enableGoogle ??
      false;

  bool? get enableLinkedDevices =>
      environmentState.environmentConfig?.enableLinkedDevices ?? true;

  bool? get enableGetApp =>
      environmentState.environmentConfig?.enableGetApp ?? false;

  bool? get enableHomeOnlineStoreCard =>
      environmentState.environmentConfig?.enableHomeOnlineStoreCard ?? true;

  int get softPosDeviceLimit =>
      environmentState.environmentConfig?.softPosDeviceLimit ?? 10;

  String? get token => authState.token;

  String get merchantID {
    return environmentState.environmentConfig?.merchantID ?? '';
  }

  String get mcc {
    return environmentState.environmentConfig?.mcc ?? '';
  }

  CashbackRequirements? get cashbackRequirements =>
      environmentState.environmentConfig?.cashbackRequirements;

  WithdrawRequirements? get withdrawRequirements =>
      environmentState.environmentConfig?.withdrawRequirements;

  List<double>? get cashbackAmountOptions =>
      environmentState.environmentConfig?.cashbackAmountOptions ?? [];
  List<double>? get withdrawalAmountOptions =>
      environmentState.environmentConfig?.withdrawalAmountOptions ?? [];

  bool? get enableOverviewHomePage =>
      environmentState.environmentConfig!.enableOverviewHomePage ?? false;

  //Hardware
  // Future<dynamic> get defaultPrinter async =>
  //     await hardwareState.defaultPrinter;
  bool get hasPrinters => false;

  @nullable
  bool? get hasInternet => environmentState.hasInternet;

  UserProfile? get userProfile => userState.profile;

  String? get userCountryCode => userProfile?.countryCode;

  AuthUser? get currentUser => authState.currentUser;

  LittlefishAuthManager get authManager => authState.authManager;

  String? get authenticationProvider => authState.signInProvider;

  bool get isCustomAuthentication => authenticationProvider == null
      ? false
      : authenticationProvider!.toLowerCase() == 'password';

  String? get currentBusinessId => businessState.businessId;

  HomeUIState? get homeUIState => uiState.homeUIState;

  AuthUIState? get authUIState => uiState.authUIState;

  EmployeesUIState? get employeeUiState => uiState.employeeUIState;

  BusinessUsersUIState? get businessUserUIState => uiState.businessUsersUIState;

  CustomerUIState? get customerUIState => uiState.customerUIState;

  TicketUIState? get ticketUIState => uiState.ticketUIState;

  SupplierUIState? get supplierUIState => uiState.supplierUIState;

  InventoryStockTakeUI? get stockTakeUI => uiState.stockTakeUI;

  InventoryRecievableUI? get stockRecievableUI => uiState.stockRecievableUI;

  ProductsUIState? get productsUIState => uiState.productsUIState;

  ModifierUIState? get modifierUIState => uiState.modifierUIState;

  CategoriesUIState? get categoriesUIState => uiState.categoriesUIState;

  CombosUIState? get combosUIState => uiState.combosUIState;

  InvoiceUIState? get invoiceUIState => uiState.invoiceUIState;

  BusinessExpensesUIState? get expensesUIState => uiState.expensesUIState;

  DiscountUIState? get discountUIState => uiState.discountUIState;

  // HardwareUIStateState get hardwareUIState => uiState.hardwareUIState;

  EnableOption get enableNewSale =>
      environmentState.environmentConfig?.enableNewSale ?? EnableOption.notSet;

  EnableOption get enableTransactions =>
      environmentState.environmentConfig?.enableTransactions ??
      EnableOption.notSet;

  EnableOption get enableTransactionsRefundSale =>
      environmentState.environmentConfig?.enableTransactionsRefundSale ??
      EnableOption.notSet;

  EnableOption get enableCustomerSalesRefundSales =>
      environmentState.environmentConfig?.enableCustomerSalesRefundSales ??
      EnableOption.notSet;

  factory AppState.fromJson(Map<String, dynamic> json) =>
      _$AppStateFromJson(json);

  Map<String, dynamic> toJson() => _$AppStateToJson(this);
}
