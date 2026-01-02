// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

class StringPopupForm<String> extends StatefulWidget {
  const StringPopupForm({
    Key? key,
    required this.title,
    this.initialValue,
    required this.maxLength,
    required this.subTitle,
    this.onSubmit,
    this.formKey,
  }) : super(key: key);

  final String? title, initialValue;

  final String subTitle;

  final int maxLength;

  final Function(BuildContext context, String value)? onSubmit;

  final GlobalKey<FormState>? formKey;

  @override
  State<StringPopupForm> createState() => _StringPopupFormState();
}

class _StringPopupFormState extends State<StringPopupForm> {
  GlobalKey<FormState>? _formKey;

  String? _value;

  FocusNode? focusNode;

  @override
  void initState() {
    _formKey = widget.formKey;
    _formKey ??= GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    focusNode ??= FocusNode();

    //debugPrint('rebuild triggered');
    var scaffold = AppSimpleAppScaffold(
      title: widget.title,
      body: Container(
        margin: const EdgeInsets.all(48.0),
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: <Widget>[
            Form(
              key: _formKey,
              child: StringFormField(
                focusNode: focusNode,
                inputAction: TextInputAction.done,
                key: Key(widget.title),
                hintText: widget.initialValue,
                labelText: widget.title,
                onFieldSubmitted: (value) {
                  setState(() {
                    _value = value.toString();
                  });
                },
                onSaveValue: (value) {
                  setState(() {
                    _value = value.toString();
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
                        if (_formKey!.currentState!.validate()) {
                          _formKey!.currentState!.save();

                          if (widget.onSubmit != null) {
                            widget.onSubmit!(context, _value);
                            Navigator.of(context).pop(_value);
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

    return scaffold;
  }
}
