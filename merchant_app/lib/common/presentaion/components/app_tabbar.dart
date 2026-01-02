import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import '../../../app/theme/applied_system/applied_button.dart';
import '../pages/scaffolds/app_tabbed_scaffold.dart';

class AppTabBar extends StatefulWidget {
  final List<TabBarItem> tabs;

  final ScrollPhysics? physics;

  final Function(int index)? onTabChanged;

  final bool? reverse;

  final int? intialIndex;

  final bool scrollable;

  final bool resizeToAvoidBottomInset;

  final TabController? controller;

  final TabAlignment? tabAlignment;

  final bool? hideTabBar;

  const AppTabBar({
    Key? key,
    required this.tabs,
    this.onTabChanged,
    this.physics,
    this.reverse = false,
    this.intialIndex = 0,
    this.scrollable = false,
    this.resizeToAvoidBottomInset = true,
    this.controller,
    this.tabAlignment,
    this.hideTabBar = false,
  }) : super(key: key);

  @override
  AppTabBarState createState() => AppTabBarState();
}

class AppTabBarState extends State<AppTabBar>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  int? _lastIndex;

  int? get currentIndex => controller?.index;

  @override
  void initState() {
    controller = widget.controller;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (controller == null) {
      controller = TabController(
        initialIndex: widget.intialIndex!,
        length: widget.tabs.length,
        vsync: this,
      );

      _lastIndex = widget.intialIndex;

      controller!.addListener(() {
        if (!controller!.indexIsChanging && _lastIndex != currentIndex) {
          _lastIndex = currentIndex;
          if (widget.onTabChanged != null) {
            widget.onTabChanged!(controller!.index);
          }

          if (mounted) {
            setState(() {});
          }
        }
      });
    }
    return widget.tabs.length == 1
        ? Container(child: widget.tabs[0].content)
        : LayoutBuilder(
            builder: (context, constraints) {
              debugPrint(
                '### AppTabBar layoutbuilder constraints: $constraints',
              );
              final widthAvailable = constraints.maxWidth;
              final defaultTabWidth =
                  widthAvailable * 0.75 / widget.tabs.length;
              return Scaffold(
                backgroundColor: Theme.of(context).colorScheme.background,
                resizeToAvoidBottomInset: widget.resizeToAvoidBottomInset,
                appBar: widget.hideTabBar!
                    ? null
                    : widget.reverse!
                    ? null
                    : tabBar(context, defaultTabWidth),
                bottomNavigationBar: widget.hideTabBar!
                    ? null
                    : widget.reverse!
                    ? bottomBar(context, defaultTabWidth)
                    : null,
                body: TabBarView(
                  controller: controller,
                  physics:
                      widget.physics ?? const NeverScrollableScrollPhysics(),

                  children: widget.tabs
                      .map((t) => Container(child: t.content))
                      .toList(),
                ),
              );
            },
          );
  }

  TabBar tabBar(BuildContext context, defaultTabWidth) => TabBar(
    isScrollable: widget.scrollable,
    tabAlignment: widget.scrollable ? TabAlignment.start : TabAlignment.center,
    controller: controller,
    physics: widget.physics,
    labelColor: Theme.of(context).extension<AppliedButton>()?.primaryDefault,
    unselectedLabelColor: Theme.of(
      context,
    ).extension<AppliedButton>()?.neutralDefault,
    indicatorColor: Theme.of(
      context,
    ).extension<AppliedButton>()?.primaryDefault,
    dividerColor: Colors.transparent,
    tabs: widget.tabs
        .map(
          (t) => SizedBox(
            width: widget.scrollable ? null : t.width ?? defaultTabWidth,
            child: Tab(
              key: t.key,
              // height: 40,
              icon: t.icon != null ? Icon(t.icon, color: Colors.grey) : null,
              child: t.text != null
                  ? context.labelSmall(
                      t.text ?? '',
                      alignLeft: true,
                      color: currentIndex == widget.tabs.indexOf(t)
                          ? Theme.of(
                              context,
                            ).extension<AppliedButton>()?.primaryDefault
                          : null,
                      isBold: currentIndex == widget.tabs.indexOf(t)
                          ? true
                          : false,
                    )
                  : null,
            ),
          ),
        )
        .toList(),
  );

  BottomAppBar bottomBar(BuildContext context, defaultTabWidth) => BottomAppBar(
    shape: const CircularNotchedRectangle(),
    child: SizedBox(height: 52, child: tabBar(context, defaultTabWidth)),
  );
}
