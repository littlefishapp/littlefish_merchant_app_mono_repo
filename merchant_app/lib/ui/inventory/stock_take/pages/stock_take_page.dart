import 'dart:math' as math;
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/app/theme/typography.dart';
import 'package:littlefish_merchant/common/presentaion/components/buttons/button_secondary.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
import 'package:littlefish_merchant/tools/helpers/product_barcode_helper.dart';
import 'package:littlefish_merchant/ui/products/products/pages/product_quantity_adjustment_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:quiver/strings.dart';
// removed ignore: depend_on_referenced_packages
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/hardware/barcode_scanner/barcode_scanner.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/models/stock/stock_take_item.dart';
import 'package:littlefish_merchant/providers/environment_provider.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/ui/inventory/view_models/view_models.dart';
import 'package:littlefish_merchant/ui/products/products/pages/product_select_page.dart';
import 'package:littlefish_merchant/ui/products/products/widgets/products_list.dart';
import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_tabbed_scaffold.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/common/presentaion/components/form_fields/auto_complete_text_field.dart';
import 'package:littlefish_merchant/common/presentaion/pages/popup_forms/barcode_popup_form.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
import 'package:littlefish_merchant/app/custom_route.dart';
import 'package:littlefish_merchant/common/presentaion/components/app_tabbar.dart';
import '../../../../app/theme/applied_system/applied_text_icon.dart';
import '../../../../common/presentaion/components/buttons/button_primary.dart';
import '../../../../injector.dart';
import '../../../../tools/network_image/flutter_network_image.dart';
import 'package:littlefish_icons/littlefish_icons.dart';

class StockTakePage extends StatefulWidget {
  static const String route = 'inventory/existing-stock';

  const StockTakePage({Key? key}) : super(key: key);

  @override
  State<StockTakePage> createState() => _StockTakePageState();
}

class _StockTakePageState extends State<StockTakePage> {
  late List<StockTakeItem> _filteredList;
  late List<StockTakeItem> _sortedList;
  late String _sortOrder;
  late String _sortSelection;
  MenuItem? _currentSelection;
  SortOrder? _selectedOrder;
  TextEditingController searchController = TextEditingController();
  GlobalKey<AutoCompleteTextFieldState<StockTakeItem>>? filterKey;

  NavigatorState? nav;

  BarcodeScanner? scanner;

  @override
  void initState() {
    _filteredList = [];
    _sortedList = [];
    _sortOrder = 'Ascending';
    _sortSelection = '';
    filterKey = GlobalKey<AutoCompleteTextFieldState<StockTakeItem>>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    nav ??= Navigator.of(context);

    return StoreConnector<AppState, StockTakeVM>(
      converter: (Store<AppState> store) {
        return StockTakeVM.fromStore(store);
      },
      builder: (BuildContext context, StockTakeVM vm) {
        updateFilteredList(vm);
        sortList(vm);
        if (scanner == null) {
          setupScanner(vm.store, vm);
        }
        return scaffold(context, vm);
      },
    );
  }

  updateFilteredList(StockTakeVM vm) {
    if (isNotBlank(searchController.text) && (vm.item!.items!.isNotEmpty)) {
      _filteredList = vm.item!.items!
          .where(
            (element) => element.productName!.toLowerCase().contains(
              searchController.text.toLowerCase(),
            ),
          )
          .toList();
    }
  }

  sortList(StockTakeVM vm) {
    if (searchController.text == '') {
      _sortedList = vm.item!.items!.toList();
    } else if (searchController.text != '') {
      _sortedList = _filteredList.toList();
    }

    if (_selectedOrder != null) {
      switch (_selectedOrder) {
        case SortOrder.name:
          _sortedList.sort(
            ((a, b) => _sortOrder == 'Descending'
                ? b.productName!.toLowerCase().compareTo(
                    a.productName!.toLowerCase(),
                  )
                : a.productName!.toLowerCase().compareTo(
                    b.productName!.toLowerCase(),
                  )),
          );
          break;
        case SortOrder.costPrice:
          _sortedList.sort(
            ((a, b) => _sortOrder == 'Descending'
                ? b.costPrice!.compareTo(a.costPrice!)
                : a.costPrice!.compareTo(b.costPrice!)),
          );
          break;
        default:
      }
    }

    if (searchController.text != '') {
      _filteredList = _sortedList.toList();
    }
  }

  AppScaffold scaffold(context, StockTakeVM vm) => AppScaffold(
    persistentFooterButtons: [
      Container(
        height: 48,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: ButtonPrimary(
          buttonColor: Theme.of(context).colorScheme.secondary,
          disabled: vm.item?.items?.isEmpty ?? false,
          text: (vm.item!.isNew ?? false) ? 'Complete Stock Take' : 'Back',
          upperCase: false,
          onTap: (ctx) => (vm.item!.isNew ?? false)
              ? vm.onUpload(ctx)
              : Navigator.of(context).pop(),
        ),
      ),
    ],
    title: (vm.item!.isNew ?? false) ? vm.title : vm.item?.displayName ?? '',
    body: vm.isLoading!
        ? const AppProgressIndicator()
        : (EnvironmentProvider.instance.isLargeDisplay!
              ? vm.item!.isNew!
                    ? layoutLarge(context, vm)
                    : layout(context, vm)
              : layout(context, vm)),
  );

  setupScanner(store, vm) {
    // var hardwareProvider = HardwareProvider.instance;

    // if (hardwareProvider.hasScanner) {
    //   scanner = BarcodeScanner.fromUsbDevice(
    //     device: hardwareProvider.scanner,
    //     enabled: true,
    //     // eventCallback: (event) => scannerLog.add(event),
    //     onScan: (barcode) {
    //       var product = vm.productState.getProductByBarcode(barcode);

    //       if (product == null) return;

    //       addItem(context, product, vm);
    //     },
    //   );
    // }
  }

  Row layoutLarge(BuildContext context, StockTakeVM vm) => Row(
    children: <Widget>[
      Expanded(child: tabBar(context, vm)),
      const VerticalDivider(width: 0.5),
      Expanded(
        child: ProductsList(
          onTap: (item) {
            addItem(context, item, vm);
          },
          canAddNew: false,
        ),
      ),
    ],
  );

  dynamic layout(context, StockTakeVM vm) => tabBar(context, vm);

  AppTabBar tabBar(context, vm) =>
      AppTabBar(tabs: tabs(context, vm), reverse: true);

  List<TabBarItem> tabs(context, StockTakeVM vm) => <TabBarItem>[
    TabBarItem(
      text: 'Items',
      content: Column(
        children: <Widget>[
          stockList(context, vm),
          if (_sortedList.isEmpty)
            Expanded(
              flex: 6,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    LittleFishIcons.info,
                    size: 64,
                    color: Theme.of(
                      context,
                    ).extension<AppliedTextIcon>()?.deEmphasized,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add products to your stock take.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Theme.of(
                        context,
                      ).extension<AppliedTextIcon>()?.deEmphasized,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    ),
  ];

  SizedBox filterHeader(
    BuildContext context, {
    Function? onAdd,
    required StockTakeVM vm,
  }) => SizedBox(
    height: 70.0,
    child: Container(
      alignment: Alignment.center,
      child: Column(
        children: [
          Row(
            children: [
              Flexible(
                flex: 10,
                child: TextField(
                  controller: searchController,
                  onChanged: (searchController) {
                    updateFilteredList(vm);
                    if (mounted) setState(() {});
                  },
                  cursorColor: Colors.grey,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    hintText: 'Search',
                    hintStyle: const TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                    ),
                    prefixIcon: Container(
                      padding: const EdgeInsets.all(15),
                      width: 18,
                      child: const Icon(Icons.search),
                    ),
                  ),
                ),
              ),
              Flexible(
                flex: 1,
                child: DropdownButtonHideUnderline(
                  child: DropdownButton2(
                    customButton: Icon(
                      Icons.sort_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    items: [
                      ...MenuItems.firstItems.map(
                        (item) => DropdownMenuItem<MenuItem>(
                          value: item,
                          child: MenuItems.buildItem(
                            item,
                            _sortSelection,
                            _sortOrder,
                            context,
                          ),
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (_currentSelection == null ||
                          value != _currentSelection) {
                        _sortOrder = 'Ascending';
                      }
                      if (value == _currentSelection &&
                          _sortOrder == 'Ascending') {
                        _sortOrder = 'Descending';
                      } else if (value == _currentSelection &&
                          _sortOrder == 'Descending') {
                        _sortOrder = 'Ascending';
                      }

                      switch (value) {
                        case MenuItems.name:
                          _selectedOrder = SortOrder.name;
                          _sortSelection = 'Product Name';
                          _currentSelection = MenuItems.name;
                          break;
                        case MenuItems.costPrice:
                          _selectedOrder = SortOrder.costPrice;
                          _sortSelection = 'Cost Price';
                          _currentSelection = MenuItems.costPrice;
                          break;
                      }

                      if (mounted) setState(() {});
                    },
                    dropdownStyleData: const DropdownStyleData(
                      maxHeight: 150,
                      width: 170,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ),
  );

  Expanded stockList(context, StockTakeVM vm) => Expanded(
    child: ListView.builder(
      shrinkWrap: true,
      physics: _sortedList.isEmpty
          ? const NeverScrollableScrollPhysics()
          : const BouncingScrollPhysics(),
      itemCount: (vm.item!.isNew ?? false)
          ? (_sortedList.length) + 1
          : _sortedList.length,
      itemBuilder: (BuildContext context, int index) =>
          (vm.item!.isNew ?? false)
          ? index == 0
                ? Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 16.0,
                      horizontal: 16.0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: SizedBox(
                            height: 48,
                            child: ButtonSecondary(
                              text: 'Add Your Products',
                              // isNeutral: true,
                              rightIcon: Icons.add,
                              onTap: (_) {
                                if ((vm.item!.isNew ?? false)) {
                                  searchItem(context, vm);
                                } else {
                                  return;
                                }
                              },
                            ),
                          ),
                        ),
                        const SizedBox(width: 16),
                        SizedBox(
                          width: 48,
                          height: 48,
                          child: ButtonSecondary(
                            //isExpanded: false,
                            radius: 0.0,
                            text: '',
                            icon: MdiIcons.barcodeScan,
                            // icon: 'assets/icons/general/barcode_scanner.svg',
                            // isNeutral: true,
                            onTap: (_) {
                              scanItem(context, vm);
                              setState(() {});
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                : (vm.item!.isNew ?? false)
                ? dismissableItem(context, _sortedList[index - 1], vm)
                : newStockItemTile(context, _sortedList[index], vm)
          : (vm.item!.isNew ?? false)
          ? dismissableItem(context, _sortedList[index], vm)
          : newStockItemTile(context, _sortedList[index], vm),
    ),
  );

  Slidable dismissableItem(context, StockTakeItem item, StockTakeVM vm) =>
      Slidable(
        key: Key(item.varianceId ?? item.productId!),
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
        child: newStockItemTile(context, item, vm),
        // secondaryActions: [
        //   IconSlideAction(
        //     color: Colors.red,
        //     icon: Icons.delete,
        //     onTap: () async {
        //       var result = await confirmDismissal(context, item);

        //       if (result == true) {
        //         vm.onRemoveItem(item, context);
        //       }
        //     },
        //   ),
        // ],
      );

  // Widget redesign() => Row(
  //       children: [
  //         Directionality(
  //           textDirection: TextDirection.rtl,
  //           child: Container(
  //             color: const Color.fromRGBO(246, 246, 246, 1),
  //             height: 56,
  //             child: ElevatedButton.icon(
  //               icon: const Icon(
  //                 Icons.add,
  //                 color: Colors.grey,
  //                 size: 24,
  //               ),
  //               label: const Text(
  //                 'text',
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                   color: Colors.white,
  //                   fontWeight: FontWeight.bold,
  //                   //fontFamily: UIStateData.primaryFontFamily,
  //                 ),
  //               ),
  //               onPressed: () {},
  //             ),
  //           ),
  //         ),
  //       ],
  //     );

  InkWell newStockItemTile(
    BuildContext context,
    StockTakeItem item,
    StockTakeVM vm,
  ) {
    final urlFallBackPath = vm.store!.state.productState
        .getProductById(item.productId)
        ?.imageUri;
    final networkImagUrl = item.product?.imageUri ?? urlFallBackPath;
    final showNetworkImage = networkImagUrl != null;
    final showIcon = networkImagUrl == null;
    return InkWell(
      onTap: (vm.item!.isNew ?? false)
          ? () => editItem(context, item, vm)
          : null,
      child: SizedBox(
        width: MediaQuery.of(context).size.width,
        // height: 88,
        child: Padding(
          padding: const EdgeInsets.only(left: 16.0, right: 16),
          child: Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color:
                          Theme.of(
                            context,
                          ).extension<AppliedTextIcon>()?.brand ??
                          Colors.red,
                    ),
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(4),
                    image: showNetworkImage
                        ? DecorationImage(
                            image: getIt<FlutterNetworkImage>()
                                .asImageProviderById(
                                  id: item.productId!,
                                  category: 'products',
                                  legacyUrl: networkImagUrl,
                                  height: AppVariables.listImageHeight,
                                  width: AppVariables.listImageWidth,
                                ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: showIcon
                      ? Icon(
                          Icons.inventory_2_outlined,
                          color:
                              Theme.of(
                                context,
                              ).extension<AppliedTextIcon>()?.primary ??
                              Colors.red,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 5,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.productName!,
                      textAlign: TextAlign.start,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: context.appThemeLabelLarge,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      children: [
                        Text(
                          '${math.max(item.expectedItemCount?.round() ?? 0, 0)} items',
                          textAlign: TextAlign.start,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                            color: Color.fromRGBO(158, 156, 159, 1),
                            //fontFamily: UIStateData.primaryFontFamily,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.keyboard_double_arrow_right,
                          size: 14,
                          color: vm.getStockMovementColor(item, context),
                        ),
                        const SizedBox(width: 4),
                        context.body02x14R(
                          vm.getStockMovementDescription(item),
                          alignLeft: true,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 2,
                child: Align(
                  alignment: Alignment.center,
                  child: context.labelSmall('Confirmed'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> searchItem(context, StockTakeVM vm) async {
    StockProduct? product;

    if (EnvironmentProvider.instance.isLargeDisplay!) {
      product = await showPopupDialog<StockProduct>(
        context: context,
        content: const ProductSelectPage(
          isEmbedded: true,
          isOnlyTrackableStock: true,
        ),
      );
    } else {
      product = await nav!.push<StockProduct>(
        CustomRoute(
          builder: (BuildContext context) =>
              const ProductSelectPage(isOnlyTrackableStock: true),
        ),
      );
    }

    if (product == null) return;

    addItem(context, product, vm);
  }

  Future<void> addItem(context, StockProduct product, StockTakeVM vm) async {
    await nav!.push(
      CustomRoute(
        builder: (BuildContext context) => ProductQuantityAdjustmentPage(
          productId: product.id,
          imageUri: product.imageUri,
          displayName: product.displayName ?? '',
          unitType: product.unitType,
          initialValue: product.quantity,
          category: vm.store!.state.productState
              .getCategory(categoryId: product.categoryId)
              ?.displayName,
          callback: (diff, reason) {
            if (diff >= 0) {
              vm.onAddItem(
                StockTakeItem.fromProduct(product, qty: diff, type: reason),
                context,
              );
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  Future<void> editItem(context, StockTakeItem item, StockTakeVM vm) async {
    if (item.product == null) return;

    StockProduct product = item.product!;
    Navigator.of(context).push(
      CustomRoute(
        builder: (BuildContext context) => ProductQuantityAdjustmentPage(
          productId: product.id,
          imageUri: product.imageUri,
          displayName: product.displayName ?? '',
          unitType: product.unitType,
          initialValue: product.quantity,
          category: vm.store!.state.productState
              .getCategory(categoryId: product.categoryId)
              ?.displayName,
          callback: (diff, reason) {
            if (diff.abs() >= 0) {
              item.stockCount = diff.abs();
              item.type = reason;
              Navigator.of(context).pop();
            }
          },
        ),
      ),
    );
  }

  Future<void> scanItem(context, StockTakeVM vm) async {
    String? barcode;

    // if (EnvironmentProvider.instance.isLargeDisplay)
    barcode = await showPopupDialog(
      context: context,
      content: BarcodePopupForm(
        store: vm.store,
        laserScannerAvailable: AppVariables.laserScanningSupported,
      ),
      height: 392,
    );
    // else
    //   barcode = await nav.push<String>(
    //     CustomRoute(
    //         maintainState: true,
    //         builder: (BuildContext context) => BarcodePopupForm()),
    //   );

    if (barcode == null || barcode.isEmpty) return;

    var product = await ProductBarcodeHelper.getProductByBarcode(
      barcode: barcode,
      store: AppVariables.store,
    );

    // var product = vm.productState!.getProductByBarcode(barcode);

    if (product == null) return;

    addItem(context, product, vm);
  }
}

class MenuItem {
  final String text;

  const MenuItem({required this.text});
}

class MenuItems {
  static const List<MenuItem> firstItems = [name, costPrice];

  static const name = MenuItem(text: 'Product Name');
  static const costPrice = MenuItem(text: 'Cost Price');

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

enum SortOrder { name, costPrice }

enum StockChangeIcon { upArrow, downArrow, check }
