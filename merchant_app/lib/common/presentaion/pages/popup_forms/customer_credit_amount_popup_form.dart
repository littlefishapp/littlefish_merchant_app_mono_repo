// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

import '../../../../tools/textformatter.dart';
import '../../components/custom_app_bar.dart';

class CustomerCreditAmountPopupForm<double> extends StatefulWidget {
  final String? title, hintText;

  final double? initialValue;
  final double creditBalance;
  final bool shouldPop;

  final Function(BuildContext context, dynamic value)? onSubmit;

  final bool isEmbedded;

  const CustomerCreditAmountPopupForm({
    Key? key,
    required this.title,
    this.hintText,
    this.initialValue,
    this.shouldPop = true,
    required this.creditBalance,
    this.onSubmit,
    this.isEmbedded = false,
  }) : super(key: key);

  @override
  State<CustomerCreditAmountPopupForm> createState() =>
      _CustomerCreditAmountPopupFormState();
}

class _CustomerCreditAmountPopupFormState
    extends State<CustomerCreditAmountPopupForm> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final FocusNode _focusNode = FocusNode();

  bool hasFocused = false;

  double? _value;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var scaffold = Scaffold(
      appBar: CustomAppBar(
        centerTitle: true,
        title: Text(
          widget.title!,
          style: TextStyle(
            color: Theme.of(context).colorScheme.secondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 1,
      ),
      persistentFooterButtons: [
        ButtonBar(
          buttonHeight: 44,
          buttonMinWidth: (MediaQuery.of(context).size.width / 2) - 24,
          children: [
            ElevatedButton(
              // TODO(lampian): fix color color: Theme.of(context).colorScheme.secondary,
              child: const Text(
                'Cancel',
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  // fontSize: 14,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(null),
            ),
            ElevatedButton(
              // TODO(lampian): fix color color: Theme.of(context).colorScheme.primary,
              child: const Text(
                'Accept',
                style: TextStyle(
                  color: Colors.white,
                  // fontWeight: FontWeight.bold,
                  // fontSize: 14,
                ),
              ),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();

                  if (widget.onSubmit != null) {
                    widget.onSubmit!(context, _value);
                    if (widget.shouldPop) Navigator.of(context).pop();
                    return;
                  }

                  Navigator.of(context).pop(_value);
                }
              },
            ),
          ],
        ),
      ],
      body: Container(
        margin: const EdgeInsets.all(48.0),
        child: ListView(
          physics: widget.isEmbedded
              ? const BouncingScrollPhysics()
              : const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Form(
              key: _formKey,
              child: CurrencyFormField(
                inputAction: TextInputAction.done,
                initialValue: widget.initialValue,
                focusNode: _focusNode,
                key: Key(widget.title!),
                hintText: widget.hintText,
                labelText: widget.title,
                onFieldSubmitted: (value) {
                  setState(() {
                    _value = value;
                  });
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                onSaveValue: (value) {
                  setState(() {
                    _value = value;
                  });
                },
              ),
            ),
            const SizedBox(height: 24.0),
            Container(
              alignment: Alignment.center,
              child: LongText(
                'Outstanding Credit: ${TextFormatter.toStringCurrency(widget.creditBalance, displayCurrency: false, currencyCode: '')}',
                maxLines: 3,
                fontSize: null,
                alignment: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );

    if (!hasFocused) {
      hasFocused = true;
      FocusScope.of(context).requestFocus(_focusNode);
    }

    return scaffold;
  }
}
