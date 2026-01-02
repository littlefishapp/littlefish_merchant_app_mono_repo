import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
import 'package:littlefish_merchant/injector.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/online_store/products/pages/product_attribute_page.dart';
import 'package:littlefish_merchant/ui/online_store/viewmodels/manage_store_vm.dart';

import '../../../../features/ecommerce_shared/models/store/store_product.dart';

class ProductAttributesPage extends StatefulWidget {
  final StoreProduct item;

  const ProductAttributesPage({Key? key, required this.item}) : super(key: key);

  @override
  State<ProductAttributesPage> createState() => _ProductAttributesPageState();
}

class _ProductAttributesPageState extends State<ProductAttributesPage> {
  bool _isLoading = false;

  setLoading(bool value) {
    if (mounted) {
      setState(() {
        _isLoading = value;
      });
    } else {
      _isLoading = value;
    }
  }

  //we need to always load the attributes currently on the product, changes are live... not on the save button...
  List<StoreProductAttribute>? _values;

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ManageStoreVM>(
      converter: (store) => ManageStoreVM.fromStore(store),
      builder: (context, vm) {
        return Scaffold(
          floatingActionButton: _isLoading
              ? null
              : FloatingActionButton(
                  child: const Icon(Icons.add),
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (BuildContext context) => ProductAttributePage(
                          product: widget.item,
                          attribute: null,
                        ),
                      ),
                    );
                  },
                ),
          body: SafeArea(
            child: FutureBuilder(
              future: _getAttributes(),
              builder:
                  (
                    context,
                    AsyncSnapshot<List<StoreProductAttribute>?> snapshot,
                  ) {
                    if (_isLoading ||
                        snapshot.connectionState != ConnectionState.done) {
                      return const LinearProgressIndicator();
                    }

                    if (snapshot.data == null || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No Data'));
                    }

                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      physics: const BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        var attr = snapshot.data![index];

                        return ListTile(
                          tileColor: Theme.of(context).colorScheme.background,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ProductAttributePage(
                                      product: widget.item,
                                      attribute: attr,
                                    ),
                              ),
                            );
                          },
                          title: Text(attr.name!),
                          subtitle: Text(
                            attr.option!,
                            style: const TextStyle(fontSize: 12),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () async {
                              setLoading(true);

                              try {
                                await getIt<ModalService>()
                                    .showActionModal(
                                      context: context,
                                      title: 'Delete item?',
                                      description:
                                          'Are you sure you want to delete this item?',
                                      acceptText: 'Yes, Delete',
                                      cancelText: 'No, Cancel',
                                    )
                                    .then((value) async {
                                      if (!value!) return;

                                      await widget.item.deleteAttribute(attr);

                                      _values!.removeAt(index);
                                    });
                              } catch (error) {
                                reportCheckedError(
                                  error,
                                  trace: StackTrace.current,
                                );
                              } finally {
                                setLoading(false);
                              }
                            },
                          ),
                        );
                      },
                    );
                  },
            ),
          ),
        );
      },
    );
  }

  Future<List<StoreProductAttribute>?> _getAttributes() async {
    try {
      var attrs = await widget.item.attributesCollection!.get();

      _values = attrs.docs
          .map(
            (e) =>
                StoreProductAttribute.fromJson(e.data() as Map<String, dynamic>)
                  ..documentSnapshot = e
                  ..documentReference = e.reference,
          )
          .toList();

      return _values;
    } catch (e) {
      rethrow;
    }
  }
}
