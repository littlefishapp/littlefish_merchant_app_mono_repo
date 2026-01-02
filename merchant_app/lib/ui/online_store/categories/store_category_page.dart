import 'dart:io';

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';
import 'package:littlefish_merchant/ui/online_store/online_store_products.dart';
import 'package:littlefish_merchant/ui/online_store/services/service_factory.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:quiver/strings.dart';

import '../../../common/presentaion/components/custom_app_bar.dart';
import '../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../common/presentaion/components/form_fields/string_form_field.dart';
import '../../../common/presentaion/components/app_progress_indicator.dart';
import '../../../injector.dart';
import '../../../tools/network_image/flutter_network_image.dart';

class StoreCategoryPage extends StatefulWidget {
  static const String route = 'store/categories/detail';

  final ManageStoreVM? vm;

  final StoreProductCategory? item;

  const StoreCategoryPage({Key? key, this.vm, this.item}) : super(key: key);

  @override
  State<StoreCategoryPage> createState() => _StoreCategoryPageState();
}

class _StoreCategoryPageState extends State<StoreCategoryPage> {
  ManageStoreVM? _vm;

  Future<List<StoreProduct>>? _future;

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
  late bool _productsIsLoading;

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
    _productsIsLoading = false;

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
          elevation: 1,
          centerTitle: true,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          title: Text(
            isBlank(item!.displayName) ? 'New Category' : item!.displayName!,
            style: TextStyle(
              color: Theme.of(context).colorScheme.secondary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        persistentFooterButtons: _vm!.isLoading! || _isLoading
            ? null
            : <Widget>[
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: ButtonPrimary(
                    buttonColor: Theme.of(context).colorScheme.secondary,
                    text: 'SAVE',
                    onTap: (ctx) async {
                      if (formKey.currentState?.validate() ?? false) {
                        formKey.currentState!.save();
                        _setLoading(true);
                        try {
                          await _vm!.upsertProdCategory(item, context);
                        } catch (error) {
                          reportCheckedError(error);
                          rethrow;
                        } finally {
                          _setLoading(false);
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
        _vm!.isLoading = value;
      });
    } else {
      _vm!.isLoading = value;
    }
  }

  Column _renderTabBarUI(context) {
    return Column(
      children: [
        if ((_vm!.isLoading ?? false) || _isLoading)
          const SizedBox(height: 2, child: LinearProgressIndicator()),
        Container(
          child: item!.isNew!
              ? null
              : TabBar(
                  isScrollable: false,
                  physics: const BouncingScrollPhysics(),
                  tabs: <Widget>[
                    Tab(text: 'Details'.toUpperCase()),
                    if (!item!.isNew!) Tab(text: 'Products'.toUpperCase()),
                  ],
                ),
        ),
        Expanded(
          child: item!.isNew!
              ? form(context)
              : TabBarView(
                  physics: const BouncingScrollPhysics(),
                  children: <Widget>[
                    form(context),
                    if (!item!.isNew!) categoryProducts(context, item!.id!),
                  ],
                ),
        ),
      ],
    );
  }

  FutureBuilder<List<StoreProduct>> categoryProducts(
    context,
    String categoryId,
  ) {
    _future ??= ServiceFactory().getStoreProductsByCategory(
      _vm!.store!.state.storeState.store!,
      item!.id!,
    );

    return FutureBuilder<List<StoreProduct>>(
      future: ServiceFactory().getStoreProductsByCategory(
        _vm!.store!.state.storeState.store!,
        item!.id!,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done ||
            _productsIsLoading) {
          return const AppProgressIndicator();
        }

        if ((snapshot.data?.length ?? 0) == 0) {
          return const Center(child: Text('No Data'));
        } else {
          return ListView.builder(
            itemCount: snapshot.data?.length ?? 0,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (ctx, index) {
              return StoreProductListTile(
                item: snapshot.data![index],
                dismissAllowed: false,
                onTap: (item) {},
                onRemove: (item) async {
                  // _productsIsLoading = true;
                  // if (mounted) setState(() {});

                  // TODO(lampian): fix nulls
                  // item.baseCategory = item.baseCategoryId = null;
                  // _vm!.store!.dispatch(upsertProductAction(item));

                  // await _vm!.upsertProduct!(
                  //   context,
                  //   item,
                  // );
                  // _productsIsLoading = false;
                },
              );
            },
          );
        }
      },
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
                  contentPadding: const EdgeInsets.symmetric(horizontal: 6),
                  trailing: isBlank(item!.featureImageUrl)
                      ? const Icon(Icons.image, size: 40)
                      : SizedBox(
                          height: 36,
                          child: getIt<FlutterNetworkImage>().asWidget(
                            id: item?.id ?? '',
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
                    // style: TextStyle(fontSize: 16),
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
