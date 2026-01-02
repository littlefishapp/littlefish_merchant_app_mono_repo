import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_secondary_primary.dart';
import 'package:littlefish_merchant/models/expenses/business_expense.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/expenses/expenses_actions.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/business/expenses/forms/expense_form.dart';
import 'package:littlefish_merchant/ui/business/expenses/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import '../../../../common/presentaion/components/dialogs/services/modal_service.dart';
import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';
import '../../../../injector.dart';

class ExpensePage extends StatefulWidget {
  static const String route = 'business/expense/detail';

  final bool isEmbedded;
  final BusinessExpense? defaultExpense;
  const ExpensePage({Key? key, this.defaultExpense, this.isEmbedded = false})
    : super(key: key);

  @override
  State<ExpensePage> createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('### ExpensePage build called');
    final isTablet = EnvironmentProvider.instance.isLargeDisplay ?? false;
    final screenWidth = MediaQuery.of(context).size.width / 3;
    return StoreConnector<AppState, ExpenseVM>(
      converter: (store) => ExpenseVM.fromStore(store)..key = formKey,
      builder: (ctx, vm) {
        if (widget.defaultExpense != null) vm.item = widget.defaultExpense;
        return PopScope(
          child: isTablet
              ? Container(
                  width: screenWidth,
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: layout(ctx, vm),
                )
              : layout(ctx, vm),
          canPop: true,
          onPopInvoked: (_) async {
            // clear vm.item (expense) by creating a new default valued expense.
            vm.store?.dispatch(ClearExpenseAction());
          },
        );
      },
    );
  }

  layout(ctx, ExpenseVM vm) {
    return AppScaffold(
      title: vm.isNew! ? 'New Expenses' : vm.item!.displayName ?? 'Expense',
      enableProfileAction: false,
      hasDrawer: false,
      displayNavDrawer: false,
      displayBackNavigation: true,
      displayNavBar: false,
      // TODO(lampian): move delete to list view items slidable?
      actions: <Widget>[
        if (!vm.isNew!) ...[
          IconButton(
            onPressed: () async {
              bool? result = await getIt<ModalService>().showActionModal(
                context: ctx,
                title: 'Delete Expense',
                acceptText: 'Yes, Delete Expense',
                cancelText: 'No, Cancel',
                description:
                    'Are you sure you want to delete this expense?'
                    '\nThis cannot be undone.',
              );

              if (result == true && context.mounted) {
                vm.onRemove(vm.item, ctx);
                Navigator.of(ctx).pop();
              }
            },
            icon: const Icon(Icons.delete),
            color: Theme.of(ctx).extension<AppliedTextIcon>()?.error,
          ),
        ],
      ],
      persistentFooterButtons: <Widget>[
        FooterButtonsSecondaryPrimary(
          primaryButtonText: 'Save',
          onPrimaryButtonPressed: (_) {
            vm.onAdd(vm.item, ctx);
          },
          secondaryButtonText: 'Cancel',
          onSecondaryButtonPressed: (_) {
            Navigator.pop(ctx);
          },
        ),
      ],
      body: vm.isLoading!
          ? const AppProgressIndicator()
          : Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: ExpenseForm(
                formKey: vm.key,
                item: vm.item,
                allowEdit: true,
              ),
            ),
    );
  }
}
