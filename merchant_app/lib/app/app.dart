// removed ignore: depend_on_referenced_packages
import 'dart:async';
import 'dart:io';
import 'package:back_button_interceptor/back_button_interceptor.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlefish_core/analytics/services/analytics_service.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core_utils/error/error_code_manager.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/app/theme/theme_factory.dart';

import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/pages/camera/barcode_helper.dart';
import 'package:littlefish_merchant/environment/environment_themes.dart';
import 'package:littlefish_merchant/features/errors/presentation/redux/error_middleware.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/bloc/linkeddevices_bloc.dart';
import 'package:littlefish_merchant/features/linked_devices/presentation/bloc/single_linked_device_bloc.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/redux/middleware/order_transaction_history_middleware.dart';
import 'package:littlefish_merchant/features/paywall/data/data_source/paywall_configuration.dart';
import 'package:littlefish_merchant/features/paywall/presentation/component/paywall_dialog.dart';
import 'package:littlefish_merchant/features/paywall/presentation/helper/paywall_route_configuration.dart';
import 'package:littlefish_merchant/features/paywall/presentation/pages/paywall_page.dart';
import 'package:littlefish_merchant/features/sell/presentation/redux/sell_middleware.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/models/device/interfaces/device_details.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/tax/sales_tax.dart';
import 'package:littlefish_merchant/redux/analytics/analytics_middleware.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_actions.dart';
import 'package:littlefish_merchant/redux/payments/payment_actions.dart';
import 'package:littlefish_merchant/redux/payments/payment_middleware.dart';
import 'package:littlefish_merchant/redux/product/product_middleware.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/tools/payment_types_helper/soft_pos_helper.dart';

import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:littlefish_merchant/ui/online_store/store_setup_v2/redux/middleware/online_store_middleware.dart';
import 'package:littlefish_payments/gateways/pos_payment_gateway.dart';
import 'package:littlefish_payments/models/shared/payment_gateway.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:redux_dev_tools/redux_dev_tools.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:littlefish_merchant/models/security/verification.dart';

import 'package:littlefish_merchant/app/app_routes.dart';
import 'package:littlefish_merchant/redux/app/app_reducer.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/auth/auth_middleware.dart';
import 'package:littlefish_merchant/redux/auth/auth_state.dart';
import 'package:littlefish_merchant/redux/business/business_state.dart';
import 'package:littlefish_merchant/redux/environment/environment_actions.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_middleware.dart';
import 'package:littlefish_merchant/redux/tickets/ticket_middleware.dart';
import 'package:littlefish_merchant/redux/ui/ui_state_actions.dart';

import 'package:littlefish_merchant/redux/user/user_state.dart';
import 'package:littlefish_merchant/singletons/connection_status_singleton.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/tools/persistors/local_storage_persistor.dart';
import 'package:littlefish_merchant/ui/business/profile/pages/business_profile_create_page.dart';
import 'package:littlefish_merchant/ui/home/home_page.dart';
import 'package:littlefish_merchant/ui/profile/user/pages/user_profile_create_page.dart';
import 'package:littlefish_merchant/ui/security/no_access/security_not_allowed_page.dart';
import 'package:littlefish_merchant/app/app_builder.dart';
import 'package:littlefish_merchant/app/custom_route.dart';

import '../bootstrap.dart';

import '../environment/environment_config.dart';

import '../features/invoicing/presentation/redux/middleware/invoicing_middleware.dart';
import '../features/payment_links/presentation/view_models/payment_links/middleware/payment_links_middleware.dart';
import '../features/receipt_common/presentation/redux/order_receipt_middleware.dart';
import '../features/store_switching/redux/middleware/business_store_middleware.dart';
import '../redux/checkout/checkout_actions.dart';
import '../redux/device/device_middleware.dart';
import '../services/route_service.dart';
import '../ui/security/login/landing_page.dart';
import '../ui/security/login/splash_page.dart';
import '../ui/initial/go_initial_page.dart';
import 'theme/app_theme_data.dart';

LittleFishCore core = LittleFishCore.instance;

ImagePicker imagePicker = ImagePicker();

List<CameraDescription> cameras = [];

class App extends StatefulWidget {
  final AppEnvironment environment;
  final AppState? initialState;
  final UserViewingMode initialViewingMode;
  final bool canChangeView;

  const App({
    Key? key,
    required this.environment,
    this.initialState,
    this.initialViewingMode = UserViewingMode.full,
    this.canChangeView = true,
  }) : super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<App> createState() => _AppState(initialState: initialState);
}

class _AppState extends State<App> {
  AppState? initialState;

  late Store<AppState> store;

  DevToolsStore<AppState>? devStore;

  LocalStoragePersistor? persistor;

  AnalyticsService get analyticsService => core.get<AnalyticsService>();

  bool _isSetup = false;

  bool deviceIntegritrySecure = false;

  List<AppThemeData> themes = [];

  _AppState({this.initialState});

  @override
  void initState() {
    BackButtonInterceptor.add(backButtonInterceptor);

    persistor ??= LocalStoragePersistor(
      throttleDuration: const Duration(seconds: 30),
    );

    //ToDo: remove this and put in the right place.
    availableCameras().then((value) {
      cameras = value;
    });

    super.initState();
  }

  @override
  void dispose() {
    BackButtonInterceptor.remove(backButtonInterceptor);
    super.dispose();
  }

  bool backButtonInterceptor(bool stopDefaultButtonEvent, RouteInfo info) {
    debugPrint('#### backButtonInterceptor called');
    final context = globalNavigatorKey.currentContext!;
    final hasPreviousRoute = Navigator.of(context).canPop();
    if (hasPreviousRoute) {
      debugPrint('#### backButtonInterceptor has previous route -> false');
      return false;
    }
    final modalService = getIt<ModalService>();
    RouteServiceDialog().showExitDialog(context, modalService).then((_) {
      debugPrint('#### backButtonInterceptor return from modal -> true');
      return true;
    });

    debugPrint('#### backButtonInterceptor has no previous route -> true');
    return true;
  }

  Store<AppState> _setupStore() {
    if (!_isSetup) {
      store = Store<AppState>(
        appReducer,
        initialState: initialState ?? AppState(),
        middleware: createSellMiddleware()
          ..addAll(createOrderTransactionHistoryMiddleware())
          ..addAll(createOrderReceiptMiddleware())
          ..addAll(paymentLinkMiddleware())
          ..addAll(invoicingMiddleware())
          ..addAll(createBusinessMiddleware())
          ..add(TokenRefreshMiddleware().call)
          ..add(OnlineStoreMiddleware().call)
          ..add(
            PushSaleMiddleware().call,
          ) //used to push offline sales captured to online instantly
          ..add(TicketMiddleware().call)
          ..add(AnalyticsMiddleware().call)
          ..add(AuthMiddleware().call)
          ..add(persistor!.createMiddleware())
          ..add(thunkMiddleware)
          ..add(ErrorMiddleware().call)
          ..add(PaymentsMiddleware().call)
          ..add(DeviceMiddleware().call)
          ..add(ProductMiddleware().call),
      );

      AppVariables.store = store;

      _isSetup = true;

      return store;
    } else {
      return store;
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreProvider<AppState>(
      store: _setupStore(),
      key: GlobalKey(),
      child: AppBuilder(
        builder: (ctx) {
          persistor!.load(store);

          configureBackgroundTasks(store);

          var instance = ConnectionStatusSingleton.getInstance();
          instance.initialize();

          //dispatch the initial connection status
          store.dispatch(SetInternetStatusAction(instance.hasConnection));

          //when online or offline this will trigger the UI to change
          bool hasAppInitialized =
              store.state.authState.hasAppInitialized ?? false;

          store.dispatch(SetEnvironmentAction(widget.environment));

          instance.connectionChange.listen((isOnline) {
            store.dispatch(
              onInternetStatusChanged(
                isOnline: isOnline,
                hasAppInitialized: hasAppInitialized,
              ),
            );
          });

          updateSslFingerPrint();

          final themes = EnvironmentThemes().fromFeatureFlags();
          final themeData = ThemeFactory().getTheme(
            context: context,
            theme: AppThemeType.light,
            language: 'en',
            appThemeDataList: themes,
          );

          return _app(context: ctx, store: store, theme: themeData);
        },
      ),
    );
  }

  void updateSslFingerPrint() {
    final core = LittleFishCore.instance;
    final configService = core.get<ConfigService>();
    final sslFingerprint = configService.getStringValue(
      key: 'config_settings_fingerprint',
      defaultValue: '',
    );
    if (sslFingerprint is String) {
      store.dispatch(SetSslFingerPrint(sslFingerprint.toLowerCase()));
    }
  }

  Widget _app({
    required BuildContext context,
    required Store<AppState> store,
    required ThemeData theme,
  }) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LinkedDevicesBloc>(
          create: (context) => LinkedDevicesBloc(),
        ),
        BlocProvider<SingleLinkedDeviceBloc>(
          create: (context) => SingleLinkedDeviceBloc(),
        ),
      ],
      child: MaterialApp(
        locale: const Locale('en', 'GB'),
        supportedLocales: const [Locale('en', 'GB')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        debugShowCheckedModeBanner: false,
        title: AppVariables.appName,
        navigatorKey: globalNavigatorKey,
        navigatorObservers: [
          analyticsService.observer,
          RouteService.instance.routeObserver,
        ],
        theme: theme,
        initialRoute: GoInitialPage.route,
        routes: baseRoutes(),
        onUnknownRoute: (route) {
          return CustomRoute(
            builder: (BuildContext context) {
              return const LandingPage();
            },
          );
        },
        onGenerateRoute: (route) {
          var authState = store.state.authState;

          if (!authState.isAuthenticated) {
            return CustomRoute(
              builder: (BuildContext context) {
                return const LandingPage();
              },
            );
          }

          if (route.name == SplashPage.route) return getRoute(authState, route);

          //the user profile applies for non-owners and owners
          if (updateUserProfile(context, store.state.userState)) {
            return navigateUserProfile();
          }

          //check the business profile first, understand that no users can be added unless the business profile is completed
          if (updateBusinessProfile(context, store.state.businessState)) {
            return navigateBusinessProfile(
              context,
              route,
              authState,
              store.state.userState,
            );
          }

          // if (versionCheck(context)) {
          //   return CustomRoute(
          //     builder: (BuildContext context) => VersionCheckScreen(context),
          //   );
          // }

          if (isNotPremium(route.name) &&
              AppVariables.store?.state.defaultBusinss != null) {
            return CustomRoute(
              builder: (BuildContext context) {
                return billingNavigationHelper(targetRoute: route.name);
              },
            );

            // showPopupDialog(context: context, content: billingNavigationHelper());
          } else {
            if (AppVariables.store?.state.showBilling == true &&
                !isPremium() &&
                AppVariables.store?.state.defaultBusinss != null &&
                route.arguments != 'from_upgrade' &&
                (route.name == HomePage.route ||
                    route.name == SellPage.route)) {
              return CustomRoute(
                builder: (BuildContext context) {
                  return billingNavigationHelper(
                    targetRoute: route.name,
                    skipNavigatesToRoute: true,
                  );
                },
              );
            }

            if (AppVariables.store?.state.showBilling == true &&
                !isPremium() &&
                AppVariables.store?.state.defaultBusinss != null &&
                route.arguments != 'from_upgrade' &&
                (route.name == HomePage.route ||
                    route.name == SellPage.route)) {
              return CustomRoute(
                builder: (BuildContext context) {
                  return billingNavigationHelper(
                    targetRoute: route.name,
                    skipNavigatesToRoute: true,
                  );
                },
              );
            }

            if (AppVariables
                        .store
                        ?.state
                        .businessState
                        .verificationStatus
                        ?.status !=
                    VerificationStatus.verified &&
                (AppVariables
                        .store
                        ?.state
                        .environmentSettings
                        ?.enableEnhancedOnboarding ??
                    false) &&
                AppVariables
                        .store
                        ?.state
                        .environmentSettings
                        ?.enhancedOnboardingRoutes !=
                    null) {
              if ((AppVariables
                      .store
                      ?.state
                      .environmentSettings!
                      .enhancedOnboardingRoutes!
                      .contains(route.name)) ??
                  false) {
                return CustomRoute(
                  builder: (BuildContext context) {
                    return getOnlineStorePage(
                      AppVariables
                              .store!
                              .state
                              .storeState
                              .store
                              ?.isConfigured ??
                          false,
                    );
                  },
                );
              }
            }

            if (PaywallRouteConfiguration.mustGuard(route.name)) {
              return CustomRoute(
                builder: (context) => _paywallGuard(context, route),
                settings: route,
              );
            }

            var newRoute = getRoute(authState, route);

            //this should consistently track the current user route
            store.dispatch(SetRouteAction(route.name));

            return newRoute;
          }
        },
      ),
    );
  }

  Widget _paywallGuard(BuildContext parentContext, RouteSettings settings) {
    return Builder(
      builder: (BuildContext context) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          PaywallDialog(
            ldFlag: invoicesLDFlag,
            onAccept: (onAcceptContext) {
              PaywallRouteConfiguration.accept(settings.name);
              globalNavigatorKey.currentState?.pushReplacementNamed(
                settings.name ?? '',
                arguments: settings.arguments,
              );
            },
            onCancel: (onCancelContext) {
              Navigator.of(onCancelContext).pop();
            },
          ).showActivationDialog(context);
        });

        return const PaywallPage();
      },
    );
  }

  bool updateBusinessProfile(BuildContext context, BusinessState state) {
    return state.profile == null || !state.profile!.validate();
  }

  CustomRoute navigateBusinessProfile(
    BuildContext context,
    RouteSettings route,
    AuthState state,
    UserState? userState,
  ) {
    return CustomRoute(
      builder: (BuildContext context) => const BusinessProfileCreatePage(),
    );
  }

  bool updateUserProfile(BuildContext context, UserState state) {
    return state.profile == null || !state.profile!.validate();
  }

  CustomRoute navigateUserProfile() => CustomRoute(
    builder: (BuildContext context) => const UserProfilePageCreatePage(),
  );

  CustomRoute getRoute(AuthState state, RouteSettings route) {
    var routes = state.routes!;
    if (!routes.containsKey(route.name)) {
      //ToDo: send to unknown / you do not have access route
      return CustomRoute(
        builder: (BuildContext context) {
          return const SecurityNotAllowedPage();
        },
      );
    }

    var thisRoute = routes[route.name!] as Widget?;

    return CustomRoute(
      builder: (BuildContext context) => thisRoute!,
      settings: route,
    );
  }

  void configureBackgroundTasks(Store<AppState>? store) {
    Future.delayed(
      const Duration(seconds: 70),
      () => Timer.periodic(const Duration(seconds: 40), (timer) async {
        var state = store!.state;
        if (!state.authState.isAuthenticated) return;
        store.dispatch(syncSales());
        store.dispatch(ValidatePaymentHardwareAction());
      }),
    );
  }
}

class AppVariables {
  static final AppVariables instance = AppVariables._internal();

  AppVariables._internal();

  factory AppVariables() => instance;

  static Store<AppState>? store;

  static bool get enableRequestCompression {
    return true;
  }

  static String get appFlavour {
    return store?.state.appSettingsState.appFlavor ?? '';
  }

  static String get baseUrl {
    return store?.state.environmentSettings?.baseUrl ?? '';
  }

  static SalesTax get salesTax {
    return store?.state.appSettingsState.salesTax ?? SalesTax();
  }

  static String? get terminalMerchantName {
    return store?.state.deviceState.deviceDetails?.merchantName;
  }

  static bool get enablePosMerchantName {
    return store?.state.enableUsePosMerchantName ?? false;
  }

  static int get softPosDeviceLimit {
    return store?.state.environmentSettings?.softPosDeviceLimit ?? 1;
  }

  static String get businessName {
    if (isPOSBuild && enablePosMerchantName) {
      if (isNotBlank(terminalMerchantName)) {
        return terminalMerchantName!;
      }
    }

    return store?.state.defaultBusinss?.displayName ?? '';
  }

  static bool get enablePrintLastReceipt {
    var remoteConfigEnabled = store?.state.enablePrintLastReceipt ?? false;
    bool isPos =
        cardPaymentRegistered == CardPaymentRegistered.pos &&
        AppVariables.isPOSBuild;
    return remoteConfigEnabled &&
        AppVariables.hasPrinter &&
        isPos &&
        userHasPermission(allowPrintLastReceipt);
  }

  static bool get enableReprintBatchReport {
    if (!userHasPermission(allowCloseBatch)) return false;
    if (!AppVariables.hasPrinter) return false;
    if (!userHasPermission(allowRePrintBatch)) return false;
    if (!canPerformAction(PaymentGatewayAction.printBatchReport)) return false;
    bool isPos =
        cardPaymentRegistered == CardPaymentRegistered.pos &&
        AppVariables.isPOSBuild;
    if (!isPos) return false;
    return true;
  }

  static bool get enableUpdateDeviceParameters {
    if (!userHasPermission(allowUpdateDeviceParameters)) return false;
    if (!canPerformAction(PaymentGatewayAction.updateDeviceParameters)) {
      return false;
    }
    bool isPos =
        cardPaymentRegistered == CardPaymentRegistered.pos &&
        AppVariables.isPOSBuild;
    if (!isPos) return false;
    return true;
  }

  static bool get enableReprintLastBatchReport {
    if (!userHasPermission(allowCloseBatch)) return false;
    if (!AppVariables.hasPrinter) return false;
    if (!userHasPermission(allowRePrintBatch)) return false;
    if (!canPerformAction(PaymentGatewayAction.printLastBatchReport)) {
      return false;
    }
    bool isPos =
        cardPaymentRegistered == CardPaymentRegistered.pos &&
        AppVariables.isPOSBuild;
    if (!isPos) return false;
    return true;
  }

  static bool get enableEmployees {
    final remoteConfigEnabled = store?.state.enableEmployee ?? false;
    final userIsAllowEmployees = userHasPermission(allowEmployee);
    return remoteConfigEnabled && userIsAllowEmployees;
  }

  static bool get enableBalanceEnquiry {
    final remoteConfigEnabled = store?.state.enableBalanceEnquiry ?? false;
    final userIsAllowBalanceEnquiry = userHasPermission(allowBalanceEnquiry);
    bool isPos =
        cardPaymentRegistered == CardPaymentRegistered.pos &&
        AppVariables.isPOSBuild;
    return remoteConfigEnabled && isPos && userIsAllowBalanceEnquiry;
  }

  static bool get enableCloseBatch {
    return userHasPermission(allowCloseBatch) &&
        cardPaymentRegistered == CardPaymentRegistered.pos &&
        AppVariables.isPOSBuild &&
        AppVariables.canPerformAction(PaymentGatewayAction.closeBatch);
  }

  static String get businessId {
    return store?.state.businessState.businessId ??
        store?.state.defaultBusinss?.id ??
        '';
  }

  static bool get enableMidValidation {
    final bool enableMidValidation = core.get<ConfigService>().getBoolValue(
      key: 'enable_mid_validation',
      defaultValue: true,
    );
    return enableMidValidation;
  }

  static String get merchantId {
    return store?.state.businessState.profile?.masterMerchantId ?? '';
  }

  static String get appName {
    return applicationName;
  }

  static bool get enableGetPaid => store?.state.enableGetPaid ?? false;

  static bool get enablePaymentLinks =>
      store?.state.enablePaymentLinks ?? false;

  static bool get enableInvoices => store?.state.enableInvoices ?? false;

  static bool get isInGuestMode {
    return (store?.state.businessState.businessUsers
                ?.where(
                  (element) =>
                      element.uid == store?.state.authState.userId &&
                      element.role == UserRoleType.guest,
                )
                .length ??
            0) >
        0;
  }

  static String get deviceMerchantId {
    return store?.state.deviceState.deviceDetails?.merchantId ?? '';
  }

  static bool get isProduction =>
      (store?.state.environmentSettings?.environment ?? AppEnvironment.local) ==
      AppEnvironment.prod;

  static AppFontCasing get appDefaultFontCasing =>
      store?.state.envConfig?.fontCasing ?? AppFontCasing.upperCase;

  static bool get isPOSBuild =>
      store?.state.appSettingsState.isPOSBuild ?? false;

  static bool get isSoftPosBuild =>
      isMobile && SoftPosHelper.hasSoftPosProvider();

  static bool get isMobileWithoutSoftPos =>
      isMobile && !SoftPosHelper.hasSoftPosProvider();

  static bool get isPosPaymentGatewayRegistered {
    LittleFishCore core = LittleFishCore.instance;
    return core.isRegistered<POSPaymentGateway>();
  }

  static RequestingChannel get requestingChannel {
    if (isPOSBuild) return RequestingChannel.pos;
    if (!isPOSBuild || platformType == PlatformType.softPos) {
      if (Platform.isAndroid) {
        return RequestingChannel.android;
      } else if (Platform.isIOS) {
        return RequestingChannel.ios;
      } else {
        return RequestingChannel.na;
      }
    }

    return RequestingChannel.na;
  }

  static double get screenWidth =>
      store?.state.environmentState.screenWidth ?? 0;

  static double get screenHeight =>
      store?.state.environmentState.screenHeight ?? 0;

  static bool get isMobile => store?.state.environmentState.isMobile ?? false;

  static bool get isDesktop => store?.state.environmentState.isDesktop ?? false;

  static bool get isLargeDisplay =>
      store?.state.environmentState.isLargeDisplay ?? false;

  static bool get hasInternet =>
      store?.state.environmentState.hasInternet ?? true;

  static bool get enableProductVariance =>
      store?.state.enableProductVarianceManagement ?? false;

  static String get termsAndConditions {
    if (isSBSA) return AppAssets.termsAndConditionsPdf;
    String? remoteTsAndCs =
        store?.state.environmentSettings?.termsAndConditionsUrl;
    if (isNotBlank(remoteTsAndCs)) return remoteTsAndCs!;
    // if (isSBSA) return AppAssets.termsAndConditionsPdf;
    if (isABSA) return AppAssets.defaultAbsaTermsAndConditions;
    return '';
  }

  static String get privacyPolicy {
    if (isSBSA) return AppAssets.privacyPolicyPdf;
    String? remotePrivacyPolicy =
        store?.state.environmentSettings?.privacyPolicyUrl;
    if (isNotBlank(remotePrivacyPolicy)) return remotePrivacyPolicy!;
    // if (isSBSA) return AppAssets.privacyPolicyPdf;
    if (isABSA) return AppAssets.defaultAbsaPrivacyPolicy;
    return '';
  }

  static double get appDefaultlistItemSize {
    return 56;
  }

  static double get appDefaultElevation {
    return 1;
  }

  static double get appDefaultButtonHeight {
    return 48;
  }

  static double get appDefaultButtonRadius {
    return 8;
  }

  static double get appDefaultRadius {
    return 8;
  }

  static double get appDefaultFieldHeight {
    return 72;
  }

  static double get listImageHeight {
    if (isPOSBuild) {
      return 56;
    } else {
      return 128;
    }
  }

  static double get listImageWidth {
    if (isPOSBuild) {
      return 56;
    } else {
      return 128;
    }
  }

  static DeviceDetails? get deviceInfo {
    return store?.state.deviceState.deviceDetails;
  }

  static String get clientSupportEmail {
    return store?.state.clientSupportEmail ?? '';
  }

  static String get clientSupportMobileNumber {
    return store?.state.clientSupportMobileNumber ?? '';
  }

  static String get deviceModel {
    return store?.state.deviceState.deviceDetails?.deviceModel ?? '';
  }

  static bool get laserScanningSupported {
    if (deviceInfo != null) {
      return deviceSupportsLaserScanning(deviceInfo);
    }

    return false;
  }

  static double get fileUploadSizeLimitKb {
    if (isPOSBuild) {
      return (5 * 1024);
    } else {
      return (20 * 1024);
    }
  }

  static String get appDateFormat {
    return 'dd MMM yyyy';
  }

  static String get appTimeFormat {
    return 'HH:mm';
  }

  static String get appFullDateTimeFormat {
    return 'dd MMM yyyy HH:mm';
  }

  static bool hasPrinter = false;
  static bool hasScanner = true;
  static bool hasPrinterInitialized = false;
  static bool hasScannerInitialized = false;
  static bool canPrintMerchantAndCustomerCopy = false;

  static List<PaymentGatewayAction> providerActions = [];

  static bool canPerformAction(PaymentGatewayAction action) {
    return providerActions.contains(action);
  }
}

void reportCheckedError(dynamic error, {StackTrace? trace}) {
  final LoggerService logger = LittleFishCore.instance.get<LoggerService>();

  try {
    logger.error(
      'app_error_report',
      ErrorCodeManager.getErrorMessage(error),
      error: error,
      stackTrace: trace ?? StackTrace.current,
    );
  } catch (e) {
    //DO NOT CHANGE BELOW AT ALL
    logger.debug('app.app', '### Error reporting error: $e');
  }
}

enum AppFontCasing { none, upperCase, titleCase, lowerCase }
