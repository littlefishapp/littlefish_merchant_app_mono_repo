import 'dart:io';

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';

import '../../../../../common/presentaion/components/cards/card_neutral.dart';
import '../../../../../common/presentaion/components/custom_app_bar.dart';
import '../../../../../features/ecommerce_shared/models/shared/form_view_model.dart';
import '../../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../../common/presentaion/components/form_fields/string_form_field.dart';
import '../../../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../../../injector.dart';
import '../../../../../tools/network_image/flutter_network_image.dart';

class SubCategoryScreen extends StatefulWidget {
  final ManageStoreVM vm;

  final StoreProductCategory? parentCategory;

  final StoreProductCategory? item;

  const SubCategoryScreen({
    Key? key,
    required this.vm,
    this.item,
    required this.parentCategory,
  }) : super(key: key);

  @override
  State<SubCategoryScreen> createState() => _SubCategoryScreenState();
}

class _SubCategoryScreenState extends State<SubCategoryScreen> {
  late ManageStoreVM _vm;

  final expandedMargin = const EdgeInsets.only(
    top: 4,
    bottom: 4,
    left: 16,
    right: 12,
  );

  final formKey = GlobalKey<FormState>();

  StoreProductCategory? item;

  bool _isLoading = false;

  void setLoading(bool value) {
    if (mounted) {
      setState(() {
        _isLoading = value;
      });
    } else {
      _isLoading = value;
    }
  }

  @override
  void initState() {
    _vm = widget.vm;
    if (item == null) {
      if (widget.item != null) {
        item = widget.item!..isNew = false;
      } else {
        item =
            StoreProductCategory(
                id: const Uuid().v4(),
                businessId: _vm.item?.businessId,
                dateCreated: DateTime.now(),
              )
              ..isNew = true
              ..storeSubtypeId = widget.parentCategory!.categoryId;
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: item!.isNew!
            ? const Text('New Sub-Category')
            : Text(item!.displayName!),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      persistentFooterButtons: _isLoading || _vm.isLoading!
          ? null
          : <Widget>[
              SizedBox(
                width: MediaQuery.of(context).size.width,
                child: ElevatedButton(
                  child: Text('Save'.toUpperCase()),
                  onPressed: () async {
                    if (formKey.currentState?.validate() ?? false) {
                      formKey.currentState!.save();
                      if (mounted) {
                        setState(() {
                          _vm.isLoading = true;
                        });
                      } else {
                        setState(() {
                          _vm.isLoading = true;
                        });
                      }

                      _vm.upsertSubProductCategory(
                        item,
                        widget.parentCategory,
                        context,
                      );
                    }
                  },
                ),
              ),
            ],
      body: SafeArea(
        child: _vm.isLoading! ? const AppProgressIndicator() : form(context),
      ),
    );
  }

  Form form(context) {
    final BasicFormModel formModel = BasicFormModel(formKey);

    var formFields = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (_vm.isLoading! || _isLoading) const LinearProgressIndicator(),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                ListTile(
                  tileColor: Theme.of(context).colorScheme.background,
                  title: Text(widget.parentCategory!.displayName!),
                  subtitle: const Text('Parent Category'),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: StringFormField(
                    hintText: 'Name',
                    key: const Key('name'),
                    labelText: 'Name',
                    focusNode: formModel.setFocusNode('name'),
                    initialValue: item!.displayName,
                    onFieldSubmitted: (value) {
                      item!.displayName = value;
                    },
                    inputAction: TextInputAction.next,
                    isRequired: true,
                    onSaveValue: (value) {
                      item!.displayName = value;
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: StringFormField(
                    hintText: 'Description',
                    key: const Key('description'),
                    labelText: 'Description',
                    focusNode: formModel.setFocusNode('description'),
                    initialValue: item!.description,
                    onFieldSubmitted: (value) {
                      item!.description = value;
                    },
                    inputAction: TextInputAction.next,
                    isRequired: false,
                    onSaveValue: (value) {
                      item!.description = value;
                    },
                  ),
                ),
                CardNeutral(
                  child: ListTile(
                    tileColor: Theme.of(context).colorScheme.background,
                    trailing: isBlank(item!.featureImageUrl)
                        ? const Icon(Icons.image, size: 48)
                        : SizedBox(
                            height: 36,
                            child: getIt<FlutterNetworkImage>().asWidget(
                              id: item!.id!,
                              category: 'categories',
                              legacyUrl: item!.featureImageUrl!,
                              height: AppVariables.listImageHeight,
                              width: AppVariables.listImageWidth,
                              httpHeaders: {
                                HttpHeaders.authorizationHeader:
                                    'Bearer ${AppVariables.store!.state.token!}',
                              },
                            ),
                          ),
                    title: const Text(
                      'Set Category Image',
                      style: TextStyle(fontSize: 16),
                    ),
                    onTap: () async {
                      setLoading(true);
                      await FileManager()
                          .chooseAndUploadImage(
                            context,
                            groupId: item!.businessId,
                            itemId: item!.categoryId,
                            sectionId: 'categories',
                          )
                          .then((result) {
                            if (result != null) {
                              item!.featureImageUrl = result.downloadUrl;
                            }
                          })
                          .whenComplete(() => setLoading(false));
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ];

    return Form(
      key: formModel.formKey,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: ListView(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: formFields,
        ),
      ),
    );
  }
}
