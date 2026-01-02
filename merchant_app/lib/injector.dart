import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:littlefish_analytics_firebase/firebase_analytics_service.dart';
import 'package:littlefish_auth/littlefish_auth_manager.dart';
import 'package:littlefish_auth_firebase/firebase_auth_service.dart';
import 'package:littlefish_config_launchdarkly/littlefish_config_launchdarkly.dart';
import 'package:littlefish_core/analytics/models/analytics_settings.dart';
import 'package:littlefish_core/analytics/services/analytics_service.dart';
import 'package:littlefish_core/auth/models/auth_settings.dart';
import 'package:littlefish_core/auth/services/auth_service.dart';
import 'package:littlefish_core/configuration/app_version_info.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/configuration/config_settings.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/default_logger.dart';
import 'package:littlefish_core/logging/models/logger_settings.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_core/monitoring/models/monitoring_settings.dart';
import 'package:littlefish_core/monitoring/services/monitoring_service.dart';
import 'package:littlefish_core/observability/observability_service.dart';
import 'package:littlefish_core/observability/observability_settings.dart';
import 'package:littlefish_merchant/app/injectors/icon_injector/icon_injector.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/injectors/payment_injector.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type_list.dart';
import 'package:littlefish_monitoring_firebase/firebase_monitoring_service.dart';
import 'package:littlefish_observability_firebase/firebase_observability_service.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'environment/environment_config.dart';
import 'handlers/interfaces/permission_handler.dart';
import 'handlers/permission_handlers/default_permission_handler.dart';

import 'injector.config.dart';

enum CardPaymentRegistered { none, pos }

//ToDo (IanL): this card payment registered, should be in the state this is an anti-pattern.
var cardPaymentRegistered = CardPaymentRegistered.none;
var isSBSA = false;
var isABSA = false;
var isVerifone = false;
var isSandbox = false;
var isYellowToast = false;
var isTPS = false;
var isFNB = false;
var platformType = PlatformType.softPos;
var useOrderModel = EnableOption.notSet;
var isProd = false;
var applicationName = 'App';

final core = LittleFishCore.instance;

//ToDo(BRoberts): remove this implementation, however many direct references are being used.
final getIt = GetIt.instance;

Future<void> initialiseCore() async {
  await _initCore();
  await _initAppVersionInfo();

  final selectedSandBoxTheme = await getSelectedSandBoxTheme();
  await initialiseConfigService(selectedSandBoxTheme);
  await _initObservabilityService();
  await _initAnalyticsService();
}

@InjectableInit()
Future<void> configureDependencies() async {
  await IconInjector.inject();
}

Future<void> _initCore() async {
  getIt.init();

  await LittleFishCore.instance.initialize(
    ((injector, environment) => {
      //ToDo: (BRoberts)-> trigger local add_app dependency configurations. (this is a placeholder)
    }),
    'env',
  );
  //Add the logger same-time as the core is initialized.
  await _initLogger();
}

Future<String> getSelectedSandBoxTheme() async {
  final prefs = await SharedPreferences.getInstance();
  final result = prefs.getString('sandbox_theme') ?? 'sandbox1';
  return result;
}

Future<void> configurePaymentServices() async {
  _initPaymentGateway();

  _initPaymentTypes();

  useOrderModel = EnableOption.enabledForV2;
}

Future<void> configureAppServices() async {
  await core.registerLazyService<PermissionHandler>(
    () => DefaultPermissionHandler(),
  );
  _initEncryptionService();

  //ToDo: add additional services.
}

Future<void> configureCoreServices() async {
  await _initMonitoringService();
  await _initAnalyticsService();
  await _initAuditingServices();
  await _initObservabilityService();
}

Future<void> _initAppVersionInfo() async {
  try {
    final packageInfo = await PackageInfo.fromPlatform();

    final appVersionInfo = AppVersionInfo(
      version: packageInfo.version,
      buildNumber: packageInfo.buildNumber,
      name: packageInfo.appName,
      channel: AppVariables.requestingChannel.name,
    );

    await core.registerService<AppVersionInfo>(instance: appVersionInfo);
  } catch (e) {
    // swallowing error as it should not be as vital as other services
  }
}

Future<void> _initLogger() async {
  //ToDo: BMR (settings should come from configuration-service, or local environment settings and not hardcoded)

  DefaultLogger loggerService = DefaultLogger();

  await loggerService.initialize(
    settings: LoggerSettings(
      printer: LoggerPrinter.simple,
      enableConsoleOutput: kDebugMode ? true : false,
      enableFileOutput: true,
      minimumLogLevel: kDebugMode ? LogLevel.info : LogLevel.info,
    ),
  );

  await core.registerService<LoggerService>(instance: loggerService);
}

Future<void> _initObservabilityService() async {
  FirebaseObservabilityService observabilityService =
      FirebaseObservabilityService();

  await observabilityService.initialise(
    settings: ObservabilitySettings(enabled: true),
  );

  await core.registerService<ObservabilityService>(
    instance: observabilityService,
  );
}

Future<void> _initEncryptionService() async {
  // //This is an encryptor service that is used to encrypt sensitive data.
  // SecureDataHandler encryptionService = await SecureDataHandler.create();

  // await core.registerService<SecureDataHandler>(
  //   instance: encryptionService,
  // );
}

Future<void> initAuthService() async {
  AuthMode authMode = AuthMode.providerAndCustom;

  if (AppVariables.isPOSBuild && AppVariables.enableMidValidation) {
    authMode = AuthMode.providerAndCustomConditions;
  }

  AuthService authService = FirebaseAuthService(
    settings: AuthSettings(platformType: platformType),
    authMode: authMode,
  );

  await authService.initialise(baseUrl: AppVariables.baseUrl);

  await core.registerService<AuthService>(instance: authService);

  await LittlefishAuthManager.instance.initialise();
}

Future<void> initialiseConfigService(String selectedSandBoxTheme) async {
  final configService = await _initLDClient(selectedSandBoxTheme);
  await core.registerService<ConfigService>(instance: configService);
}

Future<LaunchDarklyConfigService> _initLDClient(
  String selectedSandBoxTheme,
) async {
  final configService = LaunchDarklyConfigService();

  final packageInfo = await PackageInfo.fromPlatform();
  const flavorValue = String.fromEnvironment('FLUTTER_APP_FLAVOR');
  const useCaseValue = String.fromEnvironment('USE_CASE');

  //ToDo: change this value type, as it is not a user, this is being used to determine which order model should be used.
  const ldUser = String.fromEnvironment('LD_USER');

  debugPrint('### flavorValue: $flavorValue');
  debugPrint('### useCaseValue: $useCaseValue');

  if (useCaseValue.contains('simply-blue')) {
    isSBSA = true;
  } else if (useCaseValue.contains('absa')) {
    isABSA = true;
  } else if (useCaseValue.contains('yellowtoast')) {
    isSBSA = true;
    isYellowToast = true;
  } else if (useCaseValue.contains('tps')) {
    isTPS = true;
  } else if (useCaseValue.contains('fnb')) {
    isFNB = true;
  } else if (useCaseValue.contains('sandbox')) {
    isSandbox = true;
  }

  if ((flavorValue.toLowerCase().contains('pos') ||
      flavorValue.toLowerCase().contains('pax') ||
      flavorValue.toLowerCase().contains('verifone') ||
      flavorValue.toLowerCase().contains('ingenico'))) {
    platformType = PlatformType.pos;
  }

  if (flavorValue.contains('prod')) {
    isProd = true;
  }

  if (flavorValue.contains('verifone')) {
    isVerifone = true;
  }

  // TODO(lampian): migrate to flags as per P&E when ready
  if (ldUser == 'order_dev') {
    useOrderModel = EnableOption.enabled;
  }

  var platform = 'unknown';
  if (Platform.isAndroid) {
    platform = 'android';
  } else if (Platform.isIOS) {
    platform = 'ios';
  }
  applicationName = const String.fromEnvironment('APP_NAME').isNotEmpty
      ? const String.fromEnvironment('APP_NAME')
      : 'App';

  await configService.initialise(
    settings: ConfigSettings(
      appName: packageInfo.appName,
      appVersion: '$packageInfo.buildNumber (${packageInfo.version})',
      appKey: packageInfo.packageName,
      settings: {
        'use-case': useCaseValue,
        'user': ldUser.isEmpty ? 'no user' : ldUser,
        'platform': platform,
        'sandbox-ref': selectedSandBoxTheme,
        // 'test-ref': 'sell_page',
      },
      timeoutSeconds: 120,
    ),
  );

  return configService;
}

Future<void> _initMonitoringService() async {
  final m = FirebaseMonitoringService();

  final bool isEnabled = core.get<ConfigService>().getBoolValue(
    key: 'config_settings_monitoring_enabled',
    defaultValue: true,
  );

  final int traceMode = core.get<ConfigService>().getIntValue(
    key: 'config_settings_monitoring_trace_mode',
    defaultValue: 2, //both
  );

  //ToDo: the trace mode should be coming from the app-settings, and not hardcoded.
  // await m.initailize(
  //   settings: MonitoringSettings(
  //     enabled: isEnabled,
  //     mode: traceMode > TraceMode.values.length || traceMode == -1
  //         ? TraceMode.httpOnly
  //         : TraceMode.values[traceMode],
  //   ),
  // );

  await m.initailize(
    settings: MonitoringSettings(
      enabled: isEnabled,
      mode: traceMode > TraceMode.values.length || traceMode == -1
          ? TraceMode.httpOnly
          : TraceMode.values[traceMode],
    ),
  );

  await core.registerService<MonitoringService>(instance: m);
}

Future<void> _initAuditingServices() async {
  // final deviceManager = DeviceManager();

  // await core.registerService<DeviceManager>(
  //   instance: deviceManager,
  // );

  // final auditService = AuditManager();

  // await core.registerService<AuditService>(
  //   instance: auditService,
  // );
}

Future<void> _initAnalyticsService() async {
  AnalyticsService analyticsService = FirebaseAnalyticsService();
  ConfigService configService = core.get<ConfigService>();

  final bool isEnabled = configService.getBoolValue(
    key: 'config_settings_analytics_enabled',
    defaultValue: true,
  );

  //ToDo: (BRoberts) - the enabled flag should come from our config-service and not be hard-coded.
  // await analyticsService.initialize(
  //   settings: AnalyticsSettings(enabled: isEnabled),
  // );

  await analyticsService.initialize(
    settings: AnalyticsSettings(enabled: isEnabled),
  );

  await core.registerService<AnalyticsService>(instance: analyticsService);
}

Future<void> _initPaymentGateway() async {
  cardPaymentRegistered = await PaymentsInjector.inject();
}

//ToDo: this logic should move to the payment service as a whole, and not just the payment types.
void _initPaymentTypes() {
  final ConfigService configService = core.get<ConfigService>();
  final LoggerService logger = LittleFishCore.instance.get<LoggerService>();

  logger.debug('app_injector', '### config_settings_payment_types');

  final paymentTypesMap = configService.getObjectValue(
    key: 'config_settings_payment_types',
    defaultValue: const {
      'key':
          'value', //ToDo: confirm if this is actually even needed, was a legacy migration from the old system
    },
  );

  logger.debug(
    'app_injector',
    '### config_settings_payment_types $paymentTypesMap',
  );

  //ToDo: confirm, this is called but actually never used in the application itself.
  final reasonPaymentTypes = configService.getObjectValue(
    key: 'config_settings_payment_types',
    defaultValue: const {
      'key':
          'value', //ToDo: confirm if this is actually even needed, was a legacy migration from the old system
    },
  );

  logger.debug(
    'app_injector',
    '### config_settings_payment_types reason $reasonPaymentTypes',
  );

  logger.debug(
    'injector',
    'Config settings payment types reason: $reasonPaymentTypes',
  );

  final paymentTypes = PaymentTypeList.fromJson(paymentTypesMap);

  core.registerLazyService<PaymentTypeList>(() => paymentTypes);
}

String getCohort() {
  if (isABSA) {
    return 'ABSA';
  } else if (isYellowToast) {
    return 'Yellowtoast';
  } else if (isSBSA) {
    return 'SBSA';
  } else if (isTPS) {
    return 'TPS';
  } else if (isFNB) {
    return 'FNB';
  } else {
    return 'LF';
  }
}
