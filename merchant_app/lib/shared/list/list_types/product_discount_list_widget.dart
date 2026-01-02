//Flutter Imports
// remove ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
//Project Imports
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/products/product_discount.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/view_models/product_discount_vm.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';

class ProductDiscountListWidget extends StatelessWidget {
  final List<ProductDiscount> productDiscounts;
  final ProductDiscountVM vm;
  final Function(ProductDiscount, BuildContext)? onTap;
  final Function(ProductDiscount, BuildContext)? trailingOnTap;

  const ProductDiscountListWidget({
    Key? key,
    required this.productDiscounts,
    required this.vm,
    required this.onTap,
    required this.trailingOnTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (BuildContext ctx, int index) {
        return Slidable(
          endActionPane: ActionPane(
            extentRatio: .25,
            motion: const ScrollMotion(),
            children: [
              SlidableAction(
                onPressed: (ctex) async {
                  var result = await confirmDismissal(
                    context,
                    productDiscounts[index],
                  );

                  if (result == true && trailingOnTap != null) {
                    trailingOnTap!(productDiscounts[index], ctx);
                  }
                },
                backgroundColor: Theme.of(context).colorScheme.error,
                foregroundColor: Theme.of(context).colorScheme.onError,
                icon: Icons.delete,
                label: 'Delete',
              ),
            ],
          ),
          child: ListTile(
            tileColor: Theme.of(context).colorScheme.background,
            trailing: context.paragraphMedium(
              '${productDiscounts[index].type == DiscountType.fixedDiscountAmount ? 'R ' : ''}'
              '${productDiscounts[index].value} '
              '${productDiscounts[index].type == DiscountType.percentage ? '%' : ''}',
            ),
            title: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(productDiscounts[index].displayName ?? ''),
                subText(
                  context,
                  discountTypeFormatter(productDiscounts[index].type!),
                ),
                subText(
                  context,
                  'Items: ${productDiscounts[index].products?.length ?? '0'}',
                ),
              ],
            ),
            onTap: onTap != null
                ? () {
                    onTap!(productDiscounts[index], ctx);
                  }
                : null,
          ),
        );
      },
      itemCount: productDiscounts.length,
      separatorBuilder: (BuildContext context, int index) =>
          const CommonDivider(),
    );
  }

  discountTypeFormatter(DiscountType type) {
    List<String> words = type
        .toString()
        .split('.')[1]
        .split(RegExp(r'(?=[A-Z])'));

    String result = words
        .map(
          (word) =>
              '${word[0].toUpperCase()}${word.substring(1).toLowerCase()}',
        )
        .join(' ');
    return result;
  }

  subText(BuildContext context, String text) => context.body02x14R(
    text,
    color: Theme.of(context).extension<AppliedTextIcon>()?.secondary,
  );
}
