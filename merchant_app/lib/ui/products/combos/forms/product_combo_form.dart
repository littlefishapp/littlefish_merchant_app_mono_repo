// Flutter imports:
// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_text.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';

// Project imports:
import 'package:littlefish_merchant/models/products/product_combo.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/products/combos/forms/product_combo_item_form.dart';
import 'package:littlefish_merchant/ui/products/combos/view_models/combo_item_vm.dart';
import 'package:littlefish_merchant/ui/products/combos/widgets/product_combo_summary.dart';
import 'package:littlefish_merchant/ui/products/products/pages/product_select_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/barcode_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/text_tag.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/custom_route.dart';

import '../../../../injector.dart';
import '../../../../redux/product/product_actions.dart';
import '../../../../shared/constants/permission_name_constants.dart';

class ProductComboForm extends StatefulWidget {
  final ComboViewModel vm;

  const ProductComboForm({Key? key, required this.vm}) : super(key: key);

  @override
  State<ProductComboForm> createState() => _ProductComboFormState();
}

class _ProductComboFormState extends State<ProductComboForm> {
  late ComboViewModel vm;
  bool hasScanBarcodePerm = true;

  _ProductComboFormState();

  @override
  void initState() {
    super.initState();
    hasScanBarcodePerm = userHasPermission(allowScanBarcode);
  }

  @override
  Widget build(BuildContext context) {
    vm = widget.vm;
    return StoreBuilder<AppState>(
      builder: (BuildContext context, Store<AppState> store) => vm.isLoading!
          ? const AppProgressIndicator()
          : Column(
              children: <Widget>[
                Expanded(child: form(context, store)),
                const CommonDivider(),
                SizedBox(
                  child: Container(
                    height: 56,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: ProductComboSummary(item: vm.item),
                  ),
                ),
              ],
            ),
    );
  }

  Form form(context, Store<AppState> store) => Form(
    key: vm.form.key,
    child: ListView(
      physics: const BouncingScrollPhysics(),
      children: <Widget>[
        StringFormField(
          enforceMaxLength: true,
          maxLength: 255,
          hintText: 'Name',
          key: const Key('name'),
          labelText: 'Combo Name',
          focusNode: vm.form.setFocusNode('name'),
          nextFocusNode: vm.form.setFocusNode('description'),
          onFieldSubmitted: (value) {
            vm.item!.name = vm.item!.displayName = value;
          },
          inputAction: TextInputAction.next,
          initialValue: vm.item!.displayName,
          isRequired: true,
          onSaveValue: (value) {
            vm.item!.name = vm.item!.displayName = value;
          },
        ),
        StringFormField(
          enforceMaxLength: true,
          maxLength: 255,
          hintText: 'Description',
          key: const Key('description'),
          labelText: 'Description',
          focusNode: vm.form.setFocusNode('description'),
          onFieldSubmitted: (value) {
            vm.item!.description = value;
          },
          inputAction: TextInputAction.next,
          initialValue: vm.item!.description,
          isRequired: false,
          onSaveValue: (value) {
            vm.item!.description = value;
          },
        ),
        if (hasScanBarcodePerm)
          BarcodeFormField(
            canScanBarcode: hasScanBarcodePerm,
            hintText: hasScanBarcodePerm
                ? 'Enter or Scan Barcode'
                : 'Enter Barcode',
            key: const Key('barcode'),
            labelText: 'Item Barcode',
            focusNode: vm.form.setFocusNode('barcode'),
            onFieldSubmitted: (value) {
              vm.item!.barcode = value;
            },
            inputAction: TextInputAction.next,
            initialValue: vm.item!.barcode,
            isRequired: false,
            onSaveValue: (value) {
              vm.item!.barcode = value;
            },
          ),
        // const CommonDivider(),
        SizedBox(
          child: ButtonText(
            icon: Icons.add,
            text: 'Add Product',
            layoutVertically: true,
            onTap: (_) {
              _addProduct(context, vm.item);
            },
          ),
        ),
        const CommonDivider(),
        products(context, vm.item!, store),
      ],
    ),
  );

  MediaQuery products(context, ProductCombo item, Store<AppState> store) =>
      MediaQuery.removeViewPadding(
        context: context,
        child: ListView.separated(
          shrinkWrap: true,
          physics: const BouncingScrollPhysics(),
          itemCount: item.items?.length ?? 0,
          separatorBuilder: (context, index) => const CommonDivider(),
          itemBuilder: (BuildContext context, int index) {
            var c = item.items![index];
            return ProductListTile(
              combo: item,
              productItem: c,
              store: store,
              onRemove: (productItem, combo) async {
                vm.item!.items!.removeWhere(
                  (p) => p.productId == productItem.productId,
                );
                combo.categoryId = null;
                if (mounted) setState(() {});
              },
            );
          },
        ),
      );

  _addProduct(context, ProductCombo? item) async {
    if (EnvironmentProvider.instance.isLargeDisplay!) {
      await showPopupDialog<StockProduct>(
        context: context,
        content: const ProductSelectPage(isEmbedded: true),
      ).then((product) async {
        if (product != null) {
          var existingIndex = item!.items!.indexWhere(
            (p) =>
                p.productId == ProductComboItem.fromProduct(product).productId,
          );

          if (existingIndex >= 0) {
            showMessageDialog(
              context,
              '${product.displayName} already exists in combo',
              MdiIcons.information,
            );
          } else {
            var result = await showPopupDialog<ProductComboItem>(
              context: context,
              content: ProductComboItemForm(
                item: ProductComboItem.fromProduct(product),
                product: product,
              ),
            );
            if (result != null) {
              if (mounted) {
                setState(() {
                  item.addComboItem(result);
                });
              } else {
                item.addComboItem(result);
              }
            }
          }
        }
      });
    } else {
      await Navigator.of(context)
          .push<StockProduct>(
            CustomRoute(
              builder: (BuildContext context) => const ProductSelectPage(),
              maintainState: true,
            ),
          )
          .then((product) async {
            if (product != null) {
              var existingIndex = item!.items!.indexWhere(
                (p) =>
                    p.productId ==
                    ProductComboItem.fromProduct(product).productId,
              );

              if (existingIndex >= 0) {
                showMessageDialog(
                  context,
                  '${product.displayName} already exists in combo',
                  MdiIcons.information,
                );
              } else {
                var result = await showDialog<ProductComboItem>(
                  context: context,
                  builder: (ctx) {
                    return ProductComboItemForm(
                      item: ProductComboItem.fromProduct(product),
                      product: product,
                    );
                  },
                );
                if (result != null)
                  if (mounted) {
                    setState(() {
                      item.addComboItem(result);
                    });
                  } else {
                    item.addComboItem(result);
                  }
              }
            }
          });
    }
  }
}

class ProductListTile extends StatelessWidget {
  final ProductCombo combo;
  final Store<AppState> store;
  final ProductComboItem productItem;

  final Function(ProductComboItem productItemValue, ProductCombo combo)?
  onRemove;
  final bool canRemove;

  const ProductListTile({
    Key? key,
    required this.store,
    required this.combo,
    required this.productItem,
    this.onRemove,
    this.canRemove = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return canRemove
        ? _dismissableListTile(context, combo, store, productItem)
        : listTile(context, store, productItem, combo);
  }

  ListTile listTile(
    BuildContext context,
    Store<AppState> store,
    ProductComboItem productItem,
    ProductCombo combo,
  ) {
    return ListTile(
      dense: EnvironmentProvider.instance.isLargeDisplay! ? false : true,
      onTap: () => _editComboItem(context, productItem, store, combo),
      title: Text('${productItem.quantity} x ${productItem.name}'),
      subtitle: LongText(
        "cost: ${TextFormatter.toStringCurrency(productItem.costPrice, currencyCode: '')}, saving: ${TextFormatter.toStringCurrency(productItem.comboSaving, currencyCode: '')}",
      ),
      trailing: TextTag(
        displayText: TextFormatter.toStringCurrency(
          productItem.comboPrice,
          currencyCode: '',
        ),
      ),
    );
  }

  _editComboItem(
    context,
    ProductComboItem item,
    Store<AppState> store,
    ProductCombo combo,
  ) async {
    var result = await showDialog<ProductComboItem>(
      context: context,
      builder: (ctx) => ProductComboItemForm(
        item: item,
        product:
            item.product ??
            store.state.productState.getProductById(item.productId),
      ),
    );
    if (result != null) {
      Navigator.of(context).pop();
      store.dispatch(editCombo(context, combo));
    } //there may be some changes, trigger the ui
  }

  Slidable _dismissableListTile(
    BuildContext context,
    ProductCombo combo,
    Store<AppState> store,
    ProductComboItem productItem,
  ) => Slidable(
    endActionPane: ActionPane(
      extentRatio: .25,
      motion: const ScrollMotion(),
      children: [
        SlidableAction(
          onPressed: (ctx) async {
            var result = await confirmDismissal(context, null);

            if (result == true) {
              onRemove!(productItem, combo);
            }
          },
          backgroundColor: const Color(0xFFFE4A49),
          foregroundColor: Colors.white,
          icon: Icons.delete,
          label: 'Delete',
        ),
      ],
    ),
    child: listTile(context, store, productItem, combo),
  );
}
