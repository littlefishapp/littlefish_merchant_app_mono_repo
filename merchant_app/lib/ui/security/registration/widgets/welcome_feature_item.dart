import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';

class WelcomeFeatureItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;
  final BuildContext context;

  const WelcomeFeatureItem({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
    required this.context,
  });

  @override
  Widget build(BuildContext context) {
    ///Todo(Brandon): Add New LD Theming
    return ListTile(
      leading: ListLeadingIconTile(icon: icon),
      title: context.labelSmall(title, isBold: true),
      subtitle: context.labelXSmall(
        description,
        maxLines: 3,
        alignLeft: true,
        alignRight: false,
      ),
    );
  }
}
