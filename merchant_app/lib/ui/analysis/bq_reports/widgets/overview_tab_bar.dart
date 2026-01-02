// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/reports/bq_comparison_overview_report.dart';
import 'package:littlefish_merchant/tools/helpers.dart';

class OverviewTabBar extends StatefulWidget {
  const OverviewTabBar({
    Key? key,
    required this.reportData,
    required this.currentTabIndex,
    required this.setParentTabIndex,
    this.isloading,
  }) : super(key: key);

  final List<OverviewComparisonReport>? reportData;
  final int? currentTabIndex;
  final Function? setParentTabIndex;
  final bool? isloading;

  @override
  State<OverviewTabBar> createState() => _OverviewTabBarState();
}

class _OverviewTabBarState extends State<OverviewTabBar>
    with TickerProviderStateMixin {
  int? tabIndex;

  @override
  Widget build(BuildContext context) {
    if ((widget.reportData!.length - 1) < widget.currentTabIndex!) {
      tabIndex = 0;
    } else {
      tabIndex = widget.currentTabIndex!;
    }

    TabController controller = TabController(
      // TODO(lampian): check null test logic
      length: widget.reportData == null || widget.reportData!.isEmpty
          ? 1
          : widget.reportData!.length,
      vsync: this,
      initialIndex: tabIndex!,
    );

    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TabBar(
          isScrollable: true,
          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 2),
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Theme.of(context).colorScheme.secondary,
          controller: controller,
          labelColor: chartPallete[tabIndex!],
          unselectedLabelColor: Colors.grey,
          onTap: (index) {
            setState(() {
              if ((widget.reportData!.length - 1) < index) {
                tabIndex = 0;
              }

              tabIndex = index;

              if (widget.setParentTabIndex != null) {
                widget.setParentTabIndex!(tabIndex);
              }
            });
          },
          tabs: [
            if (widget.reportData!.isEmpty)
              const Text('Empty Series Tab', textAlign: TextAlign.center)
            else
              for (var i = 0; i < widget.reportData!.length; i++)
                Text(
                  widget.reportData![i].seriesName!.replaceFirst(
                    'Custom, ',
                    '',
                  ),
                  textAlign: TextAlign.center,
                ),
          ],
        ),
      ],
    );
  }
}
