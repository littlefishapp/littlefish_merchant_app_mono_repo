// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_core/business/models/business_user.dart';

// Project imports:
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/ui/reports/customer_report/customer_select_filter_page.dart';
import 'package:littlefish_merchant/ui/reports/customer_report/customer_statement_vm.dart';
import 'package:littlefish_merchant/ui/reports/shared/models/item.dart';
import 'package:littlefish_merchant/ui/reports/shared/widgets/multi_select_page/multi_select_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';

class CustomerFilterPage extends StatefulWidget {
  final CustomerStatementVM? vm;

  final bool showHeader;

  final BuildContext? parentContext;

  const CustomerFilterPage(
    this.vm, {
    Key? key,
    this.showHeader = true,
    this.parentContext,
  }) : super(key: key);

  @override
  State<CustomerFilterPage> createState() => _CustomerFilterPageState();
}

class _CustomerFilterPageState extends State<CustomerFilterPage> {
  List<Item>? selectedSellers;
  List<Item>? selectedCustomers;

  @override
  Widget build(BuildContext context) {
    return layout(context, widget.vm!);
  }

  List<Item> buildListItem(List<dynamic> array) {
    return List.generate(
      array.length,
      (index) => Item.build(
        content: array[index].displayName,
        display: array[index].displayName,
        value: array[index],
      ),
    );
  }

  AppSimpleAppScaffold layout(context, CustomerStatementVM vm) =>
      AppSimpleAppScaffold(
        isEmbedded: true,
        displayAppBar: widget.showHeader,
        title: 'Customer Filters',
        body: Column(
          children: <Widget>[
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: <Widget>[
                  const CommonDivider(),
                  SizedBox(
                    height: 60,
                    child: Container(
                      color: Colors.grey.shade50,
                      child: MaterialButton(
                        elevation: 4,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Text(
                            vm.dateSelectionString,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          ),
                        ),
                        onPressed: () {
                          if (isNotPremium('report_custom')) {
                            showPopupDialog(
                              defaultPadding: false,
                              context: context,
                              content: billingNavigationHelper(isModal: true),
                            );
                          } else {
                            vm.selectDateRange(context).then((dates) {
                              if (dates != null) {
                                vm.changeDates(dates[0], dates[1]);
                                vm.changeMode(ReportMode.custom);
                                if (mounted) setState(() {});
                              }
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const CommonDivider(),
                  ListTile(
                    tileColor: Theme.of(context).colorScheme.background,
                    title: const Text('Customers'),
                    subtitle: Text(
                      vm.selectedCustomer?.displayName ?? 'None Selected',
                    ),
                    onTap: () {
                      showPopupDialog(
                        context: context,
                        content: CustomerSelectFilterPage(vm),
                        defaultPadding: false,
                      ).then((result) {
                        if (mounted) setState(() {});
                      });
                    },
                  ),
                  const CommonDivider(),
                  MultiFilterSelect(
                    placeholder: 'Sellers',
                    allItems: buildListItem(vm.sellers!),
                    initValue: vm.selectedSeller.isNotEmpty
                        ? vm.selectedSeller
                        : null,
                    tail: Text(
                      '${vm.selectedSeller.length} of ${vm.sellers!.length}',
                    ),
                    selectCallback: (List? selectedValue) {
                      var result = selectedValue?.cast<BusinessUser>().toList();
                      vm.onSelectSeller(result!);
                      if (mounted) setState(() {});
                    },
                  ),
                  const CommonDivider(),
                ],
              ),
            ),
            ButtonPrimary(
              onTap: (c) {
                vm.runReport(widget.parentContext ?? context);

                if (mounted) setState(() {});

                if (widget.showHeader) Navigator.of(context).pop();
              },
              text: 'APPLY FILTERS',
              textColor: Colors.white,
            ),
            const SizedBox(height: 32),
          ],
        ),
      );
}
