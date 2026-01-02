// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

class AmountPopupForm<double> extends StatefulWidget {
  final String? title, hintText;

  final double? initialValue;

  final String subTitle;

  final Function(BuildContext context, dynamic value)? onSubmit;

  final bool isEmbedded;

  const AmountPopupForm({
    Key? key,
    required this.title,
    this.hintText,
    this.initialValue,
    required this.subTitle,
    this.onSubmit,
    this.isEmbedded = false,
  }) : super(key: key);

  @override
  State<AmountPopupForm> createState() => _AmountPopupFormState();
}

class _AmountPopupFormState extends State<AmountPopupForm> {
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
    var scaffold = AppSimpleAppScaffold(
      isEmbedded: widget.isEmbedded,
      title: widget.title,
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
              child: SizedBox(
                height: 100,
                child: CurrencyFormField(
                  inputAction: TextInputAction.done,
                  initialValue: widget.initialValue,
                  focusNode: _focusNode,
                  key: Key(widget.title!),
                  hintText: widget.hintText,
                  labelText: widget.title,
                  onFieldSubmitted: (value) {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  onSaveValue: (value) {
                    setState(() {
                      _value = value;
                    });
                  },
                  //select all text when the field has focus, that way it is
                  // easier to enter the desired amount since currently
                  // by default enetered digits is appended to the end of the
                  // existing text (which is 0.00 by default), so pressing '5'
                  // would unintuitively result in '0.005'.
                  // By selecting all text when focused, user overrides text.
                  // Possible improvement is for it to work identically to
                  // the amount due field when charging for payments in checkout.
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Container(
              alignment: Alignment.center,
              child: LongText(
                widget.subTitle,
                maxLines: 3,
                fontSize: null,
                alignment: TextAlign.center,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 24.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: ButtonPrimary(
                      buttonColor: Theme.of(context).colorScheme.secondary,
                      text: 'cancel',
                      onTap: (context) => Navigator.of(context).pop(null),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: ButtonPrimary(
                      buttonColor: Theme.of(context).colorScheme.primary,
                      text: 'accept',
                      onTap: (context) {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();

                          if (widget.onSubmit != null) {
                            widget.onSubmit!(context, _value);
                            Navigator.of(context).pop();
                            return;
                          }

                          Navigator.of(context).pop(_value);
                        }
                      },
                    ),
                  ),
                ],
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
