import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/customers/customer_list.dart';
import 'package:littlefish_merchant/ui/online_store/customers/customer_screen.dart';
import 'package:littlefish_merchant/ui/online_store/customers/manage_customer_vm.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_simple_scaffold.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

class StoreCustomersScreen extends StatefulWidget {
  // final showAppBar;
  final Function? onFetched;

  const StoreCustomersScreen({
    Key? key,
    // this.showAppBar = true,
    this.onFetched,
  }) : super(key: key);

  @override
  State<StoreCustomersScreen> createState() => _StoreCustomersScreenState();
}

class _StoreCustomersScreenState extends State<StoreCustomersScreen> {
  final _scrollController = ScrollController();
  final _scrollThreshold = 200.0;
  ManageCustomerVM? vm;
  dynamic store;

  bool isLoading = false;

  setLoading(bool value) {
    if (mounted) {
      setState(() {
        isLoading = value;
      });
    } else {
      isLoading = value;
    }
  }

  onFetched() {
    if (widget.onFetched != null) widget.onFetched!();
  }

  onFetchError(error) {
    debugPrint('Something Went Wrong');
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      vm!.fetchCustomers();
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  onPressed() async {
    var result = await Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (context) => const CustomerScreen()));

    if (result == true) {
      if (mounted) setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageCustomerVM>(
      converter: (Store<AppState> store) => ManageCustomerVM.fromStore(store),
      builder: (BuildContext ctx, ManageCustomerVM vm) {
        // if (vm == null) _vm.fetchCustomers();
        // _vm
        return body(vm);
      },
    );
  }

  AppSimpleAppScaffold body(ManageCustomerVM vm) => AppSimpleAppScaffold(
    title: 'Customers',
    floatingActionButton: FloatingActionButton(
      onPressed: onPressed,
      child: const Icon(Icons.add),
    ),
    actions: [
      if (vm.isLoading != true)
        IconButton(
          onPressed: () {
            // vm.fetchCustomers();
            setState(() {});
          },
          icon: const Icon(Icons.refresh),
        ),
    ],
    body: FutureBuilder(
      future: vm.fetchCustomers(limit: 2000),
      builder: (ctx, snapshot) {
        return vm.customerCount > 0 && vm.isFetching != true
            ? SafeArea(
                child: CustomersList(
                  customers: vm.customers,
                  scrollController: _scrollController,
                ),
              )
            : Column(
                children: <Widget>[
                  if (vm.isFetching == true) const LinearProgressIndicator(),
                  Expanded(
                    child: Center(
                      child: Text(
                        vm.isFetching == true
                            ? 'Loading'
                            : 'No Customers Found',
                      ),
                    ),
                  ),
                ],
              );
      },
    ),
  );
}
