import 'package:decimal/decimal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/custom_keypad.dart';
// removed ignore: depend_on_referenced_packages, implementation_imports
import 'package:redux/src/store.dart';
import 'package:littlefish_merchant/ui/checkout/viewmodels/checkout_viewmodels.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/selectable_box_grid.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_action_submit_controller.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_action_requirements.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_action_requirements_factory.dart';
import 'package:littlefish_merchant/models/sales/checkout/checkout_action_requirements_validator.dart';
import 'package:littlefish_merchant/redux/checkout/checkout_actions.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/models/enums.dart';

class CheckoutActionPage extends StatefulWidget {
  final CheckoutActionType actionType;

  const CheckoutActionPage({required this.actionType, Key? key})
    : super(key: key);

  @override
  State<CheckoutActionPage> createState() => _CheckoutActionPageState();
}

class _CheckoutActionPageState extends State<CheckoutActionPage> {
  late List<double> predefinedAmountList;
  late Decimal amount;
  final TextEditingController _customAmountController = TextEditingController();
  late CheckoutActionRequirements actionRequirements;
  late String _title;

  @override
  void initState() {
    predefinedAmountList = _getPredefinedAmountList(widget.actionType);
    actionRequirements = _getActionRequirments(widget.actionType);
    _title = _getTitle(widget.actionType);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CheckoutVM>(
      converter: (Store<AppState> store) {
        return CheckoutVM.fromStore(store);
      },
      onInit: (store) {
        var state = store.state.checkoutState;
        switch (widget.actionType) {
          case CheckoutActionType.cashback:
            store.dispatch(
              CheckoutSetCurrentActionAmount(
                state.cashbackAmount ?? Decimal.zero,
              ),
            );
            break;
          case CheckoutActionType.withdrawal:
            store.dispatch(
              CheckoutSetCurrentActionAmount(
                state.withdrawalAmount ?? Decimal.zero,
              ),
            );
            break;
          default:
            store.dispatch(CheckoutSetCurrentActionAmount(Decimal.zero));
        }
      },
      builder: (BuildContext context, CheckoutVM vm) {
        if (vm.isLoading == true) return const AppProgressIndicator();
        _initializeAmount(widget.actionType, vm);
        return scaffold(vm);
      },
    );
  }

  Widget scaffold(CheckoutVM vm) {
    return vm.isLoading == true
        ? const AppProgressIndicator(
            hasScaffold: true,
            backgroundColor: Colors.white,
          )
        : PopScope(
            onPopInvoked: (didPop) {
              if (widget.actionType == CheckoutActionType.withdrawal) {
                vm.store?.dispatch(
                  CheckoutSetWithdrawalAmountAction(Decimal.zero),
                );
              }
              return;
            },
            child: layout(vm),
          );
  }

  Widget layout(CheckoutVM vm) {
    String actionName = widget.actionType == CheckoutActionType.withdrawal
        ? 'withdrawal'
        : 'cashback';
    return CustomKeyPad(
      title: _title,
      isNoDecimalAmountCapture: true,
      confirmButtonText: widget.actionType == CheckoutActionType.withdrawal
          ? 'Continue to Withdraw'
          : 'Add Cashback',
      isFullPage: true,
      onSubmit: (value, description) => _onSubmit(vm),
      onValueChanged: (value) => _onValueChanged(value, vm),
      onDescriptionChanged: (description) {},
      confirmErrorMessage:
          'Please enter an amount to complete the $actionName.',
      initialValue: (vm.currentCheckoutActionAmount ?? Decimal.zero).toDouble(),
      enableDiscardButton: true,
      discardTitle: 'Discard $actionName',
      discardDescription:
          'Are you sure you want to discard this $actionName?'
          '\nYou will lose any changes you have made.',
      onDiscard: (canDiscard) => _onDiscard(canDiscard, vm),
    );
  }

  void _onSubmit(CheckoutVM vm) {
    AmountValidationResult result =
        CheckoutActionRequirementsValidator.validateAmount(
          actionRequirements,
          amount.toBigInt().toInt(),
        );
    String message = CheckoutActionRequirementsValidator.validationMessage(
      result,
      actionRequirements,
    );

    if (result != AmountValidationResult.success) {
      showMessageDialog(context, message, LittleFishIcons.error);
      return;
    }

    CheckoutActionSubmit.submit(widget.actionType, vm, context, amount);
  }

  void _onDiscard(bool canDiscard, CheckoutVM vm) {
    if (!canDiscard) return;
    if (mounted) {
      setState(() {
        vm.store?.dispatch(CheckoutSetCurrentActionAmount(Decimal.zero));
        if (widget.actionType == CheckoutActionType.withdrawal) {
          vm.store?.dispatch(CheckoutSetWithdrawalAmountAction(Decimal.zero));
        } else {
          vm.store?.dispatch(CheckoutSetCashbackAmountAction(Decimal.zero));
        }
      });
    }
  }

  void _onValueChanged(double value, CheckoutVM vm) {
    if (mounted) {
      setState(() {
        amount = Decimal.parse(value.toString());
        vm.store?.dispatch(CheckoutSetCurrentActionAmount(amount));
        _customAmountController.text = '';
      });
    }
  }

  Widget predefinedAmountOptions(CheckoutVM vm) {
    return SelectableBoxGrid<double>(
      onTap: (selectedAmount) {
        if (mounted) {
          setState(() {
            amount = Decimal.parse((selectedAmount ?? 0).toString());
            vm.store?.dispatch(CheckoutSetCurrentActionAmount(amount));
            _customAmountController.text = '';
          });
        }
      },
      items: predefinedAmountList,
      numColumns: 3,
      initiallySelectedItem: amount.toDouble(),
      itemFormat: SelectableBoxItemFormat.currencyNoDecimal,
    );
  }

  void _initializeAmount(CheckoutActionType actionType, CheckoutVM vm) {
    switch (actionType) {
      case CheckoutActionType.cashback:
        amount =
            vm.currentCheckoutActionAmount ?? vm.cashbackAmount ?? Decimal.zero;
        break;
      case CheckoutActionType.withdrawal:
        amount =
            vm.currentCheckoutActionAmount ??
            vm.withdrawalAmount ??
            Decimal.zero;
        break;
      default:
        amount = Decimal.zero;
    }

    if (amount == Decimal.zero) {
      _customAmountController.text = '';
      return;
    }

    if (isAmountCustom(amount)) {
      _customAmountController.text = amount.toString();
    }
  }

  CheckoutActionRequirements _getActionRequirments(
    CheckoutActionType actionType,
  ) {
    CheckoutActionRequirements? requirementsFromRemote;

    switch (actionType) {
      case CheckoutActionType.cashback:
        requirementsFromRemote = AppVariables.store?.state.cashbackRequirements;
        break;
      case CheckoutActionType.withdrawal:
        requirementsFromRemote = AppVariables.store?.state.withdrawRequirements;
        break;
      default:
        requirementsFromRemote = AppVariables.store?.state.cashbackRequirements;
        break;
    }

    if (requirementsFromRemote != null) return requirementsFromRemote;

    return CheckoutActionRequirementsFactory.createRequirements(
      actionType,
      minAmount: 0,
    );
  }

  List<double> _getPredefinedAmountList(CheckoutActionType actionType) {
    switch (actionType) {
      case CheckoutActionType.cashback:
        return AppVariables.store?.state.cashbackAmountOptions ?? [];
      case CheckoutActionType.withdrawal:
        return AppVariables.store?.state.withdrawalAmountOptions ?? [];
      default:
        return [];
    }
  }

  bool isAmountCustom(Decimal amount) {
    if (amount == Decimal.zero) return false;
    bool isAmountPredefined = predefinedAmountList.contains(amount.toDouble());
    if (isAmountPredefined) return false;
    return true;
  }

  String _getTitle(CheckoutActionType actionType) {
    switch (actionType) {
      case CheckoutActionType.cashback:
        return 'Cashback Amount';
      case CheckoutActionType.withdrawal:
        return 'Cash Withdrawal Amount';
      default:
        return 'Cashback Amount';
    }
  }
}
