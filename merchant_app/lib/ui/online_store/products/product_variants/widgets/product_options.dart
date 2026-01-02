import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:quiver/strings.dart';
import 'package:uuid/uuid.dart';
import '../../../../../features/ecommerce_shared/models/online/system_variant.dart';
import '../../../../../features/ecommerce_shared/models/store/store_product.dart';
import '../../../../../common/presentaion/components/form_fields/string_form_field.dart';

class ProductOptions extends StatefulWidget {
  final ManageStoreVM? vm;
  final List<SystemVariant>? selectedVariants;
  final List<VariantTitle>? variantTitles;

  const ProductOptions({
    Key? key,
    this.selectedVariants,
    this.variantTitles,
    this.vm,
  }) : super(key: key);

  @override
  State<ProductOptions> createState() => _ProductOptionsState();
}

class _ProductOptionsState extends State<ProductOptions> {
  GlobalKey<FormState>? _formKey;
  List<SystemVariant>? selectedVariants;
  List<VariantTitle>? variantTitles;

  @override
  void initState() {
    widget.vm!.selectedVariants = widget.selectedVariants;
    variantTitles = widget.variantTitles;
    _formKey = GlobalKey();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return body();
  }

  ListView body() => ListView(
    shrinkWrap: true,
    children: [
      Container(
        margin: const EdgeInsets.symmetric(horizontal: 12),
        height: 40,
        child: ListView(
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          children: widget.vm!.productVariants.map((e) {
            var isSelected =
                widget.vm!.selectedVariants
                    ?.map((f) => f.name)
                    .contains(e.name) ??
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
                    widget.vm!.selectedVariants
                        ?.map((f) => f.name)
                        .contains(e.name) ??
                    false,
                onSelected: (selected) {
                  if (selected) {
                    widget.vm!.selectedVariants!.add(e);
                  } else {
                    widget.vm!.selectedVariants!.removeWhere(
                      (element) => e.id == element.id,
                    );
                  }
                  // myState(() {});
                  widget.vm!.variantTitles = widget.vm!.selectedVariants!
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
              ...widget.vm!.variantTitles.map(
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
                        style: const TextStyle(fontWeight: FontWeight.bold),
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
                        borderRadius: BorderRadius.circular(kBorderRadius!),
                        color: Theme.of(context).scaffoldBackgroundColor,
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
                                e.values!.removeAt(e.values!.length - 2);
                                // if (!e.values.contains('')) {
                                submitVariantOptions(
                                  selectedVariants:
                                      widget.vm!.selectedVariants!,
                                );
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
                                submitVariantOptions(
                                  selectedVariants:
                                      widget.vm!.selectedVariants!,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8, width: MediaQuery.of(context).size.width),
            ],
          ),
        ),
      ),
    ],
  );

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

  submitVariantOptions({
    required List<SystemVariant> selectedVariants,
    bool refreshState = true,
  }) {
    List fullPermutation = [];
    var variantNames = selectedVariants.map((e) => e.name).toList();

    for (var index = 0; index < variantNames.length; index++) {
      var element = variantNames[index];
      var vt = [...widget.vm!.variantTitles];

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

    widget.vm!.totalCombinations = allPossibleCases(fullPermutation);

    widget.vm!.totalCombinations.forEach(
      (element) => {
        // this.form.addControl(element, this.createProductEntry(element.split('#')))
      },
    );

    widget.vm!.separatedCombinations = widget.vm!.totalCombinations
        .map((val) => val.split('#'))
        ?.toList();

    for (var element in widget.vm!.variantTitles) {
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
    var item = widget.vm!.variantTitles.firstWhere(
      (element) => element.name == name,
    );
    item.values!.removeWhere((element) => isBlank(element));

    var index = item.values!.indexWhere((element) => element == value);

    if (index == -1) {
      item.values!.add(value);
    } else {
      item.values![index] = value;
    }

    submitVariantOptions(selectedVariants: widget.vm!.selectedVariants!);
    // item.values.add('');

    // if (!item.values.contains('')) {
    // }
  }
}
