// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/ui/reports/customer_report/customer_statement_vm.dart';
import 'package:littlefish_merchant/common/presentaion/components/filter_add_bar.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';

class CustomerSelectFilterPage extends StatefulWidget {
  final CustomerStatementVM vm;

  const CustomerSelectFilterPage(this.vm, {Key? key}) : super(key: key);
  @override
  State<CustomerSelectFilterPage> createState() =>
      _CustomerSelectFilterPageState();
}

class _CustomerSelectFilterPageState extends State<CustomerSelectFilterPage> {
  GlobalKey<AutoCompleteTextFieldState<Customer>>? filterkey;

  @override
  Widget build(BuildContext context) {
    filterkey = GlobalKey<AutoCompleteTextFieldState<Customer>>();

    return AppSimpleAppScaffold(
      isEmbedded: true,
      title: 'Choose a customer',
      body: Column(
        children: <Widget>[
          topBar(context, widget.vm),
          Expanded(child: customerList(context, widget.vm)),
        ],
      ),
    );
  }

  FilterAddBar<Customer> topBar(BuildContext context, CustomerStatementVM vm) =>
      FilterAddBar<Customer>(
        filterKey: filterkey,
        itemSorter: (a, b) {
          return a.displayName!
              .substring(0, 1)
              .toLowerCase()
              .compareTo(b.displayName!.substring(0, 1).toLowerCase());
        },
        suggestions: vm.customers,
        itemBuilder: (BuildContext context, Customer suggestion) =>
            customerListTile(context, suggestion),
        itemFilter: (suggestion, query) =>
            suggestion.displayName!.toLowerCase().contains(query.toLowerCase()),
        itemSubmitted: (Customer data) {},
      );

  ListTile customerListTile(BuildContext context, Customer item) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    dense: !EnvironmentProvider.instance.isLargeDisplay!,
    title: LongText(
      '${item.displayName}',
      fontSize: null,
      textColor: Theme.of(context).colorScheme.secondary,
      fontWeight: FontWeight.bold,
    ),
    onTap: () {
      widget.vm.onSelectCustomer(item);
      if (mounted) setState(() {});
      Navigator.of(context).pop();
    },
    leading: item.profileImageUri != null && item.profileImageUri!.isNotEmpty
        ? ListLeadingImageTile(url: item.profileImageUri)
        : const ListLeadingIconTile(icon: Icons.accessibility),
  );

  ListView customerList(BuildContext context, CustomerStatementVM vm) =>
      ListView.separated(
        physics: const BouncingScrollPhysics(),
        itemBuilder: (BuildContext context, int index) {
          var item = vm.customers![index];

          return ListTile(
            tileColor: Theme.of(context).colorScheme.background,
            title: Text(item.displayName!),
            onTap: () {
              widget.vm.onSelectCustomer(item);
              Navigator.of(context).pop();
            },
          );
        },
        itemCount: vm.customers?.length ?? 0,
        separatorBuilder: (BuildContext context, int index) =>
            const CommonDivider(),
      );
}
