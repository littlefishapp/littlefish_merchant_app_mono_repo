import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/simple_app_scaffold.dart';
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:littlefish_merchant/providers/locale_provider.dart';
import '../../../common/presentaion/components/form_fields/mobile_number_form_field.dart';
import '../../../common/presentaion/components/form_fields/string_form_field.dart';

class InputModal extends StatefulWidget {
  final bool mobileNumber;
  final String title;
  final String description;
  final String inputTitle;

  const InputModal({
    Key? key,
    required this.title,
    required this.description,
    required this.inputTitle,
    this.mobileNumber = false,
  }) : super(key: key);

  @override
  State<InputModal> createState() => _InputModalState();
}

class _InputModalState extends State<InputModal> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return inputPopup(context);
  }

  SimpleAppScaffold inputPopup(BuildContext ctx) {
    String? reason = '';

    var formFields = <Widget>[
      Expanded(
        child: Column(
          children: <Widget>[
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(widget.title, style: const TextStyle(fontSize: 24)),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Text(
                widget.description,
                style: const TextStyle(fontSize: 16),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: !widget.mobileNumber
                  ? StringFormField(
                      hintText: widget.inputTitle,
                      key: const Key('reason'),
                      labelText: widget.inputTitle,
                      focusNode: FocusNode(),
                      initialValue: reason,
                      onFieldSubmitted: (value) {
                        reason = value;
                      },
                      inputAction: TextInputAction.done,
                      isRequired: true,
                      onSaveValue: (value) {
                        reason = value;
                      },
                    )
                  // TODO(lampian): extract as common widget
                  : MobileNumberFormField(
                      country: CountryStub(
                        countryCode: LocaleProvider.instance.countryCode,
                        diallingCode: LocaleProvider.instance.dialingCode,
                      ),
                      hintText: 'Primary Telephone Number',
                      key: const Key('telnumber'),
                      labelText: 'Mobile Number',
                      initialValue: reason,
                      onFieldSubmitted: (value) {
                        reason = value;
                      },
                      inputAction: TextInputAction.next,
                      isRequired: true,
                      onSaveValue: (value) {
                        reason = value;
                      },
                    ),
            ),
          ],
        ),
      ),
    ];

    return SimpleAppScaffold(
      bottomButtonFunction: () {
        if (formKey.currentState?.validate() ?? false) {
          formKey.currentState!.save();
          Navigator.of(ctx).pop(reason);
        }
      },
      body: Form(
        key: formKey,
        child: MediaQuery.removePadding(
          removeTop: true,
          context: ctx,
          child: ListView(
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: formFields,
          ),
        ),
      ),
    );
  }
}
