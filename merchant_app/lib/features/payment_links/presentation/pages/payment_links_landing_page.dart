import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_core/core/littlefish_core.dart';
import 'package:littlefish_core/logging/services/logger_service.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/bottom_sheet_indicator.dart';
import 'package:littlefish_merchant/features/order_transaction_history/presentation/widgets/search_and_button.dart';
import 'package:littlefish_merchant/models/store/business_profile.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/business/business_actions.dart';
import 'package:littlefish_merchant/shared/constants/semantics_constants.dart';
import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../common/presentaion/components/completers.dart';
import '../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import '../../../order_common/data/model/order.dart';
import '../view_models/payment_links/actions/payment_links_actions.dart';
import '../view_models/payment_links/viewmodels/payment_links_vm.dart';
import '../components/payment_links_tile.dart';
import 'create_payment_link_page.dart';

LoggerService _logger = LittleFishCore.instance.get<LoggerService>();

class PaymentLinksLandingPage extends StatefulWidget {
  static const String route = 'payment-links-landing-page';
  const PaymentLinksLandingPage({super.key});

  @override
  State<PaymentLinksLandingPage> createState() =>
      _PaymentLinksLandingPageState();
}

class _PaymentLinksLandingPageState extends State<PaymentLinksLandingPage> {
  final ScrollController _scrollController = ScrollController();
  final state = AppVariables.store?.state ?? AppState();
  bool _hasAttachedScrollListener = false;
  String _searchText = '';
  late BusinessProfile _businessProfile;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('#### PaymentLinksLandingPage build entry');
    return StoreConnector<AppState, PaymentLinksViewModel>(
      distinct: true,
      converter: (store) => PaymentLinksViewModel.fromStore(store),
      onInit: (store) {
        store.dispatch(LoadMorePaymentLinksAction(offset: 0, limit: 50));
        store.dispatch(loadBusinessProfile(refresh: true));
      },
      builder: (context, vm) {
        final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
        final showSideNav =
            isTablet || (vm.store!.state.enableSideNavDrawer ?? false);

        final isInitialLoad = (vm.isLoading ?? false);

        _businessProfile = AppVariables.store!.state.businessState.profile!;

        debugPrint(
          '#### PaymentLinksLandingPage PaymentLinksViewModel builder '
          'isInitialLoad: $isInitialLoad',
        );

        return AppScaffold(
          title: 'Payment Links',
          displayNavDrawer: showSideNav,
          hasDrawer: showSideNav,
          body: isInitialLoad
              ? const AppProgressIndicator()
              : _body(context, vm),
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
                        CustomRoute(
                          builder: (_) => const CreatePaymentLinksPage(),
                        ),
                      )
                    : showMessageDialog(
                        context,
                        'You cannot create a payment link '
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

  Widget _body(BuildContext context, PaymentLinksViewModel vm) {
    return Column(
      children: [
        invoiceStatusCard(context, vm),
        if (isOnlinePaymentsEnabled()) ...[
          SearchAndButton(
            onButtonPressed: (ctx) => onFilterButtonPressed(ctx),
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
                TabBarItem(text: 'All', content: linksList(vm)),
                TabBarItem(
                  text: 'Created',
                  content: linksList(vm, PaymentLinkStatus.created),
                ),
                TabBarItem(
                  text: 'Sent',
                  content: linksList(vm, PaymentLinkStatus.sent),
                ),
                TabBarItem(
                  text: 'Paid',
                  content: linksList(vm, PaymentLinkStatus.paid),
                ),
                TabBarItem(
                  text: 'Disabled',
                  content: linksList(vm, PaymentLinkStatus.disabled),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget linksList(PaymentLinksViewModel vm, [PaymentLinkStatus? status]) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final filtered = vm.filteredByStatus(status);
      if (vm.hasMore &&
          !(vm.isLoading ?? false) &&
          filtered.length < 50 &&
          vm.items!.length < vm.totalRecords) {
        vm.loadMore(context);
      }
    });
    final filtered = vm.filteredByStatus(status);
    final links = filtered.where((link) {
      if (_searchText.isEmpty) return true;
      final search = _searchText.toLowerCase();
      final productName = link.orderLineItems.isNotEmpty
          ? link.orderLineItems[0].displayName.toLowerCase()
          : '';
      final firstName = link.customer?.firstName.toLowerCase() ?? '';
      final lastName = link.customer?.lastName.toLowerCase() ?? '';
      return productName.contains(search) ||
          firstName.contains(search) ||
          lastName.contains(search);
    }).toList();
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
    if (links.isEmpty) {
      return Center(
        child: context.labelSmall(
          'No payment links found',
          isBold: false,
          color: Theme.of(context).colorScheme.secondary,
        ),
      );
    }
    final showLoader = links.isNotEmpty && links.first.orderLineItems.isEmpty;
    return RefreshIndicator(
      onRefresh: () async => vm.onRefresh(),
      child: ListView.builder(
        controller: _scrollController,
        itemCount: links.length,
        itemBuilder: (context, index) {
          if (showLoader) {
            return vm.hasMore
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: AppProgressIndicator()),
                  )
                : const SizedBox.shrink();
          }
          if (links[index].orderLineItems.isEmpty) {
            return SizedBox.shrink();
          }
          return PaymentLinksTile(link: links[index], vm: vm, ctx: context);
        },
      ),
    );
  }

  Future<void> onFilterButtonPressed(BuildContext ctx) async {
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

  Widget invoiceStatusCard(BuildContext context, PaymentLinksViewModel vm) {
    return isOnlinePaymentsEnabled()
        ? SizedBox.shrink()
        : hasOnlinePaymentsAccount()
        ? pendingOnlinePaymentsCard()
        : notRegisteredPaymentsCard(context: context, vm: vm);
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

  Widget notRegisteredPaymentsCard({
    required BuildContext context,
    required PaymentLinksViewModel vm,
  }) {
    // Reuse dialog content as a non-modal card for persistent display
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
            'New! Accept payments directly on your phone.',
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
                      tapContext,
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
                    'payment_links_landing_page.dart',
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
