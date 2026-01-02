import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/features/store_switching/presentation/pages/list_of_stores_page.dart';

class SelectBusinessTile extends StatelessWidget {
  const SelectBusinessTile({super.key, required this.context});

  final BuildContext context;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (!AppVariables.isPOSBuild) {
          Navigator.of(
            context,
          ).push(CustomRoute(builder: (ctx) => const ListOfStoresPage()));
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
        child: context.labelSmall(
          AppVariables.store?.state.businessState.profile!.name ?? '',
          color: Theme.of(context).colorScheme.surface,
          isBold: true,
        ),
      ),
    );
  }
}
