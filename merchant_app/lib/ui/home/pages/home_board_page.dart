import 'dart:io';
import 'package:flutter/material.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_button.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/components/cards/card_square_flat.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/environment/environment_config.dart';
import 'package:littlefish_merchant/shared/constants/permission_name_constants.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/home/home_board_header/home_board_header.dart';
import 'package:littlefish_merchant/ui/sales/sales_page.dart';
import 'package:littlefish_merchant/ui/sales/widgets/sales_transaction_tile.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/ui/reports/financial_statement/financial_statement_vm.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/reports/business_summary.dart';
import 'package:littlefish_merchant/models/security/access_management/module.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/services/analysis_service.dart';
import 'package:littlefish_merchant/ui/home/widgets/home_low_stock_card.dart';
import 'package:littlefish_merchant/ui/home/widgets/home_revenue_card.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class HomeBoardPage extends StatefulWidget {
  const HomeBoardPage({Key? key}) : super(key: key);

  @override
  State<HomeBoardPage> createState() => _HomeBoardPage();
}

class _HomeBoardPage extends State<HomeBoardPage> {
  late ReportService _reportService;
  late Store<AppState> store;

  FinancialStatementVM? vm;
  late final Future<BusinessSummary?> _getBusinessSummary;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _getBusinessSummary = _getFuture(context);
      });
    });
  }

  Future<BusinessSummary?> _getFuture(BuildContext context) async {
    store = StoreProvider.of<AppState>(context);
    vm = FinancialStatementVM.fromStore(store, context: context);
    _reportService = ReportService.fromStore(store);
    if (vm != null) {
      await vm!.runReport(context);
      return _reportService.getBusinessSummary();
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<BusinessSummary?>(
      future: _getBusinessSummary,
      builder: (c, snapshot) {
        debugPrint('### HomeBoardPage: ${snapshot.connectionState}');
        // if (snapshot.hasError) {
        //   return Center(
        //     child: TextTag(
        //       displayText: 'Something went wrong',
        //       color: Theme.of(context).colorScheme.error,
        //     ),
        //   );
        // }

        return snapshot.connectionState == ConnectionState.done
            ? scaffoldMobile(context, snapshot.data)
            // : const DashboardPage();
            : Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  //HomeHeaderWidget(),
                  homeBoardHeader(),
                  Expanded(child: AppProgressIndicator()),
                ],
              );
      },
    );
  }

  Widget scaffoldMobile(BuildContext context, BusinessSummary? summary) =>
      SingleChildScrollView(
        child: Column(
          children: <Widget>[
            // const HomeHeaderWidget(),
            homeBoardHeader(),
            Column(
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.all(8),
                  child: _headerActions(context, summary),
                ),
                if (AppVariables.store!.state.permissions!.analytics == true ||
                    AppVariables.store!.state.permissions!.isAdmin == true ||
                    userHasPermission(allowReportOverview))
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: transactionsCard(context, summary),
                  ),
                if (AppVariables.store!.state.permissions!.analytics == true ||
                    userHasPermission(allowReportOverview))
                  Container(
                    margin: const EdgeInsets.all(8),
                    child: salesBreakdownCard(context, summary),
                  ),
                if (AppVariables.store!.state.permissions!.manageInventory ==
                        true ||
                    userHasPermission(allowInventoryStock))
                  const HomeLowStockCard(),
              ],
            ),
          ],
        ),
      );

  Widget salesBreakdownCard(BuildContext context, BusinessSummary? data) {
    return HomeRevenueCard(summary: data);
  }

  Widget transactionsCard(BuildContext context, BusinessSummary? data) {
    return CardSquareFlat(
      margin: EdgeInsets.zero,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
        width: double.infinity,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: context.labelXSmall('Total Sales', alignLeft: true),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              child: context.headingSmall(
                TextFormatter.toStringCurrency(data?.revenue ?? 0),
                isBold: true,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 8),
              child: context.labelXSmall('Recent Sales', isBold: true),
            ),
            if (data?.recentTransactions != null &&
                data!.recentTransactions!.isNotEmpty)
              ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                padding: EdgeInsets.zero,
                shrinkWrap: true,
                itemCount: data.recentTransactions?.length ?? 0,
                itemBuilder: (c, i) {
                  final sale = data.recentTransactions?[i];

                  return SalesTransactionTile(
                    sale: sale!,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 4),
                    isDense: true,
                  );
                },
              ),
            if (data?.recentTransactions == null ||
                data!.recentTransactions!.isEmpty)
              SizedBox(
                height: 84,
                child: Center(
                  child: context.labelMedium('No Transactions Found'),
                ),
              ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
              child: ButtonSecondary(
                text: 'See All Sales',
                onTap: (context) {
                  Navigator.pushNamed(context, SalesPage.route);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  StatelessWidget _headerActions(
    BuildContext context,
    BusinessSummary? summary,
  ) {
    AccessManager accessManager = StoreProvider.of<AppState>(
      context,
    ).state.authState.accessManager!;

    var actions = accessManager.getAllQuickActions();

    if (actions.isEmpty) return Container();
    return CardSquareFlat(
      margin: EdgeInsets.zero,
      child: Container(
        width: double.infinity,
        key: const Key('quick_actions'),
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            ListView.separated(
              separatorBuilder: (c, i) => const SizedBox(height: 8),
              itemCount: actions.length,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final item = actions[index];

                return ListTile(
                  title: context.labelSmall((item.name ?? ''), alignLeft: true),
                  trailing: Icon(
                    Platform.isIOS
                        ? Icons.arrow_forward_ios
                        : Icons.arrow_forward,
                  ),
                  onTap: () {
                    if (item.action != null) {
                      item.action!(context);
                    } else {
                      Navigator.of(context).pushNamed(item.route!);
                    }
                  },
                  leading: ListLeadingIconTile(
                    icon: item.icon,
                    color: Theme.of(
                      context,
                    ).extension<AppliedButton>()?.primaryDefault,
                    iconColor: Colors.white,
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
