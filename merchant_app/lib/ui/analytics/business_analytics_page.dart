// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/analysis/analysis_overviews.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/analysis_service.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/ui/analysis/reports/shared/report_vm_base.dart';
import 'package:littlefish_merchant/ui/analysis/views/analysis_business.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import 'package:littlefish_merchant/common/view_models/store_collection_viewmodel.dart';

class BusinessAnalyticsPage extends StatefulWidget {
  static const String route = 'dashboard/overview';

  final bool showHeader;

  const BusinessAnalyticsPage({Key? key, this.showHeader = true})
    : super(key: key);

  @override
  State<BusinessAnalyticsPage> createState() => _BusinessAnalyticsPageState();
}

class _BusinessAnalyticsPageState extends State<BusinessAnalyticsPage>
    with SingleTickerProviderStateMixin {
  BusinessOverviewVM? vm;
  TabController? controller;
  int? _lastIndex;

  int? get currentIndex => controller?.index;

  @override
  void initState() {
    controller = TabController(initialIndex: 0, length: 3, vsync: this);
    controller!.addListener(() {
      if (!controller!.indexIsChanging && _lastIndex != currentIndex) {
        _lastIndex = currentIndex;
        var index = controller!.index;
        var mode = '';
        if (index == 0) mode = 'report_day';
        if (index == 1) mode = 'report_week';
        if (index == 2) mode = 'report_month';

        if (isNotPremium(mode)) {
          showPopupDialog(
            defaultPadding: false,
            context: context,
            content: billingNavigationHelper(isModal: true),
          );
          controller!.animateTo(0);
        } else {
          vm!.changeMode(ReportMode.values[index]);
          vm!.runReport(context);
        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var store = StoreProvider.of<AppState>(context);

    vm ??= BusinessOverviewVM.fromStore(store)
      ..onReportLoaded = () {
        if (mounted) {
          setState(() {});
        }
      }
      ..initialMode = ReportMode
          .values[((ModalRoute.of(context)!.settings.arguments as int?) ?? 0)];

    if (vm!.currentView == null) vm!.currentView = 0;

    return scaffold(context, vm);
  }

  dynamic scaffold(context, BusinessOverviewVM? vm) => widget.showHeader
      ? AppScaffold(
          title: 'Overview',
          hasDrawer: vm!.store!.state.enableSideNavDrawer!,
          // TODO(lampian): add LD specific flags for this page if LD feature required
          // TODO(lampian): displayNavDrawer: vm.store!.state.enableSideNavDrawer!,
          // TODO(lampian): displayBackNavigation: vm.store!.state.enableSideNavDrawer!,
          displayNavDrawer: false,
          displayBackNavigation: true,
          body: vm.isLoading!
              ? const AppProgressIndicator()
              : analyticsBar(context, vm),
        )
      : vm!.isLoading!
      ? const AppProgressIndicator()
      : analyticsBar(context, vm);

  AppTabBar analyticsBar(context, BusinessOverviewVM vm) => AppTabBar(
    reverse: EnvironmentProvider.instance.isLargeDisplay,
    intialIndex: vm.mode?.index ?? 0,
    controller: controller,
    onTabChanged: (index) async {},
    tabs: [
      TabBarItem(text: '1d', content: analysticsBody(context, vm)),
      TabBarItem(text: '1w', content: analysticsBody(context, vm)),
      TabBarItem(text: '1m', content: analysticsBody(context, vm)),
    ],
  );

  StatelessWidget analysticsBody(context, BusinessOverviewVM vm) =>
      vm.isLoading!
      ? const AppProgressIndicator()
      : BusinessOverview(overview: vm.overview, currentView: vm.currentView);
}

class BusinessOverviewVM extends StoreViewModel<AppState> with ReportVMBase {
  BusinessOverviewCount? overview;

  AnalysisService? service;

  Function? onReportLoaded;

  int? currentView;

  BusinessOverviewVM.fromStore(Store<AppState> store) : super.fromStore(store);

  @override
  loadFromStore(Store<AppState>? store, {BuildContext? context}) {
    var service = AnalysisService.fromStore(store!);

    this.store = store;
    state = store.state;

    isLoading = false;

    runReport = (ctx) async {
      isLoading = true;

      await service
          .getBusinessCountOverview(mode: DateGroupType.values[mode!.index])
          .then((result) {
            overview = result;

            isLoading = false;

            if (onReportLoaded != null) onReportLoaded!();
          })
          .catchError((error) {
            isLoading = false;

            reportCheckedError(error, trace: StackTrace.current);

            if (ctx != null) {
              showErrorDialog(context, error);
            }

            if (onReportLoaded != null) onReportLoaded!();
          })
          .whenComplete(() {
            isLoading = false;
          });
    };

    if (mode == null) {
      mode = initialMode ?? ReportMode.day;
      runReport(context);
    }

    onLoad = () {
      mode ??= ReportMode.day;
    };

    //loading from store is based on a singleton pattern, should only load the first time
    //this.runReport(null);
  }
}
