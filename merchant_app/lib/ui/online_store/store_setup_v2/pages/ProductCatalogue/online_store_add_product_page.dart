// // remove ignore_for_file: use_build_context_synchronously
// // flutter imports
// import 'package:flutter/material.dart';
// import 'package:flutter_redux/flutter_redux.dart';
// import 'package:littlefish_merchant/common/presentaion/components/dialogs/services/modal_service.dart';
// import 'package:littlefish_merchant/injector.dart';
// import 'package:littlefish_merchant/common/presentaion/components/buttons/button_text.dart';

// // package imports
// import 'package:quiver/strings.dart';

// // project imports
// import 'package:littlefish_merchant/tools/helpers.dart';
// import 'package:littlefish_merchant/redux/store/store_actions.dart';
// import 'package:littlefish_merchant/common/presentaion/components/buttons/button_primary.dart';
// import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
// import 'package:littlefish_merchant/redux/product/product_actions.dart';
// import 'package:littlefish_merchant/models/shared/form_view_model.dart';
// import 'package:littlefish_merchant/ui/products/products/widgets/add_product_form.dart';
// import 'package:littlefish_merchant/common/presentaion/components/app_progress_indicator.dart';
// import 'package:littlefish_merchant/common/presentaion/components/keyboard_dismissal_utility.dart';
// import 'package:littlefish_merchant/models/stock/stock_product.dart';
// import 'package:littlefish_merchant/ui/online_store/store_setup_v2/HelperUtilities/product_catalogue_utils.dart';
// import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/add_image_widget.dart';
// import 'package:littlefish_merchant/ui/online_store/store_setup_v2/widgets/text_widgets.dart';
// import 'package:littlefish_merchant/ui/products/products/view_models/product_item_vm.dart';
// import 'package:littlefish_merchant/common/presentaion/pages/scaffolds/app_scaffold.dart';
// import 'package:littlefish_merchant/redux/app/app_state.dart';

// class OnlineStoreAddProductPage extends StatefulWidget {
//   static const route = 'online-store/add-product-page';

//   final bool isNewProduct;
//   const OnlineStoreAddProductPage({
//     Key? key,
//     this.isNewProduct = true,
//   }) : super(key: key);

//   @override
//   State<OnlineStoreAddProductPage> createState() =>
//       _OnlineStoreAddProductPageState();
// }

// class _OnlineStoreAddProductPageState extends State<OnlineStoreAddProductPage> {
//   late StockProduct _product;
//   late final GlobalKey<FormState> _formKey;
//   late FormManager _form;
//   late double _checkerHeight;
//   late bool _isCostValidCheck;

//   @override
//   void initState() {
//     _formKey = GlobalKey();
//     _form = FormManager(_formKey);
//     _checkerHeight = 56;
//     _isCostValidCheck = true;
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return StoreConnector<AppState, ProductViewModelNew>(
//       onInit: (store) {
//         StockProduct stateProduct =
//             store.state.productsUIState?.item ?? StockProduct.create();
//         _product = widget.isNewProduct
//             ? StockProduct.create()
//             : stateProduct.copyWith();
//         _product.isOnline = true;
//       },
//       converter: (store) {
//         return ProductViewModelNew.fromStore(store);
//       },
//       builder: (BuildContext ctx, ProductViewModelNew vm) {
//         return KeyboardDismissalUtility(
//           content: scaffold(context, vm),
//         );
//       },
//     );
//   }

//   scaffold(BuildContext context, ProductViewModelNew vm) {
//     return KeyboardDismissalUtility(
//       content: AppScaffold(
//         title: widget.isNewProduct ? 'Add Product' : 'Edit Product',
//         centreTitle: false,
//         body: vm.isLoading != true
//             ? layout(context, vm)
//             : const AppProgressIndicator(),
//         enableProfileAction: false,
//         persistentFooterButtons: [
//           Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 cancelButton(vm),
//                 const SizedBox(
//                   width: 8,
//                 ),
//                 saveButton(vm),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget layout(BuildContext context, ProductViewModelNew vm) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16),
//       child: SingleChildScrollView(
//         child: Column(
//           children: [
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: HeadingText(text: 'Images'),
//             ),
//             productImages(vm),
//             AddProductForm(
//               product: _product,
//               formManager: _form,
//               onProductChanged: (product) async {
//                 if (mounted) {
//                   setState(() {
//                     _product = product;
//                   });
//                 }
//               },
//               checkerHeight: _checkerHeight,
//               isCostValid: _isCostValidCheck,
//               isOnlineRequired: true,
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget productImages(ProductViewModelNew vm) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 16),
//       child: Row(
//         children: [
//           UploadImage(
//             width: 140,
//             onTap: () async {
//               final result = await chooseAndUploadProductImage(
//                 context,
//                 _product.id!,
//               );

//               _product.imageUri =
//                   result == null ? _product.imageUri : result.downloadUrl;
//               if (mounted) {
//                 setState(() {});
//               }
//             },
//             imageUri: _product.imageUri,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget cancelButton(ProductViewModelNew vm) => ButtonText(
//         onTap: (_) {
//           Navigator.of(context).pop();
//         },
//         expand: true,
//         isNegative: true,
//         text: 'Cancel',
//       );

//   saveButton(ProductViewModelNew vm) {
//     return Expanded(
//       child: ButtonPrimary(
//         text: 'Publish Product',
//         upperCase: false,
//         disabled: isBlank(_product.name),
//         buttonColor: Theme.of(context).colorScheme.secondary,
//         onTap: (context) async {
//           if (vm.store == null) return;

//           if (_formKey.currentState?.validate() == true) {
//             _formKey.currentState!.save();
//           }
//           vm.store!.dispatch(ProductStateLoadingAction(true));

//           bool uniqueSKU = await isUniqueSku(
//             context,
//             vm.store,
//             _product.sku,
//             _product.id!,
//           );

//           if (!uniqueSKU) {
//             vm.store!.dispatch(ProductStateLoadingAction(false));
//             setState(() {
//               _checkerHeight = 78;
//             });
//             showMessageDialog(
//               context,
//               'SKU is not Unique',
//               LittleFishIcons.info,
//             );
//             return;
//           }

//           bool isProductOffline = _product.isOnline != true;
//           bool storeHasNoProducts =
//               isNullOrEmpty(vm.store!.state.storeState.products);
//           bool shouldAddProduct = true;
//           if (isProductOffline && storeHasNoProducts) {
//             shouldAddProduct = await _offLineProductWarning() ?? true;
//           }

//           if (!shouldAddProduct) {
//             vm.store!.dispatch(ProductStateLoadingAction(false));
//             return;
//           }

//           if (vm.store!.state.storeState.store == null) {
//             vm.store!.dispatch(CreateDefaultStoreAction());
//           }

//           var onlineStore = vm.store!.state.storeState.store;
//           if (await doesOnlineStoreExist(vm) == false) {
//             vm.store!.dispatch(addOnlineStoreToAccount(onlineStore!));
//           }

//           vm.onAdd(_product, context);
//           vm.store!.dispatch(ProductStateLoadingAction(false));
//         },
//       ),
//     );
//   }

//   Future<bool?> _offLineProductWarning() async {
//     return await getIt<ModalService>().showActionModal(
//       context: context,
//       title: 'Product Not Online',
//       description:
//           'Please note, to complete your online store setup at least one product must be set to online. Are you sure you want to add an offline product?',
//     );
//   }
// }
