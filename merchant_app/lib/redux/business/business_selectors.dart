// Project imports:
import 'package:collection/collection.dart';
import 'package:littlefish_merchant/models/settings/accounts/linked_account.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

bool hasPosAccount(AppState state) => state.businessState.enabledLinkedAccounts
    .any((account) => account.providerType == ProviderType.pos);

bool hasZapperAccount(AppState state) => state
    .businessState
    .enabledLinkedAccounts
    .any((account) => account.providerType == ProviderType.zapper);

LinkedAccount? zapperAccount(AppState state) => state
    .businessState
    .enabledLinkedAccounts
    .firstWhereOrNull((account) => account.providerType == ProviderType.zapper);

bool hasSnapscanAccount(AppState state) => state
    .businessState
    .enabledLinkedAccounts
    .any((account) => account.providerType == ProviderType.snapscan);

LinkedAccount? snapscanAccount(AppState state) => state
    .businessState
    .enabledLinkedAccounts
    .firstWhere((account) => account.providerType == ProviderType.snapscan);

StoreCreditSettings? storeCreditSettings(AppState? state) =>
    state!.businessState.profile?.storeCreditSettings;

// final hasCommerceAccount = (AppState state) =>
//     state.businessState?.salesChannels
//         ?.any((account) => account.salesChannelType == SalesChannelType.littleFishEcommerce) ??
//     false;
