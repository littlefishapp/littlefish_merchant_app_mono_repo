// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';

import '../../../../common/presentaion/components/cards/card_neutral.dart';

class CategoryListCard extends StatelessWidget {
  final StockCategory item;

  final Function(StockCategory item)? onTap;

  final int productCount;

  const CategoryListCard({
    Key? key,
    required this.item,
    this.onTap,
    this.productCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return card(context);
  }

  ListTile card(BuildContext context) {
    return ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
      dense: !EnvironmentProvider.instance.isLargeDisplay!,
      key: Key(item.id!),
      leading: Material(
        color: Colors.transparent,
        elevation: 2,
        child: Container(
          width: MediaQuery.of(context).size.width * 0.15,
          height: (MediaQuery.of(context).size.width * 0.15) * 0.65,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Icon(MdiIcons.tagMultiple, color: Colors.white),
        ),
      ),
      onTap: onTap != null
          ? () {
              onTap!(item);
            }
          : null,
      title: LongText(
        '${item.displayName}',
        fontSize: null,
        fontWeight: FontWeight.bold,
        textColor: Theme.of(context).colorScheme.secondary,
      ),
      subtitle: item.description != null && item.description!.isNotEmpty
          ? LongText(item.description)
          : null,
      trailing: CircleAvatar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        child: DecoratedText(
          (item.productCount ?? 0).toString(),
          alignment: Alignment.center,
          fontSize: null,
          textColor: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class CategoryItemCardTablet extends StatelessWidget {
  final StockCategory item;

  final Function(StockCategory item)? onTap;

  final int productCount;

  const CategoryItemCardTablet({
    Key? key,
    required this.item,
    this.onTap,
    this.productCount = 0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return card(context);
  }

  Material card(BuildContext context) {
    return Material(
      child: CardNeutral(
        child: InkWell(
          onTap: onTap == null
              ? null
              : () {
                  if (onTap != null) onTap!(item);
                },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                flex: 2,
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  child: Container(
                    constraints: const BoxConstraints.expand(),
                    child: Icon(
                      MdiIcons.tagMultiple,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${item.displayName}',
                style: const TextStyle(fontSize: 12),
                maxLines: 3,
              ),
              Text(
                '${item.productCount} Items',
                style: TextStyle(color: Theme.of(context).colorScheme.primary),
                maxLines: 3,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
