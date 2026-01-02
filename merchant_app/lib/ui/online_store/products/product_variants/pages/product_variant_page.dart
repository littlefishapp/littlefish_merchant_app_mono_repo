// remove ignore_for_file: use_build_context_synchronously

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/image_constants.dart';
import 'package:littlefish_merchant/ui/online_store/shared/firebase_image.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';
import '../../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../../common/presentaion/components/custom_app_bar.dart';
import '../../../../../common/presentaion/components/icons/delete_icon.dart';
import '../../../../../features/ecommerce_shared/models/online/system_variant.dart';
import '../../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../../../common/presentaion/components/form_fields/string_form_field.dart';

class ProductVariantPage extends StatefulWidget {
  static const String route = 'store/productvariant/detail';

  final ProductVariant? productVariant;

  const ProductVariantPage({Key? key, this.productVariant}) : super(key: key);

  @override
  State<ProductVariantPage> createState() => _ProductVariantPageState();
}

class _ProductVariantPageState extends State<ProductVariantPage> {
  GlobalKey<FormState>? _formKey;
  // AsyncMemoizer<QuerySnapshot> _memoizer;
  late bool _isLoading;
  ProductVariant? _productVariant;
  List<SystemVariant>? _selectedVariants;
  List<List<Widget>>? createdVariants;
  List<VariantTitle>? variantTitles;
  dynamic totalCombinations;
  List? separatedCombinations;
  TextEditingController? messageEditingController;

  int? selectedTabIndex;

  @override
  void initState() {
    _productVariant =
        widget.productVariant ?? ProductVariant(products: [], isNew: true);
    _isLoading = false;
    _formKey = GlobalKey();
    // _memoizer = AsyncMemoizer();
    selectedTabIndex = 0;
    _selectedVariants = [];
    messageEditingController = TextEditingController();

    super.initState();
  }

  baseSetup(ManageStoreVM vm) {
    variantTitles = _productVariant!.variantTitles;
    _selectedVariants = vm.productVariants
        .where(
          (element) => _productVariant!.variantTitles!
              .map((e) => e.name)
              .contains(element.name),
        )
        .toList();

    // messageEditingController.text = _productVariant.name;
    submitVariantOptions(refreshState: false);
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (context, ManageStoreVM vm) {
        if (variantTitles == null && widget.productVariant != null) {
          baseSetup(vm);
        }
        return Scaffold(
          appBar: CustomAppBar(
            title: TextField(
              controller: messageEditingController,
              textInputAction: TextInputAction.done,
              onSubmitted: (value) {
                // sendMessage();
              },
              decoration: InputDecoration(
                hintText: 'New Variant',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.all(8),
                border: OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.circular(kBorderRadius!),
                ),
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: _isLoading
                    ? null
                    : () async {
                        if (isBlank(messageEditingController!.text)) {
                          showMessageDialog(
                            context,
                            'Please Give your Variant a Name',
                            LittleFishIcons.error,
                          );
                          return;
                        }

                        if (_productVariant!.variantCombinations!
                            .map((e) => e.productId)
                            .isEmpty) {
                          showSuccess(
                            context,
                            'Variant Must Have At Least One Product',
                            LittleFishIcons.error,
                          );
                          return;
                        }
                        try {
                          _isLoading = true;
                          if (mounted) setState(() {});
                          // _productVariant.name =
                          //     messageEditingController.text;

                          _productVariant!.variantTitles = variantTitles;
                          await vm.upsertProductVariant(
                            _productVariant!,
                            context,
                          );
                        } catch (e) {
                          showMessageDialog(
                            context,
                            'Error',
                            LittleFishIcons.error,
                          );
                        }
                        _isLoading = false;
                        if (mounted) setState(() {});
                      },
              ),
            ],
          ),
          body: SafeArea(child: body(vm)),
        );
      },
    );
  }

  Column body(ManageStoreVM vm) => Column(
    children: <Widget>[
      if (_isLoading) const LinearProgressIndicator(),
      Expanded(
        child: DefaultTabController(
          length: 2,
          initialIndex: 0,
          child: Column(
            children: <Widget>[
              const TabBar(
                tabs: <Widget>[
                  Tab(text: 'Details'),
                  Tab(text: 'Products'),
                ],
              ),
              Expanded(
                child: TabBarView(
                  children: <Widget>[
                    _detailsTab(context, vm),
                    _productsTab(vm),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ],
  );

  ListView _productsTab(ManageStoreVM vm) {
    return ListView(
      shrinkWrap: true,
      children:
          (totalCombinations as List?)?.map((e) {
            var currentProduct = _productVariant?.variantCombinations
                ?.firstWhereOrNull((element) => element.variant == e);

            return ListTile(
              tileColor: Theme.of(context).colorScheme.background,
              isThreeLine: true,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(kBorderRadius!),
                child: SizedBox(
                  width: 64,
                  height: 64,
                  child: isNotBlank(currentProduct?.imageUrl)
                      ? FirebaseImage(imageAddress: currentProduct!.imageUrl)
                      : Image.asset(
                          ImageConstants.productDefault,
                          fit: BoxFit.cover,
                        ),
                ),
              ),
              title: Text(e),
              trailing: IconButton(
                icon: const DeleteIcon(),
                onPressed: () {
                  _productVariant!.variantCombinations!.removeWhere(
                    (element) => element.productId == currentProduct?.productId,
                  );

                  if (mounted) setState(() {});
                },
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(currentProduct?.sku ?? 'None Selected'),
                  Text(
                    currentProduct?.price?.toString() ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              onTap: () async {
                //TODO: When tshief has merged his code, this should pull from that same list
                // StoreProduct? product = await Navigator.of(context).push(
                //   MaterialPageRoute(
                //     builder: (ctx) => productPage(),
                //   ),
                // );

                // if (product != null) {
                //   // var itemAlreadySelected = _productVariant
                //   //     .variantCombinations
                //   //     .map((f) => f.productId)
                //   //     .contains(product.id);
                //   // if (!itemAlreadySelected) {
                //   // if (isNotBlank(product.variantId)) {
                //   // var replaceVariant = await showAcceptDialog(
                //   // context: context,
                //   // toUppercase: false,
                //   // title: S.of(context).proceedButtonText,
                //   // content: Text(S.of(context).productInAVariantTitle),
                //   // );
                //   // if (replaceVariant == true) {
                //   addVariant(product, e);
                //   // }
                // } else {
                //   // addVariant(product, e);
                // }

                // _productVariant.variantCombinations.removeWhere(
                //   (el) => el?.productId == currentProduct?.productId,
                // );
                // } else {
                // showMessageDialog(
                // context,
                // S.of(context).productInAVariantTitle,
                // LittleFishIcons.error,
                // );
                // }
                // }
              },
            );
          }).toList() ??
          [],
    );
  }

  addVariant(product, e) {
    var variant = ProductVariantLink(
      price: product.sellingPrice,
      productId: product.id ?? product.productId,
      variant: e,
      sku: product.displayName,
      imageUrl: product.featureImageUrl,
    );

    if (_productVariant!.variantCombinations == null) {
      _productVariant!.variantCombinations = [variant];
    } else {
      _productVariant!.variantCombinations!.add(variant);
    }

    if (mounted) setState(() {});
  }

  // productPage() => Scaffold(
  //       appBar: CustomAppBar(title: Text("Product")),
  //       body: SafeArea(
  //         child: ProductsList(
  //           listViewMode: ListViewMode.select,
  //         ),
  //       ),
  //     );

  ListView _detailsTab(context, ManageStoreVM vm) {
    return ListView(
      shrinkWrap: true,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 12),
          height: 40,
          child: ListView(
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            children: vm.productVariants.map((e) {
              var isSelected =
                  _selectedVariants?.map((f) => f.name).contains(e.name) ??
                  false;

              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                child: InputChip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(kBorderRadius!),
                  ),
                  label: Text(
                    e.name!,
                    style: TextStyle(color: isSelected ? Colors.white : null),
                  ),
                  showCheckmark: false,
                  selectedColor: Theme.of(context).colorScheme.secondary,
                  selected:
                      _selectedVariants?.map((f) => f.name).contains(e.name) ??
                      false,
                  onSelected: (selected) {
                    if (selected) {
                      _selectedVariants!.add(e);
                    } else {
                      _selectedVariants!.removeWhere(
                        (element) => e.id == element.id,
                      );
                    }
                    // myState(() {});
                    variantTitles = _selectedVariants!
                        .map((e) => VariantTitle(name: e.name, values: ['']))
                        .toList();
                    if (mounted) setState(() {});
                  },
                ),
              );
            }).toList(),
          ),
        ),
        Material(
          borderRadius: BorderRadius.circular(kBorderRadius!),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                ...variantTitles
                        ?.map(
                          (e) => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(
                                  left: 16,
                                  bottom: 4,
                                  top: 8,
                                ),
                                child: Text(
                                  e.name!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 0,
                                ),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    kBorderRadius!,
                                  ),
                                  color: Theme.of(
                                    context,
                                  ).scaffoldBackgroundColor,
                                ),
                                child: Column(
                                  children:
                                      e.values
                                          ?.map(
                                            (f) => Container(
                                              child: createVariantEntry(
                                                e.name,
                                                initialValue: f,
                                              ),
                                            ),
                                          )
                                          .toList() ??
                                      [],
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 20,
                                  vertical: 4,
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      // TODO(lampian): fix
                                      // style: ElevatedButton.styleFrom(
                                      //   primary: Colors.red,
                                      // ),
                                      child: const Text(
                                        'Delete',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        if (e.values!.length == 1) {
                                        } else {
                                          e.values!.removeAt(
                                            e.values!.length - 2,
                                          );
                                          // if (!e.values.contains('')) {
                                          submitVariantOptions();
                                          // }
                                        }
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      child: const Text(
                                        'Add',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        _formKey?.currentState?.save();
                                        if (!e.values!.contains('')) {
                                          submitVariantOptions();
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList() ??
                    [],
                SizedBox(height: 8, width: MediaQuery.of(context).size.width),
              ],
            ),
          ),
        ),
      ],
    );
  }

  dynamic allPossibleCases(List arr) {
    if (arr.length == 1) {
      return arr[0];
    } else {
      var result = [];
      var allCasesOfRest = allPossibleCases(arr.sublist(1));
      for (var i = 0; i < allCasesOfRest.length; i++) {
        for (var j = 0; j < arr[0].length; j++) {
          result.add(arr[0][j] + '#' + allCasesOfRest[i]);
        }
      }
      return result;
    }
  }

  submitVariantOptions({bool refreshState = true}) {
    List fullPermutation = [];
    var variantNames = _selectedVariants!.map((e) => e.name).toList();

    for (var index = 0; index < variantNames.length; index++) {
      var element = variantNames[index];
      var vt = [...variantTitles!];

      vt
          .firstWhere((ele) => ele.name == element)
          .values!
          .removeWhere((ll) => isBlank(ll));

      var keyLoop = vt.firstWhere((ele) => ele.name == element).values!;

      var combinations = [];

      for (var j = 0; j < keyLoop.length; j++) {
        combinations.add(keyLoop[j]);
      }
      fullPermutation.add(combinations);
    }

    totalCombinations = allPossibleCases(fullPermutation);

    totalCombinations.forEach(
      (element) => {
        // this.form.addControl(element, this.createProductEntry(element.split('#')))
      },
    );

    separatedCombinations = totalCombinations
        .map((val) => val.split('#'))
        ?.toList();

    for (var element in variantTitles!) {
      if (element.values!.contains('') == false) element.values!.add('');
    }

    if (refreshState) if (mounted) setState(() {});
  }

  Widget createVariantEntry(name, {initialValue}) {
    return StringFormField(
      key: Key(const Uuid().v4()),
      initialValue: initialValue,
      onSaveValue: (value) {
        saveVariant(name, value);
      },
      onFieldSubmitted: (value) {
        saveVariant(name, value);
      },
      hintText: name,
      labelText: name,
    );
  }

  saveVariant(name, value) {
    var item = variantTitles!.firstWhere((element) => element.name == name);
    item.values!.removeWhere((element) => isBlank(element));

    var index = item.values!.indexWhere((element) => element == value);

    if (index == -1) {
      item.values!.add(value);
    } else {
      item.values![index] = value;
    }

    submitVariantOptions();
    // item.values.add('');

    // if (!item.values.contains('')) {
    // }
  }

  Future choices(BuildContext context, {required ManageStoreVM vm}) async {
    var selection = [..._selectedVariants!];
    return await showPopupDialog(
      context: context,
      content: StatefulBuilder(
        builder: (ctx, myState) => Column(
          children: [
            Wrap(
              children: vm.productVariants.map((e) {
                var isSelected = selection.map((f) => f.name).contains(e.name);

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  child: InputChip(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(kBorderRadius!),
                    ),
                    label: Text(
                      e.name!,
                      style: TextStyle(color: isSelected ? Colors.white : null),
                    ),
                    showCheckmark: false,
                    selectedColor: Theme.of(context).colorScheme.secondary,
                    selected: selection.map((f) => f.name).contains(e.name),
                    onSelected: (selected) {
                      if (selected) {
                        selection.add(e);
                      } else {
                        selection.removeWhere((element) => e.id == element.id);
                      }
                      myState(() {});
                      if (mounted) setState(() {});
                    },
                  ),
                );
              }).toList(),
            ),
            const Spacer(),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ButtonPrimary(
                buttonColor: Theme.of(context).colorScheme.secondary,
                text: 'OK',
                onTap: (ctx) {
                  Navigator.of(context).pop(selection);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
