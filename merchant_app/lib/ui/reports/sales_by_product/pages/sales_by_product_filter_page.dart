// Flutter imports:
import 'package:flutter/material.dart';
import 'package:littlefish_core/business/models/business_user.dart';
import 'package:littlefish_merchant/app/theme/applied_system/applied_text_icon.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/models/enums.dart';
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/tools/billing/billing_helpers.dart';
import 'package:littlefish_merchant/ui/reports/sales_by_product/viewmodels/sales_by_product_report_vm.dart';
import 'package:littlefish_merchant/ui/reports/shared/models/item.dart';
import 'package:littlefish_merchant/ui/reports/shared/widgets/multi_select_page/multi_select_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';

import '../../../../common/presentaion/pages/scaffolds/app_scaffold.dart';

class SalesByProductFilterPage extends StatefulWidget {
  static const String route = 'reports/sales/filters';

  final SalesByProductReportVM? vm;

  final bool showHeader;

  final BuildContext? parentContext;

  const SalesByProductFilterPage(
    this.vm, {
    Key? key,
    this.showHeader = true,
    this.parentContext,
  }) : super(key: key);

  @override
  State<SalesByProductFilterPage> createState() =>
      _SalesByProductFilterPageState();
}

class _SalesByProductFilterPageState extends State<SalesByProductFilterPage> {
  List<Item>? selectedProducts;
  List<Item>? selectedCategories;
  List<Item>? selectedSellers;
  List<Item>? selectedCustomers;
  SalesByProductReportVM? vm;

  @override
  Widget build(BuildContext context) {
    vm = widget.vm;

    return layout(context, widget.vm ?? vm!);
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

  Widget layout(context, SalesByProductReportVM vm) {
    return AppScaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      displayAppBar: widget.showHeader,
      title: 'Sales by Product Filters',
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
                            color: Theme.of(
                              context,
                            ).extension<AppliedTextIcon>()?.brand,
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
                MultiFilterSelect(
                  placeholder: 'Products',
                  allItems: buildListItem(vm.products),
                  initValue: vm.selectedProducts.isNotEmpty
                      ? vm.selectedProducts
                      : null,
                  tail: Text(
                    '${vm.selectedProducts.length} of ${vm.products.length}',
                  ),
                  selectCallback: (List? selectedValue) {
                    var result = selectedValue!.cast<StockProduct>().toList();
                    vm.onSelectProduct(result);

                    if (mounted) setState(() {});
                  },
                ),
                const CommonDivider(),
                MultiFilterSelect(
                  placeholder: 'Categories',
                  allItems: buildListItem(vm.categories),
                  initValue: vm.selectedCategories.isNotEmpty
                      ? vm.selectedCategories
                      : null,
                  tail: Text(
                    '${vm.selectedCategories.length} of ${vm.categories.length}',
                  ),
                  selectCallback: (List? selectedValue) {
                    var result = selectedValue!.cast<StockCategory>().toList();
                    vm.onSelectCategory(result);
                    if (mounted) setState(() {});
                  },
                ),
                const CommonDivider(),
                MultiFilterSelect(
                  placeholder: 'Customers',
                  allItems: buildListItem(vm.customers!),
                  initValue: vm.selectedCustomer.isNotEmpty
                      ? vm.selectedCustomer
                      : null,
                  tail: Text(
                    '${vm.selectedCustomer.length} of ${vm.customers!.length}',
                  ),
                  selectCallback: (List? selectedValue) {
                    var result = selectedValue!.cast<Customer>().toList();
                    vm.onSelectCustomer(result);
                    if (mounted) setState(() {});
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
                    var result = selectedValue!.cast<BusinessUser>().toList();
                    vm.onSelectSeller(result);
                    if (mounted) setState(() {});
                  },
                ),
                const CommonDivider(),
              ],
            ),
          ),

          // const SizedBox(
          //   height: 32,
          // ),
        ],
      ),
      persistentFooterButtons: [
        ButtonPrimary(
          onTap: (c) {
            vm.runReport(widget.parentContext ?? context);
            vm.getNextPage(widget.parentContext ?? context);

            if (mounted) setState(() {});

            if (widget.showHeader) Navigator.of(context).pop();
          },
          text: 'APPLY FILTERS',
        ),
      ],
    );
  }
}
