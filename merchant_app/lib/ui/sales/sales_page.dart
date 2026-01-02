import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/search_text_field.dart';
import 'package:littlefish_merchant/environment/environment_config.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_transaction.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/sales/sales_actions.dart';
import 'package:littlefish_merchant/redux/sales/sales_selectors.dart';
import 'package:littlefish_merchant/ui/online_store/tools.dart';
import 'package:littlefish_merchant/ui/sales/view_models.dart';
import 'package:littlefish_merchant/ui/sales/widgets/sales_more_actions.dart';
import 'package:littlefish_merchant/ui/sales/widgets/sales_tab_layout.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:quiver/strings.dart';
import '../../common/presentaion/components/bottomNavBar/bottom_navbar.dart';

class SalesPage extends StatefulWidget {
  static const String route = 'business/transactions';
  final bool useOutlineStyling;
  final bool enabled;

  const SalesPage({
    Key? key,
    this.useOutlineStyling = true,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<SalesPage> createState() => _SalesPageState();
}

class _SalesPageState extends State<SalesPage> {
  ScrollController? controller;
  TextEditingController searchController = TextEditingController();
  GlobalKey<FormState>? formKey = GlobalKey();
  final FocusNode _focusNode = FocusNode();
  Timer? _debounce;

  bool isFiltered = false;
  int currentTabIndex = 0;

  @override
  void initState() {
    controller = ScrollController();
    searchController = TextEditingController();
    searchController.text = '';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, SalesVM>(
      onInit: (store) async {
        store.dispatch(getInitialTransactions(forceRefresh: true));
        bool value =
            await getKeyFromPrefsBool('enableReportFilteringByTerminalId') ??
            false;
        store.dispatch(SalesSetTerminalFilterAction(value));
      },
      converter: (store) => SalesVM.fromStore(store),
      builder: (ctx, vm) {
        final isLargeDisplay =
            EnvironmentProvider.instance.isLargeDisplay ?? false;
        final isGuestLogin = vm.store!.state.userState.isGuestUser ?? false;
        final enableBackNav =
            !(vm.store!.state.enableSideNavDrawer ?? false) || isGuestLogin;
        final enableNavDrawer = isLargeDisplay || !enableBackNav;
        final enableBottomNav =
            !isLargeDisplay && (vm.store!.state.enableBottomNavBar ?? false);
        return AppScaffold(
          enableProfileAction:
              !(EnvironmentProvider.instance.isLargeDisplay ?? false),
          navBar: const BottomNavBar(page: PageType.sales),
          displayBackNavigation: enableBackNav,
          displayNavBar: enableBottomNav,
          hasDrawer: enableNavDrawer,
          displayNavDrawer: enableNavDrawer,
          title: 'Transactions',
          body: layout(context, vm),
          actions: [
            if (!isLargeDisplay &&
                AppVariables.isPOSBuild &&
                AppVariables.store!.state.enableTerminalReportFiltering)
              SalesMoreActions.showMoreActions(
                context: context,
                isSelected: vm.enableTerminalReportFiltering,
                onChanged: (value) async {
                  await vm.setEnableTerminalReportFiltering(value);
                },
              ),
          ],
        );
      },
    );
  }

  Widget transactionNumberSearchField(
    BuildContext context,
    SalesVM vm, {
    Function? onAdd,
  }) {
    return SearchTextField(
      enabled: widget.enabled,
      controller: searchController ?? TextEditingController(),
      // focusNode: _focusNode,
      keyboardType: TextInputType.number,
      hintText: 'Search by Transaction Number',
      key: formKey,
      useOutlineStyling: false,
      onClear: () {
        setState(() {
          searchController.text = '';
          isFiltered = false;
          _focusNode.unfocus();
        });
        updateFilteredList(vm, SalesSubType.values[currentTabIndex]);
      },
      onFieldSubmitted: (searchText) async {
        searchController.text = searchText;

        await updateFilteredList(vm, SalesSubType.values[currentTabIndex]);
        if (mounted) setState(() {});
      },
      onChanged: (searchText) {
        if (_debounce?.isActive ?? false) _debounce!.cancel();

        _debounce = Timer(const Duration(milliseconds: 1400), () async {
          searchController.text = searchText;
          if (isNotBlank(searchText)) {
            await updateFilteredList(vm, SalesSubType.values[currentTabIndex]);
            if (mounted) setState(() {});
          }
        });
      },
    );
  }

  layout(BuildContext context, SalesVM vm) => Column(
    children: [
      transactionNumberSearchField(context, vm),
      vm.isLoading!
          ? const Expanded(
              child: AppProgressIndicator(isCentered: true, hasScaffold: false),
            )
          : Expanded(
              child: AppTabBar(
                tabAlignment: TabAlignment.start,
                scrollable: true,
                intialIndex: currentTabIndex,
                onTabChanged: (index) {
                  currentTabIndex = index;
                  if (!isFiltered) return;
                  updateFilteredList(vm, SalesSubType.values[currentTabIndex]);
                  if (mounted) setState(() {});
                },
                physics: const BouncingScrollPhysics(),
                tabs: [
                  ///All
                  TabBarItem(
                    content: SalesTabLayout(
                      vm: vm,
                      searchController: searchController,
                      isFiltered: isFiltered,
                      controller: controller,
                      type: SalesSubType.all,
                      transactions: getTransactionData(SalesSubType.all, vm),
                    ),
                    text: (SalesSubType.all.name).toUpperCase(),
                  ),

                  ///Complete
                  TabBarItem(
                    content: SalesTabLayout(
                      vm: vm,
                      searchController: searchController,
                      isFiltered: isFiltered,
                      controller: controller,
                      type: SalesSubType.completed,
                      transactions: getTransactionData(
                        SalesSubType.completed,
                        vm,
                      ),
                    ),
                    text: 'Purchases'.toUpperCase(),
                  ),

                  // ///Refunded
                  TabBarItem(
                    content: SalesTabLayout(
                      vm: vm,
                      searchController: searchController,
                      isFiltered: isFiltered,
                      controller: controller,
                      type: SalesSubType.refunded,
                      transactions: getTransactionData(
                        SalesSubType.refunded,
                        vm,
                      ),
                    ),
                    text: 'Refunds'.toUpperCase(),
                  ),

                  ///Cancelled
                  // TODO(lampian): Reuse as needed for v1 and v2
                  if (AppVariables.store!.state.enableVoidSale !=
                          EnableOption.disabled &&
                      AppVariables.store!.state.enableVoidSale !=
                          EnableOption.notSet)
                    TabBarItem(
                      content: SalesTabLayout(
                        vm: vm,
                        searchController: searchController,
                        isFiltered: isFiltered,
                        controller: controller,
                        type: SalesSubType.cancelled,
                        transactions: getTransactionData(
                          SalesSubType.cancelled,
                          vm,
                        ),
                      ),
                      text: 'Voids'.toUpperCase(),
                    ),

                  ///Withdrawal
                  TabBarItem(
                    content: SalesTabLayout(
                      vm: vm,
                      searchController: searchController,
                      isFiltered: isFiltered,
                      controller: controller,
                      type: SalesSubType.withdrawals,
                      transactions: getTransactionData(
                        SalesSubType.withdrawals,
                        vm,
                      ),
                    ),
                    text: SalesSubType.withdrawals.name.toUpperCase(),
                  ),
                ],
              ),
            ),
    ],
  );

  // This function checks whether or not to use original data or filtered data,
  // Once checked will go to the SalesSelector object to get data for the specific SalesSubtype
  List<CheckoutTransaction?> getTransactionData(SalesSubType type, SalesVM vm) {
    if (isNotBlank(searchController.text)) {
      return SalesSelector(
        type: type,
        transactions: vm.itemsFiltered,
      ).getTransactionListBySubType();
    } else {
      if (type == SalesSubType.all) {
        return SalesSelector(
          type: type,
          transactions: vm.items,
        ).getTransactionListBySubType();
      }
      return SalesSelector(
        type: type,
        transactions: vm.itemsAgglomerate,
      ).getTransactionListBySubType();
    }
  }

  updateFilteredList(SalesVM vm, SalesSubType type) async {
    if (isNotBlank(searchController.text)) {
      // Checking in State
      List<CheckoutTransaction?> result = checkStateFilter(vm, type);

      //Checking API
      if (result.isEmpty) {
        if (type != SalesSubType.all) {
          await vm.store!.dispatch(
            getFilteredBatchBySalesSubType(type, searchController.text),
          );
        } else {
          await vm.store!.dispatch(getFilteredBatch(searchController.text));
        }
      } else {
        // TODO(brandon): Update item in sale state to be of type List<CheckoutTransaction to remove nullable object in conjunction update reducer, action, vm and pages respectively for changes
        vm.onUpdateFilter(result as List<CheckoutTransaction>);
      }
      setState(() {
        isFiltered = true;
      });
      return;
    }
    if (isBlank(searchController.text)) {
      searchController.text = '';
      isFiltered = false;
      vm.store!.dispatch(ClearFiltersAction());
      vm.store!.dispatch(getInitialTransactions(forceRefresh: false));

      setState(() {});
    }
  }

  List<CheckoutTransaction?> checkStateFilter(SalesVM vm, SalesSubType type) {
    try {
      int.parse(searchController.text);
      List<CheckoutTransaction> transactions = vm.itemsAgglomerate.where((
        element,
      ) {
        bool transactionMatch = element.transactionNumber.toString().contains(
          searchController.text.trim(),
        );
        bool refundMatch = false;
        if ((element.refunds ?? []).isNotEmpty) {
          refundMatch = element.refunds!.any(
            (refund) => refund.transactionNumber.toString().contains(
              searchController.text.trim(),
            ),
          );
        }
        return transactionMatch || refundMatch;
      }).toList();

      int index = transactions.indexWhere((element) {
        bool transactionMatch =
            element.transactionNumber.toString().contains('.')
            ? element.transactionNumber.toString().split('.')[0].trim() ==
                  searchController.text.trim()
            : element.transactionNumber.toString().trim() ==
                  searchController.text.trim();
        bool refundMatch = false;
        if ((element.refunds ?? []).isNotEmpty) {
          refundMatch = element.refunds!.any(
            (refund) => refund.transactionNumber.toString().contains('.')
                ? refund.transactionNumber.toString().split('.')[0].trim() ==
                      searchController.text.trim()
                : refund.transactionNumber.toString().trim() ==
                      searchController.text.trim(),
          );
        }
        return transactionMatch || refundMatch;
      });
      if (index == -1) {
        return [];
      } else {
        return SalesSelector(
          type: type,
          transactions: transactions,
        ).getFilteredTransactions();
      }
    } catch (e) {
      return [];
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }
}
