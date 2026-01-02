import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/business/models/business.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_surface.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/features/store_switching/model/business_store.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:quiver/strings.dart';

import '../../../../common/presentaion/components/bottom_sheet_indicator.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/components/dialogs/services/modal_service.dart';
import '../../../../common/presentaion/components/list_leading_tile.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../injector.dart';
import '../../../order_transaction_history/presentation/widgets/search_and_button.dart';
import '../../redux/actions/business_actions.dart';
import '../../redux/viewmodels/business_store_view_model.dart';

class ListOfStoresLoginFlowPage extends StatefulWidget {
  static const String route = 'list-of-stores-login-flow-page';
  final bool isSigningIn;
  const ListOfStoresLoginFlowPage({super.key, this.isSigningIn = false});

  @override
  State<ListOfStoresLoginFlowPage> createState() =>
      _ListOfStoresLoginFlowPageState();
}

class _ListOfStoresLoginFlowPageState extends State<ListOfStoresLoginFlowPage> {
  final ScrollController _scrollController = ScrollController();
  final modalService = getIt<ModalService>();
  final String imageUrl = '';
  String _searchText = '';

  @override
  Widget build(BuildContext context) {
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
          return const AppScaffold(
            displayBackNavigation: false,
            title: 'Select Store',
            body: AppProgressIndicator(),
          );
        }

        return AppScaffold(
          displayBackNavigation: false,
          title: 'Select Store',
          body: _body(context, storesToDisplay, vm),
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
          showFilterButton: false,
          showSortButton: false,
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

              return ListTile(
                onTap: () {
                  final completer = Completer();

                  vm.selectAndNavigateStore(
                    context,
                    store,
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
                tileColor: Theme.of(context).colorScheme.background,
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
                          color: Theme.of(
                            context,
                          ).extension<AppliedSurface>()?.brandSubTitle,
                          border: Border.all(color: Colors.transparent),
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
                    context.labelXSmall(
                      'Role: ${store.role}' ?? 'No role',
                      alignLeft: true,
                    ),
                  ],
                ),
                trailing: Icon(
                  Platform.isIOS
                      ? Icons.arrow_forward_ios_outlined
                      : Icons.arrow_forward,
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
}
