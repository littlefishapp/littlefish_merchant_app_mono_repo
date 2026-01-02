// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

// Project imports:
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/ui/reports/products/filter/product_list_filter_page.dart';
import 'package:littlefish_merchant/ui/reports/products/filter/product_list_vm.dart';
import 'package:littlefish_merchant/ui/reports/products/product_list_data_table.dart';
import 'package:littlefish_merchant/ui/reports/shared/widgets/percentage_card.dart';
import 'package:littlefish_merchant/ui/reports/shared/widgets/summary_card.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

import '../../../app/theme/applied_system/applied_text_icon.dart';

class ProductListPage extends StatefulWidget {
  static const String route = 'report/product';

  const ProductListPage({Key? key}) : super(key: key);

  @override
  State<ProductListPage> createState() => _ProductListPageState();
}

class _ProductListPageState extends State<ProductListPage> {
  var dateSelection = DateTime.now().toUtc();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  late ProductListVM vm;

  PageController? pageController;

  @override
  void initState() {
    pageController = PageController(viewportFraction: 0.6, initialPage: 0);
    vm = ProductListVM.fromStore(AppVariables.store!, context: context)
      ..reportLoaded = (report) {
        if (mounted) setState(() {});
      }
      ..onLoadingChanged = () {
        if (mounted) setState(() {});
      };
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffold(
      key: _scaffoldKey,
      title: 'Products',
      // displayFloat: vm.isLoading || !vm.hasData ? false : true,
      actions: vm.isLoading! || !vm.hasData
          ? []
          : [
              IconButton(
                icon: Icon(
                  MdiIcons.filePdfBox,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
                onPressed: () {
                  vm.downloadProductList(true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Downloading...',
                        style: TextStyle(color: Colors.black),
                      ),
                      duration: Duration(seconds: 3),
                    ),
                  );
                },
              ),
              // IconButton(
              //   icon: Icon(MdiIcons.fileExcel),
              //   onPressed: () => vm.downloadProductList(false),
              // ),
              IconButton(
                icon: Icon(
                  Icons.search,
                  color: Theme.of(
                    context,
                  ).extension<AppliedTextIcon>()?.inversePrimary,
                ),
                onPressed: () => showPopupDialog(
                  context: context,
                  content: ProductListFilterPage(vm, parentContext: context),
                ),
              ),
            ],
      // floatIcon: Icons.search,
      // floatAction: () {
      // },
      // floatLocation: FloatingActionButtonLocation.endTop,
      body: vm.isLoading!
          ? const AppProgressIndicator()
          : !vm.hasData
          ? Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ProductListFilterPage(
                vm,
                showHeader: false,
                // parentContext: context,
              ),
            )
          : EnvironmentProvider.instance.isLargeDisplay!
          ? _bodyTablet()
          : _bodyMobile(),
    );
  }

  ListView _bodyMobile() => ListView(
    physics: const BouncingScrollPhysics(),
    children: <Widget>[
      SizedBox(
        height: 120,
        child: Container(
          color: Colors.grey.shade50,
          child: PageView(
            controller: pageController,
            children: <Widget>[
              PercentageCard(
                context,
                value: //num.tryParse(
                vm.productSummary![0].value!.toStringAsFixed(
                  2,
                ),
                title: 'Average Markup',
              ),
              SummaryCard(
                context,
                value: vm.productSummary![1].value!.toStringAsFixed(2),
                title: 'Average profit',
              ),
              SummaryCard(
                context,
                value: vm.productSummary![2].value.toString(),
                asDouble: false,
                title: 'Total Products',
              ),
              SummaryCard(
                context,
                value: vm.productSummary![3].value.toString(),
                title: 'Total Stock',
              ),
              SummaryCard(
                context,
                value: vm.productSummary![4].value!.toStringAsFixed(2),
                title: 'Stock Value',
              ),
            ],
          ),
        ),
      ),
      const CommonDivider(),
      ProductListDataTable(vm: vm),
    ],
  );

  ListView _bodyTablet() => ListView(
    physics: const BouncingScrollPhysics(),
    children: <Widget>[
      SizedBox(
        height: 120,
        child: Container(
          color: Colors.grey.shade50,
          child: ListView(
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            children: <Widget>[
              PercentageCard(
                context,
                value: //num.parse(
                vm.productSummary![0].value!.toStringAsFixed(
                  2,
                ), //),                    t
                title: 'Average Markup',
              ),
              SummaryCard(
                context,
                value: vm.productSummary![1].value!.toStringAsFixed(2),
                title: 'Average profit',
              ),
              SummaryCard(
                context,
                value: vm.productSummary![2].value.toString(),
                asDouble: false,
                title: 'Total Producs',
              ),
              SummaryCard(
                context,
                value: vm.productSummary![3].value.toString(),
                title: 'Total Stock',
              ),
              SummaryCard(
                context,
                value: vm.productSummary![4].value!.toStringAsFixed(2),
                title: 'Stock Value',
              ),
            ],
          ),
        ),
      ),
      const CommonDivider(),
      ProductListDataTable(vm: vm),
    ],
  );
}
