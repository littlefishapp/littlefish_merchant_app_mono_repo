import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/adjustment_description.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/quantity_and_category_display.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/quantity_field.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/reason_dropdown.dart';

class QuantityAdjustment extends StatefulWidget {
  final String title;
  final Widget? image;
  final double initialValue;
  final QuantityUnitType unitType;
  final List<String>? increaseReasons;
  final List<String>? decreaseReasons;
  final Function(double adjustedQuantity, String? selectedReason) onConfirmed;
  final String? category;
  final bool showQuantityInfo;
  final bool? enableProfileAction;

  const QuantityAdjustment({
    Key? key,
    required this.title,
    this.image,
    required this.initialValue,
    required this.unitType,
    this.increaseReasons,
    this.decreaseReasons,
    required this.onConfirmed,
    this.category,
    this.showQuantityInfo = true,
    this.enableProfileAction,
  }) : super(key: key);

  @override
  QuantityAdjustmentState createState() => QuantityAdjustmentState();
}

class QuantityAdjustmentState extends State<QuantityAdjustment> {
  late double quantity;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? _selectedReason;
  final FocusNode _focusNode = FocusNode();

  bool get _quantityUnchanged => widget.initialValue == quantity;

  @override
  void initState() {
    super.initState();
    quantity = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      enableProfileAction: widget.enableProfileAction,
      onBackPressed: _handleBackPressed,
      centreTitle: true,
      title: widget.title,
      persistentFooterButtons: [_buildConfirmButton()],
      body: _buildBody(),
    );
  }

  Future<void> _handleBackPressed() async {
    if (_quantityUnchanged) {
      Navigator.of(context).pop();
      return;
    }

    var result = await getIt<ModalService>().showActionModal(
      context: context,
      title: 'Discard changes?',
      description:
          'Are you sure you want to go back?'
          'Any changes will not be saved.',
      acceptText: 'Yes, Go Back',
      cancelText: 'No, Cancel',
    );

    if (result == true && mounted) {
      Navigator.pop(context);
    }
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            const SizedBox(height: 32),
            if (widget.image != null) Center(child: widget.image!),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Center(
                child: context.headingSmall(
                  widget.title,
                  isBold: true,
                  alignLeft: false,
                ),
              ),
            ),
            QuantityAndCategoryDisplay(
              category: widget.category,
              initialValue: widget.initialValue,
              showQuantityInfo: widget.showQuantityInfo,
            ),
            const SizedBox(height: 16),
            QuantityField(
              unitType: widget.unitType,
              initialValue: quantity,
              focusNode: _focusNode,
              textFieldWidth: 124,
              onChanged: (newQuantity) {
                setState(() {
                  bool decreasingToIncreasing =
                      (newQuantity >= widget.initialValue &&
                      quantity <= widget.initialValue);
                  bool increasingToDecrease =
                      (newQuantity <= widget.initialValue &&
                      quantity >= widget.initialValue);
                  if (decreasingToIncreasing || increasingToDecrease) {
                    _selectedReason = null;
                  }
                  quantity = newQuantity;
                });
              },
            ),
            const SizedBox(height: 16),
            AdjustmentDescription(
              initialValue: widget.initialValue,
              quantity: quantity,
            ),
            ReasonDropdown(
              formKey: _formKey,
              initialValue: widget.initialValue,
              quantity: quantity,
              reason: _selectedReason,
              increaseReasons: widget.increaseReasons,
              decreaseReasons: widget.decreaseReasons,
              onChanged: (value) {
                setState(() {
                  _selectedReason = value;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConfirmButton() {
    final canConfirm =
        !_quantityUnchanged &&
        ((_selectedReason != null) ||
            (widget.increaseReasons == null && widget.decreaseReasons == null));

    return Container(
      height: 48,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      child: ButtonPrimary(
        disabled: !canConfirm,
        buttonColor: Theme.of(context).colorScheme.secondary,
        text: 'Confirm',
        upperCase: false,
        onTap: (ctx) => _handleConfirmButtonPressed(),
      ),
    );
  }

  void _handleConfirmButtonPressed() {
    if (_quantityUnchanged) {
      Navigator.of(context).pop();
      return;
    }
    if (_formKey.currentState != null && !_formKey.currentState!.validate()) {
      return;
    }
    _formKey.currentState?.save();

    widget.onConfirmed(quantity, _selectedReason);
  }
}
