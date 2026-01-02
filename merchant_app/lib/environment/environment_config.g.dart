// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment_config.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EnvironmentConfig _$EnvironmentConfigFromJson(Map<String, dynamic> json) =>
    EnvironmentConfig(
        accentColor: json['accentColor'] as String?,
        baseUrl: json['baseUrl'] as String?,
        paymentsUrl: json['paymentsUrl'] as String?,
        paymentLinksPayUrl: json['paymentLinksPayUrl'] as String?,
        reportingUrl: json['reportingUrl'] as String?,
        financingingUrl: json['financingingUrl'] as String?,
        environment: $enumDecodeNullable(
          _$AppEnvironmentEnumMap,
          json['environment'],
        ),
        name: json['name'] as String?,
        primaryColor: json['primaryColor'] as String?,
        dsn: json['dsn'] as String?,
        enableLogging: json['enableLogging'] as bool?,
        authProviderType: $enumDecodeNullable(
          _$AuthProviderTypeEnumMap,
          json['authProviderType'],
        ),
        privacyPolicyUrl: json['privacyPolicyUrl'] as String?,
        termsAndConditionsUrl: json['termsAndConditionsUrl'] as String?,
        zapperEnabled: json['zapperEnabled'] as bool? ?? false,
        snapscanEnabled: json['snapscanEnabled'] as bool? ?? false,
        financeEnabled: json['financeEnabled'] as bool? ?? false,
        enableBilling: json['enableBilling'] as bool? ?? false,
        enableTrial: json['enableTrial'] as bool? ?? false,
        revCatAppName: json['revCatAppName'] as String?,
        cloudFunctionsUrl: json['cloudFunctionsUrl'] as String?,
        posStoreLicense: json['posStoreLicense'] == null
            ? null
            : POSStoreLicense.fromJson(
                json['posStoreLicense'] as Map<String, dynamic>,
              ),
        subscriptionKeys: (json['subscriptionKeys'] as List<dynamic>?)
            ?.map((e) => e as String?)
            .toList(),
        contactUsNumber: json['contactUsNumber'] as String?,
        contactUsEmail: json['contactUsEmail'] as String?,
        userGuide: json['userGuide'] as String?,
        enableCheckoutV2: json['enableCheckoutV2'] as bool?,
        enableOfflineCheckout: json['enableOfflineCheckout'] as bool?,
        paidFeaturesList: (json['paidFeaturesList'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        commonPasswords: (json['commonPasswords'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        allowedFileTypes: (json['allowedFileTypes'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
        minimumAppVersion: json['minimumAppVersion'] as String?,
        posSubscriptionGracePeriod: (json['posSubscriptionGracePeriod'] as num?)
            ?.toInt(),
        onlineStoreSettings: json['onlineStoreSettings'] == null
            ? null
            : POSOnlineStoreSettings.fromJson(
                json['onlineStoreSettings'] as Map<String, dynamic>,
              ),
        bqDownloadReportsUrl: json['bqDownloadReportsUrl'] as String?,
        enableEnhancedOnboarding:
            json['enableEnhancedOnboarding'] as bool? ?? false,
        enhancedOnboardingRoutes:
            (json['enhancedOnboardingRoutes'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList(),
        envIOSMarketAppBundleID:
            json['envIOSMarketAppBundleID'] as String? ??
            'africa.littlefishapp.littlefishseller',
        envIOSSellerAppBundleID:
            json['envIOSSellerAppBundleID'] as String? ??
            'africa.littlefishapp.littlefishmarket',
        envAndroidMarketAppBundleID:
            json['envAndroidMarketAppBundleID'] as String? ??
            'africa.littlefishapp.littlefish_seller',
        envAndroidSellerAppBundleID:
            json['envAndroidSellerAppBundleID'] as String? ??
            'africa.littlefishapp.littlefish_market',
        onboardingUrl: json['onboardingUrl'] as String?,
        subscriptionFrequency: json['subscriptionFrequency'] == null
            ? null
            : SubscriptionFrequency.fromJson(
                json['subscriptionFrequency'] as Map<String, dynamic>,
              ),
        enableOnlineStore: json['enableOnlineStore'] as bool? ?? false,
        enableFinance: json['enableFinance'] as bool? ?? false,
        enableContactUs: json['enableContactUs'] as bool? ?? false,
        enableUserGuide: json['enableUserGuide'] as bool? ?? false,
        enableTax: json['enableTax'] as bool? ?? false,
        enableStoreCredit: json['enableStoreCredit'] as bool? ?? false,
        enableEmployee: json['enableEmployee'] as bool? ?? false,
        enableStaffSales: json['enableStaffSales'] as bool? ?? false,
        enableFulfilment: json['enableFulfilment'] as bool? ?? false,
        enableAdvancedReporting:
            json['enableAdvancedReporting'] as bool? ?? false,
        enableUsers: json['enableUsers'] as bool? ?? false,
        enableKYC: json['enableKYC'] as bool? ?? false,
        enableDiscounts: json['enableDiscounts'] as bool? ?? false,
        enableDiscountSettings:
            json['enableDiscountSettings'] as bool? ?? false,
        enableGetStarted: json['enableGetStarted'] as bool? ?? false,
        enablePendingTransactions:
            json['enablePendingTransactions'] as bool? ?? false,
        enableCheckoutFavourites:
            json['enableCheckoutFavourites'] as bool? ?? false,
        enableBottomBarHamburgerMenu:
            json['enableBottomBarHamburgerMenu'] as bool? ?? false,
        enableSellNowInFavourites:
            json['enableSellNowInFavourites'] as bool? ?? false,
        enableSellNowModule: json['enableSellNowModule'] as bool? ?? false,
        enableSuppliersModule: json['enableSuppliersModule'] as bool? ?? false,
        enableOverviewInFavourites:
            json['enableOverviewInFavourites'] as bool? ?? false,
        enableOnlyCashCardSnapscanPayments:
            json['enableOnlyCashCardSnapscanPayments'] as bool? ?? false,
        enableStock: json['enableStock'] as bool? ?? false,
        enableReceiveStock: json['enableReceiveStock'] as bool? ?? false,
        enableReceivedStock: json['enableReceivedStock'] as bool? ?? false,
        enableStockTaking: json['enableStockTaking'] as bool? ?? false,
        enableCombos: json['enableCombos'] as bool? ?? false,
        enableSignup: json['enableSignup'] as bool? ?? false,
        presetDiscountPercentages:
            (json['presetDiscountPercentages'] as List<dynamic>?)
                ?.map((e) => (e as num).toDouble())
                .toList(),
        presetCheckoutTipPercentages:
            (json['presetCheckoutTipPercentages'] as List<dynamic>?)
                ?.map((e) => (e as num).toDouble())
                .toList(),
        enableSignupActivation:
            json['enableSignupActivation'] as bool? ?? false,
        authorizationToken: json['authorizationToken'] as String?,
        enableOnboarding: json['enableOnboarding'] as bool? ?? false,
        cashbackRequirements: json['cashbackRequirements'] == null
            ? null
            : CashbackRequirements.fromJson(
                json['cashbackRequirements'] as Map<String, dynamic>,
              ),
        withdrawRequirements: json['withdrawRequirements'] == null
            ? null
            : WithdrawRequirements.fromJson(
                json['withdrawRequirements'] as Map<String, dynamic>,
              ),
        cashbackAmountOptions: (json['cashbackAmountOptions'] as List<dynamic>?)
            ?.map((e) => (e as num).toDouble())
            .toList(),
        withdrawalAmountOptions:
            (json['withdrawalAmountOptions'] as List<dynamic>?)
                ?.map((e) => (e as num).toDouble())
                .toList(),
        enableCashback: json['enableCashback'] as bool? ?? false,
        enableWithdrawal: json['enableWithdrawal'] as bool? ?? false,
        enableTips: json['enableTips'] as bool? ?? false,
        enableOverviewHomePage:
            json['enableOverviewHomePage'] as bool? ?? false,
        enableFinancialStatements:
            json['enableFinancialStatements'] as bool? ?? false,
        enableVoid:
            $enumDecodeNullable(_$EnableOptionEnumMap, json['enableVoid']) ??
            EnableOption.notSet,
        merchantID: json['merchantID'] as String? ?? '',
        mcc: json['mcc'] as String? ?? '',
        enableHomeOnlineStoreCard:
            json['enableHomeOnlineStoreCard'] as bool? ?? false,
        enableNewSale:
            $enumDecodeNullable(_$EnableOptionEnumMap, json['enableNewSale']) ??
            EnableOption.notSet,
        enableTransactions:
            $enumDecodeNullable(
              _$EnableOptionEnumMap,
              json['enableTransactions'],
            ) ??
            EnableOption.notSet,
        enableTransactionsRefundSale:
            $enumDecodeNullable(
              _$EnableOptionEnumMap,
              json['enableTransactionsRefundSale'],
            ) ??
            EnableOption.notSet,
        enableCustomerSalesRefundSales:
            $enumDecodeNullable(
              _$EnableOptionEnumMap,
              json['enableCustomerSalesRefundSales'],
            ) ??
            EnableOption.notSet,
        enableGuestUser: json['enableGuestUser'] as bool? ?? false,
        guestUserTimeout: json['guestUserTimeout'] as String?,
        enableDeleteAccountPage: json['enableDeleteAccountPage'] as bool?,
        fontCasing:
            $enumDecodeNullable(_$AppFontCasingEnumMap, json['fontCasing']) ??
            AppFontCasing.upperCase,
        slowNetworkNotificationInterval:
            (json['slowNetworkNotificationInterval'] as num?)?.toInt(),
        configEnableSlowNetworkCheck:
            json['configEnableSlowNetworkCheck'] as bool? ?? false,
        softPosProviderName: json['softPosProviderName'] as String?,
        enableProductVarianceManagement:
            json['enableProductVarianceManagement'] as bool? ?? false,
        merchantIdLength: (json['merchantIdLength'] as num?)?.toInt() ?? 10,
        enablePrintLastReceipt:
            json['enablePrintLastReceipt'] as bool? ?? false,
        enableBalanceEnquiry: json['enableBalanceEnquiry'] as bool? ?? false,
        enableUsePosMerchantName:
            json['enableUsePosMerchantName'] as bool? ?? false,
        enableGetPaid: json['enableGetPaid'] as bool? ?? false,
        enablePaymentLinks: json['enablePaymentLinks'] as bool? ?? false,
      )
      ..clientSupportEmail = json['clientSupportEmail'] as String?
      ..clientSupportMobileNumber = json['clientSupportMobileNumber'] as String?
      ..activationOptions = (json['activationOptions'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList()
      ..customPaymentLinksBannerMessage =
          json['customPaymentLinksBannerMessage'] as String?
      ..customStoreReviewMessage = json['customStoreReviewMessage'] as String?
      ..wizzitTapToPayEnabled = json['wizzitTapToPayEnabled'] as bool? ?? false
      ..enableProductDiscounts =
          json['enableProductDiscounts'] as bool? ?? false
      ..cybersourceEnabled = json['cybersourceEnabled'] as bool? ?? false
      ..exitPasswordEnabled = json['exitPasswordEnabled'] as bool? ?? false
      ..enableSideNavDrawer = json['enableSideNavDrawer'] as bool? ?? false
      ..enableBottomNavBar = json['enableBottomNavBar'] as bool? ?? false
      ..enableProfileNavBar = json['enableProfileNavBar'] as bool? ?? false
      ..enableStoreSetupV2 = json['enableStoreSetupV2'] as bool? ?? false
      ..enableLinkedDevices = json['enableLinkedDevices'] as bool? ?? false
      ..enableGetApp = json['enableGetApp'] as bool? ?? false
      ..enableTerminalReportFiltering =
          json['enableTerminalReportFiltering'] as bool? ?? false
      ..enableInvoices = json['enableInvoices'] as bool? ?? false
      ..softPosDeviceLimit = (json['softPosDeviceLimit'] as num?)?.toInt();

Map<String, dynamic> _$EnvironmentConfigToJson(
  EnvironmentConfig instance,
) => <String, dynamic>{
  'environment': _$AppEnvironmentEnumMap[instance.environment],
  'posStoreLicense': instance.posStoreLicense,
  'onlineStoreSettings': instance.onlineStoreSettings,
  'subscriptionFrequency': instance.subscriptionFrequency,
  'subscriptionKeys': instance.subscriptionKeys,
  'authProviderType': _$AuthProviderTypeEnumMap[instance.authProviderType],
  'cashbackRequirements': instance.cashbackRequirements,
  'withdrawRequirements': instance.withdrawRequirements,
  'name': instance.name,
  'baseUrl': instance.baseUrl,
  'paymentsUrl': instance.paymentsUrl,
  'paymentLinksPayUrl': instance.paymentLinksPayUrl,
  'reportingUrl': instance.reportingUrl,
  'financingingUrl': instance.financingingUrl,
  'cloudFunctionsUrl': instance.cloudFunctionsUrl,
  'bqDownloadReportsUrl': instance.bqDownloadReportsUrl,
  'revCatAppName': instance.revCatAppName,
  'contactUsNumber': instance.contactUsNumber,
  'contactUsEmail': instance.contactUsEmail,
  'userGuide': instance.userGuide,
  'clientSupportEmail': instance.clientSupportEmail,
  'clientSupportMobileNumber': instance.clientSupportMobileNumber,
  'paidFeaturesList': instance.paidFeaturesList,
  'commonPasswords': instance.commonPasswords,
  'allowedFileTypes': instance.allowedFileTypes,
  'presetDiscountPercentages': instance.presetDiscountPercentages,
  'presetCheckoutTipPercentages': instance.presetCheckoutTipPercentages,
  'onboardingUrl': instance.onboardingUrl,
  'cashbackAmountOptions': instance.cashbackAmountOptions,
  'withdrawalAmountOptions': instance.withdrawalAmountOptions,
  'guestUserTimeout': instance.guestUserTimeout,
  'enableDeleteAccountPage': instance.enableDeleteAccountPage,
  'enableOfflineCheckout': instance.enableOfflineCheckout,
  'enableCheckoutV2': instance.enableCheckoutV2,
  'primaryColor': instance.primaryColor,
  'accentColor': instance.accentColor,
  'privacyPolicyUrl': instance.privacyPolicyUrl,
  'termsAndConditionsUrl': instance.termsAndConditionsUrl,
  'dsn': instance.dsn,
  'minimumAppVersion': instance.minimumAppVersion,
  'authorizationToken': instance.authorizationToken,
  'posSubscriptionGracePeriod': instance.posSubscriptionGracePeriod,
  'envIOSSellerAppBundleID': instance.envIOSSellerAppBundleID,
  'envIOSMarketAppBundleID': instance.envIOSMarketAppBundleID,
  'envAndroidSellerAppBundleID': instance.envAndroidSellerAppBundleID,
  'envAndroidMarketAppBundleID': instance.envAndroidMarketAppBundleID,
  'merchantID': instance.merchantID,
  'mcc': instance.mcc,
  'activationOptions': instance.activationOptions,
  'enableNewSale': _$EnableOptionEnumMap[instance.enableNewSale]!,
  'enableTransactions': _$EnableOptionEnumMap[instance.enableTransactions]!,
  'enableTransactionsRefundSale':
      _$EnableOptionEnumMap[instance.enableTransactionsRefundSale]!,
  'enableCustomerSalesRefundSales':
      _$EnableOptionEnumMap[instance.enableCustomerSalesRefundSales]!,
  'enableVoid': _$EnableOptionEnumMap[instance.enableVoid]!,
  'fontCasing': _$AppFontCasingEnumMap[instance.fontCasing]!,
  'softPosProviderName': instance.softPosProviderName,
  'customPaymentLinksBannerMessage': instance.customPaymentLinksBannerMessage,
  'customStoreReviewMessage': instance.customStoreReviewMessage,
  'zapperEnabled': instance.zapperEnabled,
  'snapscanEnabled': instance.snapscanEnabled,
  'wizzitTapToPayEnabled': instance.wizzitTapToPayEnabled,
  'financeEnabled': instance.financeEnabled,
  'enableBilling': instance.enableBilling,
  'enableTrial': instance.enableTrial,
  'enableEnhancedOnboarding': instance.enableEnhancedOnboarding,
  'enableOnlineStore': instance.enableOnlineStore,
  'enableFinance': instance.enableFinance,
  'enableContactUs': instance.enableContactUs,
  'enableUserGuide': instance.enableUserGuide,
  'enableTax': instance.enableTax,
  'enableStoreCredit': instance.enableStoreCredit,
  'enableEmployee': instance.enableEmployee,
  'enableStaffSales': instance.enableStaffSales,
  'enableFulfilment': instance.enableFulfilment,
  'enableAdvancedReporting': instance.enableAdvancedReporting,
  'enableUsers': instance.enableUsers,
  'enableDiscounts': instance.enableDiscounts,
  'enableDiscountSettings': instance.enableDiscountSettings,
  'enableProductDiscounts': instance.enableProductDiscounts,
  'enableGetStarted': instance.enableGetStarted,
  'enablePendingTransactions': instance.enablePendingTransactions,
  'enableCheckoutFavourites': instance.enableCheckoutFavourites,
  'enableBottomBarHamburgerMenu': instance.enableBottomBarHamburgerMenu,
  'enableSellNowInFavourites': instance.enableSellNowInFavourites,
  'enableSellNowModule': instance.enableSellNowModule,
  'enableSuppliersModule': instance.enableSuppliersModule,
  'enableOverviewInFavourites': instance.enableOverviewInFavourites,
  'enableOnlyCashCardSnapscanPayments':
      instance.enableOnlyCashCardSnapscanPayments,
  'enableKYC': instance.enableKYC,
  'cybersourceEnabled': instance.cybersourceEnabled,
  'exitPasswordEnabled': instance.exitPasswordEnabled,
  'enableStock': instance.enableStock,
  'enableReceiveStock': instance.enableReceiveStock,
  'enableReceivedStock': instance.enableReceivedStock,
  'enableStockTaking': instance.enableStockTaking,
  'enableCombos': instance.enableCombos,
  'enableSignup': instance.enableSignup,
  'enableSignupActivation': instance.enableSignupActivation,
  'enableCashback': instance.enableCashback,
  'enableWithdrawal': instance.enableWithdrawal,
  'enableOnboarding': instance.enableOnboarding,
  'enableTips': instance.enableTips,
  'enableSideNavDrawer': instance.enableSideNavDrawer,
  'enableBottomNavBar': instance.enableBottomNavBar,
  'enableProfileNavBar': instance.enableProfileNavBar,
  'enableStoreSetupV2': instance.enableStoreSetupV2,
  'enableOverviewHomePage': instance.enableOverviewHomePage,
  'enableFinancialStatements': instance.enableFinancialStatements,
  'enableLinkedDevices': instance.enableLinkedDevices,
  'enableGetApp': instance.enableGetApp,
  'enableHomeOnlineStoreCard': instance.enableHomeOnlineStoreCard,
  'enableGuestUser': instance.enableGuestUser,
  'configEnableSlowNetworkCheck': instance.configEnableSlowNetworkCheck,
  'enableProductVarianceManagement': instance.enableProductVarianceManagement,
  'enablePrintLastReceipt': instance.enablePrintLastReceipt,
  'enableBalanceEnquiry': instance.enableBalanceEnquiry,
  'enableUsePosMerchantName': instance.enableUsePosMerchantName,
  'enableTerminalReportFiltering': instance.enableTerminalReportFiltering,
  'enableGetPaid': instance.enableGetPaid,
  'enablePaymentLinks': instance.enablePaymentLinks,
  'enableInvoices': instance.enableInvoices,
  'slowNetworkNotificationInterval': instance.slowNetworkNotificationInterval,
  'merchantIdLength': instance.merchantIdLength,
  'softPosDeviceLimit': instance.softPosDeviceLimit,
  'enhancedOnboardingRoutes': instance.enhancedOnboardingRoutes,
  'enableLogging': instance.enableLogging,
};

const _$AppEnvironmentEnumMap = {
  AppEnvironment.local: 'local',
  AppEnvironment.dev: 'dev',
  AppEnvironment.prod: 'prod',
};

const _$AuthProviderTypeEnumMap = {
  AuthProviderType.systemDefault: 0,
  AuthProviderType.firebase: 1,
};

const _$EnableOptionEnumMap = {
  EnableOption.notSet: 'notSet',
  EnableOption.disabled: 'disabled',
  EnableOption.enabled: 'enabled',
  EnableOption.enabledForV1: 'enabledForV1',
  EnableOption.enabledForV2: 'enabledForV2',
};

const _$AppFontCasingEnumMap = {
  AppFontCasing.none: 'none',
  AppFontCasing.upperCase: 'upperCase',
  AppFontCasing.titleCase: 'titleCase',
  AppFontCasing.lowerCase: 'lowerCase',
};
