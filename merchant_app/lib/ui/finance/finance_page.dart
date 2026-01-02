import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/models/finance/score.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/finance/pages/finance_process_page.dart';
import 'package:littlefish_merchant/ui/finance/pages/finance_score_breakdown_page.dart';
import 'package:littlefish_merchant/ui/finance/viewmodels/finance_vm.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/ui/finance/widgets/score_view.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/decorated_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/text_tag.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/custom_route.dart';

class FinancePage extends StatefulWidget {
  static const String route = '/finance';

  const FinancePage({Key? key}) : super(key: key);

  @override
  State<FinancePage> createState() => _FinancePageState();
}

class _FinancePageState extends State<FinancePage> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();

  FinanceVM? vm;

  @override
  Widget build(BuildContext context) {
    //create the VM
    if (vm == null) {
      var store = StoreProvider.of<AppState>(context);

      vm = FinanceVM.fromStore(store);
    }

    return AppScaffold(
      title: 'Finance',
      hasDrawer: vm!.store!.state.enableSideNavDrawer!,
      displayNavDrawer: vm!.store!.state.enableSideNavDrawer!,
      persistentFooterButtons: [
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 8),
          child: ButtonPrimary(
            disabled: true,
            text: 'Request Loan',
            onTap: (c) => Navigator.of(
              context,
            ).push(CustomRoute(builder: (cc) => FinanceWizzardPage(vm: vm))),
          ),
        ),
      ],
      body: FutureBuilder(
        future: vm?.scoreService?.getBusinessPerfomanceScore(),
        builder: (ctx, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: TextTag(
                displayText: 'Something Went Wrong',
                color: Colors.red,
              ),
            );
          }
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.data == null
                    ? const Center(child: TextTag(displayText: 'No Data'))
                    : layout(
                        context,
                        snapshot.data! as BusinessPerformanceScore,
                      )
              : const AppProgressIndicator();
        },
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(
            Icons.refresh,
            color: Theme.of(context).colorScheme.onBackground,
          ),
          onPressed: () {
            if (mounted) setState(() {});
          },
        ),
      ],
    );
  }

  Column layout(context, BusinessPerformanceScore data) {
    vm!.performanceScore = data;
    vm!.setEligibleLimit(data.finalScore, data.loanLimit);
    return Column(
      children: <Widget>[
        SizedBox(
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Material(
                      color: Colors.white,
                      child: InkWell(
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: ScoreView(
                            firstValue: vm!.performanceScore.finalScore,
                            secondValue: 100,
                            radius: MediaQuery.of(context).size.width / 8,
                            fontSize: 18,
                            color: vm!.getColor(
                              vm!.performanceScore.finalScore,
                              vm!.performanceScore.max,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 84, child: VerticalDivider()),
                  Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      businessDetails(context),
                      SizedBox(
                        width: MediaQuery.of(context).size.width / 2,
                        child: OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          child: Text(
                            'View Score',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Theme.of(context).colorScheme.secondary,
                              //fontFamily: UIStateData.primaryFontFamily,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          // TODO(lampian): fix color
                          // textColor:
                          //     Theme.of(context).colorScheme.secondary,
                          onPressed: () {
                            showPopupDialog(
                              context: context,
                              content: FinanceScoreBreakdownPage(vm: vm),
                              defaultPadding: false,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const CommonDivider(),
              SizedBox(
                height: 104,
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: <Widget>[
                    creditDetails(
                      firstValue: vm!.performanceScore.sales!.score,
                      secondValue: vm!.performanceScore.sales!.max,
                      title: 'Sales',
                    ),
                    const VerticalDivider(width: 1),
                    creditDetails(
                      firstValue: vm!.performanceScore.growth!.score,
                      secondValue: vm!.performanceScore.growth!.max,
                      title: 'Growth',
                    ),
                    const VerticalDivider(width: 1),
                    creditDetails(
                      firstValue: vm!.performanceScore.systemUse!.score,
                      secondValue: vm!.performanceScore.systemUse!.max,
                      title: 'Usage',
                    ),
                    const VerticalDivider(width: 1),
                    creditDetails(
                      firstValue: vm!.performanceScore.penalties!.score,
                      secondValue: vm!.performanceScore.penalties!.max,
                      title: 'Penalties',
                    ),
                  ],
                ),
              ),
              const CommonDivider(),
            ],
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 24),
            child: const LongText(
              'We aim to get you the best deal fast, request a loan now so we can get you the money you need',
              alignment: TextAlign.center,
              fontSize: null,
              maxLines: 5,
            ),
          ),
        ),
        const CommonDivider(),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Column(
                children: <Widget>[
                  LongText(
                    'Loan Limit',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    textColor: Theme.of(context).colorScheme.secondary,
                  ),
                  LongText(
                    TextFormatter.toStringCurrency(
                      vm!.totalLoanLimit,
                      displayCurrency: false,
                      currencyCode: '',
                    ),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    textColor: Theme.of(context).colorScheme.secondary,
                  ),
                ],
              ),
              const SizedBox(height: 24, child: VerticalDivider()),
              Column(
                children: <Widget>[
                  LongText(
                    'Your Limit',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    textColor: Theme.of(context).colorScheme.primary,
                  ),
                  LongText(
                    TextFormatter.toStringCurrency(
                      vm!.eligableLoanLimit,
                      displayCurrency: false,
                      currencyCode: '',
                    ),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    textColor: Theme.of(context).colorScheme.primary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  SizedBox loanInformationGrid(BuildContext context) => SizedBox(
    child: GridView.count(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      crossAxisCount: 3,
      childAspectRatio: 1.75,
      children: <Widget>[
        loanDetailCard(icon: Icons.trending_up, title: '7% Interest'),
        loanDetailCard(icon: LittleFishIcons.warning, title: '1% Risk Premium'),
        loanDetailCard(icon: Icons.timelapse, title: '1% Period Risk'),
      ],
    ),
  );

  Container loanPeriodGrid(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: Row(
      children: <Widget>[
        Expanded(
          child: loanDetailCard(
            icon: Icons.calendar_today,
            title: 'Min 1 Month',
            hasBorder: false,
          ),
        ),
        const SizedBox(height: 48, child: VerticalDivider()),
        Expanded(
          child: loanDetailCard(
            icon: Icons.date_range,
            title: 'Max 6 Months',
            hasBorder: false,
          ),
        ),
      ],
    ),
  );

  Container loanDetailCard({
    required IconData icon,
    required String title,
    bool hasBorder = true,
  }) => Container(
    decoration: hasBorder
        ? BoxDecoration(border: Border.all(color: Colors.grey.shade50))
        : null,
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Icon(icon, size: 30.0, color: Theme.of(context).colorScheme.secondary),
        const SizedBox(height: 8.0),
        DecoratedText(
          title,
          fontSize: null,
          textColor: Theme.of(context).colorScheme.secondary,
          alignment: Alignment.bottomCenter,
        ),
      ],
    ),
  );

  Material creditDetails({
    double? firstValue,
    double? secondValue,
    String? title,
  }) => Material(
    color: Colors.white,
    child: InkWell(
      child: Container(
        width: (MediaQuery.of(context).size.width) / 4,
        color: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 4.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ScoreView(
              firstValue: firstValue,
              secondValue: secondValue,
              fontSize: 14,
              lineWidth: 6,
              radius: MediaQuery.of(context).size.width / 16,
              color: vm!.getColor(firstValue, secondValue),
            ),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 4),
              child: LongText(
                title,
                fontSize: 12,
                alignment: TextAlign.center,
                textColor: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Column businessDetails(context) {
    var store = StoreProvider.of<AppState>(context);

    //important to have the business details loaded from the state only
    var businessState = store.state.businessState;

    var profile = businessState.profile!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          '${profile.name}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        Text('${profile.type!.name}'),
      ],
    );
  }
}
