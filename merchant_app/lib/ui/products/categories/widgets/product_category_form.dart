// Dart imports:
// remove ignore_for_file: use_build_context_synchronously

import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:image_picker/image_picker.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:littlefish_merchant/ui/products/categories/view_models/category_item_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/round_icon_button.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';

import '../../../../injector.dart';
import '../../../../tools/network_image/flutter_network_image.dart';

class ProductCategoryForm extends StatefulWidget {
  final Function(StockCategory) onSubmit;

  final GlobalKey<FormState>? formKey;

  final CategoryViewModel vm;

  final StockCategory category;

  const ProductCategoryForm({
    Key? key,
    required this.onSubmit,
    required this.vm,
    required this.formKey,
    required this.category,
  }) : super(key: key);

  @override
  State<ProductCategoryForm> createState() => _ProductCategoryFormState();
}

class _ProductCategoryFormState extends State<ProductCategoryForm> {
  late CategoryViewModel vm;

  _ProductCategoryFormState();

  late StockCategory category;

  @override
  void initState() {
    vm = widget.vm;
    category = widget.category;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        imageUpload(),
        const SizedBox(height: 8),
        Container(child: form(context)),
      ],
    );
  }

  Row imageUpload() => Row(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      RoundIconButton(
        icon: Icons.camera_alt,
        text: 'Take Picture',
        onTap: () => uploadImage(context, category, source: ImageSource.camera),
      ),
      Material(
        color: Theme.of(context).colorScheme.secondary,
        elevation: 1,
        borderRadius: BorderRadius.circular(4),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () =>
              uploadImage(context, category, source: ImageSource.camera),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              image: isNotBlank(category.imageUri)
                  ? DecorationImage(
                      image: getIt<FlutterNetworkImage>().asImageProviderById(
                        id: category.id!,
                        category: 'categories',
                        legacyUrl: category.imageUri!,
                        height: AppVariables.listImageHeight,
                        width: AppVariables.listImageWidth,
                      ),
                    )
                  : null,
            ),
            height: 80,
            width: 120,
            child: isNotBlank(category.imageUri)
                ? Container()
                : const Icon(Icons.camera_alt, size: 48),
          ),
        ),
      ),
      RoundIconButton(
        icon: Icons.image,
        text: 'Upload From Gallery',
        onTap: () =>
            uploadImage(context, category, source: ImageSource.gallery),
      ),
    ],
  );

  Form form(BuildContext context) {
    var formFields = <Widget>[
      StringFormField(
        enforceMaxLength: true,
        maxLength: 24,
        hintText: 'Name',
        key: const Key('name'),
        labelText: 'Category Name',
        focusNode: vm.form.setFocusNode('name'),
        nextFocusNode: vm.form.setFocusNode('description'),
        onFieldSubmitted: (value) {
          // vm.form.refresh();
          category.name = category.displayName = value;
        },
        inputAction: TextInputAction.next,
        initialValue: category.displayName ?? category.name,
        isRequired: true,
        onSaveValue: (value) {
          category.name = category.displayName = value;
        },
      ),
      StringFormField(
        enforceMaxLength: true,
        maxLength: 48,
        // suffixIcon: FontAwesomeIcons.productHunt,
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
      Visibility(
        visible: vm.isStoreOnline && vm.store!.state.enableOnlineStore!,
        child: YesNoFormField(
          labelText: 'Is Category Online',
          padding: const EdgeInsets.all(0),
          initialValue: category.isOnline ?? false,
          onSaved: (value) {
            category.isOnline = value;
            if (mounted) setState(() {});
            // _rebuild();
          },
          description: 'Add category to your online store',
        ),
      ),
    ];

    return Form(
      key: widget.formKey,
      child: ListView(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: formFields,
      ),
    );
  }

  Future<void> uploadImage(
    BuildContext context,
    StockCategory? item, {
    ImageSource source = ImageSource.camera,
  }) async {
    var selectedImage = await imagePicker.pickImage(source: source);

    if (selectedImage == null) return;

    if (!await FileManager().isFileTypeAllowed(selectedImage, context)) {
      return;
    }

    showProgress(context: context);

    try {
      var state = AppVariables.store!.state;
      var file = File(selectedImage.path);
      var downloadUrl = await FileManager().uploadFile(
        file: file,
        businessId: state.businessId!,
        category: 'categories',
        id: category.id ?? const Uuid().v4(),
        businessName: 'business-tag',
      );

      category.imageUri = downloadUrl.downloadUrl;

      hideProgress(context);
      //we should change the image to the new one
      if (mounted) setState(() {});
    } on PlatformException catch (e) {
      hideProgress(context);

      showMessageDialog(
        context,
        '${e.code}: ${e.message}',
        LittleFishIcons.warning,
      );
    } catch (e) {
      hideProgress(context);

      reportCheckedError(e, trace: StackTrace.current);

      showMessageDialog(
        context,
        'Something went wrong, please try again later',
        LittleFishIcons.error,
      );
    }
  }
}
