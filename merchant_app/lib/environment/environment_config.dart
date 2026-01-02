import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/domain/entity/square_button_entity.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/domain/usecases/square_button_config.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/form_field_config/form_field_config_entity.dart';

import '../app/app.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_merchant/models/online/online_store.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';
import 'package:littlefish_merchant/models/billing/pos_store_license.dart';
import 'package:littlefish_merchant/models/billing/subscription_frequency.dart';
import 'package:littlefish_merchant/models/sales/checkout/cashback_requirements.dart';
import 'package:littlefish_merchant/models/sales/checkout/withdraw_requirements.dart';

part 'environment_config.g.dart';

/// V1 - pre order object implementation
/// V2 - order object implementation
enum EnableOption { notSet, disabled, enabled, enabledForV1, enabledForV2 }

@JsonSerializable()
class EnvironmentConfig {
  static LoggerService get logger =>
      LittleFishCore.instance.get<LoggerService>();
  EnvironmentConfig({
    this.accentColor,
    this.baseUrl,
    this.paymentsUrl,
    this.paymentLinksPayUrl,
    this.reportingUrl,
    this.financingingUrl,
    this.environment,
    this.name,
    this.primaryColor,
    this.dsn,
    this.enableLogging,
    this.authProviderType,
    this.privacyPolicyUrl,
    this.termsAndConditionsUrl,
    this.zapperEnabled,
    this.snapscanEnabled,
    this.financeEnabled,
    this.enableBilling,
    this.enableTrial,
    this.revCatAppName,
    this.cloudFunctionsUrl,
    this.posStoreLicense,
    this.subscriptionKeys,
    this.contactUsNumber,
    this.contactUsEmail,
    this.userGuide,
    this.enableCheckoutV2,
    this.enableOfflineCheckout,
    this.paidFeaturesList,
    this.commonPasswords,
    this.allowedFileTypes,
    this.minimumAppVersion,
    this.posSubscriptionGracePeriod,
    this.onlineStoreSettings,
    this.bqDownloadReportsUrl,
    this.enableEnhancedOnboarding,
    this.enhancedOnboardingRoutes,
    this.envIOSMarketAppBundleID = 'africa.littlefishapp.littlefishseller',
    this.envIOSSellerAppBundleID = 'africa.littlefishapp.littlefishmarket',
    this.envAndroidMarketAppBundleID = 'africa.littlefishapp.littlefish_seller',
    this.envAndroidSellerAppBundleID = 'africa.littlefishapp.littlefish_market',
    this.onboardingUrl,
    this.subscriptionFrequency,
    this.enableOnlineStore,
    this.enableFinance,
    this.enableContactUs,
    this.enableUserGuide,
    this.enableTax,
    this.enableStoreCredit,
    this.enableEmployee,
    this.enableStaffSales,
    this.enableFulfilment,
    this.enableAdvancedReporting,
    this.enableUsers,
    this.enableKYC,
    this.enableDiscounts,
    this.enableDiscountSettings = false,
    this.enableGetStarted,
    this.enablePendingTransactions,
    this.enableCheckoutFavourites,
    this.enableBottomBarHamburgerMenu,
    this.enableSellNowInFavourites,
    this.enableSellNowModule,
    this.enableSuppliersModule,
    this.enableOverviewInFavourites,
    this.enableOnlyCashCardSnapscanPayments,
    this.enableStock,
    this.enableReceiveStock,
    this.enableReceivedStock,
    this.enableStockTaking,
    this.enableCombos,
    this.enableSignup,
    this.presetDiscountPercentages,
    this.presetCheckoutTipPercentages,
    this.enableSignupActivation,
    this.authorizationToken,
    this.enableOnboarding,
    this.cashbackRequirements,
    this.withdrawRequirements,
    this.cashbackAmountOptions,
    this.withdrawalAmountOptions,
    this.enableCashback,
    this.enableWithdrawal,
    this.enableTips,
    this.enableOverviewHomePage,
    this.enableFinancialStatements,
    this.enableVoid = EnableOption.notSet,
    this.merchantID = '',
    this.mcc = '',
    this.enableHomeOnlineStoreCard,
    this.enableNewSale = EnableOption.notSet,
    this.enableTransactions = EnableOption.notSet,
    this.enableTransactionsRefundSale = EnableOption.notSet,
    this.enableCustomerSalesRefundSales = EnableOption.notSet,
    this.enableGuestUser,
    this.guestUserTimeout,
    this.enableDeleteAccountPage,
    this.fontCasing = AppFontCasing.upperCase,
    this.slowNetworkNotificationInterval,
    this.configEnableSlowNetworkCheck,
    this.softPosProviderName,
    this.enableProductVarianceManagement,
    this.merchantIdLength = 10,
    this.enablePrintLastReceipt = false,
    this.enableBalanceEnquiry = false,
    this.enableUsePosMerchantName = false,
    this.squareButtonConfig,
    this.formFieldConfig,
    this.enableGetPaid = false,
    this.enablePaymentLinks = false,
  });

  AppEnvironment? environment;

  POSStoreLicense? posStoreLicense;

  POSOnlineStoreSettings? onlineStoreSettings;

  SubscriptionFrequency? subscriptionFrequency;

  List<String?>? subscriptionKeys;

  AuthProviderType? authProviderType;

  CashbackRequirements? cashbackRequirements;
  WithdrawRequirements? withdrawRequirements;

  String? name;
  String? baseUrl;
  String? paymentsUrl;
  String? paymentLinksPayUrl;
  String? reportingUrl;
  String? financingingUrl;
  String? cloudFunctionsUrl;
  String? bqDownloadReportsUrl;
  String? revCatAppName;
  String? contactUsNumber;
  String? contactUsEmail;
  String? userGuide;
  String? clientSupportEmail;
  String? clientSupportMobileNumber;
  List<String>? paidFeaturesList;
  List<String>? commonPasswords;
  List<String>? allowedFileTypes;

  List<double>? presetDiscountPercentages;
  List<double>? presetCheckoutTipPercentages;
  String? onboardingUrl;

  List<double>? cashbackAmountOptions;
  List<double>? withdrawalAmountOptions;

  String? guestUserTimeout;

  bool? enableDeleteAccountPage;

  bool? enableOfflineCheckout, enableCheckoutV2;

  String? primaryColor, accentColor;

  String? privacyPolicyUrl, termsAndConditionsUrl;

  String? dsn;

  String? minimumAppVersion;

  String? authorizationToken;

  int? posSubscriptionGracePeriod;

  String envIOSSellerAppBundleID;
  String envIOSMarketAppBundleID;
  String envAndroidSellerAppBundleID;
  String envAndroidMarketAppBundleID;
  String merchantID;
  String mcc;
  List<String>? activationOptions;

  EnableOption enableNewSale;
  EnableOption enableTransactions;
  EnableOption enableTransactionsRefundSale;
  EnableOption enableCustomerSalesRefundSales;
  EnableOption enableVoid;

  AppFontCasing fontCasing = AppFontCasing.none;

  @JsonKey(includeFromJson: false, includeToJson: false)
  SquareButtonEntity? squareButtonConfig;

  @JsonKey(includeFromJson: false, includeToJson: false)
  FormFieldConfigEntity? formFieldConfig;

  String? softPosProviderName;

  String? customPaymentLinksBannerMessage;

  String? customStoreReviewMessage;

  @JsonKey(defaultValue: false)
  bool? zapperEnabled,
      snapscanEnabled,
      wizzitTapToPayEnabled,
      financeEnabled,
      enableBilling,
      enableTrial,
      enableEnhancedOnboarding,
      enableOnlineStore,
      enableFinance,
      enableContactUs,
      enableUserGuide,
      enableTax,
      enableStoreCredit,
      enableEmployee,
      enableStaffSales,
      enableFulfilment,
      enableAdvancedReporting,
      enableUsers,
      enableDiscounts,
      enableDiscountSettings,
      enableProductDiscounts,
      enableGetStarted,
      enablePendingTransactions,
      enableCheckoutFavourites,
      enableBottomBarHamburgerMenu,
      enableSellNowInFavourites,
      enableSellNowModule,
      enableSuppliersModule,
      enableOverviewInFavourites,
      enableOnlyCashCardSnapscanPayments,
      enableKYC,
      cybersourceEnabled,
      exitPasswordEnabled,
      enableStock,
      enableReceiveStock,
      enableReceivedStock,
      enableStockTaking,
      enableCombos,
      enableSignup,
      enableSignupActivation,
      enableCashback,
      enableWithdrawal,
      enableOnboarding,
      enableTips,
      enableSideNavDrawer,
      enableBottomNavBar,
      enableProfileNavBar,
      enableStoreSetupV2,
      enableOverviewHomePage,
      enableFinancialStatements,
      enableLinkedDevices,
      enableGetApp,
      enableHomeOnlineStoreCard,
      enableGuestUser,
      configEnableSlowNetworkCheck,
      enableProductVarianceManagement,
      enablePrintLastReceipt,
      enableBalanceEnquiry,
      enableUsePosMerchantName,
      enableTerminalReportFiltering,
      enableGetPaid,
      enablePaymentLinks,
      enableInvoices;

  int? slowNetworkNotificationInterval, merchantIdLength, softPosDeviceLimit;

  List<String>? enhancedOnboardingRoutes;

  bool? enableLogging;

  static Future<EnvironmentConfig> fromAsset(
    AppEnvironment? environment,
  ) async {
    var envName = environment.toString().substring(
      environment.toString().lastIndexOf('.') + 1,
    );

    var assetName = '${envName}_settings.json';

    var configFilePath = 'assets/environment/$assetName';

    String content = await rootBundle.loadString(configFilePath);

    var json = jsonDecode(content);

    return EnvironmentConfig.fromJson(json);
  }

  factory EnvironmentConfig.fromJson(Map<String, dynamic> json) =>
      _$EnvironmentConfigFromJson(json);

  Map<String, dynamic> toJson() => _$EnvironmentConfigToJson(this);

  Map<String, String?> toEnvironmentSettings() => <String, String?>{
    'environment': _$AppEnvironmentEnumMap[environment!],
    'name': name,
    'baseUrl': baseUrl,
    'primaryColor': primaryColor,
    'accentColor': accentColor,
    'dsn': dsn,
    'enableLogging': enableLogging.toString(),
    'privacyPolicyUrl': privacyPolicyUrl,
    'onboardingUrl': onboardingUrl,
    'termsAndConditionsUrl': termsAndConditionsUrl,
    'zapperEnabled': zapperEnabled.toString(),
  };

  static Future<EnvironmentConfig> fromFeatureFlags(
    AppEnvironment? environment,
  ) async {
    final core = LittleFishCore.instance;
    final ConfigService configService = core.get<ConfigService>();

    final isLocal = (environment ?? '') == AppEnvironment;
    var envName = environment.toString().substring(
      environment.toString().lastIndexOf('.') + 1,
    );

    var assetName = '${envName}_settings.json';

    var configFilePath = 'assets/environment/$assetName';

    String content = await rootBundle.loadString(configFilePath);

    var json = jsonDecode(content);

    var defaultConfig = EnvironmentConfig.fromJson(json);

    final ffConfig = configService.getObjectValue(
      key: 'config_settings_general',
      defaultValue: {'key': 'value'},
    );

    getConfigInfo(ffConfig);

    getFeatureFlagParameters(ffConfig, defaultConfig, isLocal);

    getFeatureFlagParamaterGroups(ffConfig, defaultConfig, isLocal);

    getFlatFags(defaultConfig);

    return defaultConfig;
  }

  static void getFlatFags(EnvironmentConfig defaultConfig) {
    ConfigService configService = core.get<ConfigService>();
    defaultConfig.cybersourceEnabled = core.get<ConfigService>().getBoolValue(
      key: 'enable_cybersource',
      defaultValue: false,
    );
    defaultConfig.exitPasswordEnabled = core.get<ConfigService>().getBoolValue(
      key: 'enable_exit_password',
      defaultValue: false,
    );
    defaultConfig.slowNetworkNotificationInterval = core
        .get<ConfigService>()
        .getIntValue(
          key: 'config_slow_network_notification_interval',
          defaultValue: 1, // in minutes
        );
    defaultConfig.configEnableSlowNetworkCheck = core
        .get<ConfigService>()
        .getBoolValue(
          key: 'config_enable_slow_network_check',
          defaultValue: false,
        );
    defaultConfig.softPosProviderName = core
        .get<ConfigService>()
        .getStringValue(key: 'config_soft_pos_provider_name', defaultValue: '');
    defaultConfig.enableProductVarianceManagement = core
        .get<ConfigService>()
        .getBoolValue(key: 'temp_show_product_variances', defaultValue: false);
    defaultConfig.merchantIdLength = core.get<ConfigService>().getIntValue(
      key: 'config_merchant_id_length',
      defaultValue: 10,
    );
    defaultConfig.enablePrintLastReceipt = core
        .get<ConfigService>()
        .getBoolValue(key: 'enable_print_last_receipt', defaultValue: false);
    defaultConfig.enableBalanceEnquiry = core.get<ConfigService>().getBoolValue(
      key: 'enable_balance_enquiry',
      defaultValue: false,
    );
    defaultConfig.customPaymentLinksBannerMessage = core
        .get<ConfigService>()
        .getStringValue(
          key: 'custom_paymentlinks_banner_message',
          defaultValue:
              'Enable online payment processing to accept through your invoices.',
        );
    defaultConfig.customStoreReviewMessage = core
        .get<ConfigService>()
        .getStringValue(
          key: 'custom_store_review_message',
          defaultValue:
              'Are you sure you want to submit your online store'
              ' for review? It will be submitted to your bank for '
              'review. Customers will be able to visit your site '
              'and browse through your products. Please note, you '
              'will not be able to accept online payments until '
              'your store has been approved.',
        );
    defaultConfig.softPosDeviceLimit = core.get<ConfigService>().getIntValue(
      key: 'config_soft_pos_device_limit',
      defaultValue: 10,
    );
    defaultConfig.enableSideNavDrawer = core.get<ConfigService>().getBoolValue(
      key: 'enable_side_navigation',
      defaultValue: true,
    );

    defaultConfig.enableBottomNavBar = core.get<ConfigService>().getBoolValue(
      key: 'enable_bottom_navigation',
      defaultValue: false,
    );
    defaultConfig.enableProfileNavBar = core.get<ConfigService>().getBoolValue(
      key: 'enable_profile_navigation',
      defaultValue: false,
    );
    defaultConfig.enableUsePosMerchantName = core
        .get<ConfigService>()
        .getBoolValue(
          key: 'config_enable_use_pos_merchant_name',
          defaultValue: false,
        );
    defaultConfig.enableGetApp = core.get<ConfigService>().getBoolValue(
      key: 'enable_get_app',
      defaultValue: true,
    );
    defaultConfig.wizzitTapToPayEnabled = core
        .get<ConfigService>()
        .getBoolValue(key: 'enable_wizzit_tap_to_pay', defaultValue: false);
    defaultConfig.enableTerminalReportFiltering = core
        .get<ConfigService>()
        .getBoolValue(
          key: 'enable_terminal_report_filtering',
          defaultValue: false,
        );

    defaultConfig.enableTerminalReportFiltering = core
        .get<ConfigService>()
        .getBoolValue(
          key: 'enable_terminal_report_filtering',
          defaultValue: false,
        );

    defaultConfig.enableGetPaid = configService.getBoolValue(
      key: 'config_enable_get_paid',
      defaultValue: false,
    );

    defaultConfig.enablePaymentLinks = configService.getBoolValue(
      key: 'config_enable_payment_links',
      defaultValue: false,
    );

    defaultConfig.enableInvoices = configService.getBoolValue(
      key: 'config_enable_invoices',
      defaultValue: false,
    );

    defaultConfig.squareButtonConfig = SquareButtonConfig().config;
    defaultConfig.formFieldConfig = FormFieldConfig().config;
  }

  static void getConfigInfo(ffMap) {
    if (ffMap is Map && ffMap.containsKey('config_info')) {
      final configInfo = ffMap['config_info'];
      var created = 'no creation date';
      var usecase = 'no use case found';

      if (configInfo is Map && configInfo.containsKey('created')) {
        created = configInfo['created'];
      }

      if (configInfo is Map && configInfo.containsKey('usecase')) {
        usecase = configInfo['usecase'];
      }

      debugPrint('#### getConfigInfo use case $usecase created $created');

      logger.debug(
        'environment.environment_config',
        '### getConfigInfo use case $usecase created $created',
      );
    } else {
      logger.debug(
        'environment.environment_config',
        '### getConfigInfo not found',
      );
    }
  }

  static void getFeatureFlagParamaterGroups(
    ffMap,
    EnvironmentConfig defaultConfig,
    bool isLocal,
  ) {
    if (ffMap.containsKey('parameterGroups')) {
      final parameterGroups = ffMap['parameterGroups'];
      getLFMerchantSetting(parameterGroups, defaultConfig, isLocal);
      getLFeCommerceSettings(parameterGroups, defaultConfig);
      getSBHideables(parameterGroups, defaultConfig);
      getPOSSettings(parameterGroups, defaultConfig, isLocal);
    }
  }

  static void getPOSSettings(
    parameterGroups,
    EnvironmentConfig defaultConfig,
    bool isLocal,
  ) {
    if (parameterGroups is Map && parameterGroups.containsKey('POS')) {
      final pos = parameterGroups['POS'];
      if (pos is Map && pos.containsKey('parameters')) {
        final parameters = pos['parameters'];
        //--
        if (parameters.containsKey('merchant_api_url')) {
          final baseUrl = parameters['merchant_api_url'];
          defaultConfig.baseUrl = baseUrl;

          if (defaultConfig.baseUrl!.endsWith('/')) {
            defaultConfig.baseUrl = defaultConfig.baseUrl!.substring(
              0,
              defaultConfig.baseUrl!.length - 1,
            );
          }
        }

        if (parameters.containsKey('payments_api_url')) {
          final paymentsUrl = parameters['payments_api_url'];
          defaultConfig.paymentsUrl = paymentsUrl;

          if (defaultConfig.paymentsUrl!.endsWith('/')) {
            defaultConfig.paymentsUrl = defaultConfig.paymentsUrl!.substring(
              0,
              defaultConfig.paymentsUrl!.length - 1,
            );
          }
        }

        if (parameters.containsKey('report_api_url')) {
          final reportLocal = parameters['report_api_url'];
          defaultConfig.reportingUrl = reportLocal;

          if (defaultConfig.reportingUrl!.endsWith('/')) {
            defaultConfig.reportingUrl = defaultConfig.reportingUrl!.substring(
              0,
              defaultConfig.reportingUrl!.length - 1,
            );
          }
        }

        if (parameters.containsKey('zapper_enabled')) {
          defaultConfig.zapperEnabled = jsonToBool(
            parameters['zapper_enabled'],
          );
        }
        if (parameters.containsKey('snapscan_enabled')) {
          defaultConfig.snapscanEnabled = jsonToBool(
            parameters['snapscan_enabled'],
          );
        }

        if (parameters.containsKey('finance_enabled')) {
          defaultConfig.financeEnabled = jsonToBool(
            parameters['finance_enabled'],
          );
        }

        if (parameters.containsKey('finance_api_url')) {
          defaultConfig.financingingUrl = parameters['finance_api_url'];
        }

        if (parameters.containsKey('finance_mailbox')) {
          final financeMailbox = parameters['finance_mailbox'];
          logger.debug(
            'environment.config',
            'Unused financeMailbox: $financeMailbox',
          );
        }

        if (parameters.containsKey('store_loan_request_attachment')) {
          final storeLoanRequestAttachment =
              parameters['store_loan_request_attachment'];
          logger.debug(
            'environment.config',
            'Unused storeLoanRequestAttachment: $storeLoanRequestAttachment',
          );
        }
        if (parameters.containsKey('rev_cat_app_name_pos')) {
          defaultConfig.revCatAppName = parameters['rev_cat_app_name_pos'];
        }
        if (parameters.containsKey('enable_billing_pos')) {
          defaultConfig.enableBilling = jsonToBool(
            parameters['enable_billing_pos'],
          );
        }
        if (parameters.containsKey('enable_trial_pos')) {
          defaultConfig.enableTrial = jsonToBool(
            parameters['enable_trial_pos'],
          );
        }

        defaultConfig.merchantID = '';
        if (parameters.containsKey('merchant_id')) {
          defaultConfig.merchantID = parameters['merchant_id'];
        }
        defaultConfig.mcc = '';
        if (parameters.containsKey('mcc')) {
          defaultConfig.mcc = parameters['mcc'];
        }

        if (isLocal) {
          if (parameters.containsKey('report_local')) {
            final reportLocal = parameters['report_local'];
            defaultConfig.reportingUrl = reportLocal;
          }

          if (parameters.containsKey('merchant_local')) {
            defaultConfig.baseUrl = parameters['merchant_local'];
          }

          if (parameters.containsKey('finance_local')) {
            final financingingUrl = parameters['finance_local'];
            defaultConfig.financingingUrl = financingingUrl;

            if (defaultConfig.financingingUrl!.endsWith('/')) {
              defaultConfig.financingingUrl = defaultConfig.financingingUrl!
                  .substring(0, defaultConfig.financingingUrl!.length - 1);
            }
          }
        }
      }
    }
  }

  static void getSBHideables(parameterGroups, EnvironmentConfig defaultConfig) {
    if (parameterGroups is Map &&
        parameterGroups.containsKey('Standard Bank Hideables')) {
      final stdBankHideables = parameterGroups['Standard Bank Hideables'];
      if (stdBankHideables is Map &&
          stdBankHideables.containsKey('parameters')) {
        final parameters = stdBankHideables['parameters'];
        if (parameters.containsKey('enable_finance')) {
          defaultConfig.enableFinance = jsonToBool(
            parameters['enable_finance'],
          );
        }

        if (parameters.containsKey('enable_store_credit')) {
          defaultConfig.enableStoreCredit = jsonToBool(
            parameters['enable_store_credit'],
          );
        }

        if (parameters.containsKey('enable_employees')) {
          defaultConfig.enableEmployee = jsonToBool(
            parameters['enable_employees'],
          );
        }

        if (parameters.containsKey('enable_contact_us')) {
          defaultConfig.enableContactUs = jsonToBool(
            parameters['enable_contact_us'],
          );
        }

        if (parameters.containsKey('enable_tax')) {
          defaultConfig.enableTax = jsonToBool(parameters['enable_tax']);
        }

        if (parameters.containsKey('enable_staff_sales')) {
          defaultConfig.enableStaffSales = jsonToBool(
            parameters['enable_staff_sales'],
          );
        }

        if (parameters.containsKey('enable_fulfilment')) {
          defaultConfig.enableFulfilment = jsonToBool(
            parameters['enable_fulfilment'],
          );
        }

        if (parameters.containsKey('contact_us_email')) {
          defaultConfig.contactUsEmail = parameters['contact_us_email'];
        }

        if (parameters.containsKey('enable_advanced_reporting')) {
          defaultConfig.enableAdvancedReporting = jsonToBool(
            parameters['enable_advanced_reporting'],
          );
        }

        if (parameters.containsKey('enable_users')) {
          defaultConfig.enableUsers = jsonToBool(parameters['enable_users']);
        }

        if (parameters.containsKey('enable_kyc')) {
          defaultConfig.enableKYC = jsonToBool(parameters['enable_kyc']);
        }

        if (parameters.containsKey('enable_discounts')) {
          defaultConfig.enableDiscounts = jsonToBool(
            parameters['enable_discounts'],
          );
        }

        if (parameters.containsKey('enable_discount_setting')) {
          defaultConfig.enableDiscountSettings = jsonToBool(
            parameters['enable_discount_setting'],
          );
        }

        defaultConfig.enableProductDiscounts = true;
        if (parameters.containsKey('enable_product_discounts')) {
          defaultConfig.enableProductDiscounts = jsonToBool(
            parameters['enable_product_discounts'],
          );
        }

        if (parameters.containsKey('enable_get_started')) {
          defaultConfig.enableGetStarted = jsonToBool(
            parameters['enable_get_started'],
          );
        }

        if (parameters.containsKey('enable_pending_transactions')) {
          defaultConfig.enablePendingTransactions = jsonToBool(
            parameters['enable_pending_transactions'],
          );
        }

        if (parameters.containsKey('enable_bottom_bar_hamburger_menu')) {
          defaultConfig.enableBottomBarHamburgerMenu = jsonToBool(
            parameters['enable_bottom_bar_hamburger_menu'],
          );
        }

        if (parameters.containsKey('enable_sell_now_in_favourites')) {
          defaultConfig.enableSellNowInFavourites = jsonToBool(
            parameters['enable_sell_now_in_favourites'],
          );
        }

        defaultConfig.enableVoid = EnableOption.disabled;
        if (parameters.containsKey('enable_void_sale')) {
          defaultConfig.enableVoid = getConfigValue(
            parameters: parameters,
            mapKey: 'enable_void_sale',
          );
        }

        defaultConfig.enableSuppliersModule = true;
        if (parameters.containsKey('enable_suppliers_module')) {
          defaultConfig.enableSuppliersModule = jsonToBool(
            parameters['enable_suppliers_module'],
          );
        }

        if (parameters.containsKey('enable_overview_in_favourites')) {
          defaultConfig.enableOverviewInFavourites = jsonToBool(
            parameters['enable_overview_in_favourites'],
          );
        }

        if (parameters.containsKey('enable_only_cash_card_snapscan_payments')) {
          defaultConfig.enableOnlyCashCardSnapscanPayments = jsonToBool(
            parameters['enable_only_cash_card_snapscan_payments'],
          );
        }

        if (parameters.containsKey('enable_user_guide')) {
          defaultConfig.enableUserGuide = jsonToBool(
            parameters['enable_user_guide'],
          );
        }

        if (parameters.containsKey('enable_combos')) {
          defaultConfig.enableCombos = jsonToBool(parameters['enable_combos']);
        }

        if (parameters.containsKey('enable_stock')) {
          defaultConfig.enableStock = jsonToBool(parameters['enable_stock']);
        }

        defaultConfig.enableStockTaking = true;
        if (parameters.containsKey('enable_stock_taking')) {
          defaultConfig.enableStockTaking = jsonToBool(
            parameters['enable_stock_taking'],
          );
        }
        defaultConfig.enableReceivedStock = true;
        if (parameters.containsKey('enable_stock_receiving')) {
          defaultConfig.enableReceivedStock = jsonToBool(
            parameters['enable_stock_receiving'],
          );
        }

        if (parameters.containsKey('enable_checkout_favourites')) {
          defaultConfig.enableCheckoutFavourites = jsonToBool(
            parameters['enable_checkout_favourites'],
          );
        }
        if (parameters.containsKey('enable_signup')) {
          defaultConfig.enableSignup = jsonToBool(parameters['enable_signup']);
        }

        if (parameters.containsKey('enable_signup_activation')) {
          defaultConfig.enableSignupActivation = jsonToBool(
            parameters['enable_signup_activation'],
          );
        }

        if (parameters.containsKey('enable_onboarding')) {
          defaultConfig.enableOnboarding = jsonToBool(
            parameters['enable_onboarding'],
          );
        }

        if (parameters.containsKey('enable_online_store')) {
          defaultConfig.enableOnlineStore = jsonToBool(
            parameters['enable_online_store'],
          );
        }
      }
    }
  }

  static void getLFeCommerceSettings(
    parameterGroups,
    EnvironmentConfig defaultConfig,
  ) {
    if (parameterGroups is Map &&
        parameterGroups.containsKey('LF eCommerce Params')) {
      final lfMerchantSettings = parameterGroups['LF eCommerce Params'];
      if (lfMerchantSettings is Map &&
          lfMerchantSettings.containsKey('parameters')) {
        final parameters = lfMerchantSettings['parameters'];
        if (parameters.containsKey('DefaultISOLanguageCode')) {
          final defaultISOLanguageCode = parameters['DefaultISOLanguageCode'];
          logger.debug(
            'environment.environment_config',
            '### not used defaultISOLanguageCode $defaultISOLanguageCode',
          );
        }

        if (parameters.containsKey('ShowDefaultProductImage')) {
          final showDefaultProductImage = parameters['ShowDefaultProductImage'];
          logger.debug(
            'environment.environment_config',
            '### not used showDefaultProductImage $showDefaultProductImage',
          );
        }

        if (parameters.containsKey('ShowMap')) {
          final showMap = parameters['ShowMap'];
          logger.debug(
            'environment.environment_config',
            '### not used showMap $showMap',
          );
        }

        if (parameters.containsKey('google_ios_key')) {
          kGoogleAPIKey['google_ios_key'] = parameters['google_ios_key'];
        }

        if (parameters.containsKey('google_android_key')) {
          kGoogleAPIKey['google_android_key'] =
              parameters['google_android_key'];
        }
        if (parameters.containsKey('google_web_key')) {
          kGoogleAPIKey['google_web_key'] = parameters['google_web_key'];
        }

        if (parameters.containsKey('cloud_functions_url')) {
          defaultConfig.cloudFunctionsUrl = parameters['cloud_functions_url'];
        }
      }
    }
  }

  static void getLFMerchantSetting(
    parameterGroups,
    EnvironmentConfig defaultConfig,
    bool isLocal,
  ) {
    if (parameterGroups is Map &&
        parameterGroups.containsKey('LF Merchant - Settings')) {
      final lfMerchantSettings = parameterGroups['LF Merchant - Settings'];
      if (lfMerchantSettings is Map &&
          lfMerchantSettings.containsKey('parameters')) {
        final parameters = lfMerchantSettings['parameters'];

        if (parameters.containsKey('cloud_functions_url')) {
          defaultConfig.cloudFunctionsUrl = parameters['cloud_functions_url'];
        }

        if (parameters.containsKey('finance_api_url')) {
          defaultConfig.financingingUrl = parameters['finance_api_url'];
        }

        if (parameters.containsKey('store_loan_request_attachment')) {
          final storeLoanRequestAttachment =
              parameters['store_loan_request_attachment'];
          logger.debug(
            'environment.environment_config',
            '### not used storeLoanRequestAttachment $storeLoanRequestAttachment',
          );
        }

        if (parameters.containsKey('finance_mailbox')) {
          final financeMailbox = parameters['finance_mailbox'];
          logger.debug(
            'environment.config',
            'Unused financeMailbox: $financeMailbox',
          );
        }

        if (isLocal) {
          if (parameters.containsKey('finance_local')) {
            final financingingUrl = parameters['finance_local'];
            defaultConfig.financingingUrl = financingingUrl;

            if (defaultConfig.financingingUrl!.endsWith('/')) {
              defaultConfig.financingingUrl = defaultConfig.financingingUrl!
                  .substring(0, defaultConfig.financingingUrl!.length - 1);
            }
          }
        }

        if (parameters.containsKey('finance_enabled')) {
          defaultConfig.financeEnabled = jsonToBool(
            parameters['finance_enabled'],
          );
        }

        if (parameters.containsKey('snapscan_enabled')) {
          defaultConfig.snapscanEnabled = jsonToBool(
            parameters['snapscan_enabled'],
          );
        }

        if (parameters.containsKey('zapper_enabled')) {
          defaultConfig.zapperEnabled = jsonToBool(
            parameters['zapper_enabled'],
          );
        }

        if (isLocal) {
          if (parameters.containsKey('report_local')) {
            final reportLocal = parameters['report_local'];
            defaultConfig.reportingUrl = reportLocal;
          }

          if (parameters.containsKey('merchant_local')) {
            defaultConfig.baseUrl = parameters['merchant_local'];
          }
        }
        if (parameters.containsKey('client_support_email')) {
          defaultConfig.clientSupportEmail = parameters['client_support_email'];
        }
        if (parameters.containsKey('client_support_mobile_number')) {
          defaultConfig.clientSupportMobileNumber =
              parameters['client_support_mobile_number'];
        }

        if (parameters.containsKey('privacy_policy_url')) {
          defaultConfig.privacyPolicyUrl = parameters['privacy_policy_url'];
        }
        if (parameters.containsKey('terms_conditions_url')) {
          defaultConfig.termsAndConditionsUrl =
              parameters['terms_conditions_url'];
        }

        if (!isLocal) {
          if (parameters.containsKey('merchant_api_url')) {
            final baseUrl = parameters['merchant_api_url'];
            defaultConfig.baseUrl = baseUrl;

            if (defaultConfig.baseUrl!.endsWith('/')) {
              defaultConfig.baseUrl = defaultConfig.baseUrl!.substring(
                0,
                defaultConfig.baseUrl!.length - 1,
              );
            }
          }

          if (parameters.containsKey('payments_api_url')) {
            final paymentsUrl = parameters['payments_api_url'];
            defaultConfig.paymentsUrl = paymentsUrl;

            if (defaultConfig.paymentsUrl!.endsWith('/')) {
              defaultConfig.paymentsUrl = defaultConfig.paymentsUrl!.substring(
                0,
                defaultConfig.paymentsUrl!.length - 1,
              );
            }
          }

          if (parameters.containsKey('payment_links_pay_url')) {
            final paymentLinksPayUrl = parameters['payment_links_pay_url'];
            defaultConfig.paymentLinksPayUrl = paymentLinksPayUrl;

            if (defaultConfig.paymentLinksPayUrl!.endsWith('/')) {
              defaultConfig.paymentLinksPayUrl = defaultConfig
                  .paymentLinksPayUrl!
                  .substring(0, defaultConfig.paymentLinksPayUrl!.length - 1);
            }
          }

          if (parameters.containsKey('report_api_url')) {
            final reportLocal = parameters['report_api_url'];
            defaultConfig.reportingUrl = reportLocal;

            if (defaultConfig.reportingUrl!.endsWith('/')) {
              defaultConfig.reportingUrl = defaultConfig.reportingUrl!
                  .substring(0, defaultConfig.reportingUrl!.length - 1);
            }
          }
        }

        if (parameters.containsKey('enable_trial_pos')) {
          defaultConfig.enableTrial = jsonToBool(
            parameters['enable_trial_pos'],
          );
        }
        if (parameters.containsKey('enable_billing_pos')) {
          defaultConfig.enableBilling = jsonToBool(
            parameters['enable_billing_pos'],
          );
        }

        if (parameters.containsKey('rev_cat_app_name_pos')) {
          defaultConfig.revCatAppName = parameters['rev_cat_app_name_pos'];
        }

        if (parameters.containsKey('authorization_token')) {
          defaultConfig.authorizationToken = parameters['authorization_token'];
        }

        if (parameters.containsKey('activation_options')) {
          final activations = parameters['activation_options'];
          defaultConfig.activationOptions = (activations as List)
              .map((e) => e as String)
              .toList();
        }
      }
    }
  }

  static void getFeatureFlagParameters(
    ffMap,
    EnvironmentConfig defaultConfig,
    bool isLocal,
  ) {
    if (ffMap is Map && ffMap.containsKey('parameters')) {
      final parameters = ffMap['parameters'];
      if (parameters is Map) {
        defaultConfig.enableNewSale = getConfigValue(
          parameters: parameters,
          mapKey: 'enable_new_sale',
        );

        defaultConfig.fontCasing = getFontCasingValue(
          parameters: parameters,
          mapKey: 'font_casing',
        );

        defaultConfig.enableTransactions = getConfigValue(
          parameters: parameters,
          mapKey: 'enable_transactions',
        );

        defaultConfig.enableTransactionsRefundSale = getConfigValue(
          parameters: parameters,
          mapKey: 'enable_transactions_refund_sale',
        );

        defaultConfig.enableCustomerSalesRefundSales = getConfigValue(
          parameters: parameters,
          mapKey: 'enable_customer_sales_refund_sales',
        );

        if (parameters.containsKey('enable_store_setup_v2')) {
          final enableStoreSetupv2 = parameters['enable_store_setup_v2'];
          logger.debug(
            'environment.environment_config',
            '### enable_store_setup_v2 not used $enableStoreSetupv2',
          );
        }

        if (parameters.containsKey('subscription_frequency')) {
          final subFrequencyMap = parameters['subscription_frequency'];
          if (subFrequencyMap is Map<String, dynamic>) {
            defaultConfig.subscriptionFrequency =
                SubscriptionFrequency.fromJsonRobust(subFrequencyMap);
          }
        }

        if (parameters.containsKey('pos_online_store_settings')) {
          final posOnlineStoreSettings =
              parameters['pos_online_store_settings'];
          defaultConfig.onlineStoreSettings = POSOnlineStoreSettings.fromJson(
            posOnlineStoreSettings,
          );
        }

        if (parameters.containsKey('accentColor')) {
          final accentColor = parameters['accentColor'];
          defaultConfig.accentColor = accentColor;
        }

        if (isLocal) {
          if (parameters.containsKey('baseUrl')) {
            final baseUrl = parameters['baseUrl'];
            defaultConfig.baseUrl = baseUrl;
          }

          if (parameters.containsKey('bq_download_reports_local')) {
            final bqDownloadReportsUrl =
                parameters['bq_download_reports_local'];
            defaultConfig.bqDownloadReportsUrl = bqDownloadReportsUrl;
          }
        } else {
          if (parameters.containsKey('bq_download_reports_url')) {
            final bqDownloadReportsUrl = parameters['bq_download_reports_url'];
            defaultConfig.bqDownloadReportsUrl = bqDownloadReportsUrl;
          }
        }

        if (parameters.containsKey('contact_us_number')) {
          defaultConfig.contactUsNumber = parameters['contact_us_number'];
        }

        if (parameters.containsKey('pos_subscription_grace_period')) {
          final value = parameters['pos_subscription_grace_period'];
          if (value is int) {
            defaultConfig.posSubscriptionGracePeriod = value;
          } else if (value is double) {
            defaultConfig.posSubscriptionGracePeriod = value.toInt();
          }
        }

        if (parameters.containsKey('user_guide')) {
          defaultConfig.userGuide = parameters['user_guide'];
        }
        if (parameters.containsKey('withdraw_requirements')) {
          final withdrawRequirements = parameters['withdraw_requirements'];
          defaultConfig.withdrawRequirements = WithdrawRequirements.fromJson(
            withdrawRequirements,
          );
        }

        if (parameters.containsKey('onboardingUrl')) {
          defaultConfig.onboardingUrl = parameters['onboardingUrl'];
        }
        if (parameters.containsKey('enable_offline_checkout')) {
          final value = parameters['enable_offline_checkout'];
          defaultConfig.enableOfflineCheckout = jsonToBool(value);
        }
        if (parameters.containsKey('cashback_amount_options')) {
          final cashbackAmountOptions = parameters['cashback_amount_options'];
          defaultConfig.cashbackAmountOptions = (cashbackAmountOptions as List)
              .map((e) => jsonToDouble(e))
              .toList();
        }
        if (parameters.containsKey('enable_cashback')) {
          defaultConfig.enableCashback = jsonToBool(
            parameters['enable_cashback'],
          );
        }
        if (parameters.containsKey('enable_financial_statements')) {
          defaultConfig.enableFinancialStatements = jsonToBool(
            parameters['enable_financial_statements'],
          );
        }
        if (parameters.containsKey('paid_features_list')) {
          final paidFeaturesList = parameters['paid_features_list'];
          defaultConfig.paidFeaturesList = (paidFeaturesList as List)
              .map((e) => e as String)
              .toList();
        }
        if (parameters.containsKey('sessions_max_length_minutes')) {
          final sessionsMaxLengthMinutes =
              parameters['sessions_max_length_minutes'];
          logger.debug(
            'environment.config',
            'Sessions max length minutes not used: $sessionsMaxLengthMinutes',
          );
        }

        if (parameters.containsKey('playstore_subscription_keys')) {
          final storeSubscriptionKeysMap =
              parameters['playstore_subscription_keys'];
          var monthly = storeSubscriptionKeysMap['monthly'] as String?;
          var yearly = storeSubscriptionKeysMap['yearly'] as String?;
          defaultConfig.subscriptionKeys = [monthly, yearly];
        }

        if (parameters.containsKey('enable_enhanced_onboarding')) {
          defaultConfig.enableEnhancedOnboarding = jsonToBool(
            parameters['enable_enhanced_onboarding'],
          );
          if (defaultConfig.enableEnhancedOnboarding ?? false) {
            if (parameters.containsKey('enhanced_onboarding_routes')) {
              final routes = parameters['enhanced_onboarding_routes'];
              defaultConfig.enhancedOnboardingRoutes = (routes as List)
                  .map((e) => e as String)
                  .toList();
            }
          }
        }
        if (parameters.containsKey('algolia_store_index')) {
          final algoliaStoreIindex = parameters['algolia_store_index'];
          logger.debug(
            'environment.environment_config',
            '### algoliaStoreIindex not used $algoliaStoreIindex',
          );
        }

        if (parameters.containsKey('playstore_subscription_key')) {
          final playstoreSubscriptionKey =
              parameters['playstore_subscription_key'];
          logger.debug(
            'environment.environment_config',
            '### playstoreSubscriptionKey not used $playstoreSubscriptionKey',
          );
        }

        if (parameters.containsKey('cashback_requirements')) {
          final cashbackRequirements = parameters['cashback_requirements'];
          defaultConfig.cashbackRequirements = CashbackRequirements.fromJson(
            cashbackRequirements,
          );
        }
        if (parameters.containsKey('withdrawal_amount_options')) {
          final withdrawalAmountOptions =
              parameters['withdrawal_amount_options'];
          defaultConfig.withdrawalAmountOptions =
              (withdrawalAmountOptions as List)
                  .map((e) => e as double)
                  .toList();
        }
        if (parameters.containsKey('preset_tip_percentage')) {
          final checkoutTipPercentages = parameters['preset_tip_percentage'];
          defaultConfig.presetCheckoutTipPercentages =
              (checkoutTipPercentages as List)
                  .map((e) => jsonToDouble(e))
                  .toList();
        }
        if (parameters.containsKey('pos_minimum_app_version')) {
          defaultConfig.minimumAppVersion =
              parameters['pos_minimum_app_version'];
        }
        if (parameters.containsKey('allowed_file_types')) {
          final allowedFileTypes = parameters['allowed_file_types'];
          defaultConfig.allowedFileTypes = (allowedFileTypes as List)
              .map((e) => e as String)
              .toList();
        }

        if (parameters.containsKey('sessions_feature_enabled')) {
          final sessionsFeatureEnabled = parameters['sessions_feature_enabled'];
          logger.debug(
            'environment.environment_config',
            '### sessionsFeatureEnabled not used $sessionsFeatureEnabled',
          );
        }

        if (parameters.containsKey('CommonPasswords')) {
          final commonPasswords = parameters['CommonPasswords'];
          defaultConfig.commonPasswords = (commonPasswords['passwords'] as List)
              .map((e) => e as String)
              .toList();
        }
        if (parameters.containsKey('preset_discount_percentage')) {
          final percentages = parameters['preset_discount_percentage'];
          defaultConfig.presetDiscountPercentages = (percentages as List)
              .map((e) => jsonToDouble(e))
              .toList();
        }
        if (parameters.containsKey('enable_withdrawal')) {
          defaultConfig.enableWithdrawal = jsonToBool(
            parameters['enable_withdrawal'],
          );
        }
        if (parameters.containsKey('enable_checkout_v2')) {
          defaultConfig.enableCheckoutV2 = jsonToBool(
            parameters['enable_checkout_v2'],
          );
        }
        defaultConfig.enableGuestUser = false;
        if (parameters.containsKey('enable_guest_user')) {
          defaultConfig.enableGuestUser = jsonToBool(
            parameters['enable_guest_user'],
          );
        }
        defaultConfig.guestUserTimeout = '1D';
        if (parameters.containsKey('guest_user_timeout')) {
          defaultConfig.guestUserTimeout = parameters['guest_user_timeout'];
        }
        defaultConfig.enableDeleteAccountPage = false;
        if (parameters.containsKey('config_enable_delete_account')) {
          defaultConfig.enableDeleteAccountPage = jsonToBool(
            parameters['config_enable_delete_account'],
          );
        }
        if (parameters.containsKey('enable_tips')) {
          defaultConfig.enableTips = jsonToBool(parameters['enable_tips']);
        }
        if (parameters.containsKey('pos_store_license')) {
          final posStoreLicense = parameters['pos_store_license'];
          defaultConfig.posStoreLicense = POSStoreLicense.fromJson(
            posStoreLicense,
          );
        }
        if (parameters.containsKey('enable_overview_home_page')) {
          defaultConfig.enableOverviewHomePage = jsonToBool(
            parameters['enable_overview_home_page'],
          );
        }

        defaultConfig.enableLinkedDevices = true;
        if (parameters.containsKey('enable_linked_device')) {
          defaultConfig.enableLinkedDevices = jsonToBool(
            parameters['enable_linked_device'],
          );
        }

        defaultConfig.enableHomeOnlineStoreCard = true;
        if (parameters.containsKey('enable_home_online_store_card')) {
          defaultConfig.enableHomeOnlineStoreCard = jsonToBool(
            parameters['enable_home_online_store_card'],
          );
        }
      }
    }
  }

  static bool jsonToBool(value) {
    if (value is String) {
      return value.contains('true') ? true : false;
    } else if (value is bool) {
      return value;
    } else {
      return false;
    }
  }

  static int jsonToInt(value) {
    if (value is String) {
      return int.tryParse(value) ?? 0;
    } else if (value is int) {
      return value;
    } else if (value is double) {
      return value.toInt();
    }
    return 0;
  }

  static double jsonToDouble(value) {
    if (value is String) {
      return double.tryParse(value) ?? 0.0;
    } else if (value is int) {
      return value.toDouble();
    } else if (value is double) {
      return value;
    }
    return 0;
  }

  static EnableOption getConfigValue({
    required Map parameters,
    required String mapKey,
  }) {
    var enableOption = EnableOption.notSet;
    if (parameters.containsKey(mapKey)) {
      final mapValue = parameters[mapKey];
      if (mapValue is String) {
        switch (mapValue) {
          case 'disabled':
            enableOption = EnableOption.disabled;
            break;
          case 'enabled':
            enableOption = EnableOption.enabled;
            break;
          case 'enabledForV1':
            enableOption = EnableOption.enabledForV1;
            break;
          case 'enabledForV2':
            enableOption = EnableOption.enabledForV2;
            break;

          default:
            enableOption = EnableOption.notSet;
        }
      }
    }
    return enableOption;
  }

  static AppFontCasing getFontCasingValue({
    required Map parameters,
    required String mapKey,
  }) {
    var enableOption = AppFontCasing.upperCase;
    if (parameters.containsKey(mapKey)) {
      final mapValue = parameters[mapKey];
      if (mapValue is String) {
        switch (mapValue) {
          case 'upperCase':
            enableOption = AppFontCasing.upperCase;
            break;
          case 'titleCase':
            enableOption = AppFontCasing.titleCase;
            break;
          case 'lowerCase':
            enableOption = AppFontCasing.lowerCase;
            break;

          default:
            enableOption = AppFontCasing.upperCase;
        }
      }
    }
    return enableOption;
  }
}

enum AppEnvironment { local, dev, prod }
