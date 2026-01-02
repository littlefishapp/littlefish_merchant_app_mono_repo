// removed ignore: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';

import '../../../../common/presentaion/components/buttons/button_secondary.dart';

class StockProductListEmpty extends StatelessWidget {
  const StockProductListEmpty({super.key, required this.addProductsOnTap});

  final void Function(void) addProductsOnTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 96,
              height: 97,
              margin: const EdgeInsets.all(36),
              decoration: ShapeDecoration(
                color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(990),
                ),
              ),
            ),
            Text(
              'No Products',
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                color: Theme.of(context).colorScheme.secondary,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Align(
                alignment: Alignment.center,
                child: context.paragraphMedium(
                  'Your added inventory will show here.',
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.6,
              child: ButtonSecondary(
                text: 'Add Products',
                onTap: addProductsOnTap,
                icon: Icons.add,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
