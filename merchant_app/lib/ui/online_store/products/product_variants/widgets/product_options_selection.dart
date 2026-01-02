import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/online_store/common/config.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import '../../../../../features/ecommerce_shared/models/online/system_variant.dart';
import '../../../../../common/presentaion/components/buttons/button_primary.dart';

class ProductOptionsSelection extends StatelessWidget {
  final BuildContext context;
  final ManageStoreVM vm;
  final List<SystemVariant> selectedVariants;

  const ProductOptionsSelection({
    Key? key,
    required this.context,
    required this.selectedVariants,
    required this.vm,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return body();
  }

  StatefulBuilder body() => StatefulBuilder(
    builder: (ctx, myState) => Column(
      children: [
        Wrap(
          children: vm.productVariants.map((e) {
            var isSelected = selectedVariants
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
                selected: selectedVariants.map((f) => f.name).contains(e.name),
                onSelected: (selected) {
                  if (selected) {
                    selectedVariants.add(e);
                  } else {
                    selectedVariants.removeWhere(
                      (element) => e.id == element.id,
                    );
                  }
                  myState(() {});
                  // if (mounted) setState(() {});
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
            // buttonColor: vm.store!.state.isDarkMode
            //     ? Theme.of(context).colorScheme.secondary
            //     : null,
            onTap: (ctx) {
              Navigator.of(context).pop(selectedVariants);
            },
          ),
        ),
      ],
    ),
  );
}
