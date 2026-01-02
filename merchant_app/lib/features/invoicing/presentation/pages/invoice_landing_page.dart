import 'package:flutter/material.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/shared/constants/semantics_constants.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import '../../../../app/custom_route.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../common/presentaion/components/completers.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../models/store/business_profile.dart';
import '../redux/actions/invoicing_actions.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import '../../../order_common/data/model/order.dart';
import '../../../../redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import '../../../../common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottom_sheet_indicator.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/widgets/invoices_list_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import 'package:littlefish_merchant/features/invoicing/presentation/redux/viewmodels/invoicing_view_model.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/widgets/search_and_button.dart';

import 'invoice_create_page.dart';

LoggerService _logger = LittleFishCore.instance.get<LoggerService>();

class InvoiceLandingPage extends StatefulWidget {
  static const String route = 'invoice-landing-page';
  const InvoiceLandingPage({super.key});

  @override
  State<InvoiceLandingPage> createState() => _InvoiceLandingPageState();
}

class _InvoiceLandingPageState extends State<InvoiceLandingPage> {
  final ScrollController _scrollController = ScrollController();
  final state = AppVariables.store?.state ?? AppState();
  bool _hasAttachedScrollListener = false;
  String _searchText = '';
  late BusinessProfile _businessProfile;

  @override
  void initState() {
    super.initState();
    _businessProfile = AppVariables.store!.state.businessState.profile!;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('#### InvoiceLandingPage build');
    return StoreConnector<AppState, InvoicingViewModel>(
      distinct: true,
      converter: (store) => InvoicingViewModel.fromStore(store),
      onInit: (store) {
        store.dispatch(ResetInvoicingStateAction());
        store.dispatch(LoadMoreInvoicesAction(offset: 0, limit: 50));
        store.dispatch(CheckoutSetCustomerAction(null));
        store.dispatch(loadBusinessProfile(refresh: true));
      },
      builder: (context, vm) {
        final isInitialLoad = (vm.isLoading ?? false);

        debugPrint(
          '### InvoiceLandingPage InvoiceViewModel builder'
          ' isInitialLoad: $isInitialLoad',
        );

        return AppScaffold(
          title: 'Invoices',
          displayNavDrawer: AppVariables.store!.state.enableSideNavDrawer!,
          hasDrawer: AppVariables.store!.state.enableSideNavDrawer!,
          body: isInitialLoad ? const AppProgressIndicator() : _body(vm),
          persistentFooterButtons: [
            FooterButtonsIconPrimary(
              primaryButtonText: 'Create',
              primaryEnabled: isOnlinePaymentsEnabled(),
              semanticsIdentifier: SemanticsConstants.kRefresh,
              semanticsLabel: SemanticsConstants.kRefresh,
              secondaryButtonIcon: Icons.refresh_outlined,
              onPrimaryButtonPressed: (_) {
                isOnlinePaymentsEnabled()
                    ? Navigator.of(context).push(
                        CustomRoute(builder: (_) => const InvoiceCreatePage()),
                      )
                    : showMessageDialog(
                        context,
                        'You cannot create an invoice '
                        'because your account is not enabled '
                        'for online payments.',
                        LittleFishIcons.error,
                      );
              },
              onSecondaryButtonPressed: (_) => vm.onRefresh(),
            ),
          ],
        );
      },
    );
  }

  Widget _body(InvoicingViewModel vm) {
    return Column(
      children: [
        paymentLinkStatusCard(context, vm),
        if (isOnlinePaymentsEnabled()) ...[
          SearchAndButton(
            onButtonPressed: (ctx) => _onFilterButtonPressed(ctx),
            onTextChanged: (text) => setState(() => _searchText = text.trim()),
            showFilterButton: false,
          ),
          Expanded(
            child: AppTabBar(
              intialIndex: 0,
              scrollable: true,
              physics: const BouncingScrollPhysics(),
              resizeToAvoidBottomInset: false,
              tabs: [
                TabBarItem(text: 'All', content: _invoicesList(vm)),
                TabBarItem(
                  text: 'Draft',
                  content: _invoicesList(vm, OrderStatus.draft),
                ),
                TabBarItem(
                  text: 'Discarded',
                  content: _invoicesList(vm, OrderStatus.discarded),
                ),
                TabBarItem(
                  text: 'Open',
                  content: _invoicesList(vm, OrderStatus.open),
                ),
                TabBarItem(
                  text: 'Closed',
                  content: _invoicesList(vm, OrderStatus.closed),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _invoicesList(InvoicingViewModel vm, [OrderStatus? status]) {
    final filtered = vm.filteredByStatus(status);

    final invoices = filtered.where((invoice) {
      if (_searchText.isEmpty) return true;

      final searchLower = _searchText.toLowerCase();

      return (invoice.note.toLowerCase().contains(searchLower)) ||
          (invoice.orderNumber.toString().contains(searchLower)) ||
          (invoice.customer?.firstName.toLowerCase().contains(searchLower) ??
              false) ||
          (invoice.customer?.lastName.toLowerCase().contains(searchLower) ??
              false);
    }).toList();

    if (vm.hasMore &&
        !(vm.isLoading ?? false) &&
        invoices.length < 50 &&
        vm.items!.length < vm.totalRecords) {
      vm.loadMore(context);
    }

    if (!_hasAttachedScrollListener) {
      _scrollController.addListener(() {
        if (_scrollController.position.pixels >=
                _scrollController.position.maxScrollExtent - 100 &&
            vm.hasMore &&
            !(vm.isLoading ?? false)) {
          vm.loadMore(context);
        }
      });
      _hasAttachedScrollListener = true;
    }

    if (invoices.isEmpty) {
      return Center(
        child: context.labelSmall(
          'No invoices found',
          isBold: false,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
    final showLoader =
        invoices.isNotEmpty && invoices.first.orderLineItems.isEmpty;
    return RefreshIndicator(
      onRefresh: () async => vm.onRefresh(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: invoices.length,
        itemBuilder: (context, index) {
          if (showLoader) {
            return vm.hasMore
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: AppProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }

          if (invoices[index].orderLineItems.isEmpty) {
            return SizedBox.shrink();
          }

          return InvoicesListTile(
            invoice: invoices[index],
            vm: vm,
            ctx: context,
          );
        },
      ),
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
      builder: (buildContext) => const SafeArea(
        top: false,
        bottom: true,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [BottomSheetIndicator()],
        ),
      ),
    );
  }

  Widget paymentLinkStatusCard(BuildContext context, InvoicingViewModel vm) {
    return isOnlinePaymentsEnabled()
        ? SizedBox.shrink()
        : hasOnlinePaymentsAccount()
        ? pendingOnlinePaymentsCard()
        : notRegisteredPaymentsCard(vm);
  }

  Widget pendingOnlinePaymentsCard() {
    final brandColor =
        Theme.of(context).extension<AppliedTextIcon>()?.brand ?? Colors.black87;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: brandColor.withAlpha(40),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: brandColor.withAlpha(60)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                LittleFishIcons.info,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: 8),
              context.paragraphMedium(
                'Request in Progress',
                color: Theme.of(context).colorScheme.primary,
                isSemiBold: true,
              ),
            ],
          ),
          const SizedBox(height: 6),
          context.paragraphMedium(
            'Your activation request has been submitted and is being reviewed.',
            color: Theme.of(context).colorScheme.primary,
            isSemiBold: false,
            alignLeft: true,
          ),
        ],
      ),
    );
  }

  Widget notRegisteredPaymentsCard(InvoicingViewModel vm) {
    final brandColor =
        Theme.of(context).extension<AppliedTextIcon>()?.brand ?? Colors.black87;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: brandColor.withAlpha(20),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: brandColor.withAlpha(40)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          context.paragraphMedium(
            'New! Accept invoice payments directly on your phone.',
            color: brandColor,
            isSemiBold: false,
            alignLeft: true,
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ButtonPrimary(
              text: 'Get Started',
              onTap: (tapContext) async {
                final linkedAccount = vm.getDefaultOnlinePaymentsAccount();

                final completer = snackBarCompleter(
                  context,
                  'Successfully requested activation',
                  useOnlyCompleterAction: true,
                )!;

                vm.requestActivation(
                  linkedAccount,
                  completer: completer,
                  onError: (e) {
                    showMessageDialog(
                      context,
                      'Failed to request activation: ${e.toString()}',
                      LittleFishIcons.error,
                    );
                  },
                );

                try {
                  await completer.future;

                  if (!mounted) return;
                  setState(() {
                    _businessProfile =
                        AppVariables.store!.state.businessState.profile!;
                  });
                } catch (e) {
                  _logger.debug(
                    'invoice_landing_page.dart',
                    'Failed to update activation: ${e.toString()}',
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  bool hasOnlinePaymentsAccount() {
    return _businessProfile.linkedAccounts?.any(
          (a) => a.providerName?.toLowerCase() == 'onlinepayments',
        ) ??
        false;
  }

  bool isOnlinePaymentsEnabled() {
    final match = _businessProfile.linkedAccounts?.where(
      (a) => a.providerName?.toLowerCase() == 'onlinepayments',
    );

    if (match != null && match.isNotEmpty) {
      return match.first.enabled == true;
    }
    return false;
  }
}
