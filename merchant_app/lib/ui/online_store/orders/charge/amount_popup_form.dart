// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/simple_app_scaffold.dart';

// Package imports:

// Project imports:

import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../common/presentaion/components/form_fields/numeric_form_field.dart';
import '../../../../common/presentaion/components/long_text.dart';

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
    var scaffold = SimpleAppScaffold(
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
              child: NumericFormField(
                inputAction: TextInputAction.done,
                initialValue: widget.initialValue.toInt(),
                focusNode: _focusNode,
                key: Key(widget.title!),
                hintText: widget.hintText!,
                labelText: widget.title!,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                onSaveValue: (value) {
                  setState(() {
                    _value = value.toDouble();
                  });
                },
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
                      text: 'Cancel',
                      onTap: (context) => Navigator.of(context).pop(null),
                    ),
                  ),
                  const SizedBox(width: 4.0),
                  Expanded(
                    child: ButtonPrimary(
                      buttonColor: Theme.of(context).colorScheme.primary,
                      text: 'Accept',
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
