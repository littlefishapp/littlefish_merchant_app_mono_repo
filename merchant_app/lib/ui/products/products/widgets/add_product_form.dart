// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:littlefish_merchant/models/stock/stock_run_helper.dart';
// import 'package:littlefish_merchant/ui/products/products/pages/product_quantity_adjustment_page.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
// import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/text_widgets.dart';
// import 'package:littlefish_merchant/tools/helpers.dart';
// import 'package:littlefish_merchant/models/shared/form_view_model.dart';
// import 'package:littlefish_merchant/common/presentaion/components/form_fields/alphanumeric_form_field.dart';
// import 'package:littlefish_merchant/common/presentaion/components/form_fields/barcode_form_field.dart';
// import 'package:littlefish_merchant/common/presentaion/components/form_fields/currency_form_field.dart';
// import 'package:littlefish_merchant/common/presentaion/components/form_fields/decimal_form_field.dart';
// import 'package:littlefish_merchant/common/presentaion/components/form_fields/dropdown_form_field.dart';
// import 'package:littlefish_merchant/common/presentaion/components/form_fields/numeric_form_field.dart';
// import 'package:littlefish_merchant/common/presentaion/components/form_fields/string_form_field.dart';
// import 'package:littlefish_merchant/common/presentaion/components/form_fields/yes_no_form_field.dart';
// import 'package:littlefish_merchant/models/stock/stock_product.dart';
// import 'package:littlefish_merchant/tools/textformatter.dart';
// import 'package:littlefish_merchant/ui/products/products/view_models/product_item_vm.dart';
// import 'package:littlefish_merchant/redux/app/app_state.dart';

// import '../../../../common/presentaion/components/cards/card_neutral.dart';

// class AddProductForm extends StatefulWidget {
//   final FormManager formManager;
//   final StockProduct product;
//   final ValueChanged<StockProduct> onProductChanged;
//   final double checkerHeight;
//   final bool isCostValid;
//   final bool enableIsOnline;
//   final bool isOnlineRequired;

//   const AddProductForm({
//     Key? key,
//     required this.formManager,
//     required this.product,
//     required this.onProductChanged,
//     this.checkerHeight = 56,
//     this.isCostValid = true,
//     this.enableIsOnline = true,
//     this.isOnlineRequired = false,
//   }) : super(key: key);

//   @override
//   State<AddProductForm> createState() => _AddProductFormState();
// }

// class _AddProductFormState extends State<AddProductForm> {
//   late StockProduct _product;
//   late bool _isCostValid;
//   late double _checkerHeight;
//   late final FormManager _form;
//   double? _initialLowStockCount;
//   String? _initialName, _initialDescription, _initialBarcode;
//   String? _initialCategoryId;
//   late String _initialSku;
//   late String _initialUnitOfMeasure;

//   @override
//   void initState() {
//     _checkerHeight = widget.checkerHeight;
//     _form = widget.formManager;
//     _product = widget.product;
//     _isCostValid = widget.isCostValid;
//     _initialName = _product.displayName;
//     _initialDescription = _product.description;
//     _initialUnitOfMeasure = _product.unitOfMeasure ?? 'kg';
//     _initialSku = _product.sku ?? generateSKU();
//     _initialBarcode = _product.regularBarCode;
//     _initialLowStockCount = _product.regularVariance?.lowQuantityValue;
//     _initialCategoryId = _product.categoryId;
//     super.initState();
//   }

//   @override
//   void didUpdateWidget(covariant AddProductForm oldWidget) {
//     if (widget.product != oldWidget.product) {
//       _product = widget.product;
//     }
//     if (oldWidget.isCostValid != widget.isCostValid) {
//       _isCostValid = widget.isCostValid;
//     }
//     if (widget.checkerHeight != oldWidget.checkerHeight) {
//       _checkerHeight = widget.checkerHeight;
//     }
//     if (widget.formManager != oldWidget.formManager) {
//       _form = widget.formManager;
//     }
//     super.didUpdateWidget(oldWidget);
//   }

//   @override
//   Widget build(BuildContext context) {
//     debugPrint('#### AddProductForm');
//     return StoreConnector<AppState, ProductViewModelNew>(
//       converter: (store) {
//         return ProductViewModelNew.fromStore(store);
//       },
//       builder: (BuildContext ctx, ProductViewModelNew vm) {
//         return formDetails(context, vm);
//       },
//     );
//   }

//   Form formDetails(BuildContext context, ProductViewModelNew vm) {
//     int categoryIndex = 0;

//     var formFields = <Widget>[
//       const SizedBox(
//         height: 16,
//       ),
//       //Heading
//       const Align(
//         alignment: Alignment.centerLeft,
//         child: HeadingText(text: 'General'),
//       ),
//       const SizedBox(
//         height: 32,
//       ),
//       SizedBox(
//         child: StringFormField(
//           enforceMaxLength: true,
//           useOutlineStyling: true,
//           hintStyle: formFieldStyle(),
//           textStyle: formFieldStyle(
//             color: Theme.of(context).colorScheme.onTertiary,
//           ),
//           maxLength: 255,
//           hintText: 'Keloggs, Omo, Jik',
//           maxLines: 3,
//           key: const Key('productName'),
//           labelText: 'Product Name',
//           onFieldSubmitted: (value) {
//             _product.displayName = _product.name = value;
//             widget.onProductChanged(_product);
//           },
//           inputAction: TextInputAction.next,
//           initialValue: _initialName,
//           onChanged: (value) {
//             _product.name = _product.displayName = value;
//             widget.onProductChanged(_product);
//           },
//           isRequired: true,
//           onSaveValue: (value) {
//             _product.name = _product.displayName = value;
//             widget.onProductChanged(_product);
//           },
//         ),
//       ),
//       if (isNullOrEmpty(vm.state!.categories)) const SizedBox(height: 8),
//       //Categories
//       Visibility(
//         visible: isNotNullOrEmpty(vm.state!.categories),
//         child: Column(
//           children: [
//             const SizedBox(
//               height: 10,
//             ),
//             SizedBox(
//               height: 56,
//               child: Visibility(
//                 child: DropdownFormField(
//                   labelText: 'Category',
//                   hintText: 'Select a category',
//                   useOutlineStyling: true,
//                   isRequired: false,
//                   key: const Key('category'),
//                   onSaveValue: (value) {
//                     _product.categoryId = value?.value;
//                     widget.onProductChanged(_product);
//                   },
//                   onFieldSubmitted: (value) {
//                     _product.categoryId = value?.value;
//                     widget.onProductChanged(_product);
//                   },
//                   initialValue: _initialCategoryId,
//                   onChanged: (value) {
//                     _product.categoryId = value?.value;
//                     widget.onProductChanged(_product);
//                   },
//                   values: vm.state!.categories
//                       ?.map(
//                         (c) => DropDownValue(
//                           displayValue: c.displayName,
//                           index: categoryIndex += 1,
//                           value: c.id,
//                         ),
//                       )
//                       .toList(),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               height: 20,
//             ),
//           ],
//         ),
//       ),
//       //Description
//       SizedBox(
//         child: StringFormField(
//           enforceMaxLength: true,
//           maxLines: 5,
//           maxLength: 255,
//           hintStyle: formFieldStyle(),
//           textStyle: formFieldStyle(
//             color: Theme.of(context).colorScheme.onTertiary,
//           ),
//           useOutlineStyling: true,
//           hintText: 'Describe your product',
//           key: const Key('description'),
//           labelText: 'Description',
//           // focusNode: _form.setFocusNode('description'),
//           // nextFocusNode: _form.setFocusNode('barcode'),
//           onFieldSubmitted: (value) {
//             _product.description = value;
//             widget.onProductChanged(_product);
//           },
//           inputAction: TextInputAction.next,
//           initialValue: _initialDescription,
//           onChanged: (value) {
//             _product.description = value;
//             widget.onProductChanged(_product);
//           },
//           isRequired: false,
//           onSaveValue: (value) {
//             _product.description = value;
//             widget.onProductChanged(_product);
//           },
//         ),
//       ),
//       const SizedBox(
//         height: 12,
//       ),
//       //Barcode
//       Visibility(
//         visible: _product.productType == ProductType.physical,
//         child: SizedBox(
//           height: 56,
//           child: BarcodeFormField(
//             hintText: 'Enter or Scan Barcode',
//             key: const Key('barcode'),
//             labelText: 'Item Barcode',
//             useOutlineStyling: true,
//             // focusNode: _form.setFocusNode('barcode'),
//             // nextFocusNode: _form.setFocusNode('sellingPrice'),
//             onFieldSubmitted: (value) {
//               _product.regularBarCode = value;
//               widget.onProductChanged(_product);
//             },
//             inputAction: TextInputAction.next,
//             initialValue: _initialBarcode,
//             onChanged: (value) {
//               _product.regularBarCode = value;
//               widget.onProductChanged(_product);
//             },
//             isRequired: false,
//             onSaveValue: (value) {
//               _product.regularBarCode = value;
//               widget.onProductChanged(_product);
//             },
//           ),
//         ),
//       ),
//       const SizedBox(
//         height: 24,
//       ),
//       // Online Settings/ catalog
//       Visibility(
//         visible: widget.enableIsOnline,
//         child: Column(
//           children: [
//             Container(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 'Online Settings',
//                 style: TextStyle(
//                   color: Theme.of(context).colorScheme.onTertiary,
//                   fontWeight: FontWeight.w700,
//                   fontSize: 16,
//                 ),
//               ),
//             ),
//             SizedBox(
//               height: 64,
//               child: YesNoFormField(
//                 key: const Key('onlineProduct'),
//                 padding: const EdgeInsets.all(0),
//                 labelText: 'Product is Online',
//                 initialValue:
//                     widget.isOnlineRequired ? true : _product.isOnline ?? false,
//                 onSaved: (value) {
//                   if (widget.isOnlineRequired) {
//                     _product.isOnline = true;
//                     widget.onProductChanged(_product);
//                     if (mounted) setState(() {});
//                     return;
//                   }
//                   _product.isOnline = value;
//                   widget.onProductChanged(_product);
//                   if (mounted) setState(() {});
//                   // _rebuild();
//                 },
//                 description: 'Add Product to Online Store',
//               ),
//             ),
//             const SizedBox(
//               height: 16,
//             ),
//           ],
//         ),
//       ),
//       //Pricing and Additional items
//       Column(
//         children: [
//           //Price heading
//           const Align(
//             alignment: Alignment.centerLeft,
//             child: HeadingText(text: 'Price'),
//           ),
//           const SizedBox(
//             height: 24,
//           ),

//           //Selling Price
//           SizedBox(
//             height: _checkerHeight,
//             child: CurrencyFormField(
//               showExtra: false,
//               prefixIcon: Icons.sell_outlined,
//               hintText: 'Selling Price',
//               isRequired: false,
//               useOutlineStyling: true,
//               key: const Key('sellingPrice'),
//               labelText: 'Selling Price',
//               // focusNode: _form.setFocusNode('sellingPrice'),
//               enableCustomKeypad: true,
//               customKeypadHeading: 'Selling Price :',
//               onFieldSubmitted: (value) {
//                 _product.regularVariance!.sellingPrice = value;
//                 widget.onProductChanged(_product);
//                 FocusScope.of(context).unfocus();
//               },
//               inputAction: TextInputAction.next,
//               initialValue: _product.regularVariance!.sellingPrice,
//               onSaveValue: (value) {
//                 _product.regularVariance!.sellingPrice = value;
//                 widget.onProductChanged(_product);
//                 FocusScope.of(context).unfocus();
//               },
//             ),
//           ),
//           const SizedBox(
//             height: 20,
//           ),
//           //Cost Price
//           SizedBox(
//             height: _isCostValid ? 56 : 80,
//             child: CurrencyFormField(
//               showExtra: false,
//               prefixIcon: Icons.price_check_outlined,
//               hintText: 'Cost Price',
//               isRequired: false,
//               useOutlineStyling: true,
//               key: const Key('costPrice'),
//               labelText: 'Cost Price',
//               // focusNode: _form.setFocusNode('costPrice'),
//               enableCustomKeypad: true,
//               customKeypadHeading: 'Cost Price :',
//               onFieldSubmitted: (value) {
//                 _product.regularVariance!.costPrice = value;
//                 widget.onProductChanged(_product);
//                 FocusScope.of(context).unfocus();
//               },
//               inputAction: TextInputAction.next,
//               initialValue: _product.regularVariance!.costPrice ?? 0,
//               onSaveValue: (value) {
//                 _product.regularVariance!.costPrice = value;
//                 widget.onProductChanged(_product);
//                 FocusScope.of(context).unfocus();
//               },
//             ),
//           ),
//           const SizedBox(
//             height: 16,
//           ),
//           SizedBox(
//             height: 88,
//             child: Row(
//               mainAxisSize: MainAxisSize.max,
//               children: [
//                 Expanded(
//                   flex: 1,
//                   child: CardNeutral(
//                     margin: EdgeInsets.zero,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(width: 2, color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(6.0),
//                     ),
//                     elevation: 0,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.only(left: 16),
//                           child: Text(
//                             'Margin',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w700,
//                               color: productColourChecker(),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         Container(
//                           padding: const EdgeInsets.only(left: 16),
//                           child: Text(
//                             productChecker('margin'),
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: productColourChecker(),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   width: 16,
//                 ),
//                 Expanded(
//                   child: CardNeutral(
//                     margin: EdgeInsets.zero,
//                     shape: RoundedRectangleBorder(
//                       side: BorderSide(width: 2, color: Colors.grey.shade300),
//                       borderRadius: BorderRadius.circular(6),
//                     ),
//                     elevation: 0,
//                     child: Column(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       crossAxisAlignment: CrossAxisAlignment.stretch,
//                       children: [
//                         Container(
//                           padding: const EdgeInsets.only(left: 16),
//                           child: Text(
//                             'Profit per item',
//                             style: TextStyle(
//                               fontSize: 12,
//                               fontWeight: FontWeight.w700,
//                               color: productColourChecker(),
//                             ),
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 16,
//                         ),
//                         Container(
//                           padding: const EdgeInsets.only(left: 16),
//                           child: Text(
//                             productChecker('profit'),
//                             style: TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.w700,
//                               color: productColourChecker(),
//                             ),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           const SizedBox(
//             height: 24,
//           ),
//           //Details Heading
//           const Align(
//             alignment: Alignment.centerLeft,
//             child: HeadingText(text: 'Details'),
//           ),
//           const SizedBox(
//             height: 24,
//           ),
//           Container(
//             padding: EdgeInsets.only(
//               bottom: _product.isStockTrackable == true ? 24 : 0,
//             ),
//             // height: 80,
//             child: YesNoFormField(
//               key: const Key('stockTracking'),
//               padding: const EdgeInsets.all(0),
//               labelText: 'Track product stock levels',
//               initialValue: _product.isStockTrackable ?? false,
//               onSaved: (value) {
//                 if (_product.productType != ProductType.service) {
//                   if (mounted) {
//                     setState(() {
//                       _product.isStockTrackable = value;
//                       widget.onProductChanged(_product);
//                     });
//                   }
//                 }
//               },
//               description: 'By toggling this feature, you control whether '
//                   'stock levels for this product are being '
//                   'tracked within your operations',
//             ),
//           ),
//           Visibility(
//             visible: _product.unitType == StockUnitType.byFraction &&
//                 _product.isStockTrackable == true,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 56,
//                   child: StringFormField(
//                     prefixIcon: Icons.cases_outlined,
//                     // focusNode: _form.setFocusNode('unitOfMeasure'),
//                     // nextFocusNode: _form.setFocusNode('dStockCount'),
//                     hintText: 'How many do you have?',
//                     useOutlineStyling: true,
//                     textAlign: TextAlign.end,
//                     key: const Key('unitOfMeasure'),
//                     labelText: 'Unit of Measure',
//                     onSaveValue: (value) {
//                       _product.unitOfMeasure = value;
//                       widget.onProductChanged(_product);
//                     },
//                     inputAction: TextInputAction.next,
//                     initialValue: _initialUnitOfMeasure,
//                     onChanged: (value) {
//                       _product.unitOfMeasure = value;
//                       widget.onProductChanged(_product);
//                     },
//                     onFieldSubmitted: (value) {
//                       _product.unitOfMeasure = value;
//                       widget.onProductChanged(_product);
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 12,
//                 ),
//               ],
//             ),
//           ),
//           //Stock Count Decimal
//           Visibility(
//             visible: _product.unitType == StockUnitType.byFraction &&
//                 _product.productType == ProductType.physical &&
//                 _product.isStockTrackable == true,
//             child: Column(
//               children: [
//                 SizedBox(
//                   height: 56,
//                   child: DecimalFormField(
//                     prefixIcon: Icons.numbers,
//                     // focusNode: _form.setFocusNode('dStockCount'),
//                     // nextFocusNode: _form.setFocusNode('lowstock'),
//                     hintText: 'How many do you have?',
//                     useOutlineStyling: true,
//                     key: const Key('dStockCount'),
//                     labelText: 'Stock Count',
//                     onSaveValue: (value) {
//                       _product.regularVariance!.quantity = max(0, value);
//                       widget.onProductChanged(_product);
//                     },
//                     inputAction: TextInputAction.next,
//                     initialValue: _product.regularVariance?.quantity,
//                     onChanged: (value) {
//                       _product.regularVariance!.quantity = max(0, value);
//                       widget.onProductChanged(_product);
//                     },
//                     onFieldSubmitted: (value) {
//                       _product.regularVariance!.quantity = max(0, value);
//                       widget.onProductChanged(_product);
//                     },
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//           // Stock Count Integer
//           Visibility(
//             visible: _product.unitType == StockUnitType.byUnit &&
//                 _product.productType == ProductType.physical &&
//                 _product.isStockTrackable == true,
//             child: Column(
//               children: [
//                 InkWell(
//                   onTap: () {
//                     showModalBottomSheet(
//                       context: context,
//                       shape: const RoundedRectangleBorder(
//                         borderRadius:
//                             BorderRadius.vertical(top: Radius.circular(25.0)),
//                       ),
//                       isScrollControlled: true,
//                       builder: (ctx) => SizedBox(
//                         height: 480,
//                         child: ProductQuantityAdjustmentPage(
//                           showProductImage: false,
//                           category: vm.store!.state.productState
//                               .getCategory(
//                                 categoryId: _product.categoryId,
//                               )
//                               ?.displayName,
//                           productId: _product.id,
//                           imageUri: _product.imageUri,
//                           displayName: _product.displayName ?? '',
//                           unitType: _product.unitType,
//                           initialValue:
//                               _product.regularVariance!.quantityAsNonNegative,
//                           isEmbedded: true,
//                           callback: (difference, reason) async {
//                             try {
//                               if (!_product.isNew!) {
//                                 vm.onMakeStockAdjustment!(
//                                   context,
//                                   difference,
//                                   reason,
//                                   true,
//                                 );
//                               }
//                               double diff = difference;
//                               if (StockRunHelper.isDecreaseByReason(reason)) {
//                                 diff = -diff;
//                               }
//                               setState(() {
//                                 _product.regularVariance!.quantity = max(
//                                   0,
//                                   _product.regularVariance!.quantity! + diff,
//                                 );
//                                 widget.onProductChanged(_product);
//                               });

//                               Navigator.of(context).pop();
//                             } catch (e) {
//                               setState(() {});
//                             }
//                           },
//                         ),
//                       ),
//                     );
//                     setState(() {});
//                   },
//                   child: SizedBox(
//                     height: 56,
//                     child: NumericFormField(
//                       prefixIcon: Icons.numbers,
//                       hintText: 'How many do you have?',
//                       enabled: false,
//                       key: const Key('quantity'),
//                       useOutlineStyling: true,
//                       labelText: 'Stock Count',
//                       onSaveValue: (value) {
//                         _product.regularVariance!.quantity =
//                             max(0, value.toDouble());
//                         widget.onProductChanged(_product);
//                       },
//                       inputAction: TextInputAction.next,
//                       initialValue: _product
//                           .regularVariance?.quantityAsNonNegative
//                           .floor(),
//                       onChanged: (value) {
//                         _product.regularVariance!.quantity =
//                             max(0, value.toDouble());
//                         widget.onProductChanged(_product);
//                       },
//                       onFieldSubmitted: (value) {
//                         _product.regularVariance!.quantity =
//                             max(0, value.toDouble());
//                         widget.onProductChanged(_product);
//                       },
//                     ),
//                   ),
//                 ),
//                 const SizedBox(
//                   height: 20,
//                 ),
//               ],
//             ),
//           ),
//           // Low Stock Value
//           Visibility(
//             visible: _product.isStockTrackable == true,
//             child: SizedBox(
//               height: 56,
//               child: DecimalFormField(
//                 prefixIcon: LittleFishIcons.warning,
//                 hintText: 'What value counts as low stock for this item?',
//                 key: const Key('lowstock'),
//                 labelText: 'Low Stock Value',
//                 useOutlineStyling: true,
//                 onSaveValue: (value) {
//                   _product.regularVariance!.lowQuantityValue = value;
//                   widget.onProductChanged(_product);
//                 },
//                 inputAction: TextInputAction.next,
//                 initialValue: _initialLowStockCount,
//                 onChanged: (value) {
//                   _product.regularVariance!.lowQuantityValue = value;
//                   widget.onProductChanged(_product);
//                 },
//                 onFieldSubmitted: (value) {
//                   _product.regularVariance!.lowQuantityValue = value;
//                   widget.onProductChanged(_product);
//                 },
//               ),
//             ),
//           ),
//           const SizedBox(height: 20),
//           //Product type
//           DropdownFormField(
//             isRequired: true,
//             hintText: 'Product or Service',
//             key: const Key('productType'),
//             useOutlineStyling: true,
//             initialValue: _product.productType ?? ProductType.physical,
//             labelText: 'Product Type',
//             onSaveValue: (value) {
//               _product.productType = value.value;
//               widget.onProductChanged(_product);
//               if (mounted) setState(() {});
//             },
//             onFieldSubmitted: (value) {
//               _product.productType = value.value;
//               if (_product.productType != ProductType.physical) {
//                 _product.isStockTrackable = false;
//               }
//               widget.onProductChanged(_product);
//               if (mounted) setState(() {});
//             },
//             values: <DropDownValue>[
//               DropDownValue(
//                 index: 0,
//                 displayValue: 'Item - Something you sell',
//                 value: ProductType.physical,
//               ),
//               DropDownValue(
//                 index: 1,
//                 displayValue: 'Service - Something you do',
//                 value: ProductType.service,
//               ),
//             ],
//           ),
//           const SizedBox(height: 20),
//           //SKU
//           Visibility(
//             visible: _product.productType == ProductType.physical,
//             child: SizedBox(
//               child: AlphaNumericFormField(
//                 isDense: true,
//                 enforceMaxLength: true,
//                 maxLines: 5,
//                 maxLength: 255,
//                 useOutlineStyling: true,
//                 suffixIcon: MdiIcons.codeArray,
//                 hintText: 'Product SKU',
//                 key: const Key('skuCode'),
//                 labelText: 'SKU',
//                 inputAction: TextInputAction.next,
//                 initialValue: _initialSku,
//                 onChanged: (value) {
//                   _product.sku = value;
//                   widget.onProductChanged(_product);
//                 },
//                 isRequired: true,
//                 onSaveValue: (value) {
//                   _product.sku = value;
//                   widget.onProductChanged(_product);
//                 },
//               ),
//             ),
//           ),
//         ],
//       ),
//       const SizedBox(
//         height: 24,
//       ),
//     ];

//     return Form(
//       key: _form.key,
//       child: Column(children: formFields),
//     );
//   }

//   String productChecker(String type) {
//     if (_product.regularVariance!.sellingPrice != null &&
//         _product.regularVariance?.costPrice != null) {
//       if (type == 'profit') {
//         return '${TextFormatter.formatCurrency(((_product.regularVariance!.sellingPrice! - _product.regularVariance!.costPrice!) * 100).toStringAsFixed(2))}';
//       } else {
//         return _product.regularVariance!.sellingPrice! > 0 &&
//                 _product.regularVariance!.costPrice! > 0
//             ? '${((_product.regularVariance!.sellingPrice! - _product.regularVariance!.costPrice!) / _product.regularVariance!.costPrice! * 100).toStringAsFixed(2)}%'
//             : '0.00%';
//       }
//     } else {
//       _product.regularVariance!.sellingPrice = 0;
//       _product.regularVariance!.costPrice = 0;
//       widget.onProductChanged(_product);
//       return type == 'margin'
//           ? '0.00%'
//           : "${TextFormatter.formatCurrency("0")}";
//     }
//   }

//   Color productColourChecker() {
//     if (_product.regularVariance!.sellingPrice == null ||
//         _product.regularVariance!.costPrice == null) return Colors.black;
//     return _product.regularVariance!.sellingPrice! >=
//             _product.regularVariance!.costPrice!
//         ? Colors.black
//         : Colors.red;
//   }

//   TextStyle formFieldStyle({Color? color, double? size, FontWeight? weight}) =>
//       TextStyle(
//         fontSize: size ?? 14,
//         color: color ?? const Color(0xFC9E9C9F),
//         fontWeight: weight ?? FontWeight.w400,
//       );

//   String generateSKU() {
//     // Define the length of each segment and the total length of the SKU
//     int segmentLength = 5;
//     int totalLength = 20;

//     // Generate random alphanumeric characters for the SKU
//     String characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
//     Random random = Random();
//     String randomSKU = '';

//     for (int i = 0; i < totalLength; i++) {
//       if (i > 0 && i % segmentLength == 0) {
//         randomSKU += '-';
//       }
//       randomSKU += characters[random.nextInt(characters.length)];
//     }

//     _product.sku = randomSKU;
//     widget.onProductChanged(_product);

//     return randomSKU;
//   }
// }
