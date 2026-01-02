// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/ui/security/registration/functions/activation_functions.dart';
// ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/settings/locale/country_stub.dart';
import 'package:littlefish_merchant/models/store/business_type.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/business/profile/viewmodels/view_models.dart';
import 'package:littlefish_merchant/common/presentaion/components/circle_gradient_avatar.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/dropdown_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class BusinessProfileCreateForm extends StatefulWidget {
  const BusinessProfileCreateForm({Key? key, required this.model})
    : super(key: key);

  final BusinessProfileCreateVM model;

  @override
  State<BusinessProfileCreateForm> createState() =>
      _BusinessProfileCreateFormState();
}

class _BusinessProfileCreateFormState extends State<BusinessProfileCreateForm> {
  GlobalKey<AutoCompleteTextFieldState<CountryStub>>? countryKey;
  late BusinessProfileCreateVM model;
  bool isDescriptionRequired = false;

  @override
  void initState() {
    model = widget.model;
    countryKey = GlobalKey<AutoCompleteTextFieldState<CountryStub>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      builder: (BuildContext context, Store<AppState> store) {
        return model.isLoading!
            ? const AppProgressIndicator()
            : form(context, model, store);
      },
    );
  }

  Form form(
    BuildContext context,
    BusinessProfileCreateVM model,
    Store<AppState> store,
  ) {
    var typeIndex = 0;

    var formFields = <Widget>[
      // avatar(context, model),
      StringFormField(
        useOutlineStyling: true,
        enforceMaxLength: true,
        maxLength: 50,
        hintText: 'What is your business name?',
        suffixIcon: Icons.store,
        key: const Key('businessname'),
        labelText: 'Business Name',
        asyncValidator: (value) {
          if (value == null) return null;
          if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return 'Business name cannot have special characters';
          }
        },
        focusNode: model.form.setFocusNode('businessname'),
        nextFocusNode: model.form.setFocusNode('merchantid'),
        onFieldSubmitted: (value) {
          model.item!.name = value;
        },
        inputAction: TextInputAction.next,
        initialValue: model.item!.name,
        isRequired: true,
        onSaveValue: (value) {
          model.item!.name = value;
        },
      ),
      StringFormField(
        useOutlineStyling: true,
        enforceMaxLength: false,
        maxLength: 255,
        hintText: 'Describe your business?',
        asyncValidator: (value) {
          if (isDescriptionRequired == false) return null;
          if (value == null) return null;
          if (!RegExp(r'^[a-z A-Z]+$').hasMatch(value)) {
            return 'Description cannot have special characters';
          }
        },
        suffixIcon: Icons.store,
        key: const Key('description'),
        labelText: 'Description',
        focusNode: model.form.setFocusNode('description'),
        nextFocusNode: model.form.setFocusNode('type'),
        onFieldSubmitted: (value) {
          model.item!.description = value;
        },
        inputAction: TextInputAction.next,
        initialValue: model.item!.description,
        isRequired: isDescriptionRequired,
        onSaveValue: (value) {
          model.item!.description = value;
        },
      ),
      StringFormField(
        useOutlineStyling: true,
        enforceMaxLength: true,
        maxLength: 50,
        hintText: 'What is your Merchant ID?',
        suffixIcon: Icons.store,
        key: const Key('merchantid'),
        labelText: 'Merchant ID',
        focusNode: model.form.setFocusNode('merchantid'),
        nextFocusNode: model.form.setFocusNode('description'),
        onFieldSubmitted: (value) {
          model.item!.masterMerchantId = formatMidValue(value);
        },
        inputAction: TextInputAction.next,
        initialValue: model.item!.masterMerchantId,
        isRequired: true,
        onSaveValue: (value) {
          model.item!.masterMerchantId = formatMidValue(value);
        },
        onChanged: ((value) {
          model.item!.masterMerchantId = value;
        }),
      ),
      DropdownFormField(
        useOutlineStyling: true,
        hintText: 'Business Type',
        key: const Key('businessType'),
        labelText: 'Business Type',
        focusNode: model.form.setFocusNode('businessType'),
        nextFocusNode: model.form.setFocusNode('category'),
        onFieldSubmitted: (value) {
          setState(() {
            model.selectedType = null;
            Future.delayed(const Duration(milliseconds: 500)).then((result) {
              model.selectedType = value.value;
              model.item!.type = value.value;
            });
          });
        },
        inputAction: TextInputAction.next,
        initialValue: model.item!.type ?? setDefaultBusinessType(model),
        isRequired: false,
        onSaveValue: (value) {
          setState(() {
            model.selectedType = value?.value;
            model.item!.type = value?.value;
          });
        },
        values:
            (store.state.businessState.types ??
                    [
                      BusinessType(
                        description: '',
                        enabled: true,
                        id: 'asd',
                        name: 'name',
                        subTypes: [],
                      ),
                    ])
                .map(
                  (t) => DropDownValue(
                    displayValue: t.name,
                    value: t,
                    index: typeIndex += 1,
                  ),
                )
                .toList(),
      ),
    ];

    var form = Form(
      key: model.form.key,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: formFields,
        ),
      ),
    );

    return form;
  }

  GestureDetector avatar(BuildContext context, BusinessProfileCreateVM model) =>
      GestureDetector(
        child: Container(
          alignment: Alignment.center,
          child: OutlineGradientAvatar(
            radius: 50,
            child: Icon(Icons.store, color: Colors.grey.shade700, size: 50),
          ),
        ),
      );

  BusinessType setDefaultBusinessType(BusinessProfileCreateVM model) {
    BusinessType? type = model.state?.types?.firstWhere(
      (element) => element.name == 'Retail',
      orElse: (() => BusinessType(
        description: '',
        enabled: true,
        id: 'asdrgef',
        name: 'Other',
        subTypes: [],
      )),
    );

    model.selectedType = type;
    model.item!.type = type;
    return type!;
  }
}
