// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';

// Project imports:
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

import 'cards/card_neutral.dart';

class NewListTile extends StatelessWidget {
  const NewListTile({Key? key, this.title, this.subTitle, this.onTap})
    : super(key: key);

  final String? title, subTitle;

  final Function? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      leading: const CircleAvatar(child: Icon(Icons.add)),
      onTap: () {
        if (onTap != null) onTap!();
      },
      title: Text(title!),
      subtitle: subTitle == null ? null : Text(subTitle!),
    );
  }
}

class NewItemTile extends StatelessWidget {
  final String? title;

  final Function? onTap;

  final EdgeInsetsGeometry? padding;
  final Key? newItemKey;

  const NewItemTile({
    Key? key,
    this.title,
    this.onTap,
    this.newItemKey,
    this.padding,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      key: newItemKey,
      contentPadding: padding,
      dense: !EnvironmentProvider.instance.isLargeDisplay!,
      title: Text(
        title!,

        // textColor: Theme.of(context).colorScheme.secondary,
      ),
      subtitle: const LongText('tap to add new', fontSize: 12),
      leading: const ListLeadingIconTile(icon: Icons.add),
      onTap: () {
        if (onTap != null) onTap!();
      },
    );
  }
}

class NewItemTileTablet extends StatelessWidget {
  final String? title;

  final Function? onTap;

  final EdgeInsetsGeometry? padding;

  const NewItemTileTablet({Key? key, this.title, this.onTap, this.padding})
    : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CardNeutral(
      elevation: 2,
      child: InkWell(
        onTap: () {
          if (onTap != null) onTap!();
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Theme.of(context).colorScheme.primary,
          ),
          // color: Theme.of(context).colorScheme.primary,
          child: const Icon(Icons.add, size: 80),
        ),
      ),
    );
  }
}
