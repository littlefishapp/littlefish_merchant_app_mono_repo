import 'dart:io';

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:littlefish_merchant/ui/online_store/products/pages/product_categories/sub_product_category_list.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:quiver/strings.dart';

import '../../../../../common/presentaion/components/custom_app_bar.dart';
import '../../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../../common/presentaion/components/form_fields/string_form_field.dart';
import '../../../../../injector.dart';
import '../../../../../tools/network_image/flutter_network_image.dart';

class StoreProductCategoryScreen extends StatefulWidget {
  final ManageStoreVM vm;

  final StoreProductCategory? item;

  const StoreProductCategoryScreen({Key? key, required this.vm, this.item})
    : super(key: key);

  @override
  State<StoreProductCategoryScreen> createState() =>
      _StoreProductCategoryScreenState();
}

class _StoreProductCategoryScreenState
    extends State<StoreProductCategoryScreen> {
  late ManageStoreVM _vm;

  final expandedMargin = const EdgeInsets.only(
    top: 4,
    bottom: 4,
    left: 16,
    right: 12,
  );

  final _nodes = [FocusNode(), FocusNode(), FocusNode(), FocusNode()];

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
        item = widget.item;
        item!.isNew = false;
      } else {
        item = StoreProductCategory.create(
          AppVariables.store!.state.storeState.store!.businessId!,
        );
      }
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: item!.isNew! ? 1 : 2,
      child: Scaffold(
        appBar: CustomAppBar(
          title: isBlank(item!.displayName)
              ? const Text('New Category')
              : Text(item!.displayName!),
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => Navigator.of(context).pop(),
          ),
          // actions: [
          //   if (item.isNew == false)
          //     IconButton(
          //       icon: Icon(Icons.delete),
          //       onPressed: () async {
          //         var result = await showAcceptDialog(
          //           context: context,
          //           content: Text(S.of(context).areYouSureDeleteText),
          //         );

          //         if (result == true) {
          //           try {
          //             _vm.deleteProdCategory(item, context);
          //           } catch (e) {
          //             showMessageDialog(context, e, LittleFishIcons.error);
          //           }
          //         }
          //       },
          //     )
          // ],
          bottom: item!.isNew!
              ? null
              : TabBar(
                  isScrollable: false,
                  tabs: <Widget>[
                    Tab(text: 'Details'.toUpperCase()),
                    if (!item!.isNew!) Tab(text: 'Categories'.toUpperCase()),
                  ],
                ),
        ),
        persistentFooterButtons: _vm.isLoading! || _isLoading
            ? null
            : <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ElevatedButton(
                    child: Text('Save'.toUpperCase()),
                    onPressed: () async {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState!.save();
                        _setLoading(true);
                        try {
                          await _vm.upsertProdCategory(item, context);
                        } catch (error) {
                          reportCheckedError(error);
                          rethrow;
                        } finally {
                          _setLoading(true);
                        }
                      }
                    },
                  ),
                ),
              ],
        body: SafeArea(child: _renderTabBarUI(context)),
      ),
    );
  }

  _setLoading(bool value) {
    if (mounted) {
      setState(() {
        _vm.isLoading = value;
      });
    } else {
      _vm.isLoading = value;
    }
  }

  Column _renderTabBarUI(context) {
    return Column(
      children: [
        if (_vm.isLoading! || _isLoading) const LinearProgressIndicator(),
        Expanded(
          child: item!.isNew!
              ? form(context)
              : TabBarView(
                  children: <Widget>[
                    form(context),
                    if (!item!.isNew!) SubCategoryList(parentCategory: item),
                  ],
                ),
        ),
      ],
    );
  }

  Form form(context) {
    var formFields = <Widget>[
      Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: StringFormField(
                    hintText: 'Name',
                    key: const Key('name'),
                    maxLength: 50,
                    enforceMaxLength: true,
                    labelText: 'Name',
                    focusNode: _nodes[0],
                    nextFocusNode: _nodes[1],
                    initialValue: item!.displayName,
                    onFieldSubmitted: (value) {
                      item!.displayName = item!.name = item!.searchName = value;
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
                    maxLength: 255,
                    enforceMaxLength: true,
                    focusNode: _nodes[1],
                    nextFocusNode: _nodes[2],
                    initialValue: item!.description,
                    onFieldSubmitted: (value) {
                      item!.description = value;
                    },
                    inputAction: TextInputAction.done,
                    isRequired: false,
                    onSaveValue: (value) {
                      item!.description = value;
                    },
                  ),
                ),
                const SizedBox(height: 16),
                ListTile(
                  tileColor: Theme.of(context).colorScheme.background,
                  trailing: isBlank(item!.featureImageUrl)
                      ? const Icon(Icons.image, size: 48)
                      : SizedBox(
                          height: 36,
                          child: getIt<FlutterNetworkImage>().asWidget(
                            id: item!.categoryId!,
                            legacyUrl: item!.featureImageUrl!,
                            category: 'categories',
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
              ],
            ),
          ),
          const SizedBox(height: 8),
        ],
      ),
    ];

    return Form(
      key: formKey,
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
