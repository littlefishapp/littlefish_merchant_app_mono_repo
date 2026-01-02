// Dart imports:

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/ui/products/categories/view_models/category_item_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';

import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import '../../../../common/presentaion/components/app_progress_indicator.dart';

class ProductCategoryFormNew extends StatefulWidget {
  final Function(StockCategory) onSubmit;

  final bool isEmbedded;

  final CategoryViewModel vm;

  final StockCategory category;

  const ProductCategoryFormNew({
    Key? key,
    required this.onSubmit,
    required this.vm,
    required this.category,
    required this.isEmbedded,
  }) : super(key: key);

  @override
  State<ProductCategoryFormNew> createState() => _ProductCategoryFormNewState();
}

class _ProductCategoryFormNewState extends State<ProductCategoryFormNew> {
  _ProductCategoryFormNewState();
  StockCategory? category;

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    category = widget.category;

    return KeyboardDismissalUtility(
      content: AppSimpleAppScaffold(
        isEmbedded: false,
        footerActions: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            child: SizedBox(
              height: MediaQuery.of(context).size.width * (13 / 100),
              child: ButtonPrimary(
                text: 'Save',
                upperCase: false,
                textColor: Colors.white,
                onTap: (c) {
                  if (formKey.currentState!.validate()) {
                    formKey.currentState!.save();
                    widget.onSubmit(category!);
                    Navigator.of(context).pop();
                  }
                },
              ),
            ),
          ),
        ],
        actions: <Widget>[saveAction()],
        title: 'Edit Category',
        body: widget.vm.isLoading!
            ? const AppProgressIndicator()
            : categoryForm(context, widget.vm),
      ),
    );
  }

  Column categoryForm(BuildContext context, CategoryViewModel vm) => Column(
    children: <Widget>[
      Expanded(
        child: Form(
          key: formKey,
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: editContext(context, vm, category!),
          ),
        ),
      ),
      // SizedBox(height: MediaQuery.of(context).size.height*(1/100),),

      // ),
    ],
  );

  List<Widget> editContext(
    BuildContext context,
    CategoryViewModel vm,
    StockCategory category,
  ) => <Widget>[
    SizedBox(height: MediaQuery.of(context).size.height * (3 / 100)),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StringFormField(
        enforceMaxLength: false,
        maxLength: 24,
        hintText: 'Name',
        minLines: 1,
        useOutlineStyling: true,
        maxLines: 1,
        key: const Key('name'),
        labelText: 'Category Name',
        focusNode: vm.form.setFocusNode('name'),
        nextFocusNode: vm.form.setFocusNode('description'),
        onFieldSubmitted: (value) {
          category.name = category.displayName = value;
        },
        inputAction: TextInputAction.next,
        initialValue: category.displayName ?? category.name,
        isRequired: true,
        onSaveValue: (value) {
          category.name = category.displayName = value;
        },
      ),
    ),
    SizedBox(height: MediaQuery.of(context).size.height * (1 / 100)),
    Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: StringFormField(
        enforceMaxLength: false,
        maxLength: 500,
        maxLines: 120,
        minLines: 4,
        useOutlineStyling: true,
        hintText: 'Describe your product',
        key: const Key('description'),
        labelText: 'Description',
        focusNode: vm.form.setFocusNode('description'),
        nextFocusNode: vm.form.setFocusNode('new'),
        onFieldSubmitted: (value) {
          category.description = value;
        },
        inputAction: TextInputAction.done,
        initialValue: category.description,
        isRequired: false,
        onSaveValue: (value) {
          category.description = value;
        },
      ),
    ),
    SizedBox(height: MediaQuery.of(context).size.height * (3 / 100)),
  ];

  IconButton saveAction() => IconButton(
    onPressed: () {
      if (formKey.currentState!.validate()) {
        formKey.currentState!.save();
        widget.onSubmit(category!);
        Navigator.of(context).pop();
      }
    },
    icon: const Icon(Icons.save_rounded),
  );
}
