import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';
import 'package:littlefish_merchant/ui/online_store/products/viewmodels/product_vm.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';

import '../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../common/presentaion/components/form_fields/string_form_field.dart';

class ProductOptionsPage extends StatefulWidget {
  final StoreProduct? item;

  final ProductVM? vm;

  final GlobalKey<FormState>? formKey;

  const ProductOptionsPage({Key? key, this.item, this.vm, this.formKey})
    : super(key: key);

  @override
  State<ProductOptionsPage> createState() => _ProductOptionsPageState();
}

class _ProductOptionsPageState extends State<ProductOptionsPage> {
  late GlobalKey<FormState> _formKey;
  // late GlobalKey<ScaffoldState> _scaffoldKey;
  // final formKey = GlobalKey<FormState>();
  // final TextEditingController _controller = new TextEditingController();

  // AsyncMemoizer<QuerySnapshot> _memoizer;
  // bool? _isLoading;
  // ProductVariant widget.item.productVariant;

  List<List<Widget>>? createdVariants;
  // dynamic totalCombinations;
  // List separatedCombinations;
  TextEditingController? messageEditingController;

  int? selectedTabIndex;

  @override
  void initState() {
    if (widget.item!.productVariant == null) {
      widget.item!.productVariant = ProductVariant(
        products: [],
        isNew: true,
        variantTitles: [],
        totalCombinations: [],
      );
    }
    // _isLoading = false;
    _formKey = GlobalKey<FormState>();
    // _scaffoldKey = GlobalKey<ScaffoldState>();
    selectedTabIndex = 0;
    messageEditingController = TextEditingController();

    super.initState();
  }

  baseSetup(ProductVM vm) {
    widget.vm!.selectedVariants = vm.productVariants
        .where(
          (element) =>
              widget.item!.productVariant?.variantTitles
                  ?.map((e) => e.name)
                  .contains(element.name) ??
              false,
        )
        .toList();

    // messageEditingController.text = widget.item.productVariant.name;
    if (widget.item!.productVariant!.variantTitles!.isNotEmpty) {
      submitVariantOptions(vm, refreshState: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.item!.productVariant!.variantTitles == null &&
        widget.item!.productVariant != null) {
      baseSetup(widget.vm!);
    }
    // else if (widget.item.productVariant.variantTitles == null) {
    //   widget.item.productVariant.variantTitles.forEach((element) {
    //     if (isNotBlank(element.values.last)) element.values.add('');
    //   });
    // }

    // if(widget.item.productVariant?.variantTitles.every((element) => element.values.last))

    // return KeyboardActions(
    //   disableScroll: true,
    //   config: keyboardConfig(context, []),
    //   child: _detailsTab(context, widget.vm!),
    // );
    return _detailsTab(context, widget.vm!);
  }

  ListView _detailsTab(context, ProductVM vm) {
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
              var isSelected = widget.vm!.selectedVariants
                  .map((f) => f.name)
                  .contains(e.name);

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
                  selected: widget.vm!.selectedVariants
                      .map((f) => f.name)
                      .contains(e.name),
                  onSelected: (selected) {
                    if (selected) {
                      widget.vm!.selectedVariants.add(e);
                    } else {
                      widget.vm!.selectedVariants.removeWhere(
                        (element) => e.id == element.id,
                      );
                    }
                    // myState(() {});
                    widget.item!.productVariant!.variantTitles = widget
                        .vm!
                        .selectedVariants
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
            child: ListView(
              shrinkWrap: true,
              children: [
                ...widget.item!.productVariant!.variantTitles
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
                                                vm,
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
                                      // TODO(lampian): fix  style
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
                                          submitVariantOptions(vm);
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
                                        _formKey.currentState?.save();
                                        if (!e.values!.contains('')) {
                                          submitVariantOptions(vm);
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

  submitVariantOptions(ProductVM vm, {bool refreshState = true}) {
    List fullPermutation = [];
    var variantNames = widget.vm!.selectedVariants.map((e) => e.name).toList();

    for (var index = 0; index < variantNames.length; index++) {
      var element = variantNames[index];
      var vt = [...widget.item!.productVariant!.variantTitles!];

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

    vm.totalCombinations = allPossibleCases(fullPermutation);

    vm.totalCombinations.forEach(
      (element) => {
        // this.form.addControl(element, this.createProductEntry(element.split('#')))
      },
    );

    vm.separatedCombinations = vm.totalCombinations
        .map((val) => val.split('#'))
        ?.toList();

    for (var element in widget.item!.productVariant!.variantTitles!) {
      if (element.values!.contains('') == false) element.values!.add('');
    }

    if (refreshState) if (mounted) setState(() {});
  }

  Widget createVariantEntry(name, ProductVM vm, {initialValue}) {
    return StringFormField(
      key: Key(const Uuid().v1()),
      initialValue: initialValue,
      onSaveValue: (value) {
        saveVariant(name, value, vm: vm);
      },
      onFieldSubmitted: (value) {
        saveVariant(name, value, vm: vm);
      },
      hintText: name,
      labelText: name,
      focusNode: FocusNode(),
    );
  }

  saveVariant(name, value, {required ProductVM vm}) {
    var item = widget.item!.productVariant!.variantTitles!.firstWhere(
      (element) => element.name == name,
    );
    item.values!.removeWhere((element) => isBlank(element));

    var index = item.values!.indexWhere((element) => element == value);

    if (index == -1) {
      item.values!.add(value);
    } else {
      item.values![index] = value;
    }

    submitVariantOptions(vm);
    // item.values.add('');

    // if (!item.values.contains('')) {
    // }
  }
}
