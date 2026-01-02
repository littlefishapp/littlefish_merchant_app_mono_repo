import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';

import '../../../../../features/ecommerce_shared/models/store/promotion.dart';
import '../../../../../features/ecommerce_shared/models/store/store_customer.dart';
import '../../../../../tools/textformatter.dart';
import '../../../../../common/presentaion/components/common_divider.dart';
import '../../../../../common/presentaion/components/app_progress_indicator.dart';

//Not in use
// Using old Online store vm and is used for promotions
class CustomerSelectPage extends StatefulWidget {
  final dynamic item;

  const CustomerSelectPage({Key? key, required this.item}) : super(key: key);

  @override
  State<CustomerSelectPage> createState() => _CustomerSelectPageState();
}

class _CustomerSelectPageState extends State<CustomerSelectPage> {
  List<StoreCustomer>? customers;

  dynamic item;

  @override
  void initState() {
    customers = <StoreCustomer>[];
    item = widget.item;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (ctx, vm) {
        return AppSimpleAppScaffold(
          title: 'Customers',
          footerActions: [
            ButtonBar(
              buttonHeight: 48,
              buttonMinWidth: MediaQuery.of(context).size.width,
              children: [
                ElevatedButton(
                  child: const Text('Save'),
                  onPressed: () async {
                    if (customers!.isEmpty) {
                    } else {
                      var selected = customers!
                          .where(
                            (element) =>
                                element.isSelected == true &&
                                element.customerId != null,
                          )
                          .map(
                            (e) => PromotionUser(
                              displayName: '${e.firstName} ${e.lastName}',
                              email: e.email,
                              id: e.uid,
                            ),
                          )
                          .toList();

                      item.audience.users = selected;

                      Navigator.of(context).pop(item);
                      //Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          ],
          body: SafeArea(child: body(vm, context)),
        );
      },
    );
  }

  Widget body(ManageStoreVM vm, BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) {
        if (didPop) return;

        Navigator.of(context).pop(true);
        return;
      },
      child: FutureBuilder<List<StoreCustomer>>(
        future: vm.getCustomers(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const AppProgressIndicator();
          }

          customers = snapshot.data;

          if (customers!.isEmpty) {
            return const Center(child: Text('Nothing found'));
          } else {
            return ListView.separated(
              itemCount: customers?.length ?? 0,
              itemBuilder: (context, index) {
                var customer = customers![index];

                return MultiSelectCustomerTile(
                  customer: customer,
                  onTap: (customers) {
                    customers = customers;
                  },
                );
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const CommonDivider(),
            );
          }
        },
      ),
    );
  }
}

class MultiSelectCustomerTile extends StatefulWidget {
  final StoreCustomer customer;
  final Function? onTap;
  const MultiSelectCustomerTile({Key? key, required this.customer, this.onTap})
    : super(key: key);

  @override
  State<MultiSelectCustomerTile> createState() =>
      _MultiSelectCustomerTileState();
}

class _MultiSelectCustomerTileState extends State<MultiSelectCustomerTile> {
  List<StoreCustomer> customers = [];

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      onChanged: (val) {
        if (customers.isNotEmpty) {
          if (customers
              .where(
                (element) => element.customerId == widget.customer.customerId,
              )
              .toList()
              .isNotEmpty) {
            for (var i = 0; i < customers.length; i++) {
              if (customers[i].customerId == widget.customer.customerId) {
                customers[i].isSelected = val;
              }
            }
          } else {
            var cust = widget.customer;
            cust.isSelected = val;
            customers.add(cust);
          }

          if (widget.onTap != null) widget.onTap!(customers);
          if (mounted) setState(() {});
        } else {
          var cust = widget.customer;
          cust.isSelected = val;
          customers.add(cust);
          if (widget.onTap != null) widget.onTap!(customers);
          if (mounted) setState(() {});
        }

        // widget.customer.isSelected = val;
        // StoreCustomer cust = widget.customer;
        // if (mounted) setState(() {});
      },
      value: widget.customer.isSelected ?? false,
      title: Text('${widget.customer.firstName} ${widget.customer.lastName}'),
      subtitle: widget.customer.lastPurchaseDate == null
          ? const Text('no purchase history')
          : Text(
              "${TextFormatter.toStringCurrency(widget.customer.totalPurchases, currencyCode: '')} purchases",
            ),
    );
  }
}
