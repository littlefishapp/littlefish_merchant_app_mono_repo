// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_slidable/flutter_slidable.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/goods_received_voucher.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/tools/textformatter.dart';
import 'package:littlefish_merchant/ui/inventory/grv/pages/grv_item_page.dart';
import 'package:littlefish_merchant/ui/inventory/view_models/view_models.dart';
import 'package:littlefish_merchant/ui/products/products/pages/product_select_page.dart';
import 'package:littlefish_merchant/common/presentaion/components/filter_add_bar.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/long_text.dart';
import 'package:littlefish_merchant/common/presentaion/components/text_tag.dart';
import 'package:littlefish_merchant/common/presentaion/components/list_leading_tile.dart';
import 'package:littlefish_merchant/common/presentaion/components/new_list_tile.dart';

class GRVItemList extends StatefulWidget {
  final GRVVM vm;

  const GRVItemList({Key? key, required this.vm}) : super(key: key);

  @override
  State<GRVItemList> createState() => _GRVItemListState();
}

class _GRVItemListState extends State<GRVItemList> {
  GlobalKey<AutoCompleteTextFieldState<GoodsRecievedItem>>? filterKey;

  @override
  void initState() {
    filterKey = GlobalKey<AutoCompleteTextFieldState<GoodsRecievedItem>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        filterHeader(context, widget.vm),
        stockList(context, widget.vm),
      ],
    );
  }

  FilterAddBar<GoodsRecievedItem> filterHeader(
    context,
    GRVVM vm,
  ) => FilterAddBar(
    // onAdd: (vm.item.isNew ?? false) ? () => searchItem(context, vm) : null,
    filterKey: filterKey,
    itemSorter: (dynamic a, dynamic b) {
      return a.displayName
          .substring(0, 1)
          .toLowerCase()
          .compareTo(b.displayName.substring(0, 1).toLowerCase());
    },
    suggestions: vm.item!.items,
    itemBuilder: (BuildContext context, GoodsRecievedItem suggestion) =>
        itemTile(context, suggestion, vm),
    itemSubmitted: (GoodsRecievedItem data) {
      if ((vm.item!.isNew ?? false)) {
        // editItem(context, data, vm);
      }
    },
    itemFilter: (GoodsRecievedItem suggestion, query) =>
        (suggestion.productName!.toLowerCase().startsWith(
          query.toLowerCase(),
        ) ||
        suggestion.variantName!.toLowerCase().startsWith(query.toLowerCase())),
  );

  Expanded stockList(context, GRVVM vm) => Expanded(
    child: ListView.separated(
      shrinkWrap: true,
      physics: const BouncingScrollPhysics(),
      itemCount: vm.item!.isNew!
          ? (vm.item!.items!.length) + 1
          : vm.item!.items!.length,
      itemBuilder: (BuildContext context, int index) =>
          vm.item!.isNew! && index == 0
          ? NewItemTile(
              title: 'Add Item',
              onTap: () {
                if (vm.item!.isNew!) searchItem(context, vm);
              },
            )
          : (vm.item!.isNew ?? false)
          ? dismissableItem(context, vm.item!.items![index - 1], vm)
          : itemTile(context, vm.item!.items![index], vm),
      separatorBuilder: (BuildContext context, int index) =>
          const CommonDivider(),
    ),
  );

  Slidable dismissableItem(context, GoodsRecievedItem item, GRVVM vm) =>
      Slidable(
        key: Key(item.variantId ?? item.productId!),
        endActionPane: ActionPane(
          extentRatio: .25,
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (ctx) async {
                var result = await confirmDismissal(context, item);

                if (result == true) {
                  vm.onRemoveItem(item, context);
                }
              },
              backgroundColor: const Color(0xFFFE4A49),
              foregroundColor: Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: itemTile(context, item, vm),
      );

  ListTile itemTile(context, GoodsRecievedItem item, GRVVM vm) => ListTile(
    tileColor: Theme.of(context).colorScheme.background,
    dense: !EnvironmentProvider.instance.isLargeDisplay!,
    leading: ListLeadingTextTile(text: '${item.totalUnits}'),
    subtitle: item.productId != null && item.productId!.isNotEmpty
        ? LongText('${item.currentUnitCount} currently in stock')
        : null,
    title: Text('${item.productName}'),
    trailing: TextTag(
      displayText: TextFormatter.toStringCurrency(
        item.totalUnitCost,
        currencyCode: '',
      ),
    ),
    onTap: (vm.item!.isNew ?? false) ? () => editItem(context, item, vm) : null,
  );

  Future<void> searchItem(context, GRVVM vm) async {
    StockProduct? product;

    if (EnvironmentProvider.instance.isLargeDisplay!) {
      product = await showPopupDialog(
        context: context,
        content: const ProductSelectPage(isEmbedded: true),
      );
    } else {
      product = await showDialog<StockProduct>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) => const ProductSelectPage(),
      );
    }

    if (product != null) {
      addItem(context, product, vm);
    }

    // if (mounted) setState(() {});
  }

  Future<void> editItem(context, GoodsRecievedItem item, GRVVM vm) async {
    if (EnvironmentProvider.instance.isLargeDisplay!) {
      showPopupDialog<GoodsRecievedItem>(
        context: context,
        content: GRVItemPage(item: item),
      ).then((item) {
        if (item != null) {
          vm.onAddItem(item, context);
          if (mounted) setState(() {});
        }
      });
    } else {
      showDialog<GoodsRecievedItem>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) {
          return GRVItemPage(item: item);
        },
      ).then((item) {
        if (item != null) {
          vm.onAddItem(item, context);
          if (mounted) setState(() {});
        }
      });
    }
  }

  Future<void> addItem(context, StockProduct product, GRVVM vm) async {
    if (EnvironmentProvider.instance.isLargeDisplay!) {
      showPopupDialog<GoodsRecievedItem>(
        context: context,
        content: GRVItemPage(
          item: GoodsRecievedItem.fromProduct(
            product,
            product.regularVariance!,
          ),
        ),
      ).then((item) {
        if (item != null) {
          vm.onAddItem(item, context);
          if (mounted) setState(() {});
        }
      });
    } else {
      var item = await showDialog<GoodsRecievedItem>(
        context: context,
        barrierDismissible: true,
        builder: (ctx) {
          return GRVItemPage(
            item: GoodsRecievedItem.fromProduct(
              product,
              product.regularVariance!,
            ),
          );
        },
      );
      if (item != null) {
        vm.onAddItem(item, context);
        if (mounted) setState(() {});
      }
    }
  }
}
