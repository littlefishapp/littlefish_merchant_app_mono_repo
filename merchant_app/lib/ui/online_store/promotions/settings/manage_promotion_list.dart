import 'package:flutter/material.dart';
import '../../../../features/ecommerce_shared/models/store/promotion.dart';
import '../../../../common/presentaion/components/common_divider.dart';
import 'manage_promotion_tile.dart';

class ManagePromotionList extends StatelessWidget {
  final List<Promotion>? promotions;

  const ManagePromotionList({Key? key, required this.promotions})
    : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (promotions!.isEmpty) {
      return const Center(child: Text('No Promotions found'));
    }

    return ListView.separated(
      itemCount: promotions?.length ?? 0,
      itemBuilder: (context, index) {
        var prom = promotions![index];

        return ManagePromotionTile(item: prom);
      },
      separatorBuilder: (BuildContext context, int index) =>
          const CommonDivider(),
    );
  }
}
