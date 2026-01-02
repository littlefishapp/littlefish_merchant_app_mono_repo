// flutter imports
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';

// project imports
import 'package:littlefish_merchant/models/shared/image_representable.dart';
import 'package:littlefish_merchant/ui/checkout/widgets/checkout_sort_sales_actions.dart';
import 'package:littlefish_merchant/models/enums.dart';

import '../../../../app/theme/applied_system/applied_surface.dart';

class SortProductsButton extends StatelessWidget {
  final SortOrder order;
  final SortBy sortBy;
  final ImageRepresentable? imageRepresentable;
  final void Function(SortBy type, SortOrder order) onChanged;
  const SortProductsButton({
    Key? key,
    required this.order,
    required this.sortBy,
    required this.onChanged,
    this.imageRepresentable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: 50,
      decoration: BoxDecoration(
        border: Border.all(
          color:
              Theme.of(context).extension<AppliedSurface>()?.brand ??
              Colors.red,
        ),
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        child: imageRepresentable != null
            ? imageRepresentable!.buildWidget()
            : IconRepresentable(Icons.tune_outlined).buildWidget(
                colour: Theme.of(context).extension<AppliedTextIcon>()?.brand,
              ),
        onTap: () async {
          await showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
            ),
            elevation: 0,
            builder: (ctx) => SafeArea(
              top: false,
              bottom: true,
              child: CheckoutSortActions(
                order: order,
                type: sortBy,
                onUpdateSort: (type, order) {
                  onChanged(type, order);
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
