// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_svg/svg.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/models/assets/app_assets.dart';
import 'package:littlefish_merchant/tools/helpers/product_barcode_helper.dart';
import 'package:quiver/strings.dart';

// Project imports:
import 'package:littlefish_merchant/models/stock/stock_category.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
import 'package:littlefish_merchant/common/presentaion/components/common_divider.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/pages/popup_forms/barcode_popup_form.dart';
import 'package:littlefish_merchant/models/products/product_discount.dart';
import 'package:littlefish_merchant/tools/helpers.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/view_models/product_discount_vm.dart';
import 'package:littlefish_merchant/ui/products/products/pages/multi_product_select_page.dart';
import 'package:littlefish_merchant/ui/products/product_discounts/widgets/product_list_tile.dart';

class DiscountProductsList extends StatefulWidget {
  final ProductDiscountVM? vm;
  final ProductDiscount? discount;
  final Function(List<StockProduct>? items, ProductDiscount)?
  onProductsSelected;

  const DiscountProductsList({
    Key? key,
    this.onProductsSelected,
    this.discount,
    this.vm,
  }) : super(key: key);

  @override
  State<DiscountProductsList> createState() => _DiscountProductsList();
}

class _DiscountProductsList extends State<DiscountProductsList> {
  late List<StockProduct> _filteredList;
  late List<StockProduct> _sortedList;
  late String _sortOrder;
  SortOrder? _selectedOrder;

  GlobalKey<AutoCompleteTextFieldState<StockCategory>>? filterkey;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    _sortOrder = 'Ascending';
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, ProductDiscountVM>(
      converter: (store) => ProductDiscountVM.fromStore(store),
      builder: (BuildContext context, ProductDiscountVM vm) {
        updateFilteredList(vm);
        sortList(vm);
        return vm.isLoading!
            ? const AppProgressIndicator()
            : Container(
                foregroundDecoration: vm.isLoading!
                    ? const BoxDecoration(color: Colors.white)
                    : null,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [topBar(context, vm), layout(context, vm)],
                ),
              );
      },
    );
  }

  topBar(BuildContext context, ProductDiscountVM vm) => Padding(
    padding: const EdgeInsets.only(top: 16.0, bottom: 16.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.only(left: 16),
          height: 56,
          width: MediaQuery.of(context).size.width - 88,
          child: ButtonPrimary(
            text: 'Add Products',
            elevation: 0,
            icon: Icons.add,
            buttonColor: Theme.of(context).colorScheme.primary,
            textColor: Theme.of(context).colorScheme.onPrimary,
            onTap: (_) {
              (EnvironmentProvider.instance.isLargeDisplay!
                  ? showPopupDialog<List<StockProduct>>(
                      content: MultiProductSelectPage(
                        isDiscount: true,
                        productDiscountVM: vm,
                        isEmbedded: true,
                        getProducts: (products) {
                          widget.onProductsSelected!(
                            products ?? [],
                            widget.discount!,
                          );
                        },
                      ),
                      context: context,
                    )
                  : Navigator.of(context).push(
                      CustomRoute(
                        maintainState: false,
                        builder: (BuildContext context) =>
                            MultiProductSelectPage(
                              isDiscount: true,
                              productDiscountVM: vm,
                              getProducts: (products) {
                                widget.onProductsSelected!(
                                  products ?? [],
                                  widget.discount!,
                                );
                              },
                            ),
                      ),
                    ));
            },
          ),
        ),
        const SizedBox(width: 8),
        Ink(
          width: 56,
          height: 56,
          decoration: ShapeDecoration(
            color: Theme.of(context).colorScheme.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
          child: IconButton(
            iconSize: 24,
            icon: SvgPicture.asset(
              AppAssets.barcodeScannerSvg,
              width: 24,
              height: 24,
            ),
            onPressed: () async {
              getCameraAccess().then((result) async {
                if (result) {
                  String? barcode;
                  barcode = await showPopupDialog(
                    context: context,
                    content: BarcodePopupForm(
                      store: vm.store,
                      laserScannerAvailable:
                          AppVariables.laserScanningSupported,
                    ),
                    height: 392,
                  );

                  if (barcode == null || barcode.isEmpty) {
                    return;
                  }

                  var product = await ProductBarcodeHelper.getProductByBarcode(
                    barcode: barcode,
                    store: vm.store,
                  );

                  // var product =
                  //     vm.productState!.getProductByBarcode(barcode);

                  if (product == null) return;
                  widget.onProductsSelected!([product], widget.discount!);
                } else {
                  showMessageDialog(
                    context,
                    'We require access to the camera to scan barcodes',
                    Icons.camera,
                  );
                }
              });
            },
          ),
        ),
        const SizedBox(width: 16),
      ],
    ),
  );

  updateFilteredList(ProductDiscountVM vm) {
    if (isNotBlank(searchController.text) &&
        (vm.currentDiscount!.products!.isNotEmpty)) {
      _filteredList = vm.currentDiscount!.products!
          .where(
            (element) => element.displayName!.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  sortList(ProductDiscountVM vm) {
    if (searchController.text == '') {
      _sortedList = vm.currentDiscount!.products!;
    } else if (searchController.text != '') {
      _sortedList = _filteredList.toList();
    }

    if (_selectedOrder != null) {
      switch (_selectedOrder) {
        case SortOrder.name:
          _sortedList.sort(
            ((a, b) => _sortOrder == 'Descending'
                ? b.displayName!.toLowerCase().compareTo(
                    a.displayName!.toLowerCase(),
                  )
                : a.displayName!.toLowerCase().compareTo(
                    b.displayName!.toLowerCase(),
                  )),
          );
          break;
        case SortOrder.price:
          _sortedList.sort(
            ((a, b) => _sortOrder == 'Descending'
                ? b.regularSellingPrice!.compareTo(a.regularSellingPrice!)
                : a.regularSellingPrice!.compareTo(b.regularSellingPrice!)),
          );
          break;
        case SortOrder.createdDate:
          _sortedList.sort(
            ((a, b) => _sortOrder == 'Descending'
                ? b.dateCreated!.compareTo(a.dateCreated!)
                : a.dateCreated!.compareTo(b.dateCreated!)),
          );
          break;
        default:
      }
    }

    if (searchController.text != '') {
      _filteredList = _sortedList.toList();
    }
  }

  layout(context, vm) => searchController.text == ''
      ? productList(context, vm, _sortedList)
      : productList(context, vm, _filteredList);

  productList(
    BuildContext context,
    ProductDiscountVM vm,
    List<StockProduct> items,
  ) => ListView.separated(
    physics: const BouncingScrollPhysics(),
    shrinkWrap: true,
    itemCount: (items.length),
    itemBuilder: (BuildContext context, int index) {
      StockProduct item = items[index];
      return ProductListTile(
        item: item,
        vm: vm,
        isDismissable: false,
        selected: vm.currentDiscount!.products![index] == item,
        onRemove: (item) async {
          List<StockProduct> products = vm.currentDiscount!.products!;

          products.remove(item);
          vm.updateExistingProducts!(products);
          vm.setStockProducts!([item]);
        },
      );
    },
    separatorBuilder: (BuildContext context, int index) =>
        const CommonDivider(),
  );
}

class MenuItem {
  final String text;

  const MenuItem({required this.text});
}

class MenuItems {
  static const List<MenuItem> firstItems = [name, price, createdDate];

  static const createdDate = MenuItem(text: 'Created Date');
  static const name = MenuItem(text: 'Product Name');
  static const price = MenuItem(text: 'Price');

  static Widget buildItem(
    MenuItem item,
    String sortSelection,
    String sortOrder,
    BuildContext context,
  ) {
    if (sortSelection.toLowerCase() == item.text.toLowerCase()) {
      return Row(
        children: [
          Flexible(
            flex: 10,
            child: Text(
              item.text,
              style: TextStyle(color: Theme.of(context).colorScheme.primary),
            ),
          ),
          Flexible(
            flex: 1,
            child: Icon(
              sortOrder == 'Descending'
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              color: Theme.of(context).colorScheme.primary,
              size: 20,
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Text(item.text, style: const TextStyle(color: Colors.black)),
        ],
      );
    }
  }
}

enum SortOrder { name, price, createdDate }
