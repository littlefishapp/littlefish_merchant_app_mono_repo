import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/list_detail_view.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/expenses/expenses_actions.dart';
import 'package:littlefish_merchant/ui/business/expenses/pages/expense_page.dart';
import 'package:littlefish_merchant/ui/business/expenses/view_models.dart';
import 'package:littlefish_merchant/ui/business/expenses/widgets/expenses_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';

class ExpensesPage extends StatefulWidget {
  static const String route = 'business/expenses';

  const ExpensesPage({Key? key}) : super(key: key);

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  @override
  void initState() {
    // AppVariables.store.dispatch(getExpenses());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ExpensesVM>(
      onInit: (store) {},
      converter: (store) => ExpensesVM.fromStore(store),
      builder: (ctx, vm) => EnvironmentProvider.instance.isLargeDisplay!
          ? scaffoldTablet(context, vm)
          : scaffoldMobile(context, vm),
    );
  }

  Widget scaffoldTablet(BuildContext context, ExpensesVM vm) {
    final noExpensesAvailable = vm.items?.isEmpty ?? false;
    final detailText = noExpensesAvailable
        ? 'Select ADD NEW EXPENSE \nto start adding new expenses'
        : 'Select Expense from the list';
    return ListDetailView(
      listWidget: AppScaffold(
        enableProfileAction: false,
        title: 'Expenses',
        hasDrawer: true, //vm.store!.state.enableSideNavDrawer!,

        displayNavDrawer: true, //vm.store!.state.enableSideNavDrawer!,
        persistentFooterButtons: [
          FooterButtonsIconPrimary(
            primaryButtonText: 'Add New Expense',
            secondaryButtonIcon: Icons.refresh_outlined,
            onPrimaryButtonPressed: (BuildContext ctx) {
              vm.store!.dispatch(createExpense(ctx));
            },
            onSecondaryButtonPressed: (context) {
              vm.store!.dispatch(getExpenses(refresh: true));
            },
          ),
        ],
        body: ExpensesList(
          parentContext: context,
          canAddNew: false,
          onTap: (item) {
            vm.selectedItem = item;
            vm.store!.dispatch(ExpenseSelectAction(item));
            debugPrint('### Expense tapped: ${item.displayName}');
            setState(() {});
          },
        ),
      ),
      detailWidget:
          vm.selectedItem != null && (vm.selectedItem!.isNew ?? false) == false
          ? const ExpensePage(isEmbedded: true)
          : AppScaffold(
              enableProfileAction: false,
              displayBackNavigation: false,
              body: Padding(
                padding: const EdgeInsets.only(bottom: 64),
                child: Center(child: context.labelLarge(detailText)),
              ),
            ),
    );
  }

  AppScaffold scaffoldMobile(context, ExpensesVM vm) => AppScaffold(
    title: 'Expenses',
    hasDrawer: vm.store!.state.enableSideNavDrawer!,
    displayNavDrawer: vm.store!.state.enableSideNavDrawer!,
    persistentFooterButtons: [
      FooterButtonsIconPrimary(
        primaryButtonText: 'Add New Expense',
        secondaryButtonIcon: Icons.refresh_outlined,
        onPrimaryButtonPressed: (BuildContext ctx) {
          vm.store!.dispatch(createExpense(ctx));
        },
        onSecondaryButtonPressed: (context) {
          vm.store!.dispatch(getExpenses(refresh: true));
        },
      ),
    ],
    body: SafeArea(
      child: ExpensesList(canAddNew: false, parentContext: context),
    ),
  );
}
