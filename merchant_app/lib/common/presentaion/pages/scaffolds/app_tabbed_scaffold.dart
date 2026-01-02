// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/common/presentaion/components/drawers/app_main_drawer.dart';
import 'package:littlefish_merchant/app/theme/ui_state_data.dart';

import '../../components/custom_app_bar.dart';

class AppTabbedScaffold extends StatefulWidget {
  final String? title;

  final Widget? titleWidget;

  final Widget? subTitleWidget;

  final bool centreTitle, displayNavBar;

  final double elevation;

  final int initialIndex;

  final NavbarType navbarType;

  final List<TabBarItem> tabs;

  final List<Widget>? actions;

  final Key? scaffoldKey;

  final Function? onRefresh;

  final ScrollPhysics? physics;

  final bool reverse;

  const AppTabbedScaffold({
    Key? key,
    this.scaffoldKey,
    this.title,
    this.titleWidget,
    this.centreTitle = true,
    this.subTitleWidget,
    this.elevation = UIStateData.appBarElevation,
    this.displayNavBar = false,
    this.initialIndex = 0,
    this.navbarType = NavbarType.advanced,
    this.actions,
    this.physics,
    this.onRefresh,
    this.reverse = false,
    required this.tabs,
  }) : super(key: key);

  @override
  State<AppTabbedScaffold> createState() => _AppTabbedScaffoldState();
}

class _AppTabbedScaffoldState extends State<AppTabbedScaffold>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState>? _key;

  int? currentIndex;

  TabController? controller;

  @override
  void initState() {
    _key =
        widget.scaffoldKey as GlobalKey<ScaffoldState>? ??
        GlobalKey<ScaffoldState>();
    currentIndex = widget.initialIndex;

    controller = TabController(length: widget.tabs.length, vsync: this);

    super.initState();
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double defaultTabWidth = widget.tabs.length > 2
        ? MediaQuery.of(context).size.width / (widget.tabs.length + 1.25)
        : MediaQuery.of(context).size.width / (widget.tabs.length * 1.25);

    var appBarActions = widget.actions;

    if (widget.onRefresh != null) {
      appBarActions ??= <Widget>[];

      appBarActions.add(
        IconButton(
          icon: const Icon(Icons.refresh),
          onPressed: () => widget.onRefresh!(),
        ),
      );
    }

    return Scaffold(
      key: _key,
      appBar: CustomAppBar(
        title:
            widget.titleWidget ??
            Text(
              widget.title ?? '',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontWeight: FontWeight.bold,
              ),
            ),
        actions: appBarActions,
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.secondary,
        ),
        centerTitle: widget.centreTitle,
        backgroundColor: Colors.white,
        elevation: widget.elevation,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(
            widget.subTitleWidget == null ? 45.0 : 120.0,
          ),
          child: Container(
            alignment: Alignment.center,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            child: widget.subTitleWidget == null
                ? widget.reverse
                      ? const SizedBox(height: 0, width: 0)
                      : tabBar(context, defaultTabWidth)
                : Column(
                    children:
                        (widget.reverse
                                ? <Widget?>[widget.subTitleWidget]
                                : <Widget?>[
                                    widget.subTitleWidget,
                                    tabBar(context, defaultTabWidth),
                                  ])
                            as List<Widget>,
                  ),
          ),
        ),
      ),
      body: TabBarView(
        controller: controller,
        physics: widget.physics ?? const BouncingScrollPhysics(),
        children: widget.tabs.map((t) => t.content).toList(),
      ),
      bottomNavigationBar: widget.reverse
          ? tabBar(context, defaultTabWidth)
          : null,
      drawer: const AppMainDrawer(),
      floatingActionButton: null,
    );
  }

  TabBar tabBar(context, defaultTabWidth) => TabBar(
    tabAlignment: TabAlignment.start,
    controller: controller,
    indicatorColor: Theme.of(context).colorScheme.primary,
    labelStyle: TextStyle(
      fontWeight: FontWeight.bold,
      foreground: Paint()..color = Theme.of(context).colorScheme.secondary,
    ),
    unselectedLabelStyle: TextStyle(
      fontWeight: FontWeight.normal,
      foreground: Paint()..color = Colors.grey,
    ),
    indicatorSize: TabBarIndicatorSize.tab,
    onTap: (index) {
      controller!.animateTo(index);
    },
    tabs: widget.tabs
        .map(
          (t) => SizedBox(
            width: t.width ?? defaultTabWidth,
            child: Tab(
              text: t.text?.toUpperCase(),
              icon: t.icon != null ? Icon(t.icon) : null,
            ),
          ),
        )
        .toList(),
    isScrollable: true,
  );
}

class TabBarItem {
  TabBarItem({
    this.alignment = Alignment.center,
    this.height,
    this.text,
    required this.content,
    this.width,
    this.icon,
    this.key,
  });

  String? text;
  double? height, width;
  Alignment alignment;
  Widget content;
  IconData? icon;
  Key? key;
}
