import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/business/models/business.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/features/store_switching/model/business_store.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:quiver/strings.dart';

import '../../../../common/presentaion/components/bottom_sheet_indicator.dart';
import '../../../../common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/dialogs/services/modal_service.dart';
import '../../../../common/presentaion/components/list_leading_tile.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../injector.dart';
import '../../../../models/security/authentication/activation_option.dart';
import '../../../../redux/auth/auth_actions.dart';
import '../../../order_transaction_history/presentation/widgets/search_and_button.dart';
import '../../redux/actions/business_actions.dart';
import '../../redux/viewmodels/business_store_view_model.dart';
import 'link_new_store_page.dart';

class ListOfStoresPage extends StatefulWidget {
  static const String route = 'list-of-stores-page';
  const ListOfStoresPage({super.key});

  @override
  State<ListOfStoresPage> createState() => _ListOfStoresPageState();
}

class _ListOfStoresPageState extends State<ListOfStoresPage> {
  final ScrollController _scrollController = ScrollController();
  final modalService = getIt<ModalService>();
  final String imageUrl = '';
  String _searchText = '';
  bool _isAdmin = false;

  @override
  Widget build(BuildContext context) {
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    return StoreConnector<AppState, BusinessStoreViewModel>(
      converter: (store) => BusinessStoreViewModel.fromStore(store),
      onInit: (store) {
        store.dispatch(SetBusinessStoresLoadingAction(false));
        final vm = BusinessStoreViewModel.fromStore(store);
        vm.onRefresh();
      },
      builder: (context, vm) {
        final storesToDisplay = vm.filteredStores(_searchText);

        if (vm.isStoreLoading) {
          return AppScaffold(
            enableProfileAction: !isTablet,
            displayBackNavigation: true,
            title: 'Stores',
            body: const AppProgressIndicator(),
          );
        }

        return AppScaffold(
          displayBackNavigation: true,
          title: 'Stores',
          enableProfileAction: !isTablet,
          body: _body(context, storesToDisplay, vm),
          persistentFooterButtons: [
            if (_isAdmin)
              FooterButtonsIconPrimary(
                primaryButtonText: 'Link New Store',
                secondaryButtonIcon: Icons.refresh_outlined,
                onPrimaryButtonPressed: (_) async {
                  Navigator.of(context).push(
                    CustomRoute(
                      builder: (BuildContext context) {
                        return const LinkNewStorePage();
                      },
                    ),
                  );
                },
                onSecondaryButtonPressed: (ctx) {
                  vm.onRefresh();
                },
              ),
          ],
        );
      },
    );
  }

  Widget _body(
    BuildContext context,
    List<BusinessStore> stores,
    BusinessStoreViewModel vm,
  ) {
    return Column(
      children: [
        SearchAndButton(
          showSortButton: false,
          showFilterButton: false,
          padding: const EdgeInsets.only(right: 22.0),
          onButtonPressed: _onFilterButtonPressed,
          onTextChanged: (text) {
            setState(() {
              _searchText = text.trim().toLowerCase();
            });
          },
        ),
        Expanded(
          child: ListView.builder(
            key: const PageStorageKey<String>('stores-list'),
            controller: _scrollController,
            itemCount: stores.length,
            itemBuilder: (context, index) {
              final store = stores[index];
              final isSelected =
                  store.businessId ==
                  AppVariables.store?.state.currentBusinessId;

              final matchedBusiness = AppVariables
                  .store
                  ?.state
                  .businessState
                  .businesses
                  ?.firstWhere(
                    (b) => b.id == store.businessId,
                    orElse: () => Business(displayName: ''),
                  );

              final resolvedBusinessName = isNotBlank(store.businessName)
                  ? store.businessName!
                  : (isNotBlank(matchedBusiness?.displayName)
                        ? matchedBusiness?.displayName!
                        : 'Unnamed Store');

              if (isSelected && store.role?.toLowerCase() == 'administrator') {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isAdmin = true;
                  });
                });
              } else if (isSelected &&
                  store.role?.toLowerCase() != 'administrator') {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  setState(() {
                    _isAdmin = false;
                  });
                });
              }

              return ListTile(
                onTap: () => _showSwitchStoreDialog(context, store, vm),
                tileColor: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
                    : Theme.of(context).colorScheme.background,
                leading: isNotBlank(imageUrl)
                    ? ListLeadingImageTile(
                        width: AppVariables.appDefaultlistItemSize,
                        height: AppVariables.appDefaultlistItemSize,
                        url: imageUrl,
                      )
                    : Container(
                        width: AppVariables.appDefaultlistItemSize,
                        height: AppVariables.appDefaultlistItemSize,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? Theme.of(
                                  context,
                                ).colorScheme.primary.withOpacity(0.2)
                              : Theme.of(
                                  context,
                                ).extension<AppliedSurface>()?.brandSubTitle,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: context.labelMedium(
                          resolvedBusinessName!.substring(0, 2).toUpperCase(),
                          isBold: true,
                        ),
                      ),
                title: context.labelSmall(
                  resolvedBusinessName!,
                  alignLeft: true,
                  isBold: true,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    context.labelXSmall(
                      store.masterMerchantId ?? 'No MID',
                      alignLeft: true,
                    ),
                    context.labelXSmall('Role: ${store.role}', alignLeft: true),
                  ],
                ),
                trailing: Icon(
                  isSelected
                      ? Icons.check_circle
                      : (Platform.isIOS
                            ? Icons.arrow_forward_ios_outlined
                            : Icons.arrow_forward),
                  color: isSelected
                      ? Theme.of(context).colorScheme.primary
                      : Theme.of(context).iconTheme.color,
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Future<void> _onFilterButtonPressed(BuildContext ctx) async {
    await showModalBottomSheet(
      context: ctx,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
      ),
      useSafeArea: true,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.8,
      ),
      builder: (_) => const SafeArea(
        top: false,
        bottom: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [BottomSheetIndicator()],
        ),
      ),
    );
  }

  Future<void> _showSwitchStoreDialog(
    BuildContext context,
    BusinessStore business,
    BusinessStoreViewModel vm,
  ) async {
    await modalService.showActionModal(
      context: context,
      title: 'Switch Store?',
      description:
          'Are you sure you want to switch your store to ${business.businessName}',
      acceptText: 'Yes',
      cancelText: 'No',
      status: StatusType.destructive,
      onTap: (_) {
        final completer = Completer();

        Navigator.of(context).pop();
        vm.selectAndNavigateStore(
          context,
          business,
          (val) => vm.setBusinessStoresLoading(val),
          completer,
        );

        completer.future
            .then((_) {
              vm.setBusinessStoresLoading(false);
            })
            .catchError((_) {
              vm.setBusinessStoresLoading(false);
              showMessageDialog(
                context,
                'Unable to switch stores right now. Please try again later.',
                LittleFishIcons.error,
              );
            });
      },
    );
  }

  Future<void> thirdPartyActivations(
    BuildContext context,
    BusinessStoreViewModel vm,
    ActivationOption option,
  ) async {
    final store = StoreProvider.of<AppState>(context, listen: false);
    bool? activationStatus = await activationClientStatus(
      context: context,
      store: store,
    );

    var details = AppVariables.store!.state.deviceState.deviceDetails;

    if (activationStatus == true) {
      haveActivationOptionRoute(context, details?.merchantId ?? '');
    } else {
      vm.setBusinessStoresLoading(false);
      showMessageDialog(
        context,
        'Unable to link stores right now. Please try again later.',
        LittleFishIcons.error,
      );
    }
  }

  void haveActivationOptionRoute(BuildContext context, String merchantId) {
    Navigator.of(context).push(
      CustomRoute(
        builder: (BuildContext context) {
          return LinkNewStorePage(merchantId: merchantId);
        },
      ),
    );
  }
}
