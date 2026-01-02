import 'package:flutter/material.dart';
import 'package:littlefish_merchant/ui/online_store/common/constants/icon_constants.dart';
import 'package:littlefish_merchant/ui/online_store/shared/firebase_image.dart';
import 'package:quiver/strings.dart';
import '../../../../features/ecommerce_shared/models/store/promotion.dart';
import 'manage_promotion_screen.dart';

class ManagePromotionTile extends StatelessWidget {
  final Promotion item;

  const ManagePromotionTile({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              ManagePromotionScreen(item: item, manage: true, isPreview: false),
        ),
      ),
      leading: imageSet(),
      title: Text('${item.title}'),
      subtitle: item.duration != null
          ? Text('${item.duration} ${"Days"}')
          : Text(item.message!),
      trailing: item.type == PromotionType.post || item.isCancelled == true
          ? Text(PromotionType.post.toString().split('.').last.toUpperCase())
          : item.isExpired
          ? Text(
              'Expired'.toUpperCase(),
              style: const TextStyle(color: Colors.red),
            )
          : const Text('Active', style: TextStyle(color: Colors.green)),
    );
  }

  Widget imageSet() {
    if (isBlank(item.imageUrl)) {
      switch (item.type) {
        case PromotionType.category:
          return SizedBox(
            height: 44,
            width: 44,
            child: Image.asset(IconConstants.categoryIcon, fit: BoxFit.cover),
          );

        case PromotionType.coupon:
          return SizedBox(
            height: 44,
            width: 44,
            child: Image.asset(IconConstants.vouchersIcon, fit: BoxFit.cover),
          );
        case PromotionType.product:
          return SizedBox(
            height: 44,
            width: 44,
            child: Image.asset(IconConstants.productsIcon, fit: BoxFit.cover),
          );
        case PromotionType.post:
          return SizedBox(
            height: 44,
            width: 44,
            child: Image.asset(IconConstants.productsIcon, fit: BoxFit.cover),
          );
        default:
          return SizedBox(
            height: 44,
            width: 44,
            child: Image.asset(IconConstants.promoteIcon),
          );
      }
    } else {
      return SizedBox(
        height: 44,
        width: 44,
        child: FirebaseImage(imageAddress: item.imageUrl, fit: BoxFit.cover),
      );
    }
  }
}
