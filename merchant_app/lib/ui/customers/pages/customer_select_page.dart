// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/footer_buttons_icon_primary.dart';
import 'package:littlefish_merchant/ui/customers/pages/customer_edit_page.dart';
import 'package:littlefish_merchant/ui/online_store/shared/routes/custom_route.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/customers/customer.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/redux/customer/customer_actions.dart';
import 'package:littlefish_merchant/ui/customers/viewmodels/customer_view_models.dart';
import 'package:littlefish_merchant/ui/customers/widgets/customer_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';

class CustomerSelectPage extends StatefulWidget {
  static const String route = '/customer-select';

  final bool isDialog;

  final bool showTotals;

  final bool canAddNew;

  final Function(BuildContext context, Customer customer) onSelected;

  const CustomerSelectPage({
    Key? key,
    required this.onSelected,
    this.isDialog = false,
    this.canAddNew = false,
    this.showTotals = true,
  }) : super(key: key);

  @override
  State<CustomerSelectPage> createState() => _CustomerSelectPageState();
}

class _CustomerSelectPageState extends State<CustomerSelectPage> {
  GlobalKey<AutoCompleteTextFieldState<Customer>>? searchKey;

  @override
  void initState() {
    searchKey = GlobalKey<AutoCompleteTextFieldState<Customer>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, CustomersViewModel>(
      onInit: (store) => store.dispatch(initializeCustomers()),
      converter: (Store store) =>
          CustomersViewModel.fromStore(store as Store<AppState>),
      builder: (BuildContext context, CustomersViewModel vm) {
        if (widget.isDialog) {
          return Container(
            // constraints: BoxConstraints.tightFor(width: 376),
            alignment: Alignment.center,
            child: body(context, vm),
          );
        } else {
          return AppSimpleAppScaffold(
            title: 'Select Customer',
            body: body(context, vm),
            footerActions: [
              if (widget.canAddNew)
                FooterButtonsIconPrimary(
                  primaryButtonText: 'Add Customer',
                  onPrimaryButtonPressed: (_) {
                    Navigator.of(context).push(
                      CustomRoute(
                        builder: (BuildContext context) =>
                            const CustomerEditPage(clearCustomerOnPop: true),
                      ),
                    );
                  },
                  secondaryButtonIcon: Icons.refresh,
                  onSecondaryButtonPressed: (_) async {
                    await vm.onRefresh();
                  },
                ),
            ],
          );
        }
      },
    );
  }

  Widget body(context, CustomersViewModel vm) {
    return vm.isLoading == true
        ? const AppProgressIndicator()
        : CustomerList(
            onTap: (Customer customer) {
              widget.onSelected(context, customer);
              Navigator.of(context).pop(customer);
            },
            vm: vm,
          );
  }
}
