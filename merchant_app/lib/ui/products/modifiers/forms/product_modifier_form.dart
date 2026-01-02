// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_text.dart';

// Project imports:
import 'package:littlefish_merchant/models/products/product_modifier.dart';
import 'package:littlefish_merchant/ui/products/modifiers/view_models/modifier_item_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/number_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

import '../../../../common/presentaion/components/icons/delete_icon.dart';

class ProductModifierForm extends StatefulWidget {
  final ModifierViewModel vm;

  const ProductModifierForm({Key? key, required this.vm}) : super(key: key);

  @override
  State<ProductModifierForm> createState() => _ProductModifierFormState();
}

class _ProductModifierFormState extends State<ProductModifierForm> {
  late ModifierViewModel vm;

  _ProductModifierFormState();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    //would be important to pull across the currnet modifier where needed
    vm = widget.vm;
    return vm.isLoading!
        ? const AppProgressIndicator()
        : Column(children: <Widget>[Expanded(child: form(context, vm.item!))]);
  }

  Widget saveButton(context, ProductModifier item) =>
      item.modifiers == null || item.modifiers!.isEmpty
      ? ButtonSecondary(
          onTap: (context) => showMessageDialog(
            context,
            'Please add modifiers',
            LittleFishIcons.info,
          ),
          text: 'SAVE',
        )
      : ButtonPrimary(
          buttonColor: Theme.of(context).colorScheme.primary,
          text: 'save',
          onTap: (context) {
            if (item.multiSelect! && item.maxSelection! <= 0) {
              showMessageDialog(
                context,
                'Please enter the max amount of options',
                LittleFishIcons.info,
              );
            } else {
              if (vm.form.key!.currentState!.validate()) {
                vm.form.key!.currentState!.save();
                vm.onAdd(item, context);
                Navigator.of(context).pop();
              }
            }
          },
        );

  Form form(context, ProductModifier item) => Form(
    key: vm.form.key,
    child: ListView(
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        StringFormField(
          enforceMaxLength: true,
          maxLength: 255,
          hintText: 'Name',
          key: const Key('name'),
          labelText: 'Name',
          focusNode: vm.form.setFocusNode('name'),
          nextFocusNode: vm.form.setFocusNode('description'),
          onFieldSubmitted: (value) {
            item.name = item.displayName = value;
          },
          inputAction: TextInputAction.next,
          initialValue: item.displayName,
          isRequired: true,
          onSaveValue: (value) {
            item.name = item.displayName = value;
          },
        ),
        StringFormField(
          enforceMaxLength: true,
          maxLength: 255,
          hintText: 'Description',
          key: const Key('description'),
          labelText: 'Description',
          focusNode: vm.form.setFocusNode('description'),
          onFieldSubmitted: (value) {
            vm.item!.description = value;
          },
          inputAction: TextInputAction.next,
          initialValue: item.description,
          isRequired: false,
          onSaveValue: (value) {
            item.description = value;
          },
        ),
        YesNoFormField(
          labelText: 'Multiple Selection',
          initialValue: item.multiSelect ?? false,
          onSaved: (value) {
            setState(() {
              item.multiSelect = value;
            });
          },
          key: const Key('multiselect'),
        ),
        Visibility(
          visible: item.multiSelect!,
          maintainState: true,
          child: NumberFormField(
            hintText: 'Max Options',
            initialValue: item.maxSelection,
            key: const Key('maxOptions'),
            labelText: 'Max Options',
            focusNode: vm.form.setFocusNode('maxOptions'),
            onFieldSubmitted: (value) {
              item.maxSelection = value;
            },
            inputAction: TextInputAction.done,
            isRequired: true,
            onSaveValue: (value) {
              item.maxSelection = value;
            },
          ),
        ),
        const CommonDivider(),
        SizedBox(
          child: ButtonText(
            icon: Icons.add,
            text: 'New Modifier',
            onTap: (_) {
              setState(() {
                item.addItem();
              });
            },
          ),
        ),
        const CommonDivider(),
        modifiers(context, item),
      ],
    ),
  );

  ListView modifiers(context, ProductModifier item) => ListView(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    children:
        item.modifiers
                ?.map(
                  (m) => Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        child: IconButton(
                          icon: const DeleteIcon(),
                          onPressed: () {
                            removeModifier(context, item, m.id);
                            if (mounted) setState(() {});
                          },
                        ),
                      ),
                      Expanded(
                        child: StringFormField(
                          hintText: 'i.e. Greek Salad',
                          key: Key('${m.id}-name'),
                          labelText: 'Option Name',
                          inputAction: TextInputAction.done,
                          isRequired: true,
                          onSaveValue: (value) {
                            m.name = value;
                          },
                          onFieldSubmitted: (value) {
                            vm.form.setFocusNode('${m.id}-price');
                          },
                          focusNode: vm.form.setFocusNode('${m.id}-name'),
                          initialValue: m.name,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: CurrencyFormField(
                          hintText: 'How much?',
                          key: Key('${m.id}-price'),
                          labelText: 'Price',
                          isRequired: false,
                          inputAction: TextInputAction.done,
                          onSaveValue: (value) {
                            m.price = value;
                          },
                          onFieldSubmitted: (value) {
                            vm.form.setFocusNode('');
                          },
                          focusNode: vm.form.setFocusNode('${m.id}-price'),
                          initialValue: m.price ?? 0.0,
                        ),
                      ),
                    ],
                  ),
                )
                .toList()
            as List<Widget>,
  );

  Modifier addModifider(context, ProductModifier item) => item.addItem();

  dynamic removeModifier(context, ProductModifier item, String? id) =>
      item.removeItem(id);
}
