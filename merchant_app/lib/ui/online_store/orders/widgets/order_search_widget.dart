// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';

// Project imports:
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';
import '../../../../common/presentaion/components/form_fields/yes_no_form_field.dart';

class OrderSearchWidget extends StatefulWidget {
  const OrderSearchWidget({Key? key}) : super(key: key);

  @override
  State<OrderSearchWidget> createState() => _OrderSearchWidgetState();
}

class _OrderSearchWidgetState extends State<OrderSearchWidget> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (ctx, vm) => _layout(context, vm),
    );
  }

  Scaffold _layout(context, ManageStoreVM vm) => Scaffold(
    key: _scaffoldKey,
    body: SafeArea(
      child: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          physics: const BouncingScrollPhysics(),
          children: <Widget>[
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: const Text(
                'Set Your Filters,',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            ExpansionTile(
              title: const Text('Order Statuses'),
              subtitle: Container(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: vm.searchStatuses!.isEmpty
                    ? const Text('All')
                    : Text(vm.searchStatuses!.join(',')),
              ),
              children: vm.orderStatuses
                  .map(
                    (c) => YesNoFormField(
                      labelText: c.displayName ?? '',
                      isToggle: false,
                      onSaved: (bool? value) {
                        if (vm.searchStatuses!.contains(c.name)) {
                          vm.searchStatuses!.remove(c.name);
                        } else {
                          vm.searchStatuses!.add(c.name);
                        }

                        //trigger the toggle change
                        vm.setOrderFilterStatus(vm.searchStatuses);
                      },
                      initialValue: vm.searchStatuses!.contains(c.name),
                    ),
                  )
                  .toList(),
            ),
            // SizedBox(height: 12),
            // YesNoFormField(
            //   labelText: S.of(context).featuredProductsLabel,
            //   onSaved: (value) {
            //     vm.setSearchFeatured(value);
            //   },
            //   initialValue: vm.searchParams.searchFeatured,
            //   isToggle: false,
            // ),
            // SizedBox(height: 12),
            // YesNoFormField(
            //   labelText: S.of(context).onSaleLabel,
            //   onSaved: (value) {
            //     vm.setSearchOnSale(value);
            //   },
            //   initialValue: vm.searchParams.searchOnSale,
            //   isToggle: false,
            // ),
            // SizedBox(height: 12),
          ],
        ),
      ),
    ),
  );
}
