// removed ignore: depend_on_referenced_packages, implementation_imports

// flutter imports
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';

// project imports
import 'package:littlefish_merchant/common/presentaion/components/labels/info_summary_row.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/features/cashback/presentation/components/cashback_submit_button.dart';
import 'package:littlefish_merchant/features/sell/presentation/components/discard_dialog_action_button.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/sales/checkout/cashback_requirements.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/selectable_box_grid.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';

class CashbackAmountPage extends StatefulWidget {
  static const String route = 'cashback-amount-page';

  final double withdrawalAmount;
  final double totalBeforeWithdrawal;
  final List<double> amountOptions;
  final CashbackRequirements? requirements;
  final void Function()? discardCashback;
  const CashbackAmountPage({
    Key? key,
    this.withdrawalAmount = 0,
    this.totalBeforeWithdrawal = 0,
    this.amountOptions = const [],
    this.requirements,
    this.discardCashback,
  }) : super(key: key);

  @override
  State<CashbackAmountPage> createState() => _CashbackAmountPageState();
}

class _CashbackAmountPageState extends State<CashbackAmountPage> {
  late List<double> _amountOptions;
  late double _amount;
  final GlobalKey<FormState> _formKey = GlobalKey();
  final FocusNode _customAmountFocusNode = FocusNode();
  final TextEditingController _customAmountController = TextEditingController();
  late CashbackRequirements _cashbackRequirements;
  final String _dialogContent = 'Are you sure you want to remove the cashback?';
  final String _dialogTitle = 'Discard Cashback';

  @override
  void initState() {
    _amount = widget.withdrawalAmount;
    _amountOptions = widget.amountOptions;
    _cashbackRequirements =
        widget.requirements ?? CashbackRequirements(minAmount: 0);
    if (_amount == 0) {
      _customAmountController.text = '';
    }
    if (_isAmountCustom(_amount)) {
      _customAmountController.text = _amount.toString();
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return scaffold();
  }

  Widget scaffold() {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) => _onPopInvoked(didPop: didPop),
      child: AppScaffold(
        title: 'Cashback Amount',
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: layout(),
        ),
        actions: [
          DiscardDialogActionButton(
            onTap: (shouldDiscard) {
              if (shouldDiscard) _discardCashback(useDiscardCallback: true);
            },
            dialogContent: _dialogContent,
            dialogTitle: _dialogTitle,
          ),
        ],
        persistentFooterButtons: [
          Column(
            children: [
              _cashbackTextAndAmount(context),
              CashbackSubmitButton(
                amount: _amount,
                requirements: _cashbackRequirements,
              ),
            ],
          ),
        ],
        onBackPressed: () => _onPopInvoked(),
      ),
    );
  }

  Widget layout() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          customAmountFormField(hintText: 'Cashback Amount'),
          predefinedAmountOptions(),
        ],
      ),
    );
  }

  Form customAmountFormField({required String hintText}) {
    return Form(
      key: _formKey,
      child: DecimalFormField(
        enabled: true,
        hintText: hintText,
        key: const Key('amount'),
        labelText: 'Amount',
        onSaveValue: (value) {
          setState(() {
            _amount = value;
            _customAmountFocusNode.unfocus();
          });
        },
        controller: _customAmountController,
        inputAction: TextInputAction.done,
        useOutlineStyling: true,
        onFieldSubmitted: (value) {
          setState(() {
            _amount = value;
            _customAmountFocusNode.unfocus();
          });
        },
      ),
    );
  }

  Widget predefinedAmountOptions() {
    return SelectableBoxGrid<double>(
      onTap: (selectedAmount) {
        setState(() {
          _amount = selectedAmount ?? 0;
          _customAmountController.text = '';
        });
      },
      items: _amountOptions,
      numColumns: 3,
      initiallySelectedItem: _amount,
      itemFormat: SelectableBoxItemFormat.currencyNoDecimal,
    );
  }

  bool _isAmountCustom(double amount) {
    if (amount == 0) return false;
    return !_amountOptions.contains(amount);
  }

  Widget _cashbackTextAndAmount(BuildContext context) {
    return InfoSummaryRow(
      leading: 'Cashback',
      trailing: TextFormatter.toStringCurrency(_amount, currencyCode: ''),
      padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
    );
  }

  void _onPopInvoked({bool didPop = false}) async {
    if (didPop) return;
    if (_amount == widget.withdrawalAmount || _amount == 0) {
      Navigator.of(context).pop(_amount);
      return;
    }

    final modalService = getIt<ModalService>();

    final bool? discardSelectedDiscount = await modalService.showActionModal(
      context: context,
      title: _dialogTitle,
      description: _dialogContent,
      status: StatusType.destructive,
    );

    if (discardSelectedDiscount ?? false) {
      _discardCashback(popAfterDiscard: true, useDiscardCallback: false);
    }
  }

  void _discardCashback({
    bool popAfterDiscard = true,
    bool useDiscardCallback = false,
  }) {
    setState(() {
      _amount = 0;
      _customAmountController.text = '';
      if (widget.discardCashback != null && useDiscardCallback) {
        widget.discardCashback!();
      }
    });

    if (popAfterDiscard) {
      Navigator.of(context).pop();
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }
}
