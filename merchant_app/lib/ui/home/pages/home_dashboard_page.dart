import 'package:flutter/material.dart';
import 'package:littlefish_core/reports/models/report_settings.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:littlefish_reports/ui/report_dashboard_widget.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';

class HomeDashboardPage extends StatefulWidget {
  const HomeDashboardPage({Key? key}) : super(key: key);

  @override
  State<HomeDashboardPage> createState() => _HomeDashboardPage();
}

class _HomeDashboardPage extends State<HomeDashboardPage> {
  late Store<AppState> store;

  @override
  Widget build(BuildContext context) {
    store = StoreProvider.of<AppState>(context);

    return scaffoldMobile(context);
  }

  Column scaffoldMobile(BuildContext context) => Column(
    children: <Widget>[
      Expanded(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: CardSquareFlat(
            child: ReportDashboardWidget(
              // hint: context.labelSmall('Select Dashboard'),
              // textStyle: context.appThemeLabelLarge,
              businessId: store.state.businessId ?? '',
              // enableDownload: false,
              settings: ReportSettings(
                endpoint: store.state.reportsUrl ?? '',
                configuration: {},
              ),
            ),
          ),
        ),
      ),
    ],
  );
}
