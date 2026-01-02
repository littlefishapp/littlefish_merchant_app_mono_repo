// remove ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:core';
import 'package:app_integrity_checker/app_integrity_checker.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geolocator/geolocator.dart';
import 'package:littlefish_auth/littlefish_auth_manager.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/monitoring/services/monitoring_service.dart';
import 'package:littlefish_core/storage/littlefish_storage_service.dart';
import 'package:littlefish_core_utils/error/models/error_codes/app_initialise_error_codes.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/bootstrap.dart';
import 'package:littlefish_merchant/common/presentaion/components/snackbars/snackbar_helper.dart';
import 'package:littlefish_merchant/features/errors/presentation/pages/error_page.dart';
import 'package:littlefish_merchant/features/errors/presentation/redux/error_actions.dart';
import 'package:littlefish_merchant/features/errors/data/lf_notification_data_source.dart';
import 'package:littlefish_merchant/features/receipt_common/data/data_source/lf_order_receipt_data_source.dart';
import 'package:littlefish_merchant/features/errors/data/notification_data_source.dart';
import 'package:littlefish_merchant/features/receipt_common/data/data_source/order_receipt_data_source.dart';
import 'package:littlefish_merchant/features/errors/data/models/error_reports.dart';
import 'package:littlefish_merchant/handlers/interfaces/permission_handler.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/device/interfaces/device_details.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/permissions/business_role.dart';
import 'package:littlefish_merchant/models/permissions/business_user_role.dart';
import 'package:littlefish_merchant/models/security/authentication/api_base_response.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/tax/sales_tax.dart';
import 'package:littlefish_merchant/redux/app/utils/setting_up_text_helper.dart';
import 'package:littlefish_merchant/redux/device/device_actions.dart';
import 'package:littlefish_merchant/redux/permission/permission_action.dart';
import 'package:littlefish_merchant/redux/system_data/system_data_actions.dart';
import 'package:littlefish_merchant/redux/ui/ui_state_actions.dart';
import 'package:littlefish_merchant/redux/user/user_state.dart';
import 'package:littlefish_merchant/services/permission_service.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/shared/exceptions/permission_failure_exception.dart';
import 'package:littlefish_merchant/ui/checkout/pages/checkout_quick_sale_page.dart';
import 'package:littlefish_merchant/ui/checkout/sell_page.dart';
import 'package:littlefish_merchant/ui/home/home_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/completers.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:littlefish_storage_firebase/littlefish_firebase_storage_service.dart';
import 'package:package_info_plus/package_info_plus.dart';

// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:redux_thunk/redux_thunk.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/environment/environment_config.dart';
import 'package:littlefish_merchant/models/security/user/user_profile.dart';
import 'package:littlefish_merchant/models/shared/country.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_actions.dart';
import 'package:littlefish_merchant/redux/auth/auth_actions.dart';
import 'package:littlefish_merchant/redux/billing/billing_actions.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/redux/environment/environment_actions.dart';
import 'package:littlefish_merchant/redux/locale/locale_actions.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_merchant/redux/user/user_actions.dart';
import 'package:littlefish_merchant/services/business_service.dart';
import 'package:littlefish_merchant/services/customer_service.dart';
import 'package:littlefish_merchant/services/product_service.dart';
import 'package:littlefish_merchant/services/settings_service.dart';
import 'package:littlefish_merchant/services/system_service.dart';
import 'package:littlefish_merchant/services/user_profile_service.dart';
import 'package:littlefish_merchant/singletons/connection_status_singleton.dart';
import 'package:littlefish_merchant/tools/exceptions/common_exceptions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/offline/offline_page.dart';
import '../../features/invoicing/datasource/invoicing_data_source.dart';
import '../../features/order_common/data/data_source/lf_order_data_source.dart';
import '../../features/order_common/data/data_source/order_data_source.dart';
import '../../features/payment_links/data/datasource/payment_links_data_source.dart';
import '../../features/store_switching/data/business_store_data_source.dart';
import '../../features/store_switching/presentation/pages/list_of_stores_login_flow_page.dart';
import '../../ui/security/login/splash_page.dart';
import '../../models/products/product_combo.dart';
import '../../models/products/product_modifier.dart';
import '../../models/stock/stock_category.dart';
import '../workspaces/workspace_actions.dart';

late SettingsService settingsService;
late UserProfileService userProfileService;
late BusinessService businessProfileService;
late ProductService productService;
late PermissionService permissionService;

final core = LittleFishCore.instance;

LoggerService logger = LittleFishCore.instance.get<LoggerService>();

ThunkAction<AppState> preInitialize(
  double screenHeight,
  double screenWidth, {
  String? countryCode,
  Completer? completer,
  ValueNotifier<String>? progressNotifer,
}) {
  return (Store<AppState> store) async {
    await configureAppDependencies();

    final MonitoringService monitoringService = core.get<MonitoringService>();

    final ConfigService configService = core.get<ConfigService>();

    Future(() async {
      logger.debug('p-init', 'AppActions preInitialize entry');
      debugPrint('#### AppActions preInitialize thunk action entry');
      var trace = await monitoringService.createTrace(name: 'pre-init');

      try {
        await trace.initialize();
        await trace.start();

        const flavorValue = String.fromEnvironment('FLUTTER_APP_FLAVOR');
        const useCaseValue = String.fromEnvironment('USE_CASE');
        const appEnv = String.fromEnvironment('APP_ENVIRONMENT');

        store.dispatch(SetAppFlavorAction(flavorValue));
        store.dispatch(SetAppUseCaseAction(useCaseValue));
        store.dispatch(SetAppEnvironmentAction(appEnv));
        store.dispatch(SetUserViewingModeAction(UserViewingMode.full));

        progressNotifer?.value = 'Initializing storage services...';

        _initStorageServices();

        FlutterError.onError = (FlutterErrorDetails details) {
          reportCheckedError(details.exception, trace: details.stack);
        };

        //ToDo: add validation for locales, but move this into a seperate service, it is messy.
        store.dispatch(SetHasAppInitializedAction(false));

        var supportedLocales = countryList
            .map((e) => CountryHelper.fromCountry(e))
            .toList();
        store.dispatch(LocaleLoadedAction(supportedLocales));
        trace.setMetric('supported_locales', supportedLocales.length);

        progressNotifer?.value = 'Checking billing support...';

        store.dispatch(SetBillingSupportedAction(false));

        var checksum = await AppIntegrityChecker.getchecksum();
        var signature = await AppIntegrityChecker.getsignature();

        store.dispatch(
          SetAppIntegrityCheckAction(checksum: checksum, signature: signature),
        );

        progressNotifer?.value = 'Verifying app configuration...';

        settingsService = SettingsService(
          store: store,
          baseUrl: '',
          token: '',
          businessId: '',
        );

        EnvironmentConfig config;

        //ToDo: we need to verify the time taken to load configuration here.
        try {
          var subtrace = await monitoringService.createTrace(
            name: 'pre-init-feature-flags',
          );
          await subtrace.start();

          config = await EnvironmentConfig.fromFeatureFlags(
            store.state.environment,
          );

          store.dispatch(SetEnvironmentConfigAction(config));

          subtrace.stop();
        } catch (e) {
          config = EnvironmentConfig();
          store.dispatch(SetEnvironmentConfigAction(config));
          reportCheckedError(e, trace: StackTrace.current);
          store.dispatch(
            ShowErrorPageAction(
              'p-init',
              AppInitialiseErrorCodes.environmentConfigFailed.message,
              errorCode: AppInitialiseErrorCodes.environmentConfigFailed.code,
              error: e,
            ),
          );
          return;
        }

        progressNotifer?.value = 'Initializing authentication service...';

        await initAuthService();

        progressNotifer?.value = 'Loading application information...';

        var packageInfo = await PackageInfo.fromPlatform();

        store.dispatch(
          SetPackageInformationAction(
            appName: packageInfo.appName,
            buildNumber: packageInfo.buildNumber,
            packageName: packageInfo.packageName,
            versionNumber: packageInfo.version,
          ),
        );

        trace.putAttribute('appName', packageInfo.appName);
        trace.putAttribute('appVersion', packageInfo.version);

        //BR: moved as if no internet on startup app crashes down stream
        await initializeDeviceParams(screenHeight, screenWidth, store);

        //Trigger the link of the auth state changes.
        store.state.authManager.authStateChanges().listen((user) {
          if (user == null && store.state.currentUser != null) {
            store.dispatch(signOut(reason: 'firebase-auth-state-changed'));
          }
        });

        try {
          if (!core.isRegistered<OrderDataSource>()) {
            core.registerLazyService<OrderDataSource>(
              () => LFOrderDataSource(baseUrl: config.paymentsUrl ?? ''),
            );
          }
          if (!core.isRegistered<OrderReceiptDataSource>()) {
            core.registerLazyService<OrderReceiptDataSource>(
              () => LFOrderReceiptDataSource(baseUrl: config.baseUrl ?? ''),
            );
          }
          if (!core.isRegistered<NotificationDataSource>()) {
            core.registerLazyService<NotificationDataSource>(
              () => LfNotificationDataSource(baseUrl: config.baseUrl ?? ''),
            );
          }
          if (!core.isRegistered<BusinessStoreDataSource>()) {
            core.registerLazyService<BusinessStoreDataSource>(
              () => BusinessStoreDataSource(baseUrl: config.baseUrl ?? ''),
            );
          }
          if (!core.isRegistered<PaymentLinksDataSource>()) {
            core.registerLazyService<PaymentLinksDataSource>(
              () => PaymentLinksDataSource(
                baseUrl: config.baseUrl ?? '',
                payUrl: config.paymentLinksPayUrl ?? '',
              ),
            );
          }
          if (!core.isRegistered<InvoicingDataSource>()) {
            core.registerLazyService<InvoicingDataSource>(
              () => InvoicingDataSource(
                baseUrl: config.baseUrl ?? '',
                payUrl: config.paymentLinksPayUrl ?? '',
              ),
            );
          }
        } catch (e) {
          reportCheckedError(e, trace: StackTrace.current);
          store.dispatch(
            ShowErrorPageAction(
              'p-init',
              AppInitialiseErrorCodes.dataSourceRegistrationFailed.message,
              errorCode:
                  AppInitialiseErrorCodes.dataSourceRegistrationFailed.code,
              error: e,
            ),
          );
          return;
        }

        String reportsVersion = 'default';
        String homeVersion = 'default';

        if (store.state.appSettingsState.isPOSBuild) {
          reportsVersion = configService.getStringValue(
            key: 'config_pos_reports_version',
            defaultValue: reportsVersion,
          );

          homeVersion = configService.getStringValue(
            key: 'config_pos_homecontent_type',
            defaultValue: homeVersion,
          );
        } else {
          reportsVersion = configService.getStringValue(
            key: 'config_reports_version',
            defaultValue: reportsVersion,
          );

          homeVersion = configService.getStringValue(
            key: 'config_homecontent_type',
            defaultValue: homeVersion,
          );
        }

        progressNotifer?.value = 'Setting report and home content versions...';

        store.dispatch(SetReportVersionAction(reportsVersion));

        store.dispatch(SetHomeContentVersionAction(homeVersion));

        // store.dispatch(InitializeDeviceDetailsAction());

        //do a realtime check on the internet connection, do not use cached data
        var instance = ConnectionStatusSingleton.getInstance();

        if (store.state.environment != AppEnvironment.local) {
          if (!(await instance.checkConnection())) {
            store.dispatch(onNoInternet());
            return;
          }
        }

        var sysService = SystemService(
          store: store,
          baseUrl: store.state.baseUrl,
        );

        var isOnline = await sysService.isOnline();
        // We do the below because when the token error accurs it messes with the offline check
        // This essentially causes the token error page to be overriden by the offline page
        var tokenError = store.state.authState.hasTokenError ?? false;
        if (!isOnline && !tokenError) {
          store.dispatch(onOffline());
          return;
        }

        store.dispatch(getSystemData());

        var currentUser = authManager.user;

        if (currentUser != null) {
          store.dispatch(InitializeDeviceDetailsAction());
          store.dispatch(
            setCachedLogon(
              currentUser,
              completer: completer,
              context: globalNavigatorKey.currentContext!,
              source: 'pre_init_cached_logon',
            ),
          );
        } else {
          var posAutoLogin = configService.getBoolValue(
            key: 'config_pos_auto_login',
            defaultValue: false,
          );

          if (posAutoLogin && AppVariables.isPOSBuild) {
            store.dispatch(
              guestLogin(
                merchantId: '',
                platformType: PlatformType.pos,
                context: globalNavigatorKey.currentContext!,
                completer: snackBarCompleter(
                  globalNavigatorKey.currentContext!,
                  'Welcome',
                  goToDefaultRoute: true,
                ),
                source: 'pos_auto_login',
              ),
            );
          } else {
            await Navigator.pushNamedAndRemoveUntil(
              globalNavigatorKey.currentContext!,
              SplashPage.route,
              (route) => false,
            );
          }
        }
      } catch (e) {
        reportCheckedError(e, trace: StackTrace.current);

        store.dispatch(
          ShowErrorPageAction(
            'p-init',
            'AppActions preInitialize error [$e]',
            error: e,
          ),
        );
      } finally {
        trace.stop();
      }
    });
  };
}

bool _isDependenciesInitialised = false;

Future<void> configureAppDependencies() async {
  if (!_isDependenciesInitialised) {
    await configureCoreServices();
    await configureAppServices();
    await configurePaymentServices();
    _isDependenciesInitialised = true;
  } else {
    return;
  }
}

Future<void> _initStorageServices() async {
  LittleFishFirebaseStorageService storage = LittleFishFirebaseStorageService();

  await storage.initialise(
    settings: StorageSettings(
      enabled: true,
      compressionSettings: const CompressionSettings(enabled: true),
      uploadSizeLimitkb: AppVariables.fileUploadSizeLimitKb,
    ),
  );

  core.registerService<LittleFishStorageService>(instance: storage);
}

ThunkAction<AppState> appInitialize({
  required String? countryCode,
  Completer? completer,
  bool? isActivation = false,
}) {
  return (Store<AppState> store) async {
    store.dispatch(SetHasAppInitializedAction(false));

    Future(() async {
      logger.debug('app_actions', '### AppActions Initialize entry');
      bool isGuestLogin = await getKeyFromPrefsBool('isGuestLogin') ?? false;

      MonitoringService monitoringService = core.get<MonitoringService>();

      var trace = await monitoringService.createTrace(name: 'app-init');

      trace.start();

      if (store.state.authState.hasTokenError == true) {
        store.dispatch(
          ShowErrorPageAction(
            'token-refresh-failure',
            AppInitialiseErrorCodes.tokenRefreshExpirationTimeFailure(
              deviceId: AppVariables.deviceInfo?.deviceId ?? '',
              merchantId: AppVariables.merchantId,
              supportEmail: AppVariables.clientSupportEmail,
            ).message,
            errorCode:
                AppInitialiseErrorCodes.tokenRefreshExpirationTimeFailure(
                  deviceId: AppVariables.deviceInfo?.deviceId ?? '',
                  merchantId: AppVariables.merchantId,
                  supportEmail: AppVariables.clientSupportEmail,
                ).code,
          ),
        );
        completer?.completeError(
          ManagedException(message: 'Something went wrong'),
        );
        return;
      }

      try {
        //ToDo:(BRoberts) these services potentially need to be removed or merged with the core application layers.
        userProfileService = UserProfileService(
          store: store,
          baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
          token: store.state.authState.token,
          businessId: store.state.currentBusinessId,
        );

        businessProfileService = BusinessService(
          store: store,
          baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
          token: store.state.authState.token,
          businessId: store.state.currentBusinessId,
        );

        productService = ProductService(
          store: store,
          baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
          token: store.state.authState.token,
          businessId: store.state.currentBusinessId,
          currentLocale: store.state.localeState.currentLocale,
        );

        settingsService = SettingsService(
          store: store,
          baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
          token: store.state.authState.token,
          businessId: store.state.currentBusinessId,
        );

        customerService = CustomerService(
          store: store,
          baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
          token: store.state.authState.token,
          businessId: store.state.currentBusinessId,
        );

        permissionService = PermissionService(
          store: store,
          baseUrl: store.state.environmentState.environmentConfig!.baseUrl,
          token: store.state.authState.token,
          businessId: store.state.currentBusinessId,
        );

        logger.debug('app-init', 'created all application based services');

        bool hasError = false;

        try {
          store.dispatch(
            SetSettingUpTextAction(SettingUpTextHelper.settingUpLocation),
          );
          //we will use this to pin-point the user and isolate the transactions
          getLocation(accuracy: LocationAccuracy.medium)
              .then((location) {
                if (location != null) {
                  store.dispatch(SetUserLocationAction(location));
                }
              })
              .catchError((e) {
                //just report it, this is not worth cancelling
                reportCheckedError(e, trace: StackTrace.current);
              });
        } catch (e) {
          //just report it, this is not worth cancelling
          reportCheckedError(e, trace: StackTrace.current);
        }

        //this is a key check to look at...
        store.dispatch(
          SetSettingUpTextAction(SettingUpTextHelper.verifyingInternet),
        );
        if (!store.state.hasInternet!) {
          store.dispatch(
            ShowErrorPageAction(
              'app-init',
              AppInitialiseErrorCodes.noInternet.message,
              errorCode: AppInitialiseErrorCodes.noInternet.code,
            ),
          );
          return;
        }

        var tUserProfile = await monitoringService.createTrace(
          name: 'app-init-user-profile',
        );
        try {
          store.dispatch(
            SetSettingUpTextAction(SettingUpTextHelper.loadingUserProfile),
          );

          tUserProfile.start();

          var result = await userProfileService.getUserProfile();

          if (result != null) {
            store.dispatch(UserProfileLoadedAction(result));
            store.dispatch(SetUserLocaleAction(result.countryCode));
          } else if (hasError == false) {
            store.dispatch(
              UserProfileLoadedAction(
                UserProfile.fromFirebaseUser(
                  store.state.currentUser!,
                  setEmail: true,
                ),
              ),
            );
          }
        } catch (e) {
          store.dispatch(UserProfileLoadFailure(e.toString()));
          hasError = true;
          reportCheckedError(e);
          store.dispatch(
            ShowErrorPageAction(
              'app-init',
              AppInitialiseErrorCodes.userProfileFetchFailed.message,
              errorCode: AppInitialiseErrorCodes.userProfileFetchFailed.code,
              error: e,
            ),
          );
          completer?.completeError(e);
        } finally {
          tUserProfile.stop();
        }

        if (hasError) return;

        store.dispatch(
          SetSettingUpTextAction(
            SettingUpTextHelper.loadingBusinessInformation,
          ),
        );

        if (store.state.currentBusinessId != null &&
            store.state.currentBusinessId!.isNotEmpty) {
          try {
            var result = await businessProfileService.getBusinessProfile();
            store.dispatch(BusinessProfileLoadedAction(result));
            store.dispatch(RebuildAccessManagerAction());
          } catch (e) {
            store.dispatch(BusinessProfileLoadFailure(e.toString()));
            hasError = true;
            reportCheckedError(e);
            store.dispatch(
              ShowErrorPageAction(
                'app-init',
                AppInitialiseErrorCodes.businessProfileFetchFailed.message,
                errorCode:
                    AppInitialiseErrorCodes.businessProfileFetchFailed.code,
                error: e,
              ),
            );
          }

          if (hasError) return;

          var traceRoles = await monitoringService.createTrace(
            name: 'app-init-roles',
          );

          try {
            traceRoles.start();
            //NB! always expect 3 results...
            final roleResult = await _getRolesData(store) ?? [];

            for (var result in roleResult) {
              if (result != null) {
                if (result is List<BusinessUserRole>) {
                  //NB! this is specific legacy app-logic, do not remove without testing roles!
                  if ((store.state.userState.userBusinessRoles ?? []).isEmpty ||
                      store.state.userState.userBusinessRoles?[0].businessId !=
                          store.state.businessId) {
                    if (result.isEmpty) {
                      throw Exception('No user role found.');
                    }

                    var role = getMostRecentRole(result);
                    if (role != null) {
                      store.dispatch(UserProfileRolesLoadedAction([role]));
                      traceRoles.setMetric('user-roles-count', result.length);

                      continue;
                    }
                  }
                  store.dispatch(SetUsersBusinessRoles(result));

                  traceRoles.setMetric(
                    'business-user-roles-count',
                    result.length,
                  );
                } else if (result is List<BusinessRole>) {
                  store.dispatch(RoleLoadedAction(result));
                  traceRoles.setMetric('business-roles-count', result.length);
                }
              }
            }
          } catch (e) {
            store.dispatch(UserProfileRolesLoadFailure(e.toString()));
            store.dispatch(PermissionStateFailureAction(e.toString()));
            store.dispatch(SetUsersBusinessRolesFailure(e.toString()));

            hasError = true;
            reportCheckedError(e);
            store.dispatch(
              ShowErrorPageAction(
                'app-init',
                AppInitialiseErrorCodes.roleDataFetchFailed.message,
                errorCode: AppInitialiseErrorCodes.roleDataFetchFailed.code,
                error: e,
              ),
            );
            completer?.completeError(e);
          } finally {
            traceRoles.stop();
          }

          if (hasError) return;

          try {
            store.dispatch(
              SetSettingUpTextAction(SettingUpTextHelper.loadingPermissions),
            );
            Completer permissionCompleter = Completer();
            store.dispatch(
              initializePermissionState(
                refresh: true,
                completer: permissionCompleter,
              ),
            );

            await permissionCompleter.future;

            await _handlePermissionsReady(store);
          } catch (e) {
            hasError = true;
            reportCheckedError(e);
            completer?.completeError(e);
            store.dispatch(
              ShowErrorPageAction(
                'app-init',
                AppInitialiseErrorCodes.permissionInitFailed.message,
                errorCode: AppInitialiseErrorCodes.permissionInitFailed.code,
                error: e,
              ),
            );
          }

          if (hasError) return;

          var traceStoreData = await monitoringService.createTrace(
            name: 'app-init-store-data',
          );

          try {
            store.dispatch(
              SetSettingUpTextAction(
                SettingUpTextHelper.loadingStoreInformation,
              ),
            );
            traceStoreData.start();
            final storeData = await _getStoreData(store) ?? [];

            for (var item in storeData) {
              if (item == null) continue;

              if (item is List<StockProduct>) {
                store.dispatch(ProductsLoadedAction(item));
                traceStoreData.setMetric('productsCount', item.length);
              } else if (item is List<StockCategory>) {
                store.dispatch(CategoriesLoadedAction(item));
                traceStoreData.setMetric('categoriesCount', item.length);
              } else if (item is List<ProductModifier>) {
                store.dispatch(ModifiersLoadedAction(item));
                traceStoreData.setMetric('modifiersCount', item.length);
              } else if (item is List<ProductCombo>) {
                store.dispatch(CombosLoadedAction(item));
                traceStoreData.setMetric('combosCount', item.length);
              } else if (item is SalesTax) {
                store.dispatch(AppSettingsSetSalesTaxAction(item));
                traceStoreData.putAttribute('salesTax', 'salesTaxLoaded');
              } else if (item is List<Customer>) {
                store.dispatch(CustomersLoadedAction(item));
                traceStoreData.setMetric('customersCount', item.length);
              }
            }
          } catch (e) {
            store.dispatch(ProductStateFailureAction(e.toString()));
            store.dispatch(AppSettingsSetFault(e.toString()));

            hasError = true;
            reportCheckedError(e);
            store.dispatch(
              ShowErrorPageAction(
                'app-init',
                AppInitialiseErrorCodes.storeDataFetchFailed.message,
                errorCode: AppInitialiseErrorCodes.storeDataFetchFailed.code,
                error: e,
              ),
            );
            completer?.completeError(e);
          } finally {
            traceStoreData.stop();
          }

          if (hasError) return;
          if (userHasPermission(allowCustomer) ||
              userHasPermission(allowMakeProductSale)) {
            store.dispatch(initializeCustomers(refresh: true));
          }
        } else {
          //we need to complete a business profile and as such should load the types
          store.dispatch(
            BusinessTypesLoadedAction(
              await businessProfileService.getBusinessTypes(),
            ),
          );

          //set a blank business profile
          store.dispatch(BusinessProfileLoadedAction(BusinessProfile.create()));
        }

        try {
          store.dispatch(initializeTicketSettings(refresh: true));
        } catch (e) {
          store.dispatch(AppSettingsSetLoadingAction(false));
          store.dispatch(AppSettingsSetFault(e.toString()));
        }

        //set Business Verification Status
        if (store.state.environmentSettings?.enableEnhancedOnboarding ??
            false) {
          store.dispatch(getVerificationStatus());
        }

        //ToDo: (BRoberts) confirm if this is required at this point?
        if (userHasPermission(allowUser)) {
          store.dispatch(getUsers(refresh: true));
        }

        store.dispatch(SetIsGuestUserAction(isGuestLogin));

        if (hasError) return;

        try {
          store.dispatch(
            SetSettingUpTextAction(SettingUpTextHelper.loadingPaymentMethods),
          );
          store.dispatch(setClientPaymentTypes());
        } catch (e) {
          hasError = true;
          store.dispatch(AppSettingsSetFault(e.toString()));
          store.dispatch(AppSettingsSetLoadingAction(false));
          reportCheckedError(e);
          store.dispatch(
            ShowErrorPageAction(
              'app-init',
              AppInitialiseErrorCodes.clientPaymentTypesInitFailed.message,
              errorCode:
                  AppInitialiseErrorCodes.clientPaymentTypesInitFailed.code,
              error: e,
            ),
          );
          completer?.completeError(e);
        }

        if (hasError) return;

        var route = HomePage.route;
        if (store.state.permissions != null && isActivation == false) {
          var state = AppVariables.store!.state;
          final sellNowModuleEnabledForV2 =
              state.enableNewSale == EnableOption.enabledForV2 ||
              useOrderModel == EnableOption.enabled;
          route =
              store.state.permissions!.makeSale == true ||
                  store.state.permissions!.isAdmin == true
              ? sellNowModuleEnabledForV2
                    ? isGuestLogin == true
                          ? CheckoutQuickSale.route
                          : AppVariables.isPOSBuild
                          ? SellPage.route
                          : (store.state.businessState.businesses!.length > 1
                                ? ListOfStoresLoginFlowPage.route
                                : SellPage.route)
                    : isGuestLogin == true
                    ? SellPage.route
                    : (store.state.businessState.businesses!.length > 1
                          ? ListOfStoresLoginFlowPage.route
                          : SellPage.route)
              : HomePage.route;
        } else {
          route = SellPage.route;
        }

        Completer completed = navigateCompleter(
          globalNavigatorKey.currentContext!,
          route,
          onFailedRoute: OfflinePage.route,
        );

        if (!hasError) {
          completed.complete();
        } else {
          store.dispatch(
            ShowErrorPageAction(
              'app-init',
              AppInitialiseErrorCodes.unexpectedError.message,
              errorCode: AppInitialiseErrorCodes.unexpectedError.code,
            ),
          );
          completed.completeError(
            ManagedException(message: 'Something went wrong'),
          );
        }

        store.dispatch(SetHasAppInitializedAction(true));

        logger.debug('app_actions', '### AppActions Initialize exit');
      } catch (e) {
        store.dispatch(
          ShowErrorPageAction(
            'app-init',
            AppInitialiseErrorCodes.unexpectedError.message,
            errorCode: AppInitialiseErrorCodes.unexpectedError.code,
            error: e,
          ),
        );
        if (completer != null && !completer.isCompleted) {
          completer.completeError(e);
        }
        reportCheckedError(e);
      } finally {
        trace.stop();
      }
    });
  };
}

BusinessUserRole? getMostRecentRole(List<BusinessUserRole> roles) {
  if (roles.isEmpty) return null;

  roles.sort(
    (a, b) =>
        (b.dateUpdated ?? DateTime(0)).compareTo(a.dateUpdated ?? DateTime(0)),
  );

  return roles.first;
}

Future<List?> _getStoreData(Store<AppState> store) async {
  try {
    final vatCompleter = Completer();
    final salesTaxCompleter = Completer();
    store.dispatch(getBusinessSalesTaxes(completer: salesTaxCompleter));
    store.dispatch(getVatLevelsThunk(completer: vatCompleter));

    final results = await Future.wait([
      !userHasPermission(allowProduct)
          ? Future.value(<StockProduct>[])
          : productService.getProducts(),
      !userHasPermission(allowProduct)
          ? Future.value(<StockCategory>[])
          : productService.getCategories(),
      // productService.getModifiers(),
      // productService.getCombos(),
      settingsService.getSalesTax(),
    ]);

    return results;
  } catch (e) {
    logger.error(
      '_getStoreData',
      'An error occurred whilst getting store data',
      error: e,
      stackTrace: StackTrace.current,
    );
    rethrow;
  }
}

Future<List?> _getRolesData(Store<AppState> store) async {
  try {
    final futures = [
      permissionService.getBusinessUserRoles(
        userId: store.state.userProfile?.userId ?? '',
      ),
      permissionService.getBusinessRoles(),
      permissionService.getBusinessUserRolesByBusiness(),
    ];

    final results = await Future.wait(futures);

    return results;
  } catch (e) {
    reportCheckedError(e);
  }

  return [];
}

Future<void> _handlePermissionsReady(Store<AppState> store) async {
  try {
    await getIt.get<PermissionHandler>().populatePermissionData();
    store.dispatch(SetUserAccessPermissions(store.state.permissions));
    store.dispatch(fetchWorkspaces());
    store.dispatch(loadDefaultWorkspace());
  } on PermissionFailureException catch (e) {
    reportCheckedError(e, trace: StackTrace.current);
  }
}

ThunkAction<AppState> onOffline() {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        await Navigator.pushNamedAndRemoveUntil(
          globalNavigatorKey.currentContext!,
          OfflinePage.route,
          (route) => false,
        );
      } catch (e) {
        logger.debug('app_actions', '### appActions onOffline error [$e]');
        await Navigator.pushNamedAndRemoveUntil(
          globalNavigatorKey.currentContext!,
          OfflinePage.route,
          (route) => false,
        );
      }
    });
  };
}

Future<bool> checkInternetConnection() async {
  var instance = ConnectionStatusSingleton.getInstance();
  return await instance.checkConnection();
}

ThunkAction<AppState> testInternetWithSnackbarAction() {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        bool hasInternet = await checkInternetConnection();
        String snackbarMessage = hasInternet
            ? 'You are online'
            : 'No internet connection';

        BuildContext? context = globalNavigatorKey.currentContext;
        if (context == null || !context.mounted) {
          logger.debug(
            'testInternetWithSnackbarAction',
            'Context unavailable, could not show snackbar',
          );
          return;
        }

        if (hasInternet) {
          SnackBarHelper.showSuccessSnackbar(context, snackbarMessage);
        } else {
          SnackBarHelper.showFailureSnackbar(context, snackbarMessage);
        }
      } catch (e) {
        logger.debug('app_actions', '### appActions onNoInternet error [$e]');
        await Navigator.pushNamedAndRemoveUntil(
          globalNavigatorKey.currentContext!,
          OfflinePage.route,
          (route) => false,
        );
      }
    });
  };
}

ThunkAction<AppState> checkInternetAction({Completer? completer}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        bool hasInternet = await checkInternetConnection();

        if (store.state.environment != AppEnvironment.local) {
          if (!hasInternet) {
            store.dispatch(onNoInternet());
            return;
          }
        }
        completer?.complete();
      } catch (e) {
        logger.debug('app_actions', '### appActions onNoInternet error [$e]');
        await Navigator.pushNamedAndRemoveUntil(
          globalNavigatorKey.currentContext!,
          OfflinePage.route,
          (route) => false,
        );
        completer?.completeError(e);
      }
    });
  };
}

ThunkAction<AppState> onNoInternet({bool stopUser = true}) {
  return (Store<AppState> store) async {
    Future(() async {
      try {
        //we need to report that the state needs to be updated only.
        if (stopUser) {
          await Navigator.pushAndRemoveUntil(
            globalNavigatorKey.currentContext!,
            CustomRoute(
              builder: (context) =>
                  const ErrorPage(message: 'You do not have internet access.'),
            ),
            (route) => false,
          );
        }
      } catch (e) {
        logger.debug('app_actions', '### appActions onOffline error [$e]');
        await Navigator.pushNamedAndRemoveUntil(
          globalNavigatorKey.currentContext!,
          OfflinePage.route,
          (route) => false,
        );
      }
    });
  };
}

ThunkAction<AppState> sendBugReportAction({
  required String message,
  required String callerMethod,
  String? errorCode,
  Object? error,
  StackTrace? stackTrace,
  Completer? completer,
}) {
  return (Store<AppState> store) async {
    Future(() async {
      logger.error(callerMethod, message, error: error, stackTrace: stackTrace);

      store.dispatch(SetErrorStateLoadingAction(true));

      BusinessProfile? businessProfile = store.state.businessState.profile;
      UserProfile? userProfile = store.state.userProfile;
      DeviceDetails? deviceInfo = store.state.deviceState.deviceDetails;

      var errorReport = ErrorReport(
        errorMessage: message,
        errorLocation: callerMethod,
        errorTrace: error.toString(),
        errorCode: errorCode,
        businessId: businessProfile?.parentId,
        email: userProfile?.email,
        userId: userProfile?.userId,
        businessProfileId: businessProfile?.id,
        userName: userProfile?.displayName,
        deviceId: deviceInfo?.deviceId,
        merchantId: deviceInfo?.merchantId,
        merchantName: deviceInfo?.merchantName,
        terminalId: deviceInfo?.terminalId,
        deviceModel: deviceInfo?.deviceModel,
      );

      try {
        if (getIt.isRegistered<NotificationDataSource>()) {
          var notificationDataSource = getIt.get<NotificationDataSource>();
          ApiBaseResponse response = await notificationDataSource
              .sendErrorReport(errorReport: errorReport);

          store.dispatch(
            SetAppErrorReportedSuccessfullyAction(response.success),
          );
          if (!response.success) {
            logger.error(
              'sendBugReportAction',
              'Failed to send bug report',
              error: response.error,
            );
          }
          completer?.complete(response.success);
        } else {
          throw Exception('NotificationDataSource not registered');
        }
      } catch (e) {
        logger.error(
          'sendBugReportAction',
          'Failed to send bug report',
          error: e,
          stackTrace: StackTrace.current,
        );
        store.dispatch(SetAppErrorReportedSuccessfullyAction(false));
        completer?.complete(false);
      } finally {
        store.dispatch(SetErrorStateLoadingAction(false));
      }
    });
  };
}
