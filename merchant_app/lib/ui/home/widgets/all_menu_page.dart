// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/security/access_management/module.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/home/home_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import '../../../common/presentaion/components/dialogs/common_dialogs.dart';
import '../../../common/presentaion/components/app_navbar.dart';

class AllMenuPage extends StatefulWidget {
  const AllMenuPage({Key? key}) : super(key: key);

  @override
  State<AllMenuPage> createState() => _AllMenuPageState();
}

class _AllMenuPageState extends State<AllMenuPage> {
  @override
  Widget build(BuildContext context) {
    return StoreBuilder(
      builder: (BuildContext context, Store<AppState> store) {
        return allMenuOptions(
          context,
          EnvironmentProvider.instance.isLargeDisplay,
          store,
        );
      },
    );
  }

  GroupedListView<NavbarItem, String?> allMenuOptions(
    BuildContext context,
    bool? isLargeDisplay,
    Store<AppState> store,
  ) {
    AccessManager accessManager = store.state.authState.accessManager!;

    var isOnline = store.state.hasInternet;

    var options = accessManager
        .getAllMenuOptions()
        .map(
          (m) => NavbarItem(
            route: m.route,
            icon: m.icon,
            text: m.name,
            allowOffline: m.allowOffline,
            specialDisplay: m.specialItem,
            subItems: m.items
                ?.map(
                  (o) => NavbarItem(
                    route: o.route,
                    icon: o.icon,
                    text: o.name,
                    allowOffline: o.allowOffline,
                    specialDisplay: o.specialItem,
                  ),
                )
                .toList(),
          ),
        )
        .toList();

    return GroupedListView(
      // sort: true,
      physics: const BouncingScrollPhysics(),
      elements: options,
      //group by general / quick terms or the category section
      groupBy: (dynamic option) {
        var opt = option as NavbarItem;

        if (opt.subItems == null || opt.subItems!.isEmpty) {
          return opt.text;
        } else {
          return opt.text;
        }
      },
      itemBuilder: (BuildContext context, NavbarItem element) =>
          element.subItems == null || element.subItems!.isEmpty
          ? listMenuItem(context, element, isOnline)
          : Column(
              children: element.subItems!
                  .map((n) => listMenuItem(context, n, isOnline))
                  .toList(),
            ),
      groupSeparatorBuilder: (String? value) => Container(
        color: Colors.grey.shade50,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        child: Text(
          value!,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.grey.shade400,
          ),
        ),
      ),
    );
  }

  Widget listMenuItem(context, option, isOnline) => Container(
    margin: const EdgeInsets.symmetric(vertical: 4.0),
    child: ListTile(
      tileColor: Theme.of(context).colorScheme.background,
      onTap: (isOnline || option.allowOffline)
          ? () {
              if (option.route == HomePage.route) {
                Navigator.of(context).pushNamedAndRemoveUntil(
                  option.route,
                  ModalRoute.withName(option.route),
                );
              }

              if (option.route != null && option.route.isNotEmpty) {
                Navigator.of(context).pushNamed(option.route);
              }
            }
          : () {
              showMessageDialog(
                context,
                'this feature is only available when you are online',
                MdiIcons.wifi,
              );
            },
      leading: ListLeadingIconTile(
        icon: option.icon,
        color: Theme.of(context).colorScheme.secondary,
      ),
      trailing: Icon(
        Platform.isIOS ? Icons.arrow_forward_ios : Icons.arrow_forward,
      ),
      title: Text(option.text),
    ),
  );
}
