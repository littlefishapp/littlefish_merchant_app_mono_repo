// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/security/access_management/module.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';

import '../../../common/presentaion/components/cards/card_neutral.dart';

class FavoritesPage extends StatefulWidget {
  final BuildContext? parentContext;
  final bool? isLargeDisplay;
  final AccessManager? accessManager;

  const FavoritesPage({
    Key? key,
    this.parentContext,
    this.isLargeDisplay = false,
    this.accessManager,
  }) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late List<ModuleMenuItem> shortcuts;

  @override
  Widget build(BuildContext context) {
    shortcuts = widget.accessManager!.getShortcuts();
    // shortcuts is a list of shortcuts we get based on permissions,
    // setting this list as a variable of this class and then removing
    // shortcuts from this list if they should be hidden does not effect
    // other pages.
    shortcuts.removeWhere(
      (shortcut) =>
          (shortcut.name == 'Sell Now' &&
              AppVariables.store!.state.enableSellNowInFavourites != true) ||
          (shortcut.name == 'Overview' &&
              AppVariables.store!.state.enableOverviewInFavourites != true),
    );
    return Container(
      color: Colors.grey.shade50,
      child: Container(
        color: Colors.grey.shade50,
        child: MediaQuery.removePadding(
          context: context,
          removeTop: true,
          child: _favorites(widget.parentContext, widget.isLargeDisplay!),
        ),
      ),
    );
  }

  Container _favorites(BuildContext? context, bool isLargeDisplay) => Container(
    alignment: Alignment.topCenter,
    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    child: GridView.count(
      physics: const BouncingScrollPhysics(),
      crossAxisCount: isLargeDisplay ? 3 : 2,
      mainAxisSpacing: isLargeDisplay ? 8 : 8,
      crossAxisSpacing: isLargeDisplay ? 0 : 0,
      childAspectRatio: 1.6,
      shrinkWrap: true,
      children: _gridItems(),
    ),
  );

  List<Widget> _gridItems() {
    return shortcuts.map((qa) {
      return qa.name == 'Sell Now'
          ? CardNeutral(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              color: Theme.of(context).colorScheme.primary,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: (qa.route != null)
                    ? () => Navigator.of(context).pushNamed(qa.route!)
                    : () => showComingSoon(context: context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(qa.icon, color: Colors.white, size: 54),
                    const SizedBox(height: 4),
                    Text(qa.name!, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            )
          : qa.name == 'Online Catalog'
          ? CardNeutral(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              color: Theme.of(context).colorScheme.secondary,
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: (qa.route != null)
                    ? () => Navigator.of(context).pushNamed(qa.route!)
                    : () => showComingSoon(context: context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(qa.icon, color: Colors.white, size: 54),
                    const SizedBox(height: 4),
                    Text(qa.name!, style: const TextStyle(color: Colors.white)),
                  ],
                ),
              ),
            )
          : CardNeutral(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              child: InkWell(
                borderRadius: BorderRadius.circular(4),
                onTap: (qa.route != null)
                    ? () => Navigator.of(context).pushNamed(qa.route!)
                    : () => showComingSoon(context: context),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      qa.icon,
                      color: Theme.of(context).colorScheme.secondary,
                      size: 54,
                    ),
                    const SizedBox(height: 4),
                    Text(qa.name!),
                  ],
                ),
              ),
            );
    }).toList();
  }
}
