// Flutter imports:
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/redux/linked_account/linked_account_actions.dart';

// Package imports:
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/security/verification.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/models/settings/payments/payment_type.dart';
import 'package:littlefish_merchant/redux/app_settings/app_settings_actions.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/services/accounts_service.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class LinkedAccountVM extends StoreViewModel {
  LinkedAccountVM.fromStore(Store<AppState> store, {BuildContext? context})
    : super.fromStore(store, context: context);

  String? routeName;
  LinkedAccount? account;

  List<LinkedAccount>? linkedAccounts = [];

  late List<LinkedAccount> linkableProviders;

  late AccountsService accountsService;

  late List<LinkedAccount> Function(List<LinkedAccount> accounts)
  removeHiddenAccounts;
  late Function(LinkedAccount) updateLinkedAccountPaymentType;

  late Function(LinkedAccount? config) setAccount;

  late Function(BuildContext context) runUpsert;

  late Function getVerificationStatus;

  late Function(BuildContext ctx, VerificationStatus status)
  setVerificationStatus;

  late Function(String providerName) registerProviderMerchant;

  List<LinkedAccount> get availableProviders =>
      store?.state.businessState.availableProviders ?? [];

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    this.store = store;
    state = store!.state;
    accountsService = AccountsService.fromStore(store);

    linkedAccounts = store.state.businessState.enabledLinkedAccounts;

    isLoading = store.state.businessState.isLoading;

    setAccount = (value) => account = value;

    linkableProviders = availableProviders
        .where(
          (provider) => !linkedAccounts!.any(
            (linkedAccount) =>
                linkedAccount.providerName == provider.providerName &&
                provider.enabled == true,
          ),
        )
        .toList();

    runUpsert = (ctx) async {
      store.dispatch(SetBusinessStateLoadingAction(true));
      accountsService
          .upsertLinkedAccount(account!)
          .then((result) {
            updateLinkedAccountPaymentType(account!);
            linkedAccounts = removeHiddenAccounts(result ?? []);
            if (result == null) {
              showMessageDialog(
                context ?? ctx,
                'Something went wrong',
                LittleFishIcons.error,
              );
            } else {
              store.dispatch(
                SetBusinessLinkedAccountsAction(
                  linkedAccounts ?? [],
                  toggleIsLoading: true,
                ),
              );
            }
            toggleLoading(value: false);
          })
          .catchError((error) {
            showMessageDialog(
              context ?? ctx,
              'Something went wrong',
              LittleFishIcons.error,
            ).then((v) {
              toggleLoading(value: false);
            });

            reportCheckedError(error, trace: StackTrace.current);
          });
    };

    updateLinkedAccountPaymentType = (LinkedAccount account) {
      List<PaymentType> allPaymentTypes =
          store.state.appSettingsState.paymentTypes;
      PaymentType? paymentType = allPaymentTypes.firstWhereOrNull(
        (type) =>
            type.name?.toLowerCase() == account.providerName?.toLowerCase(),
      );
      if (paymentType == null) return;
      store.dispatch(
        setPaymentType(enabled: account.enabled, name: paymentType.name),
      );
    };

    //TODO(Michael): We should get linked accounts from the backend,
    // if we had feature flags in the API then we would not need to do this
    // manual filtering across our different platforms (pos and web, etc.)
    removeHiddenAccounts = (accounts) {
      if (isNullOrEmpty(accounts)) return [];

      var state = store.state.environmentState.environmentConfig;
      bool zapperEnabled = state?.zapperEnabled ?? false;
      bool snapscanEnabled = state?.snapscanEnabled ?? false;
      bool wizzitTapToPayEnabled = state?.wizzitTapToPayEnabled ?? false;
      bool kycEnabled = state?.enableKYC ?? false;
      List<ProviderType> disabledProviders = [];

      if (!zapperEnabled) {
        disabledProviders.add(ProviderType.zapper);
      }
      if (!snapscanEnabled) {
        disabledProviders.add(ProviderType.snapscan);
      }
      if (!kycEnabled) {
        disabledProviders.add(ProviderType.kYC);
      }
      if (!wizzitTapToPayEnabled) {
        disabledProviders.add(ProviderType.wizzitTapToPay);
      }

      List<LinkedAccount> filteredAccounts = accounts
          .where(
            (provider) => !disabledProviders.contains(provider.providerType),
          )
          .toList();

      return filteredAccounts;
    };

    // Not sure if this is needed anymore?
    getVerificationStatus = () =>
        store.state.businessState.verificationStatus?.status;
    // Same here
    setVerificationStatus = (ctx, status) {
      try {
        var currentStatus = store.state.businessState.verificationStatus;

        currentStatus ??= Verification();

        currentStatus.verificationDate = DateTime.now();
        currentStatus.status = status;

        store.dispatch(
          setBusinessVerificationStatus(
            context ?? ctx,
            currentStatus,
            // completer: snackBarCompleter(ctx, "Account Verified!"),
          ),
        );

        return currentStatus.status;
      } catch (e) {
        showMessageDialog(
          context ?? ctx,
          'Something went wrong when updating verification status',
          LittleFishIcons.error,
        );

        reportCheckedError(e, trace: StackTrace.current);

        return VerificationStatus.failed;
      }
    };

    registerProviderMerchant = (providerName) {
      store.dispatch(
        registerProviderMerchantAction(providerName: providerName),
      );
    };
  }
}
