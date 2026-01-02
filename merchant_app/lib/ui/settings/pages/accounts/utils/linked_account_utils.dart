import 'package:flutter/material.dart';
import 'package:littlefish_core/configuration/config_service.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';
import 'package:littlefish_merchant/features/order_common/data/model/app_constants.dart';
import 'package:littlefish_merchant/features/paywall/data/data_source/paywall_configuration.dart';
import 'package:littlefish_merchant/features/paywall/presentation/component/paywall_dialog.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/redux/app/app_actions.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/linked_account_vm.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/providers/default_provider_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/providers/snapscan/snapscan_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/providers/wizzit/wizzit_page.dart';
import 'package:littlefish_merchant/ui/settings/pages/accounts/providers/zapper/zapper_page.dart';
import 'package:littlefish_payments/models/accounts/linked_account.dart' as pm;

class LinkedAccountUtils {
  static Widget buildProviderPage(
    BuildContext context,
    ProviderType? type,
    LinkedAccountVM vm,
    LinkedAccount item,
  ) {
    if (type == null) {
      return DefaultProviderPage();
    }

    switch (type) {
      case ProviderType.zapper:
        return ZapperPage(vm, initialValue: item);
      case ProviderType.snapscan:
        return SnapscanPage(vm, initialValue: item);
      case ProviderType.wizzitTapToPay:
        return WizzitPage(showHeader: false, initialValue: item);

      default:
        return DefaultProviderPage();
    }
  }

  static String cleanUpProviderName(String providerName) {
    if (providerName.toLowerCase() ==
        AppConstants.wizzitTapToPay.toLowerCase()) {
      return AppVariables.store!.state.softPosProviderName ?? providerName;
    }

    return providerName;
  }

  static String getProviderDisplayImage({
    required String providerName,
    required String imageURI,
  }) {
    if (providerName.toLowerCase() ==
        AppConstants.wizzitTapToPay.toLowerCase()) {
      return UIStateData().appLogo;
    }
    return imageURI;
  }

  /// [PAYMENT_MANAGER_MAPPING]
  /// Linked Account helper functions for transformations to and from payment manager models

  static pm.LinkedAccount? getPMLinkedAccount({LinkedAccount? linkedAccount}) {
    if (linkedAccount == null) {
      return null;
    }
    return pm.LinkedAccount(
      id: linkedAccount.id,
      config: linkedAccount.config,
      providerType: getPMProviderType(linkedAccount),
      providerName: linkedAccount.providerName,
      imageURI: linkedAccount.imageURI,
      hasQRCode: linkedAccount.hasQRCode,
      isQRCodeEnabled: linkedAccount.isQRCodeEnabled,
      linkedAccountType: getPMLinkedAccountType(linkedAccount),
      deleted: linkedAccount.deleted,
      dateUpdated: linkedAccount.dateUpdated,
      updatedBy: linkedAccount.updatedBy,
      dateCreated: linkedAccount.dateCreated,
      createdBy: linkedAccount.createdBy,
    );
  }

  static pm.ProviderType getPMProviderType(LinkedAccount linkedAccount) {
    switch (linkedAccount.providerType) {
      case ProviderType.zapper:
        return pm.ProviderType.zapper;
      case ProviderType.snapscan:
        return pm.ProviderType.snapscan;
      case ProviderType.cRDB:
        return pm.ProviderType.cRDB;
      case ProviderType.pos:
        return pm.ProviderType.pos;
      case ProviderType.cybersourceTapToPay:
        return pm.ProviderType.cybersourceTapToPay;
      case ProviderType.wizzitTapToPay:
        return pm.ProviderType.wizzitTapToPay;
      default:
        throw ArgumentError(
          'Unknown ProviderType: ${linkedAccount.providerType}',
        );
    }
  }

  static ProviderType? getProviderType(pm.ProviderType? providerType) {
    if (providerType == null) {
      return null;
    }
    switch (providerType) {
      case pm.ProviderType.zapper:
        return ProviderType.zapper;
      case pm.ProviderType.snapscan:
        return ProviderType.snapscan;
      case pm.ProviderType.cRDB:
        return ProviderType.cRDB;
      case pm.ProviderType.pos:
        return ProviderType.pos;
      case pm.ProviderType.cybersourceTapToPay:
        return ProviderType.cybersourceTapToPay;
      case pm.ProviderType.wizzitTapToPay:
        return ProviderType.wizzitTapToPay;
      default:
        throw ArgumentError('Unknown pm.ProviderType: $providerType');
    }
  }

  static pm.LinkedAccountType getPMLinkedAccountType(
    LinkedAccount linkedAccount,
  ) {
    switch (linkedAccount.linkedAccountType) {
      case LinkedAccountType.payment:
        return pm.LinkedAccountType.payment;
      default:
        throw ArgumentError(
          'Unknown LinkedAccountType: ${linkedAccount.linkedAccountType}',
        );
    }
  }

  static LinkedAccountType? getLinkedAccountType(
    pm.LinkedAccountType? linkedAccountType,
  ) {
    if (linkedAccountType == null) {
      return null;
    }
    switch (linkedAccountType) {
      case pm.LinkedAccountType.payment:
        return LinkedAccountType.payment;
    }
  }

  static String? getLinkedAccountIdbyName(String name) {
    List<LinkedAccount>? linkedAccounts =
        AppVariables.store?.state.businessState.linkedAccounts;
    if (linkedAccounts == null || linkedAccounts.isEmpty) {
      logger.debug(null, 'No linked account found with name: $name');
      return null;
    }

    int index = linkedAccounts.indexWhere(
      (element) => element.providerName?.toLowerCase() == name.toLowerCase(),
    );
    if (index == -1) {
      logger.debug(null, 'No linked account found with name: $name');
      return null;
    }
    return linkedAccounts[index].id;
  }

  static String getRegisterSoftPosParagraph() {
    LittleFishCore core = LittleFishCore.instance;

    final fallBack =
        'Tap to Phone allows your device to become a Point of Sale (POS) terminal. You can accept card payments directly on your phone, making it easier to do business anywhere. To get started, register your device as a merchant.';
    final ConfigService configService = core.get<ConfigService>();
    final result = configService.getStringValue(
      key: 'config_register_soft_pos_paragraph',
      defaultValue: fallBack,
    );
    return result;
  }

  static List<LinkedAccount> getLinkableAccounts() {
    LittleFishCore core = LittleFishCore.instance;

    final ConfigService configService = core.get<ConfigService>();
    final linkableAccountsConfig = configService.getObjectValue(
      key: 'config_linkable_accounts',
      defaultValue: {'': ''},
    );
    List<LinkedAccount> linkableAccounts = [];
    if (linkableAccountsConfig != null &&
        linkableAccountsConfig is Map<String, dynamic>) {
      if (linkableAccountsConfig.containsKey('linkable_accounts')) {
        final accounts = linkableAccountsConfig['linkable_accounts'];
        if (accounts is List) {
          linkableAccounts = accounts.map((e) {
            if (e is Map<String, dynamic>) {
              return LinkedAccount.fromJson(e);
            } else {
              return LinkedAccount();
            }
          }).toList();
        }
      }
    }
    return setLinkableAccountConfig(
      linkableAccounts,
    ).where((provider) => provider.enabled == true).toList();
  }

  static List<LinkedAccount> setLinkableAccountConfig(
    List<LinkedAccount> accounts,
  ) {
    if (accounts.isEmpty) {
      return accounts;
    }

    var state = AppVariables.store?.state.environmentState.environmentConfig;
    bool zapperEnabled = state?.zapperEnabled ?? false;
    bool snapscanEnabled = state?.snapscanEnabled ?? false;

    for (var account in accounts) {
      if (account.providerName?.toLowerCase() ==
          AppConstants.wizzitTapToPay.toLowerCase()) {
        account.enabled = true;
      }
      if (account.providerName?.toLowerCase() ==
          AppConstants.zapper.toLowerCase()) {
        account.enabled = zapperEnabled;
      }
      if (account.providerName?.toLowerCase() ==
          AppConstants.snapscan.toLowerCase()) {
        account.enabled = snapscanEnabled;
      }
    }

    return accounts;
  }

  static bool isSoftPosProvider(ProviderType? providerType) {
    if (providerType == null) {
      return false;
    }
    return providerType == ProviderType.wizzitTapToPay;
  }

  static Future<bool> hasSoftPosLinkedAccount() async {
    List<LinkedAccount>? linkedAccounts =
        AppVariables.store?.state.businessState.linkedAccounts;
    if (linkedAccounts == null || linkedAccounts.isEmpty) {
      return false;
    }
    return linkedAccounts.any(
      (account) => isSoftPosProvider(account.providerType),
    );
  }
}
