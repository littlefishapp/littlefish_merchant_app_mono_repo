// remove ignore_for_file: use_build_context_synchronously, depend_on_referenced_packages

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:littlefish_core/storage/models/storage_reference.dart';
import 'package:littlefish_merchant/redux/store/store_actions.dart';
import 'package:littlefish_merchant/ui/online_store/services/littlefish/littlefish_firestore.dart';
import 'package:littlefish_merchant/ui/products/products/view_models/product_item_vm.dart';
import 'package:quiver/strings.dart';
import 'package:redux/redux.dart';
import 'package:littlefish_merchant/redux/app/app_state.dart';
import 'package:littlefish_merchant/app/app.dart';
import 'package:littlefish_merchant/common/presentaion/components/dialogs/common_dialogs.dart';
import 'package:littlefish_merchant/models/stock/stock_product.dart';
import 'package:littlefish_merchant/redux/product/product_actions.dart';
import 'package:littlefish_icons/littlefish_icons.dart';
import 'package:littlefish_merchant/services/product_service.dart';
import 'package:littlefish_merchant/tools/file_manager.dart';

Future<StorageReference?> chooseAndUploadProductImage(
  BuildContext context,
  String productId,
) async {
  ImageSource? source = await FileManager().selectFileSource(context);
  if (source == null) return null;

  XFile? image = await imagePicker.pickImage(source: source);

  if (image == null) return null;

  if (!await FileManager().isFileTypeAllowed(image, context)) {
    return null;
  }

  AppVariables.store?.dispatch(ProductStateLoadingAction(true));

  try {
    var state = AppVariables.store!.state;
    var file = File(image.path);
    var result = await FileManager().uploadFile(
      file: file,
      businessId: state.businessId!,
      category: 'products',
      id: productId,
      businessName: 'business-tag',
    );

    return result;
  } on PlatformException catch (e) {
    hideProgress(context);

    showMessageDialog(
      context,
      '${e.code}: ${e.message}',
      LittleFishIcons.warning,
    );
  } catch (e) {
    logger.error(
      'chooseAndUploadProductImage',
      'An error occurred uploading image for productId: $productId',
      error: e,
      stackTrace: StackTrace.current,
    );
  } finally {
    AppVariables.store?.dispatch(ProductStateLoadingAction(false));
  }

  return null;
}

Future<bool> isUniqueSku(
  BuildContext context,
  Store<AppState>? store,
  String? sku,
  String productId,
) async {
  try {
    ProductService productService = ProductService(
      baseUrl: store!.state.baseUrl,
      businessId: store.state.businessId,
      token: store.state.token,
      currentLocale: store.state.localeState.currentLocale,
      store: store,
    );
    StockProduct? fetchedProduct = await productService.getProductBySku(sku!);
    if (fetchedProduct != null && productId != fetchedProduct.id) {
      return false;
    } else {
      return true;
    }
  } catch (error) {
    showMessageDialog(
      context,
      'Error Verifying SKU with your Current Products',
      LittleFishIcons.error,
    );

    throw Exception('Error');
  }
}

Future<bool> doesOnlineStoreExist(ProductViewModelNew vm) async {
  vm.store?.dispatch(SetStoreLoadingAction(true));
  String? userId = vm.store?.state.currentUser?.uid;
  String? businessId = vm.store?.state.businessId;
  if (isBlank(userId) || isBlank(businessId)) return false;

  bool doesExist = await FirestoreService().doesStoreExistForUser(
    userId!,
    businessId!,
  );
  vm.store?.dispatch(SetStoreLoadingAction(false));
  return doesExist;
}
